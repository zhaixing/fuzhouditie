//
//  ViewController.m


#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong) NSArray *arrayList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - /************************* 在这里做完实验就不用了 ***************************/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - ******************** 通过此方法打印出成员变量
- (void)writeInfoWithDict:(NSDictionary *)dict {
    
    NSMutableString *strM = [NSMutableString string];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"%@,%@",key,[obj class]);
        
        NSString *className = NSStringFromClass([obj class]) ;
        
        if ([className isEqualToString:@"__NSCFString"] | [className isEqualToString:@"__NSCFConstantString"] ) {
            [strM appendFormat:@"@property (nonatomic,copy) NSString *%@;\n",key];
        }else if ([className isEqualToString:@"__NSCFArray"]){
            [strM appendFormat:@"@property (nonatomic,strong)NSArray *%@;\n",key];
        }else if ([className isEqualToString:@"__NSCFNumber"]){
            [strM appendFormat:@"@property (nonatomic,copy)NSNumber *%@;\n",key];
        }else if ([className isEqualToString:@"__NSCFBoolean"]){
            [strM appendFormat:@"@property (nonatomic,assign)BOOL %@;\n",key];
        }        
        NSLog(@"\n%@",strM);
    }];
    
}

@end
