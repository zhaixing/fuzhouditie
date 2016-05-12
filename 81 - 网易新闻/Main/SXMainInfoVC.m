//
//  SXMainInfoVC.m
//  福州地铁
//
//  Created by STDU on 16/1/2.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXMainInfoVC.h"
#import "SXLoginViewController.h"

@interface SXMainInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
- (IBAction)btnLoginOut;

@end

@implementation SXMainInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefault objectForKey:@"name"];
    NSString *user = [userDefault objectForKey:@"user"];
    _lblName.text = [NSString stringWithFormat:@"您的姓名：%@",name];
    _lblUserName.text = [NSString stringWithFormat:@"用户名：%@",user];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnLoginOut {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"num"];
    [userDefault removeObjectForKey:@"name"];
    [userDefault removeObjectForKey:@"user"];
    [userDefault removeObjectForKey:@"pwd"];
    [userDefault synchronize];
    [self.navigationController popViewControllerAnimated:NO];//退出个人信息界面
    // 加载登录界面
    SXLoginViewController *lVC = [[SXLoginViewController alloc] initWithNibName:@"SXLoginViewController" bundle:nil];
    [self presentViewController:lVC animated:YES completion:nil];
    
}
@end
