//
//  SXAdManager.h
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SXAdManager : NSObject

+ (BOOL)isShouldDisplayAd;
+ (UIImage *)getAdImage;

@end
