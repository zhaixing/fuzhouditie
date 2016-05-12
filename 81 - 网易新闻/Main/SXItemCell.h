//
//  SXItemCell.h
//  福州地铁
//
//  Created by STDU on 15/12/3.
//  Copyright © 2015年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SXItem;
@interface SXItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOne;
@property (weak, nonatomic) IBOutlet UILabel *lblTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblThree;
@property (weak, nonatomic) IBOutlet UILabel *lblFour;

+ (instancetype) itemCellWithTableView:(UITableView *)tableView;

@end
