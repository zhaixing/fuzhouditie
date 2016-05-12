//
//  SXShiWuItemCell.m
//  福州地铁
//
//  Created by STDU on 16/1/11.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXShiWuItemCell.h"

@implementation SXShiWuItemCell

+ (instancetype)itemCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"shiWuItem_cell";
    SXShiWuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SXShiWuItemCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
