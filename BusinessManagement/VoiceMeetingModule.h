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

//获取单例
+ (VoiceMeetingModule*)sharedInstance;

//发起语音会议
- (void)createVoiceMeeting:(NSString*)membersStr commandId:(NSString*) commandId delegate:(id) delegate;

//邀请成员加入会议
- (void)inviteVoiceMeetingMembers:(NSString *)meetingNo withMembersStr:(NSString *)membersStr commandId:(NSString*) commandId delegate:(id) delegate;

//解散语音会议
- (void)disbandVoiceMeeting:(NSString *)meetingNo commandId:(NSString*) commandId delegate:(id) delegate;

//踢出某个会议成员从语音会议
- (void)removeVoiceMeetingMember:(NSString *)meetingNo withMemberStr:(NSString *)memberStr commandId:(NSString*) commandId delegate:(id) delegate;

@end