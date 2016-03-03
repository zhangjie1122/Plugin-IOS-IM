//
//  PluginDelegate.h
//  趣医医生
//
//  Created by huangaoxin on 16/3/2.
//
//

#ifndef PluginDelegate_h
#define PluginDelegate_h


#endif /* PluginDelegate_h */

#import <Foundation/Foundation.h>
// 设置委托
@protocol PluginDelegate <NSObject>

// 插件异步结果回调函数
- (void) asynResultCallback:(NSString*) commandId data:(NSString*) data status:(Boolean) status;

@end
