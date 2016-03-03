//
//  Login.m
//  Plugin_platform
//
//  Created by 蔡忠亨 on 16/3/1.
//
//

#import "Common.h"
#import "IMModular.h"
#import "DeviceDelegateHelper.h"


@implementation IMModular

//发送消息
- (void)sendMessage:(NSString*) ReceiverID :(NSString*) MessageBody :(NSString*) MessageType :(NSString*) FilePath :(NSString*) DestUrl :(Boolean) ISGroupMessage commandId:(NSString*) commandId delegate:(id) delegate
{
    if([MessageType isEqualToString:@"TEXT"]){
        if(ISGroupMessage==0){
            [self sendTextMessage:ReceiverID :MessageBody commandId:commandId delegate:delegate];
        }
    }
}

//发送文本消息
- (void)sendTextMessage:(NSString*) ReceiverID :(NSString*) MessageBody commandId:(NSString*) commandId delegate:(id) delegate
{
    ECTextMessageBody *messageBody = [[ECTextMessageBody alloc] initWithText:MessageBody];
    ECMessage *message = [[ECMessage alloc] initWithReceiver:ReceiverID body:messageBody];
    
    //【具体什么样的才算是跨应用发送消息？？】
    //如果需要跨应用发送消息，需通过appkey+英文井号+用户帐号的方式拼接，发送录音、发送群组消息等与此方式一致
    //群组跨应用只是邀请成员时，被邀请的用户要用appid#账号的格式，向群组里发消息不需要。
    //ECMessage *message = [[ECMessage alloc] initWithReceiver:@"appkey#John的账号Id" body:messageBody];
    
    //取本地时间
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval tmp =[date timeIntervalSince1970]*1000;
    message.timestamp = [NSString stringWithFormat:@"%lld", (long long)tmp];
    
    [[ECDevice sharedInstance].messageManager sendMessage:message progress:nil completion:^(ECError *error,ECMessage *amessage) {
        if (error.errorCode == ECErrorType_NoError) {
            //发送成功
            ECTextMessageBody *msgBody = (ECTextMessageBody *)message.messageBody;
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:msgBody.text status:YES];
            }
        }else if(error.errorCode == ECErrorType_Have_Forbid || error.errorCode == ECErrorType_File_Have_Forbid){
            //您已被群组禁言
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:@"群组禁言" status:NO];
            }
        }else{
            //发送失败
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:[NSString stringWithFormat:@"发送失败，失败原因为：%ld",(long)error.errorCode] status:NO];
            }
        }
    }];
}




@end