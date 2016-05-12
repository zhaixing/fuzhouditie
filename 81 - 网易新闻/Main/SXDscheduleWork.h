//
//  SXDscheduleWork.h
//  福州地铁
//
//  Created by STDU on 15/12/7.
//  Copyright © 2015年 ShangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXDscheduleWork : NSObject

@property NSString *_dw_pid;// 项目id
@property NSString *_dw_year;// 年
@property NSString *_dw_month;// 月
@property NSString *_dw_day;// 日
@property NSString *_ds_id;
@property NSString *_dw_sjsw;// 实际完成
@property NSString *_dw_sjcz;// 实际产值
@property NSString *_dw_dwcsw;// 完成实物
@property NSString *_dw_dwccz;// 完成产值
@property NSString *_dw_dpercent;// 百分数
@property NSString *_sg_pname;// 项目名称
@property NSString *_ds_infonote; // 情况说明
@property NSString *_ds_remark;// 备注
@property NSString *_sg_unit;// 单位


@end
