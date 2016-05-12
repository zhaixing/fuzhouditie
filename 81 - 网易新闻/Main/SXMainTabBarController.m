#import "SXMainTabBarController.h"
#import "SXBarButton.h"
#import "SXTabBar.h"
#import "SXMainViewController.h"
#import "SXNavController.h"
#import "SXAdManager.h"
#import "UIView+Frame.h"

@interface SXMainTabBarController ()<SXTabBarDelegate>//这个类实现了这个代理

@end

@implementation SXMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([SXAdManager isShouldDisplayAd]) {
        // ------这里主要是容错一个bug。
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"top20"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"rightItem"];
        
        // ------本想把广告设置成广告显示完毕之后再加载rootViewController的，但是由于前期已经使用storyboard搭建了，写在AppDelete里会冲突，只好就随便整个view广告
        UIView *adView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        UIImageView *adImg = [[UIImageView alloc]initWithImage:[SXAdManager getAdImage]];
        UIImageView *adBottomImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"adBottom.png"]];
        [adView addSubview:adBottomImg];
        [adView addSubview:adImg];
        adBottomImg.frame = CGRectMake(0, self.view.height - 135, self.view.width, 135);
        adImg.frame = CGRectMake(0, 0, self.view.width, self.view.height - 135);
        adImg.frame = [UIScreen mainScreen].bounds;
        adView.alpha = 0.99f;
        //[self.view addSubview:adView];//将广告的视图加上去
        [[UIApplication sharedApplication] setStatusBarHidden:YES];//将状态栏隐藏
        
        [UIView animateWithDuration:3 animations:^{
            adView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication]setStatusBarHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                adView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [adView removeFromSuperview];
            }];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SXAdvertisementKey" object:nil];
        }];
    } else {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"update"];
    }

    
    SXTabBar *tabBar = [[SXTabBar alloc] init];
    tabBar.frame = self.tabBar.bounds;
    tabBar.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    [self.tabBar addSubview:tabBar];
    
    tabBar.delegate = self;
    
    [tabBar addImageView];
    
    [tabBar addBarButtonWithNorName:@"tabbar_icon_news_normal" andDisName:@"tabbar_icon_news_highlight" andTitle:@"进度"];
    [tabBar addBarButtonWithNorName:@"tabbar_icon_reader_normal" andDisName:@"tabbar_icon_reader_highlight" andTitle:@"事务"];
//    [tabBar addBarButtonWithNorName:@"tabbar_icon_media_normal" andDisName:@"tabbar_icon_media_highlight" andTitle:@"公告"];
    [tabBar addBarButtonWithNorName:@"tabbar_icon_found_normal" andDisName:@"tabbar_icon_found_highlight" andTitle:@"预警"];
//    [tabBar addBarButtonWithNorName:@"tabbar_icon_me_normal" andDisName:@"tabbar_icon_me_highlight" andTitle:@"我"];
    
    //默认选择的是序号0
    self.selectedIndex = 0;
}
#pragma mark - ******************** SXTabBarDelegate代理方法
- (void)ChangSelIndexForm:(NSInteger)from to:(NSInteger)to {
    self.selectedIndex = to;
}

@end
