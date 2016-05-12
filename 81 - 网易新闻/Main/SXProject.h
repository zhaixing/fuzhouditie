//
//  SXProject.h
//  福州地铁
//
//  Created by STDU on 15/12/6.
//  Copyright © 2015年 ShangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXProject : NSObject {
    NSString *_sg_bdid;
    NSString *_sg_pid;
    NSString *_sg_pname;
}

- (void)setSgBDid:(NSString *)sgbdid;
- (void)setSgPid:(NSString *)sgpid;
- (void)setSgPname:(NSString *)sgpname;

- (NSString *)SgBDid;
- (NSString *)SgPid;
- (NSString *)SgPname;



@end
