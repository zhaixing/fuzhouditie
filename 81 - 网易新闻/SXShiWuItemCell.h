//
//  SXShiWuItemCell.h
//  福州地铁
//
//  Created by STDU on 16/1/11.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXShiWuItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblBiaoTi;
@property (weak, nonatomic) IBOutlet UILabel *lblSqName;
@property (weak, nonatomic) IBOutlet UILabel *lblSwType;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSpState;

+ (instancetype) itemCellWithTableView:(UITableView *)tableView;

@end
