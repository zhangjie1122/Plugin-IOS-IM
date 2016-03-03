//
//  CDVOpenView.m
//  MedicalPad
//
//  Created by 蔡忠亨 2014-8-25.
//  Copyright 上海京颐信息科技有限公司  2014.
//

#import "IMModular.h"
#import "CDVIMPlugin.h"
#import "AppDelegate.h"
#import "PluginCommon.h"
#import "VideoViewController.h"
#import "DeviceDelegateHelper.h"
#import "VoiceMeetingModule.h"



@implementation CDVIMPlugin

//phoneGap插件：初始化
- (void)init:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult=nil;
    @try {
        PluginCommon* pluginCommon = [PluginCommon sharedInstance];
        [pluginCommon initialize];
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

//phoneGap插件：云容联登录
- (void) login:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult=nil;
    @try {
        NSString* UserId = [command.arguments objectAtIndex:0];
        PluginCommon* pluginCommon = [PluginCommon sharedInstance];
        [pluginCommon login:UserId commandId:command.callbackId delegate:self];
    }
    @catch (NSException *exception) {
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

//phoneGap插件：云容联登出
- (void)logout:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult=nil;
    @try {
        PluginCommon* pluginCommon = [PluginCommon sharedInstance];
        [pluginCommon logout:command.callbackId delegate:self];
    }
    @catch (NSException *exception) {
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

//phoneGap插件：云容联发送消息
- (void) sendMessage:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult=nil;
    @try {
        NSString* ReceiverID = [command.arguments objectAtIndex:0];
        NSString* MessageBody = [command.arguments objectAtIndex:1];
        NSString* MessageType = [command.arguments objectAtIndex:2];
        NSString* FilePath = [command.arguments objectAtIndex:3];
        NSString* DestUrl = [command.arguments objectAtIndex:4];
        Boolean ISGroupMessage = (Boolean)[command.arguments objectAtIndex:5];
        IMModular* imModular = [[IMModular alloc]init];
        [imModular sendMessage:ReceiverID :MessageBody :MessageType :FilePath :DestUrl :ISGroupMessage commandId:command.callbackId delegate:self];
    }
    @catch (NSException *exception) {
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

//phoneGap插件：云容联接收消息
- (void) receiveMessage:(CDVInvokedUrlCommand *)command
{
    
}

//phoneGap插件：云容联发起视频
- (void) video:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult=nil;
    @try {
        NSString* ReceiverID = [command.arguments objectAtIndex:0];
        VideoViewController* videoViewController = [[VideoViewController alloc]initWithCallerName:@"数据库中取" andVoipNo:ReceiverID andCallstatus:0];
        id rootviewcontroller = [AppDelegate shareInstance].window.rootViewController;
        [rootviewcontroller presentViewController:videoViewController animated:YES completion:nil];
        [videoViewController setDeleteData:command.callbackId delegate:self];
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

//phoneGap插件：云容联接受视频
- (void) receiveVideo:(CDVInvokedUrlCommand *)command
{
    VideoViewController* videoViewController = [[VideoViewController alloc]init];
    [videoViewController setDeleteData:command.callbackId delegate:self];
}

- (void) getConnectState:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
    DeviceDelegateHelper* devicedelegatehelper = [DeviceDelegateHelper sharedInstance];
    if ([@"success" isEqualToString:devicedelegatehelper.connectState])
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else if ([@"failed" isEqualToString:devicedelegatehelper.connectState]){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } else {
        // 连接中状态时不做处理
        return;
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


//phoneGap插件：云容联发起语音会议
- (void) createVoiceMeeting:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult=nil;
    @try {
        NSString* membersStr = [command.arguments objectAtIndex:0];
        VoiceMeetingModule* voiceMeetingModule = [VoiceMeetingModule sharedInstance];
        [voiceMeetingModule createVoiceMeeting:membersStr commandId:command.callbackId delegate:self];
    }
    @catch (NSException *exception) {
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

//phoneGap插件：云容联邀请成员加入语音会议
- (void) inviteVoiceMeetingMembers:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult=nil;
    @try {
        NSString* meetingNo = [command.arguments objectAtIndex:0];
        NSString* membersStr = [command.arguments objectAtIndex:1];
        VoiceMeetingModule* voiceMeetingModule = [VoiceMeetingModule sharedInstance];
        [voiceMeetingModule inviteVoiceMeetingMembers:meetingNo withMembersStr: membersStr commandId:command.callbackId delegate:self];
    }
    @catch (NSException *exception) {
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

//phoneGap插件：云容联解散语音会议
- (void) disbandVoiceMeeting:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult=nil;
    @try {
        NSString* meetingNo = [command.arguments objectAtIndex:0];
        VoiceMeetingModule* voiceMeetingModule = [VoiceMeetingModule sharedInstance];
        [voiceMeetingModule disbandVoiceMeeting:meetingNo commandId:command.callbackId delegate:self];
    }
    @catch (NSException *exception) {
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

//phoneGap插件：云容联踢出某个会议成员从语音会议
- (void) removeVoiceMeetingMembers:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult=nil;
    @try {
        NSString* meetingNo = [command.arguments objectAtIndex:0];
        NSString* memberStr = [command.arguments objectAtIndex:1];
        VoiceMeetingModule* voiceMeetingModule = [VoiceMeetingModule sharedInstance];
        [voiceMeetingModule removeVoiceMeetingMember:meetingNo withMemberStr:memberStr commandId:command.callbackId delegate:self];
    }
    @catch (NSException *exception) {
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}



//phoneGap插件：异步处理后，触发委托事件将对应值传给js
- (void) asynResultCallback:(NSString *)commandId data:(NSString *)data status:(Boolean)status
{
    CDVPluginResult* pluginResult = nil;
    if (status) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:data];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandId];
}

@end