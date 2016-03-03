//
//  Login.h
//  Plugin_platform
//
//  Created by 蔡忠亨 on 16/3/1.
//
//

#import <Foundation/Foundation.h>
#import "PluginDelegate.h"


@interface IMModular : NSObject


//发送消息
- (void)sendMessage:(NSString*) ReceiverID :(NSString*) MessageBody :(NSString*) MessageType :(NSString*) FilePath :(NSString*) DestUrl :(Boolean) ISGroupMessage commandId:(NSString*) commandId delegate:(id) delegate;


@end