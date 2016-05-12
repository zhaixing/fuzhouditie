//
//  SXBiaoDuan.h
//  福州地铁
//
//  Created by STDU on 15/12/6.
//  Copyright © 2015年 ShangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXBiaoDuan : NSObject {
    NSString *_bd_pid;
    NSString *_bd_pname;
}

- (void)setBDpid:(NSString *)bd_pid;
- (void)setBDpname:(NSString *)bd_pname;

- (NSString *)BDpid;
- (NSString *)BDpname;

@end
