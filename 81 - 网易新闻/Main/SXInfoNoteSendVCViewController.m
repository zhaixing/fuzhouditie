//
//  SXInfoNoteSendVCViewController.m
//  福州地铁
//
//  Created by STDU on 16/4/10.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXInfoNoteSendVCViewController.h"

@interface SXInfoNoteSendVCViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@end

@implementation SXInfoNoteSendVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblContent.text = _content;
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

@end
