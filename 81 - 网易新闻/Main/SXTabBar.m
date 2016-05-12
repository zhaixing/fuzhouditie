#import "SXTabBar.h"
#import "SXBarButton.h"
#import "UIView+Frame.h"
/**
 *  下面的tab导航栏
 */
@interface SXTabBar ()

@property(nonatomic,strong) SXBarButton *selButton;
@property(nonatomic,strong) UIImageView *imgView;

@end
@implementation SXTabBar
/**
 *  添加图片方法
 */
- (void)addImageView {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@""];
    self.imgView = imgView;
    [self addSubview:imgView];
}

#pragma mark - /************************* 通过传入数据赋值图片 ***************************/
/**
 * 传进来的参数是正常状态下的按钮和禁用状态下的按钮，还有标题
 */
- (void)addBarButtonWithNorName:(NSString *)nor andDisName:(NSString *)dis andTitle:(NSString *)title {
    //创建一个Tab导航栏按钮对象
    SXBarButton *btn = [[SXBarButton alloc]init];
    
    [btn setImage:[UIImage imageNamed:nor] forState:UIControlStateNormal];//正常状态下设置图片
    [btn setImage:[UIImage imageNamed:dis] forState:UIControlStateDisabled];//禁用状态下设置图片
    
    [btn setTitle:title forState:UIControlStateNormal];//初始状态是正常状态
    //每个状态下设置颜色
    [btn setTitleColor:[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:183/255.0 green:20/255.0 blue:28/255.0 alpha:1] forState:UIControlStateDisabled];
    //增加点击事件
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:btn];
    
    // 让第一个按钮默认为选中状态
    if (self.subviews.count == 2) {
        btn.tag = 1;//tag的默认状态是0，未选中状态，1是选中状态
        [self btnClick:btn];
    }
}


#pragma mark - /************************* 动态加载时设置frame值 ***************************/
- (void)layoutSubviews {
    UIImageView *imgView = self.subviews[0];
    imgView.frame = self.bounds;
    //创建5个按钮
    for (int i = 1; i<self.subviews.count; i++) {
        
        UIButton *btn = self.subviews[i];
        
        // CGFloat btnW = self.frame.size.width/self.subviews.count;
        // CGFloat btnH = self.frame.size.height;
        
//        CGFloat btnW = [UIScreen mainScreen].bounds.size.width;
        CGFloat btnW = [UIScreen mainScreen].bounds.size.width/3;// 将下面的导航栏分成5个
        CGFloat btnH = 49;
        CGFloat btnX = (i-1) * btnW;
        CGFloat btnY = 0;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        // 绑定tag 便于后面使用
        btn.tag = i-1;
    }
}

#pragma mark - /************************* 按钮点下方法 ***************************/
- (void)btnClick:(SXBarButton *)btn {
    // 响应代理方法 实现页面跳转
    if ([self.delegate respondsToSelector:@selector(ChangSelIndexForm:to:)]) {
        [self.delegate ChangSelIndexForm:_selButton.tag to:btn.tag];
    }
    
    // 设置按钮显示状态 并切换选中按钮
    _selButton.enabled = YES;
    _selButton = btn;
    btn.enabled = NO;
}

@end
