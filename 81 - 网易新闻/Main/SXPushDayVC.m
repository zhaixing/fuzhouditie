//
//  SXPushDayVC.m
//  福州地铁
//
//  Created by STDU on 15/12/10.
//  Copyright © 2015年 ShangxianDante. All rights reserved.
//

#import "SXPushDayVC.h"

@interface SXPushDayVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
- (IBAction)btnShow;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark;

@property (retain, nonatomic) NSArray *pushConArr;

@end
NSString *BiaoDuan;
NSString *Time;
NSString *infoNote;
NSString *remark;
NSArray *infoNoteArr;
NSArray *remarkArr;
@implementation SXPushDayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pushConArr = [_contentLabel componentsSeparatedByString:@"+"];
    BiaoDuan = [_pushConArr objectAtIndex:1];
    Time = [_pushConArr objectAtIndex:2];
    infoNote = [_pushConArr objectAtIndex:3];
    remark = [_pushConArr objectAtIndex:4];
    
    _lblContent.text = BiaoDuan;
    _lblContent.numberOfLines = 0;
    _lblTime.text = Time;
    _lblRemark.text = remark;
    _lblRemark.numberOfLines = 2;
    _lblRemark.textAlignment = NSTextAlignmentLeft;
    
    infoNoteArr = [infoNote componentsSeparatedByString:@"；"];
    for (NSString *temp in infoNoteArr) {
        NSLog(@"打印情况说明：%@",temp);
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return infoNoteArr.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    for (int i=0; i<infoNoteArr.count; i++  ) {
        if (indexPath.row == i) {
            cell.textLabel.text = [infoNoteArr objectAtIndex:i];
        }
        //NSLog(@"打印情况说明：%@",temp);
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 退出按钮
- (IBAction)btnShow {
    NSLog(@"我点我点。。。");
    // 返回到上一个界面，也就是退出这个界面
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
