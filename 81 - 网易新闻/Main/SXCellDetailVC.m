//
//  SXCellDetailVC.m
//  福州地铁
//
//  Created by STDU on 15/12/8.
//  Copyright © 2015年 ShangxianDante. All rights reserved.
//

#import "SXCellDetailVC.h"
#import "SXInfoNoteSendVCViewController.h"

@interface SXCellDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSjsw;
@property (weak, nonatomic) IBOutlet UILabel *lblSjcz;
@property (weak, nonatomic) IBOutlet UILabel *lblDwcsw;
@property (weak, nonatomic) IBOutlet UILabel *lblDwccz;
@property (weak, nonatomic) IBOutlet UILabel *lblSumwcsw;
@property (weak, nonatomic) IBOutlet UILabel *lblSumwccz;
@property (weak, nonatomic) IBOutlet UILabel *lblPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark;
//@property (weak, nonatomic) IBOutlet UITextView *tvRemark;

@end

NSArray *infoNoteArr;

@implementation SXCellDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text = _pNameTotal;
    _lblTime.text = _nowTime;
    _lblSjsw.text = [NSString stringWithFormat:@"%@%@",_dwSjsw,_sgUnit];
    _lblSjcz.text = [NSString stringWithFormat:@"%@万元",_dwSjcz];
    _lblDwcsw.text = [NSString stringWithFormat:@"%@%@",_dwDwcsw,_sgUnit];
    _lblDwccz.text = [NSString stringWithFormat:@"%@万元",_dwDwccz];
    _lblSumwcsw.text = [NSString stringWithFormat:@"%@%@",_wcswSum,_sgUnit];
    _lblSumwccz.text = [NSString stringWithFormat:@"%@万元",_wcczSum];
    _lblPercent.text = _precent;
    _lblRemark.text = _remark;
//    _lblRemark.numberOfLines = 2;
//    _lblRemark.textAlignment = NSTextAlignmentNatural;
    NSLog(@"传过来的项目值：%@",_pNameTotal);
    NSLog(@"传过来的时间值：%@",_nowTime);
    NSLog(@"传过来的值：%@",_dwSjsw);
    NSLog(@"传过来的值：%@",_dwSjcz);
    NSLog(@"传过来的值：%@",_dwDwcsw);
    NSLog(@"传过来的值：%@",_dwDwccz);
    NSLog(@"传过来的值：%@",_wcswSum);
    NSLog(@"传过来的值：%@",_wcczSum);
    NSLog(@"传过来的值：%@",_precent);
    NSLog(@"传过来的值：%@",_infoNote);
    NSLog(@"传过来的值：%@",_remark);
    NSLog(@"传过来的值：%@",_sgUnit);
    // 判断_infoNote字符中是否包含如下字符串
    NSRange r = [_infoNote rangeOfString:@"1、"];
    if (r.location != NSNotFound) {
        _infoNote = [_infoNote stringByReplacingOccurrencesOfString:@"1、" withString:@"一、"];
    }
    NSRange ra = [_infoNote rangeOfString:@"。"];
    if (ra.location != NSNotFound) {
        _infoNote = [_infoNote stringByReplacingOccurrencesOfString:@"。" withString:@"；"];
    }
    NSRange range = [_infoNote rangeOfString:@";"];
    if (range.location != NSNotFound) {
        infoNoteArr = [[_infoNote stringByReplacingOccurrencesOfString:@";" withString:@"；"] componentsSeparatedByString:@"；"];
    } else {
        infoNoteArr = [_infoNote componentsSeparatedByString:@"；"];
    }
    
    for (NSString *temp in infoNoteArr) {
        NSLog(@"打印情况说明：%@",temp);
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return infoNoteArr.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    for (int i=0; i<infoNoteArr.count; i++  ) {
        if (indexPath.row == i) {
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = [infoNoteArr objectAtIndex:i];
        }
        //NSLog(@"打印情况说明：%@",temp);
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点进去退回来，cell的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (int i = 0; i < infoNoteArr.count; i++) {
        if (infoNoteArr.count != 0) {
            if (indexPath.row == i) {
                SXInfoNoteSendVCViewController *infoNote = [[SXInfoNoteSendVCViewController alloc] init];
                infoNote.content = [infoNoteArr objectAtIndex:i];
                [self.navigationController pushViewController:infoNote animated:YES];
                
            }
        } else {
            NSLog(@"情况说明没有内容！");
            
        }
    }
    
}


@end
