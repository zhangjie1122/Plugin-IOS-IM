//
//  DeviceDelegateHelper.m
//  Plugin_platform
//
//  Created by 蔡忠亨 on 16/3/1.
//
//

//代理类.m文件中需要实现ECDeviceDelegate的回调函数，代码示例如下:
#import "DeviceDelegateHelper.h"


@implementation DeviceDelegateHelper

@synthesize connectState;

//如需使用IM功能，需实现ECChatDelegate类的回调函数。
//如需使用实时音视频功能，需实现ECVoIPCallDelegate类的回调函数。
//如需使用音视频会议功能，需实现ECMeetingDelegate类的回调函数。

//第一步：创建单例方法
+(DeviceDelegateHelper*)sharedInstance
{
    
    static DeviceDelegateHelper *devicedelegatehelper;
    
    static dispatch_once_t devicedelegatehelperonce;
    
    dispatch_once(&devicedelegatehelperonce, ^{
        
        devicedelegatehelper = [[DeviceDelegateHelper alloc] init];
        
    });
    
    return devicedelegatehelper;
    
}


//第二步：连接云通讯的服务平台，实现ECDelegateBase代理的方法
/**
 @brief 连接状态接口
 @discussion 监听与服务器的连接状态 V5.0版本接口
 @param state 连接的状态
 @param error 错误原因值
 */
-(void)onConnectState:(ECConnectState)state failed:(ECError*)error
{
    switch (state) {
        case State_ConnectSuccess:
            //连接成功
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:[ECError errorWithCode:ECErrorType_NoError]];
            self.connectState = @"success";
            break;
        case State_Connecting:
            //正在连接
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:[ECError errorWithCode:ECErrorType_Connecting]];
            self.connectState = @"connecting";
            break;
        case State_ConnectFailed:
            //失败
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:error];
            self.connectState = @"failed";
            break;
        default:
            break;
    }
    
}



//第三步 ：各功能回调函数实现
//如需使用im功能，需实现ECChatDelegate类的回调函数。
/**
 @brief 客户端录音振幅代理函数
 @param amplitude 录音振幅
 */
-(void)onRecordingAmplitude:(double) amplitude
{
    
}

/**
 @brief 接收即时消息代理函数
 @param message 接收的消息
 */
-(void)onReceiveMessage:(ECMessage*)message
{
    NSLog(@"收到%@的消息,属于%@会话", message.from, message.sessionId);
    switch(message.messageBody.messageBodyType){
        case MessageBodyType_Text:{
            ECTextMessageBody *msgBody = (ECTextMessageBody *)message.messageBody;
            NSLog(@"收到的是文本消息------%@",msgBody.text);
            break;
        }
        case MessageBodyType_Voice:{
            ECVoiceMessageBody *msgBody = (ECVoiceMessageBody *)message.messageBody;
            NSLog(@"音频文件remote路径------%@",msgBody. remotePath);
            break;
        }
            
        case MessageBodyType_Video:{
            ECVideoMessageBody *msgBody = (ECVideoMessageBody *)message.messageBody;
            NSLog(@"视频文件remote路径------%@",msgBody. remotePath);
            break;
        }
            
        case MessageBodyType_Image:{
            ECImageMessageBody *msgBody = (ECImageMessageBody *)message.messageBody;
            NSLog(@"图片文件remote路径------%@",msgBody. remotePath);
            NSLog(@"缩略图片文件remote路径------%@",msgBody. thumbnailRemotePath);
            break;
        }
            
        case MessageBodyType_File:{
            ECFileMessageBody *msgBody = (ECFileMessageBody *)message.messageBody;
            NSLog(@"文件remote路径------%@",msgBody. remotePath);
            break;
        }
        default:
            break;
    }
}

/**
 @brief 离线消息数
 @param count 消息数
 */
-(void)onOfflineMessageCount:(NSUInteger)count
{
    
}

/**
 @brief 需要获取的消息数
 @return 消息数 -1:全部获取 0:不获取
 */
-(NSInteger)onGetOfflineMessage
{
    return -1;
}

/**
 @brief 接收离线消息代理函数
 @param message 接收的消息
 */
-(void)onReceiveOfflineMessage:(ECMessage*)message
{
    
}

/**
 @brief 离线消息接收是否完成
 @param isCompletion YES:拉取完成 NO:拉取未完成(拉取消息失败)
 */
-(void)onReceiveOfflineCompletion:(BOOL)isCompletion
{
    
}

/**
 @brief 接收群组相关消息
 @discussion 参数要根据消息的类型，转成相关的消息类；
 解散群组、收到邀请、申请加入、退出群组、有人加入、移除成员等消息
 @param groupMsg 群组消息
 */
-(void)onReceiveGroupNoticeMessage:(ECGroupNoticeMessage *)groupMsg
{
    
}


@end