//
//  Login.m
//  Plugin_platform
//
//  Created by 蔡忠亨 on 16/3/1.
//
//

#import "Common.h"
#import "PluginCommon.h"
#import "DeviceDelegateHelper.h"


@implementation PluginCommon

//第一步：创建单例方法
+(PluginCommon*)sharedInstance
{
    static PluginCommon *pluginCommon;
    static dispatch_once_t pluginCommononce;
    dispatch_once(&pluginCommononce, ^{
        pluginCommon = [[PluginCommon alloc] init];
    });
    return pluginCommon;
}

//初始化
- (void)initialize
{
    //设置代理
    [ECDevice sharedInstance].delegate = [DeviceDelegateHelper sharedInstance];
    //初始化数据库
    
    //初始化监听事件
    
}

//云容联登录
- (void)login:(NSString*) UserId commandId:(NSString *)commandId delegate:(id)delegate
{
    [self initialize];
    ECLoginInfo * loginInfo = [[ECLoginInfo alloc] init];
    loginInfo.username = UserId;
    loginInfo.appKey = APP_KEY;
    loginInfo.appToken = APP_TOKEN;
    loginInfo.authType = LoginAuthType_NormalAuth;
    loginInfo.mode = LoginMode_InputPassword;
    [[ECDevice sharedInstance] login:loginInfo completion:^(ECError *error){
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:error];
        if (error.errorCode == ECErrorType_NoError) {
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:nil status:YES];
            }
        }else{
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:nil status:NO];
            }
        }
    }];
}

//云容联登出
- (void)logout:(NSString*) commandId delegate:(id) delegate
{
    [[ECDevice sharedInstance] logout:^(ECError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:error];
        if (error.errorCode == ECErrorType_NoError) {
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:nil status:YES];
            }
        }else{
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:nil status:YES];
            }
        }
    }];
}


- (void)getUserState:(NSString*) UserId commandId:(NSString *)commandId delegate:(id)delegate
{
    [[ECDevice sharedInstance] getUserState:UserId completion:^(ECError *error, ECUserState *state) {
        NSMutableDictionary *dict = [NSMutableDictionary init];
        if ([UserId isEqualToString:state.userAcc]) {
            if (state.isOnline) {
                [dict setValue:[self getDeviceWithType:state.deviceType] forKey:@"DeviceType"];
                [dict setValue:[self getNetWorkWithType:state.network] forKey:@"NetworkType"];
                [dict setValue:@"true" forKey:@"isOnline"];
            } else {
                [dict setValue:@"false" forKey:@"isOnline"];
            }
            NSError* error = nil;
            NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            if(delegate && [delegate respondsToSelector:@selector(asynResultCallback: data: status:)]==YES){
                [delegate asynResultCallback:commandId data:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] status:YES];
            }
        }
    }];
}

-(NSString*)getDeviceWithType:(ECDeviceType)type{
    switch (type) {
        case ECDeviceType_AndroidPhone:
            return @"Android手机";
            
        case ECDeviceType_iPhone:
            return @"iPhone手机";
            
        case ECDeviceType_iPad:
            return @"iPad平板";
            
        case ECDeviceType_AndroidPad:
            return @"Android平板";
            
        case ECDeviceType_PC:
            return @"PC";
            
        case ECDeviceType_Web:
            return @"Web";
            
        default:
            return @"未知";
    }
}

-(NSString*)getNetWorkWithType:(ECNetworkType)type{
    switch (type) {
        case ECNetworkType_WIFI:
            return @"wifi";
            
        case ECNetworkType_4G:
            return @"4G";
            
        case ECNetworkType_3G:
            return @"3G";
            
        case ECNetworkType_GPRS:
            return @"GRPS";
            
        case ECNetworkType_LAN:
            return @"Internet";
        default:
            return @"其他";
    }
}


@end