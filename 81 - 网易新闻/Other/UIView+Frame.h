//
//  UIView+Frame.h
//  SXDownLoader
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

// 自己模仿frame写出他的四个属性
@property (nonatomic, assign) CGFloat  x;//CGFloat其实也就是double类型
@property (nonatomic, assign) CGFloat  y;
@property (nonatomic, assign) CGFloat  width;
@property (nonatomic, assign) CGFloat  height;


@end
