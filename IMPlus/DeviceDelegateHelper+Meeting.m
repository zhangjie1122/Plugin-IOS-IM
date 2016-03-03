//
//  DeviceDelegateHelper+Meeting.m
//  Plugin_platform
//
//  Created by 张杰 on 16/3/3.
//
//

#import "DeviceDelegateHelper+Meeting.h"
#import "VoiceMeetingModule.h"


@implementation DeviceDelegateHelper(Meeting)

/**
 @brief 语音群聊通知消息
 @param msg 语音群聊消息
 */
-(void)onReceiveMultiVoiceMeetingMsg:(ECMultiVoiceMeetingMsg *)message {
    [[VoiceMeetingModule sharedInstance] receiceVoiceMeetingMsg:message];
}

@end
