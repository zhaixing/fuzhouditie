//
//  SXYuJingItemCell.h
//  福州地铁
//
//  Created by STDU on 16/5/1.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXYuJingItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblApplyName;
@property (weak, nonatomic) IBOutlet UILabel *lblAlarmLevel;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblState;


+(instancetype) itemCellWithTableView:(UITableView *) tableView;
@end
