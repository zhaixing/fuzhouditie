#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        //该函数主要是创建app的几个核心对象来处理一下过程：
        //从可用StoryBoard文件加载用户界面
        //调用AppDelegate自定义代码来做一些初始化操作
        //将app放入Main Run Loop环境中来响应和处理与用户交互产生的事件
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}