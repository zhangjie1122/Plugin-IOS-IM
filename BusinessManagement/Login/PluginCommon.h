//
//  Login.h
//  Plugin_platform
//
//  Created by 蔡忠亨 on 16/3/1.
//
//

#import <Foundation/Foundation.h>
#import "PluginDelegate.h"


@interface PluginCommon : NSObject

//获取单例
+(PluginCommon*)sharedInstance;

//初始化
- (void)initialize;

//云容联登录
- (void)login:(NSString*) UserId commandId:(NSString*) commandId delegate:(id) delegate;

//云容联登出
- (void)logout:(NSString*) commandId delegate:(id) delegate;

//用户在线状态
- (void)getUserState:(NSString*) UserId commandId:(NSString*) commandId delegate:(id) delegate;


@end