//
//  SXNavController.m
//

#import "SXNavController.h"

@interface SXNavController ()

@end

@implementation SXNavController

+ (void)initialize {
    // 设置导航栏的主题,颜色设为蓝色
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor blueColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];    
}

@end
