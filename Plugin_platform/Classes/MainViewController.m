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
//  MainViewController.h
//  Plugin_platform
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "Common.h"
#import "IMModular.h"
#import "PluginCommon.h"
#import "ECDeviceHeaders.h"
#import "VideoViewController.h"
#import "DeviceDelegateHelper.h"
#import "MainViewController.h"
#import "VoiceMeetingModule.h"

NSString *meetingNo;

@implementation MainViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.

    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //登录框
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 110,80,80)];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button.layer setCornerRadius:5.0];
    button.backgroundColor = RGBACOLOR(153,202,251,0.4);
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //发送消息框
    button = [[UIButton alloc]initWithFrame:CGRectMake(10, 210,80,80)];
    [button setTitle:@"发送消息" forState:UIControlStateNormal];
    [button.layer setCornerRadius:5.0];
    button.backgroundColor = RGBACOLOR(153,202,251,0.4);
    [button addTarget:self action:@selector(continueTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    //发起视频框
    button = [[UIButton alloc]initWithFrame:CGRectMake(10, 310,80,80)];
    [button setTitle:@"发起视频" forState:UIControlStateNormal];
    [button.layer setCornerRadius:5.0];
    button.backgroundColor = RGBACOLOR(153,202,251,0.4);
    [button addTarget:self action:@selector(launchVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //登出框
    button = [[UIButton alloc]initWithFrame:CGRectMake(10, 410,80,80)];
    [button setTitle:@"登出" forState:UIControlStateNormal];
    [button.layer setCornerRadius:5.0];
    button.backgroundColor = RGBACOLOR(153,202,251,0.4);
    [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //创建语音会议
    button = [[UIButton alloc]initWithFrame:CGRectMake(10, 510,80,80)];
    [button setTitle:@"创建语音" forState:UIControlStateNormal];
    [button.layer setCornerRadius:5.0];
    button.backgroundColor = RGBACOLOR(153,202,251,0.4);
    [button addTarget:self action:@selector(createVoiceMeeting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //解散语音会议
    button = [[UIButton alloc]initWithFrame:CGRectMake(10, 610,80,80)];
    [button setTitle:@"解散语音" forState:UIControlStateNormal];
    [button.layer setCornerRadius:5.0];
    button.backgroundColor = RGBACOLOR(153,202,251,0.4);
    [button addTarget:self action:@selector(disbandVoiceMeeting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //踢人语音
    button = [[UIButton alloc]initWithFrame:CGRectMake(100, 110,80,80)];
    [button setTitle:@"踢人语音" forState:UIControlStateNormal];
    [button.layer setCornerRadius:5.0];
    button.backgroundColor = RGBACOLOR(153,202,251,0.4);
    [button addTarget:self action:@selector(removeVoiceMeetingMember) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //加人语音
    button = [[UIButton alloc]initWithFrame:CGRectMake(100, 210,80,80)];
    [button setTitle:@"加人语音" forState:UIControlStateNormal];
    [button.layer setCornerRadius:5.0];
    button.backgroundColor = RGBACOLOR(153,202,251,0.4);
    [button addTarget:self action:@selector(addVoiceMeetingMember) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/*
- (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
{
    return[super newCordovaViewWithFrame:bounds];
}
*/


//测试函数
//登录
-(void)login
{
    PluginCommon* pluginCommon = [PluginCommon sharedInstance];
    [pluginCommon login:APP_ID commandId:nil delegate:self];
}

//登出
-(void)logout
{
    PluginCommon* pluginCommon = [PluginCommon sharedInstance];
    [pluginCommon logout:nil delegate:self];
}

//发送消息
- (void) continueTest
{
    //发送消息
    IMModular* imModular = [[IMModular alloc]init];
    [imModular sendMessage:APP_OTHER_ID :@"hello" :@"TEXT" :nil :nil :0 commandId:nil delegate:self];
}

//发起视频
-(void) launchVideo{
    VideoViewController* videoViewController = [[VideoViewController alloc]initWithCallerName:@"数据库中取" andVoipNo:APP_OTHER_ID andCallstatus:0];
    id rootviewcontroller = [AppDelegate shareInstance].window.rootViewController;
    [rootviewcontroller presentViewController:videoViewController animated:YES completion:nil];
    [videoViewController setDeleteData:nil delegate:self];
}

//发起语音会议
-(void) createVoiceMeeting{
    VoiceMeetingModule* voiceMeetingModule = [[VoiceMeetingModule alloc] init];
    [voiceMeetingModule createVoiceMeeting:@"13795480340,15201833743" commandId:nil delegate:self];
}

//解散语音会议
-(void) disbandVoiceMeeting{
    VoiceMeetingModule* voiceMeetingModule = [[VoiceMeetingModule alloc] init];
    [voiceMeetingModule disbandVoiceMeeting:meetingNo commandId:nil delegate:self];
}

//踢人语音会议
-(void) removeVoiceMeetingMember{
    VoiceMeetingModule* voiceMeetingModule = [[VoiceMeetingModule alloc] init];
    [voiceMeetingModule removeVoiceMeetingMember:meetingNo withMemberStr:@"15201833743" commandId:nil delegate:self];
}

//加人语音会议
-(void) addVoiceMeetingMember{
    VoiceMeetingModule* voiceMeetingModule = [[VoiceMeetingModule alloc] init];
    [voiceMeetingModule inviteVoiceMeetingMembers:meetingNo withMembersStr:@"18801969430" commandId:nil delegate:self];
}

- (void) asynResultCallback:(NSString *)commandId data:(NSString *)data status:(Boolean)status
{
    if([data hasPrefix:@"conf"]) {
        meetingNo = data;
    }
    NSLog(@"回调被触发:%@",data);
}

@end



@implementation MainCommandDelegate

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end



@implementation MainCommandQueue

- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end
