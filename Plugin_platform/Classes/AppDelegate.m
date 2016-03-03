/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  Plugin_platform
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "DeviceDelegateHelper.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[MainViewController alloc] init];
//    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
//    self.window.rootViewController = self.navigationController;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}



+(AppDelegate*)shareInstance {
    return [[UIApplication sharedApplication] delegate];
}


//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
//    NSLog(@"推送的内容：%@",notificationSettings);
//    [application registerForRemoteNotifications];
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    //    NSError *parseError = nil;
//    //    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
//    //                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
//    //    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    //
//    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送内容"
//    //                                                    message:str
//    //                                                   delegate:nil
//    //                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//    //                                          otherButtonTitles:nil];
//    //    [alert show];
//    //
//    //    NSLog(@"远程推送str:%@",str);
//    //    NSLog(@"远程推送1:%@",userInfo);
//    //    NSLog(@"远程推送r:%@",[userInfo objectForKey:@"r"]);
//    //    NSLog(@"远程推送s:%@",[userInfo objectForKey:@"s"]);
//    
//    self.callid = nil;
//    NSString *userdata = [userInfo objectForKey:@"c"];
//    NSLog(@"远程推送userdata:%@",userdata);
//    if (userdata) {
//        NSDictionary*callidobj = [NSJSONSerialization JSONObjectWithData:[userdata dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"远程推送callidobj:%@",callidobj);
//        if ([callidobj isKindOfClass:[NSDictionary class]]) {
//            self.callid = [callidobj objectForKey:@"callid"];
//        }
//    }
//    
//    NSLog(@"远程推送 callid=%@",self.callid);
//}


//将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //将获取到的token传给SDK，用于苹果推送消息使用
    [[ECDevice sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

//注册deviceToken失败；此处失败，与SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

@end
