#import "SXBarButton.h"
#import "UIView+Frame.h"

@implementation SXBarButton

- (void)setHighlighted:(BOOL)highlighted
{
    // 目的就是重写取消高亮显示
}
// 下面的Tab导航栏
- (void)layoutSubviews
{
    [super layoutSubviews];
    // self.titleLabel.x = self.imageView.x;
    self.imageView.y = 5;
    self.imageView.width = 25;
    self.imageView.height = 25;
    self.imageView.x = (self.width - self.imageView.width)/2.0;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;//上下边界与图片框重合
    self.titleLabel.x = self.imageView.x - (self.titleLabel.width - self.imageView.width)/2.0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 2;
    
    self.titleLabel.font = [UIFont fontWithName:@"HYQiHei" size:12];
    self.titleLabel.shadowColor = [UIColor clearColor];
    
    // self.backgroundColor = [UIColor redColor];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;//文字居中
}

@end
