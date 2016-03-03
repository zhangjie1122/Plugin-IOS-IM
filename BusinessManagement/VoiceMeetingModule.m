//
//  VoiceMeetingModule.m
//  Plugin_platform
//
//  Created by 张杰 on 16/3/1.
//
//

#import "Common.h"
#import "VoiceMeetingModule.h"
#import "DeviceDelegateHelper.h"


@implementation VoiceMeetingModule

/*
 * 创建单例
 */
+(VoiceMeetingModule*)sharedInstance
{
    static VoiceMeetingModule *voiceMeetingModule;
    static dispatch_once_t voiceMeetingModuleOnce;
    dispatch_once(&voiceMeetingModuleOnce, ^{
        voiceMeetingModule = [[VoiceMeetingModule alloc] init];
    });
    return voiceMeetingModule;
}

/*
 *初始化时将回调的commandId和委托对象传入进来
 */
- (void)setDelegateData:(NSString*)commandId delegate:(id)delegate
{
    self.commandId = commandId;
    self.delegate = delegate;
}

/*
 * 发起语音会议
 */
- (void)createVoiceMeeting:(NSString *)membersStr commandId:(NSString*) commandId delegate:(id) delegate {
    //语音会议名称
    NSString * dateFormatString = [self getCurrentTime];
    NSString * meetingName = [dateFormatString stringByAppendingString:@"-voiceMeeting"];
    
    //会议参数
    ECCreateMeetingParams *params =[[ECCreateMeetingParams alloc]init];
    params.meetingName = meetingName;
    params.meetingType = VOICEMEETING_TYPE;
    params.meetingPwd = VOICEMEETING_PWD;
    params.square = VOICEMEETING_LIMIT_NUMBER;
    params.autoClose = VOICEMEETING_AUTO_CLOSE;
    params.autoJoin = VOICEMEETING_AUTO_JOIN;
    params.autoDelete = VOICEMEETING_AUTO_DELETE;
    params.voiceMod = VOICEMEETING_VOICEMOD;
    params.keywords = VOICEMEETING_KEYWORDS;
    
    //调用容联接口，发起语音会议
    [[ECDevice sharedInstance].meetingManager createMultMeetingByType:params completion:^(ECError *error, NSString *meetingNumber) {
        //meetingNumber 创建会议回调的会议号, 加上时间戳，保证唯一性
        meetingNumber = [self addTimeStampForMeetingNo:meetingNumber];
        if (error.errorCode == ECErrorType_NoError) {
            NSLog(@"会议创建成功，请讲话");
            [self inviteVoiceMeetingMembers: meetingNumber withMembersStr: membersStr commandId:commandId delegate:delegate];
        } else {
            NSLog(@"会议创建失败，稍后重试");
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:nil status:NO];
            }
        }
    }];
}

/*
 * 邀请成员加入语音会议
 */
- (void)inviteVoiceMeetingMembers:(NSString *)meetingNo withMembersStr:(NSString *)membersStr commandId:(NSString*) commandId delegate:(id) delegate {
    //传入的参数：邀请成员电话号码，以‘，’拼接成字符串
    NSArray *memberArray = [membersStr componentsSeparatedByString:@","];
    
    //传入的参数：语音会议号吗，去除时间戳
    NSString *meetingNoWithOutTimeStamp = [self removeTimeStampForMeetingNo:meetingNo];
    
    //调用容联接口，邀请成员加入语音会议
    [[ECDevice sharedInstance].meetingManager inviteMembersJoinToVoiceMeeting: meetingNoWithOutTimeStamp andIsLoandingCall: VOICEMEETING_CALL_TYPE andMembers: memberArray completion:^(ECError *error, NSString *meetingNumber) {
        if (error.errorCode == ECErrorType_NoError) {
            NSLog(@"邀请成员成功");
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:meetingNo status:YES];
            }
        } else {
            NSLog(@"邀请成员失败");
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:nil status:NO];
            }
        }
    }];
}

/*
 * 解散语音会议
 */
- (void)disbandVoiceMeeting:(NSString *)meetingNo commandId:(NSString*) commandId delegate:(id) delegate {
    //传入的参数：语音会议号吗，去除时间戳
    NSString *meetingNoWithOutTimeStamp = [self removeTimeStampForMeetingNo:meetingNo];
    
    //调用容联接口，解散语音会议
    [[ECDevice sharedInstance].meetingManager deleteMultMeetingByMeetingType: VOICEMEETING_TYPE andMeetingNumber: meetingNoWithOutTimeStamp completion:^(ECError *error, NSString *meetingNumber) {
        if (error.errorCode == ECErrorType_NoError) {
            NSLog(@"解散会议成功");
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:nil status:YES];
            }
        } else if (error.errorCode == 101020 || error.errorCode == 110183) {
            //101020或者110183会议不存在这时候可以直接退出
            NSLog(@"语音会议不存在");
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:nil status:NO];
            }
        } else if (error.errorCode == 110095) {
            NSLog(@"解散会议失败，权限验证失败，只有创建者才能解散");
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:nil status:NO];
            }
        } else if (error.errorCode == 170005) {
            //网络错误，直接挂机
            [[ECDevice sharedInstance].meetingManager exitMeeting];
        } else {
            NSLog(@"解散会议失败");
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:nil status:NO];
            }
        }
    }];
}

