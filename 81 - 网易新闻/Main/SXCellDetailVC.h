//
//  SXCellDetailVC.h
//  福州地铁
//
//  Created by STDU on 15/12/8.
//  Copyright © 2015年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXCellDetailVC : UIViewController

@property (nonatomic) NSString *pNameTotal;
@property (nonatomic) NSString *nowTime;
@property (nonatomic) NSString *dwSjsw;//设计实物量
@property (nonatomic) NSString *dwSjcz;//设计产值
@property (nonatomic) NSString *dwDwcsw;//当日完成实物量
@property (nonatomic) NSString *dwDwccz;//当日完成产值
@property (nonatomic) NSString *wcswSum;//累计完成实物量
@property (nonatomic) NSString *wcczSum;//累计完成产值
@property (nonatomic) NSString *precent;//百分比
@property (nonatomic) NSString *infoNote;//情况说明
@property (nonatomic) NSString *remark;//备注
@property (nonatomic) NSString *sgUnit;//单位

@end
