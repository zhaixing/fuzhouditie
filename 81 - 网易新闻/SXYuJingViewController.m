//
//  SXYuJingViewController.m
//  福州地铁
//
//  Created by STDU on 16/1/9.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXYuJingViewController.h"

@interface SXYuJingViewController ()<NSXMLParserDelegate>{
    // 解析webservice返回的数据
    NSMutableString *soapResults;
    NSMutableString *temp;
    NSXMLParser *xmlParser;
    BOOL recordResults;
    NSMutableArray *yuJingArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NSArray *yujing_arr;
@end

NSString *num;

@implementation SXYuJingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    yuJingArr = [NSMutableArray arrayWithCapacity:20];
    // 获取userDefault中存储的值
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    num  = [userDefault objectForKey:@"num"];
    
    [self showYuJingShenPi:[num intValue]];
    NSLog(@"事务审批列表------：%@",temp);
    _yujing_arr = [temp componentsSeparatedByString:@"#"];
    [yuJingArr removeAllObjects];
    for (int i=0; i<_yujing_arr.count; i += 10) {
        if (_yujing_arr.count-1 != 0) {
            SXYuJing *YJ = [[SXYuJing alloc] init];
            [YJ setRy_Name:  [_yujing_arr objectAtIndex:i+0]];
            [YJ setBiaoTi:  [_yujing_arr objectAtIndex:i+1]];
            [YJ setYJID  :  [_yujing_arr objectAtIndex:i+2]];
            [YJ setAlarmLevel:    [_yujing_arr objectAtIndex:i+3]];
            [YJ setQKSM  :  [_yujing_arr objectAtIndex:i+4]];
            [YJ setTime  :  [_yujing_arr objectAtIndex:i+5]];
            [YJ setSFSP  :  [_yujing_arr objectAtIndex:i+6]];
            [YJ setSPID  :  [_yujing_arr objectAtIndex:i+7]];
            [YJ setSPRID :  [_yujing_arr objectAtIndex:i+8]];
            [yuJingArr addObject:YJ];
            [self.tableView reloadData];
        } else {
            NSLog(@"预警列表为空");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return yuJingArr.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SXYuJingItemCell *cell = [SXYuJingItemCell itemCellWithTableView:tableView];
    
    for (int i = 0; i<yuJingArr.count; i++) {
        if (indexPath.row == i) {
            cell.lblTitle.text = [[yuJingArr objectAtIndex:i] BiaoTi];
            cell.lblApplyName.text = [NSString stringWithFormat:@"申请人：%@",[[yuJingArr objectAtIndex:i] Ry_Name]];
            cell.lblAlarmLevel.text = [NSString stringWithFormat:@"预警级别：%@",[[yuJingArr objectAtIndex:i] AlarmLevel]];
            NSString *time = [[[[yuJingArr objectAtIndex:i] Time] componentsSeparatedByString:@" "] objectAtIndex:0];// 将获取到的时间分割成年月日
            cell.lblTime.text    = time;
            cell.lblState.text = @"待批示";
            cell.lblState.textColor = [UIColor blueColor];
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

// 该方法实现点击cell跳转到另一个界面的功能
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 改行代码解决了，进去后退回来，cell的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (int i=0; i<yuJingArr.count; i++) {
        if (yuJingArr.count != 0) {
            if (indexPath.row == i) {
                //SXShiWuCellDetailVC *shiwu = [[SXShiWuCellDetailVC alloc] init];
                //shiwu
            }
        } else {
            NSLog(@"没有获取到东西，不能传值！");
        }
    }
}

// 设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *ICell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return 72;
}

- (void)showYuJingShenPi:(NSInteger)ryid {
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<searchyujing xmlns=\"http://com\">"
                                   "<ryid>%ld</ryid>"
                                   "</searchyujing>", ryid];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                               "<soap:Body>\n"
                               "%@\n" // 参数部分
                               "</soap:Body>\n"
                               "</soap:Envelope>", webServiceBodyStr];//webService头
    NSString *SOAPActionStr = [NSString stringWithFormat:@"http://com/%@", @"searchyujing"];//SOAPAction
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
@end