/*
 * 踢出某个会议成员从语音会议
 */
- (void)removeVoiceMeetingMember:(NSString *)meetingNo withMemberStr:(NSString *)memberStr commandId:(NSString*) commandId delegate:(id) delegate {
    //传入的参数：踢出成员电话号码，转换成容联需要的格式
    ECVoIPAccount *member = [[ECVoIPAccount alloc] init];
    member.account = memberStr;
    member.isVoIP = NO;
    
    //传入的参数：语音会议号吗，去除时间戳
    NSString *meetingNoWithOutTimeStamp = [self removeTimeStampForMeetingNo:meetingNo];
    
    //调用容联接口，踢出某个会议成员从语音会议
    [[ECDevice sharedInstance].meetingManager removeMemberFromMultMeetingByMeetingType: VOICEMEETING_TYPE andMeetingNumber: meetingNoWithOutTimeStamp andMember: member completion:^(ECError *error, ECVoIPAccount *membervVoip) {
        if (error.errorCode == ECErrorType_NoError)
        {
            NSLog(@"踢出会议成员成功");
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:nil status:YES];
            }
        } else {
            NSLog(@"踢出会议成员失败");
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:nil status:NO];
            }
        }
    }];
}

/*
 * 接受语音会议消息：有人加入，有人退出，有人拒绝，会议解散
 */
- (void)receiceVoiceMeetingMsg:(ECMultiVoiceMeetingMsg *)msg {
    //传入的参数：语音会议号吗，去除时间戳
    NSString *meetingNoWithTimeStamp = [self addTimeStampForMeetingNo:msg.roomNo];
    
    //返回前端结果：meetingNo, memberNo, resultCode
    NSMutableString* result = [[NSMutableString alloc] initWithString:@"{"];
    [result appendString:[NSString stringWithFormat:@"\"meetingNo\":\"%@\",", meetingNoWithTimeStamp]];
    
    if(msg.type == MultiVoice_JOIN) {
        NSLog(@"有人加入");
        ECVoIPAccount *member = [msg.joinArr objectAtIndex:0];
        [result appendString:[NSString stringWithFormat:@"\"memberNo\":\"%@\",", member.account]];
        [result appendString:[NSString stringWithFormat:@"\"resultCode\":\"%@\"}", MEMBER_MEETING_JOIN]];
    } else if(msg.type == MultiVoice_EXIT) {
        NSLog(@"有人退出");
        ECVoIPAccount *member = [msg.exitArr objectAtIndex:0];
        [result appendString:[NSString stringWithFormat:@"\"memberNo\":\"%@\",", member.account]];
        [result appendString:[NSString stringWithFormat:@"\"resultCode\":\"%@\"}", MEMBER_MEETING_EXIT]];
    } else if(msg.type == MultiVoice_DELETE) {
        NSLog(@"房间被删除退出");
        [result appendString:[NSString stringWithFormat:@"\"resultCode\":\"%@\"}", MEMBER_MEETING_DELETE]];
    } else if(msg.type == MultiVoice_REMOVEMEMBER) {
        NSLog(@"有人被移除");
        [result appendString:[NSString stringWithFormat:@"\"memberNo\":\"%@\",", [msg.who account]]];
        [result appendString:[NSString stringWithFormat:@"\"resultCode\":\"%@\"}", MEMBER_MEETING_REMOVE]];
    } else if(msg.type == MultiVoice_REFUSE) {
        NSLog(@"有人拒绝");
        ECVoIPAccount *member = [msg.refuseArr objectAtIndex:0];
        [result appendString:[NSString stringWithFormat:@"\"memberNo\":\"%@\",", member.account]];
        [result appendString:[NSString stringWithFormat:@"\"resultCode\":\"%@\"}", MEMBER_MEETING_REFUSE]];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
        [self.delegate asynResultCallback:self.commandId data:result status:YES];
    }
}

/*
 * 语音会议号加上时间戳：防止号码不唯一
 */
- (NSString*)addTimeStampForMeetingNo:(NSString *) meetingNo {
    return [[self getCurrentTime] stringByAppendingString:meetingNo];
}

/*
 * 语音会议号去除时间戳
 */
- (NSString*)removeTimeStampForMeetingNo:(NSString *)meetingNo {
    return [meetingNo substringFromIndex:CURRENT_TIME_FORMAT.length];
}

/*
 * 得到当前时间的字符串格式
 */
- (NSString*)getCurrentTime {
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init ];
    [dateFormat setDateFormat:CURRENT_TIME_FORMAT];
    NSString * dateFormatString = [dateFormat stringFromDate:date];
    return dateFormatString;
}

@end
