#import <UIKit/UIKit.h>

@protocol SXTabBarDelegate <NSObject>

@optional

- (void)ChangSelIndexForm:(NSInteger)from to:(NSInteger)to;

@end


@interface SXTabBar : UIView

@property (nonatomic,weak) id<SXTabBarDelegate> delegate;

- (void)addImageView;
- (void)addBarButtonWithNorName:(NSString *)nor andDisName:(NSString *)dis andTitle:(NSString *)title;

@end
