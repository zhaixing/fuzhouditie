//
//  AppDelegate.m

#import "AppDelegate.h"
#import "APService.h"
//#import "SXPushDayVC.h"
#import "SXLoginViewController.h"
#import "SXMainViewController.h"

@interface AppDelegate ()
@property (strong,nonatomic) SXMainViewController* pushDay;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // NSUserDefaults standardUserDefaults 使用来存取一些短小的信息
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"update"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"top20"];
    UIApplication *app = [UIApplication sharedApplication];
    app.statusBarStyle = UIStatusBarStyleLightContent;//更改手机状态栏的颜色
    
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    NSString *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"userInfo:%@",userInfo);
    
    // Required
    [APService setupWithOption:launchOptions];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"this is iOS7 Remote Notification");
    
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容

    NSLog(@"content123:%@",content);
    
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音

    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);
    // 创建推送控制器的对象
//    SXPushDayVC *pushDay = [[SXPushDayVC alloc] initWithNibName:@"SXPushDayVC" bundle:nil];
//    pushDay.contentLabel = content;
    SXMainViewController *pushDay = [[SXMainViewController alloc] init];
    pushDay.contentLabel = content;
    [APService resetBadge];
//    [self.window.rootViewController presentViewController:pushDay animated:YES completion:nil];
    
    NSLog(@"郭健豪");
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
// 设置应用禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

@end
