//
//  Common.h
//  Plugin_platform
//
//  Created by 蔡忠亨 on 16/3/1.
//
//

#ifndef Common_h
#define Common_h


#define APP_KEY         @"8a48b55150f4a726015101061ef5367d"
#define APP_TOKEN       @"76809be73dc19b11a7a82aa2958faa4b"





//以下是本地测试所需常量
//#define APP_ID          @"testing"
//#define APP_OTHER_ID    @"testtest"
//#define APP_ID          @"testtest"
//#define APP_OTHER_ID    @"18801969430"
#define APP_ID          @"18801969430"
#define APP_OTHER_ID    @"testtest"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//系统版本号
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define SCREEN_WIDTH (SYSTEM_VERSION <8 ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
#define SCREEN_HEIGHT (SYSTEM_VERSION < 8 ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

//语音会议配置
#define VOICEMEETING_LIMIT_NUMBER 8                          //语音会议人数限制: 8人
#define VOICEMEETING_TYPE         ECMeetingType_MultiVoice   //会议类型: 语音群聊类型
#define VOICEMEETING_PWD          @""                        //语音会议密码：暂不设置
#define VOICEMEETING_AUTO_CLOSE   NO                         //创建者退出后会议是否解散：不
#define VOICEMEETING_AUTO_JOIN    YES                        //创建后，是否自动加入会议：是
#define VOICEMEETING_AUTO_DELETE  YES                        //是否为永久会议：是
#define VOICEMEETING_KEYWORDS     @""                        //业务属性
#define VOICEMEETING_VOICEMOD     2                          //会议背景模式:有提示音有背景音
#define VOICEMEETING_CALL_TYPE    YES                        //语音会议呼叫方式：电话呼叫（NO是voip呼叫）

//语音消息配置
#define MEMBER_MEETING_JOIN       @"6001"                    //加入语音会议
#define MEMBER_MEETING_EXIT       @"6002"                    //退出语音会议
#define MEMBER_MEETING_DELETE     @"6002"                    //解散语音会议
#define MEMBER_MEETING_REMOVE     @"6002"                    //删除语音会议成员
#define MEMBER_MEETING_REFUSE     @"6002"                    //拒绝语音会议

//当前时间戳格式
#define CURRENT_TIME_FORMAT       @"yyyyMMdd HHmmss"         

#endif /* Common_h */
