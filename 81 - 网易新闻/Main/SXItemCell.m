//
//  SXItemCell.m
//  福州地铁
//
//  Created by STDU on 15/12/3.
//  Copyright © 2015年 ShangxianDante. All rights reserved.
//

#import "SXItemCell.h"

@interface SXItemCell ()

@end

@implementation SXItemCell

+ (instancetype)itemCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"item_cell";
    SXItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SXItemCell" owner:nil options:nil] firstObject];
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
