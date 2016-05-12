//
//  SXLoginViewController.m
//  福州地铁
//
//  Created by STDU on 15/12/30.
//  Copyright © 2015年 ShangxianDante. All rights reserved.
//

#import "SXLoginViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface SXLoginViewController ()<NSXMLParserDelegate> {
    // 解析webservice返回的数据
    NSMutableString *soapResults;
    NSMutableString *temp;
    NSXMLParser *xmlParser;
    BOOL recordResults;
}
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnLogin;
@property (retain, nonatomic) NSArray *login_arr; //定义一个存放返回webservice的数据

@end

@implementation SXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /* 点击空白区域，键盘消失 */
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)btnLogin {
    [self.view endEditing:YES];
    // 获取输入的用户名和密码
    NSString *userName = self.txtUserName.text;
    NSString *passWord = self.txtPassword.text;
    if ([userName isEqualToString:@""] || [passWord isEqualToString:@""]) {
        NSLog(@"用户名或密码不能为空");
        [self showAlert:@"用户名或密码不能为空!"];
    } else {
        [self login:userName passWord:[[self md5:passWord] uppercaseString]];// 要将得到的加密密码转成大写的
        NSLog(@"login返回的值是-----：%@",temp);
        _login_arr = [temp componentsSeparatedByString:@"#"];
        // 获取userDefaults单例
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        // 把信息存储到userDefault中
        [userDefaults setObject:[_login_arr objectAtIndex:0] forKey:@"num"];// 登录人员的编号
        [userDefaults setObject:[_login_arr objectAtIndex:1] forKey:@"name"];// 人员姓名
        [userDefaults setObject:[_login_arr objectAtIndex:2] forKey:@"user"];// 用户名
        [userDefaults setObject:[_login_arr objectAtIndex:3] forKey:@"pwd"];// 密码
        [userDefaults synchronize];
        if ([[_login_arr objectAtIndex:4] isEqualToString:@"1"]) {
            [self showAlert:@"登录成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self showAlert:@"用户名或密码错误"];
        }
    }
}

- (void)login:(NSString *)user passWord:(NSString *)password {
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<login xmlns=\"http://com\">"
                                   "<user>%@</user>"
                                   "<password>%@</password>"
                                   "</login>",user, password];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                               "<soap:Body>\n"
                               "%@\n" // 参数部分
                               "</soap:Body>\n"
                               "</soap:Envelope>", webServiceBodyStr];// webService头
    NSString *SOAPActionStr = [NSString stringWithFormat:@"http://com/%@", @"login"];//SOAPAction
    NSLog(@"webServiceStr的内容：%@", webServiceStr);
    NSLog(@"SOAPActionStr的内容：%@", SOAPActionStr);
    
    NSURL *url = [NSURL URLWithString:@"http://112.124.30.42:8080/test/services/searchmswork"];
    // 初始化一个request给我们的connection调用
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", webServiceStr.length];
    // 设置http内容的type
    [theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    // 设置我们soapAction；也就是我们webService调用的方法，命名空间/方法名
    [theRequest addValue:SOAPActionStr forHTTPHeaderField:@"SOAPAction"];
    // 设置内容的长度
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    // 设置http的发送方式，为post
    [theRequest setHTTPMethod:@"POST"];
    // 设置整个Body的内容，也就是我们之前拼接的那个webServiceStr
    [theRequest setHTTPBody:[webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConn) {
        NSLog(@"8888哈哈哈笑");
    }else {
        NSLog(@"5555你给我哭");
    }
    NSURLResponse *reponse;
    NSError *error = nil;
    // 接收返回数据
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&reponse error:&error];
    NSMutableString *result = [[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"返回得到的数据：%@",result);
    NSXMLParser *par = [[NSXMLParser alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding]];
    [par setDelegate:self];//设置NSXMLParser对象的解析方法代理
    BOOL flag = [par parse];//调用代理解析NSXMLParser对象，看解析是否成功
    if (flag) {
        NSLog(@"xml解析成功了");
    }
}

#pragma mark -解析返回的XML文件，将每一条数据返回
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    NSLog(@"1 parser didStarElemen: namespaceURI: attributes:");
    if ([elementName isEqualToString:@"ns1:out"]) {
        NSLog(@"开始节点-开始创建可变字符串");
        if (!soapResults) {
            soapResults = [[NSMutableString alloc] init];
            NSLog(@"可变字符串创建成功");
        }
        recordResults = YES;
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"2 parser: foundCharacters:");
    if (recordResults) {
        [soapResults appendString: string];// 将获取到的字符串添加到soapResults中
        [soapResults appendString:@"#"];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"3 parser: didEndElement:");
    
    if([elementName isEqualToString:@"ns1:out"]) {
        temp = soapResults;// 将获得的数据移出来
        recordResults = FALSE;
        soapResults = nil;
        NSLog(@"soapResults的值是+++++：%@\n解析到最后一个节点了-清空soapResults",soapResults);
    }
}
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"-------------------start--------------");
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"--------------------end---------------");
}
- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
# pragma mark - 设置弹出框
- (void)timerFireMethod:(NSTimer*)theTimer {
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}
// 时间
- (void)showAlert:(NSString *) _message {
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

@end
