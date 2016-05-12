//
//  SXProject.m
//  福州地铁
//
//  Created by STDU on 15/12/6.
//  Copyright © 2015年 ShangxianDante. All rights reserved.
//

#import "SXProject.h"

@implementation SXProject

// 实现get，set方法
- (void) setSgBDid:(NSString *)sgbdid {
    _sg_bdid = sgbdid;
}
- (void) setSgPid:(NSString *)sgpid {
    _sg_pid = sgpid;
}
- (void) setSgPname:(NSString *)sgpname {
    _sg_pname = sgpname;
}

- (NSString *) SgBDid {
    return _sg_bdid;
}
- (NSString *) SgPid {
    return _sg_pid;
}
- (NSString *) SgPname {
    return _sg_pname;
}

@end
