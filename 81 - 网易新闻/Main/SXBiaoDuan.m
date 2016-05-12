//
//  SXBiaoDuan.m
//  福州地铁
//
//  Created by STDU on 15/12/6.
//  Copyright © 2015年 ShangxianDante. All rights reserved.
//

#import "SXBiaoDuan.h"

@implementation SXBiaoDuan

// 实现get，set方法
- (void) setBDpid:(NSString *)bd_pid {
    _bd_pid = bd_pid;
}
- (void) setBDpname:(NSString *)bd_pname {
    _bd_pname = bd_pname;
}

- (NSString *)BDpid {
    return _bd_pid;
}
- (NSString *)BDpname {
    return _bd_pname;
}

@end
