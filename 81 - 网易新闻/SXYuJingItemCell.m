//
//  SXYuJingItemCell.m
//  福州地铁
//
//  Created by STDU on 16/5/1.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXYuJingItemCell.h"

@implementation SXYuJingItemCell

+(instancetype) itemCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"yuJingItem_cell";
    
    SXYuJingItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SXYuJingItemCell" owner:nil options:nil] firstObject];        
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
