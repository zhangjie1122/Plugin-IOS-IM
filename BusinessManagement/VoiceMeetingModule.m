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

//创建单例
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
 * 发起语音会议
 */
- (void)createVoiceMeeting:(NSString *)membersStr commandId:(NSString*) commandId delegate:(id) delegate {
    //语音会议名称
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init ];
    [dateFormat setDateFormat:@"yyyy年MM月dd日 HH小时mm分ss秒"];
    NSString * dateFormatString = [dateFormat stringFromDate:date];
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
        //meetingNumber 创建会议回调的会议号
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
    
    //调用容联接口，邀请成员加入语音会议
    [[ECDevice sharedInstance].meetingManager inviteMembersJoinToVoiceMeeting: meetingNo andIsLoandingCall: VOICEMEETING_CALL_TYPE andMembers: memberArray completion:^(ECError *error, NSString *meetingNumber) {
        if (error.errorCode == ECErrorType_NoError) {
            NSLog(@"邀请成员成功");
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:meetingNumber status:YES];
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
    //调用容联接口，解散语音会议
    [[ECDevice sharedInstance].meetingManager deleteMultMeetingByMeetingType: VOICEMEETING_TYPE andMeetingNumber: meetingNo completion:^(ECError *error, NSString *meetingNumber) {
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
    
    //调用容联接口，踢出某个会议成员从语音会议
    [[ECDevice sharedInstance].meetingManager removeMemberFromMultMeetingByMeetingType: VOICEMEETING_TYPE andMeetingNumber: meetingNo andMember: member completion:^(ECError *error, ECVoIPAccount *membervVoip) {
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

@end
