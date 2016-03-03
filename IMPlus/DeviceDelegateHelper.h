

#import <Foundation/Foundation.h>
#import "ECDeviceHeaders.h"
#import "AppDelegate.h"

#define KNOTIFICATION_onConnected       @"KNOTIFICATION_onConnected"
#define KNOTIFICATION_onSystemEvent    @"KNOTIFICATION_onSystemEvent"

@interface DeviceDelegateHelper : NSObject<ECDeviceDelegate>

@property(assign, nonatomic) NSString* connectState;

/**
 *@brief 获取DeviceDelegateHelper单例句柄
 */
+(DeviceDelegateHelper*)sharedInstance;


@end