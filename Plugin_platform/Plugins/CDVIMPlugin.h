//
//  CDVOpenView.h
//  MedicalPad
//
//  Created by 蔡忠亨 2014-8-25.
//  Copyright 上海京颐信息科技有限公司  2014.
//

#import <Cordova/CDV.h>

@interface CDVIMPlugin : CDVPlugin

//phoneGap插件：初始化
- (void)init:(CDVInvokedUrlCommand *)command;

//phoneGap插件：云容联登录
- (void)login:(CDVInvokedUrlCommand *)command;

//phoneGap插件：云容联登出
- (void)logout:(CDVInvokedUrlCommand *)command;

//phoneGap插件：云容联发送消息
- (void) sendMessage:(CDVInvokedUrlCommand *)command;

//phoneGap插件：云容联接收消息
- (void) receiveMessage:(CDVInvokedUrlCommand *)command;

//phoneGap插件：云容联发起视频
- (void) video:(CDVInvokedUrlCommand *)command;

//phoneGap插件：云容联接受视频
- (void) receiveVideo:(CDVInvokedUrlCommand *)command;

//phoneGap插件：获取当前用户在线状态
- (void) getConnectState:(CDVInvokedUrlCommand *)command;

//phoneGap插件：云容联发起语音会议
- (void) createVoiceMeeting:(CDVInvokedUrlCommand *)command;

//phoneGap插件：云容联邀请成员加入语音会议
- (void) inviteVoiceMeetingMembers:(CDVInvokedUrlCommand *)command;

//phoneGap插件：云容联解散语音会议
- (void) disbandVoiceMeeting:(CDVInvokedUrlCommand *)command;

//phoneGap插件：云容联踢出某个会议成员从语音会议
- (void) removeVoiceMeetingMembers:(CDVInvokedUrlCommand *)command;

@end