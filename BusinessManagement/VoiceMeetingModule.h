//
//  VoiceMeetingModule.h
//  Plugin_platform
//
//  Created by 张杰 on 16/3/1.
//
//

#import <Foundation/Foundation.h>
#import "ECMultiVoiceMeetingMsg.h"
#import "PluginDelegate.h"

@interface VoiceMeetingModule : NSObject

@property (nonatomic, strong) NSString* commandId;
@property (nonatomic, strong) id delegate;

//获取单例
+ (VoiceMeetingModule*)sharedInstance;

//初始化时将回调的commandId和委托对象传入进来
- (void)setDelegateData:(NSString*)commandId delegate:(id)delegate;

//发起语音会议
- (void)createVoiceMeeting:(NSString*)membersStr commandId:(NSString*) commandId delegate:(id) delegate;

//邀请成员加入会议
- (void)inviteVoiceMeetingMembers:(NSString *)meetingNo withMembersStr:(NSString *)membersStr commandId:(NSString*) commandId delegate:(id) delegate;

//解散语音会议
- (void)disbandVoiceMeeting:(NSString *)meetingNo commandId:(NSString*) commandId delegate:(id) delegate;

//踢出某个会议成员从语音会议
- (void)removeVoiceMeetingMember:(NSString *)meetingNo withMemberStr:(NSString *)memberStr commandId:(NSString*) commandId delegate:(id) delegate;

//接受语音会议消息：有人加入，有人退出，有人拒绝，会议解散
- (void)receiceVoiceMeetingMsg:(ECMultiVoiceMeetingMsg *)msg;

@end