// SXMainViewController.m
#import "SXMainViewController.h"
#import "UIView+Frame.h"
#import "SXHTTPManager.h"
#import "MJExtension.h"
#import "HZQDatePickerView.h"
#import "DropDownListView.h"
#import "SXItemCell.h"
#import "SXBiaoDuan.h"
#import "SXProject.h"
#import "SXDscheduleWork.h"
#import "SXDscheduleWorkItemVC.h"
#import "SXCellDetailVC.h"
#import "SXLoginViewController.h"
/*************************** 屏幕尺寸 ScreenRect **************************/
#define ScreenRect [UIScreen mainScreen].applicationFrame
#define ScreenRectHeight [UIScreen mainScreen].applicationFrame.size.height
#define ScreenRectWidth [UIScreen mainScreen].applicationFrame.size.width

@interface SXMainViewController () <HZQDatePickerViewDelegate,
                                    NSXMLParserDelegate,
                                    UITableViewDataSource,
                                    UITableViewDelegate,
                                    UIAlertViewDelegate> {
    HZQDatePickerView *_pikerView;// 日期选择弹框
    NSMutableArray *chooseArray;// 下拉列表框的选择内容
    // 解析webservice返回的数据
    NSMutableString *soapResults;
    NSMutableString *temp;
    NSXMLParser *xmlParser;
    BOOL recordResults;
    NSMutableArray *bdIdArr;// 获取到标段的id和名称
    NSMutableArray *bdNameArr;
    // 获取到一级或二级的id和名称
    NSMutableArray *yjIdArr;
    NSMutableArray *ejIdArr;
    NSMutableArray *sjIdArr;
    NSMutableArray *yjNameArr;
    NSMutableArray *ejNameArr;
    NSMutableArray *sjNameArr;
    NSMutableArray *bdarr;
    NSMutableArray *sgarr;
    NSMutableArray *workarr;
    NSMutableArray *workItemarr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnDatePick;
- (IBAction)btnDatePickClick;
- (IBAction)btnRightClick;
- (IBAction)btnLeftClick;
- (IBAction)btnLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLoginText;

@property (retain, nonatomic) NSArray *date_arr;//定义一个年月日的数组
@property (retain, nonatomic) NSArray *work_arr;//定义一个存放返回webservice的数据
@property (retain, nonatomic) NSArray *workItem_arr;
@property (retain, nonatomic) NSArray *bd_arr;//返回的标段名称
@property (retain, nonatomic) NSArray *yjej_arr;// 存放一级的名称

@property (nonatomic,strong) UIButton *rightItem;
@property (retain, nonatomic) NSArray *pushConArr;
@end

@implementation SXMainViewController
// 全局变量不能声明在协议或者接口中
NSString *year;
NSString *month;
NSString *day;
NSString *choiseBD;
NSString *choiseProj;
NSString *choiseBdName;// 选中的标段名称
NSString *choiseYjName;// 选中的一级名称
NSString *choiseEjName;// 选中的二级名称
NSString *num;
NSString *name;
NSString *user;
NSString *pwd;
double timeInterval; //访问网络的时间间隔
double start;
double end;
#pragma mark - ******************** 页面首次加载
- (void)other {
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showRightItem) name:@"SXAdvertisementKey" object:nil];
    //当我们一个界面有多个tableView之类的,要将它设置为NO,完全由自己手动来布局,就不会错乱了
    //self.automaticallyAdjustsScrollViewInsets = NO;
    UIButton *rightItem = [[UIButton alloc] init];
    self.rightItem = rightItem;
    //UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
    //[win addSubview:rightItem];
    rightItem.y = 20;
    rightItem.width = 45;
    rightItem.height = 45;
    //[rightItem addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];// 设置点击事件
    rightItem.x = [UIScreen mainScreen].bounds.size.width - rightItem.width;
    NSLog(@"%@",NSStringFromCGRect(rightItem.frame));
    [rightItem setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];
}
- (void)getNowDate {
    //这个是NSDate类型的日期，所要获取的年月日都放在这里
    NSDate     *date = [NSDate date];
    NSCalendar *cal  = [NSCalendar currentCalendar];
    //这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    //把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];
    //然后就可以从d中获取具体的年月日了；
    year = [NSString stringWithFormat:@"%ld", (long)[d year]];
    if ([d month] <10) {
        month = [NSString stringWithFormat:@"0%ld", (long)[d month]];
    } else {
        month = [NSString stringWithFormat:@"%ld", (long)[d month]];
    }
    if ([d day] <10) {
        day = [NSString stringWithFormat:@"0%ld", (long)[d day]];
    } else {
        day = [NSString stringWithFormat:@"%ld", (long)[d day]];
    }
    
    NSLog(@"当天的日期是：%@年%@月%@日",year,month,day);
    // 设置按钮一出现上面的文字，要在按钮的不同状态下设置
    [_btnDatePick setTitle:[NSString stringWithFormat:@"%@年%@月%@日",year,month,day] forState:UIControlStateNormal];
}
- (void)getWebService {
    [self searchDsWork:choiseBD chosedProject:choiseProj year:year month:month day:day ryid:[num intValue]];
    NSLog(@"searchDsWork的值是-----：%@",temp);
    _work_arr = [temp componentsSeparatedByString:@"$"];
    NSLog(@"%lu",(unsigned long)_work_arr.count);
    [workarr removeAllObjects];
    // 判断情况说明内容是不是因为太长被分开，如果被分开，将两者合上
    if ((_work_arr.count-1) %13 == 0) {
        for (int i=0; i<_work_arr.count; i += 13) {
            @try {
                if (_work_arr.count-1 != 0) {
                    SXDscheduleWork *DW = [[SXDscheduleWork alloc] init]; // 创建一个数据的实例
                    [DW set_ds_id:      [_work_arr objectAtIndex:i+0]]; // 将id添加进实体类
                    [DW set_ds_infonote:[_work_arr objectAtIndex:i+1]]; // 将情况说明加进实体类
                    [DW set_ds_remark:  [_work_arr objectAtIndex:i+2]]; // 备注
                    [DW set_dw_day:     [_work_arr objectAtIndex:i+3]]; // 日
                    [DW set_dw_dwccz:   [_work_arr objectAtIndex:i+4]]; // 完成产值
                    [DW set_dw_dwcsw:   [_work_arr objectAtIndex:i+5]]; // 完成实物量
                    [DW set_dw_month:   [_work_arr objectAtIndex:i+6]]; // 月
                    [DW set_dw_pid:     [_work_arr objectAtIndex:i+7]]; // 项目id
                    [DW set_dw_sjcz:    [_work_arr objectAtIndex:i+8]]; // 设计产值
                    [DW set_dw_sjsw:    [_work_arr objectAtIndex:i+9]]; // 设计实物量
                    [DW set_dw_year:    [_work_arr objectAtIndex:i+10]]; // 年
                    [DW set_sg_pname:   [_work_arr objectAtIndex:i+11]]; // 项目名称
                    [DW set_sg_unit:    [_work_arr objectAtIndex:i+12]]; // 单位
                    [workarr addObject:DW];
                    [self.tableView reloadData];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"work数组为空");
            }
            [self.tableView reloadData];
        }
    } else if ((_work_arr.count-1) %14 == 0){
        for (int i=0; i<_work_arr.count; i += 14) {
            @try {
                if (_work_arr.count-1 != 0) {
                    SXDscheduleWork *DW = [[SXDscheduleWork alloc] init]; // 创建一个数据的实例
                    [DW set_ds_id:      [_work_arr objectAtIndex:i+0]]; // 将id添加进实体类
                    [DW set_ds_infonote:[NSString stringWithFormat:@"%@%@",
                                         [_work_arr objectAtIndex:i+1],
                                         [_work_arr objectAtIndex:i+2]]]; // 将情况说明加进实体类
                    [DW set_ds_remark:  [_work_arr objectAtIndex:i+3]]; // 备注
                    [DW set_dw_day:     [_work_arr objectAtIndex:i+4]]; // 日
                    [DW set_dw_dwccz:   [_work_arr objectAtIndex:i+5]]; // 完成产值
                    [DW set_dw_dwcsw:   [_work_arr objectAtIndex:i+6]]; // 完成实物量
                    [DW set_dw_month:   [_work_arr objectAtIndex:i+7]]; // 月
                    [DW set_dw_pid:     [_work_arr objectAtIndex:i+8]]; // 项目id
                    [DW set_dw_sjcz:    [_work_arr objectAtIndex:i+9]]; // 设计产值
                    [DW set_dw_sjsw:    [_work_arr objectAtIndex:i+10]]; // 设计实物量
                    [DW set_dw_year:    [_work_arr objectAtIndex:i+11]]; // 年
                    [DW set_sg_pname:   [_work_arr objectAtIndex:i+12]]; // 项目名称
                    [DW set_sg_unit:    [_work_arr objectAtIndex:i+13]]; // 单位
                    [workarr addObject:DW];
                    [self.tableView reloadData];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"work数组为空");
            }
            [self.tableView reloadData];
        }
    } else if ((_work_arr.count-1) %15 == 0){
        for (int i=0; i<_work_arr.count; i += 15) {
            @try {
                if (_work_arr.count-1 != 0) {
                    SXDscheduleWork *DW = [[SXDscheduleWork alloc] init]; // 创建一个数据的实例
                    [DW set_ds_id:      [_work_arr objectAtIndex:i+0]]; // 将id添加进实体类
                    [DW set_ds_infonote:[NSString stringWithFormat:@"%@%@%@",
                                         [_work_arr objectAtIndex:i+1],
                                         [_work_arr objectAtIndex:i+2],
                                         [_work_arr objectAtIndex:i+3]]]; // 将情况说明加进实体类
                    [DW set_ds_remark:  [_work_arr objectAtIndex:i+4]]; // 备注
                    [DW set_dw_day:     [_work_arr objectAtIndex:i+5]]; // 日
                    [DW set_dw_dwccz:   [_work_arr objectAtIndex:i+6]]; // 完成产值
                    [DW set_dw_dwcsw:   [_work_arr objectAtIndex:i+7]]; // 完成实物量
                    [DW set_dw_month:   [_work_arr objectAtIndex:i+8]]; // 月
                    [DW set_dw_pid:     [_work_arr objectAtIndex:i+9]]; // 项目id
                    [DW set_dw_sjcz:    [_work_arr objectAtIndex:i+10]]; // 设计产值
                    [DW set_dw_sjsw:    [_work_arr objectAtIndex:i+11]]; // 设计实物量
                    [DW set_dw_year:    [_work_arr objectAtIndex:i+12]]; // 年
                    [DW set_sg_pname:   [_work_arr objectAtIndex:i+13]]; // 项目名称
                    [DW set_sg_unit:    [_work_arr objectAtIndex:i+14]]; // 单位
                    [workarr addObject:DW];
                    [self.tableView reloadData];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"work数组为空");
            }
            [self.tableView reloadData];
        }
    } else {
        for (int i=0; i<_work_arr.count; i += 16) {
            @try {
                if (_work_arr.count-1 != 0) {
                    SXDscheduleWork *DW = [[SXDscheduleWork alloc] init]; // 创建一个数据的实例
                    [DW set_ds_id:      [_work_arr objectAtIndex:i+0]]; // 将id添加进实体类
                    [DW set_ds_infonote:[NSString stringWithFormat:@"%@%@%@%@",
                                         [_work_arr objectAtIndex:i+1],
                                         [_work_arr objectAtIndex:i+2],
                                         [_work_arr objectAtIndex:i+3],
                                         [_work_arr objectAtIndex:i+4]]]; // 将情况说明加进实体类
                    [DW set_ds_remark:  [_work_arr objectAtIndex:i+5]]; // 备注
                    [DW set_dw_day:     [_work_arr objectAtIndex:i+6]]; // 日
                    [DW set_dw_dwccz:   [_work_arr objectAtIndex:i+7]]; // 完成产值
                    [DW set_dw_dwcsw:   [_work_arr objectAtIndex:i+8]]; // 完成实物量
                    [DW set_dw_month:   [_work_arr objectAtIndex:i+9]]; // 月
                    [DW set_dw_pid:     [_work_arr objectAtIndex:i+10]]; // 项目id
                    [DW set_dw_sjcz:    [_work_arr objectAtIndex:i+11]]; // 设计产值
                    [DW set_dw_sjsw:    [_work_arr objectAtIndex:i+12]]; // 设计实物量
                    [DW set_dw_year:    [_work_arr objectAtIndex:i+13]]; // 年
                    [DW set_sg_pname:   [_work_arr objectAtIndex:i+14]]; // 项目名称
                    [DW set_sg_unit:    [_work_arr objectAtIndex:i+15]]; // 单位
                    [workarr addObject:DW];
                    [self.tableView reloadData];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"work数组为空");
            }
            [self.tableView reloadData];
        }
    }
    
    [workItemarr removeAllObjects];//清空两个累计量的数组
    for (int i=0; i<workarr.count; i++) {
        // 获取总的完成实物量,年月日必须是字符串类型的各位输的日子前面要加0
        [self searchDsWorkItem:choiseBD chosedProject:[sjIdArr objectAtIndex:i]  year:year month:month day:day];
        NSLog(@"searchDsWorkItem的值是-----：%@",temp);
        _workItem_arr = [temp componentsSeparatedByString:@"$"];
        
        @try {
            if (_workItem_arr.count-1 != 0) {
                SXDscheduleWorkItemVC *DWI = [[SXDscheduleWorkItemVC alloc] init];
                [DWI setSumWccz:[_workItem_arr objectAtIndex:0]];
                [DWI setSumWcsw:[_workItem_arr objectAtIndex:1]];
                [workItemarr addObject:DWI];
                
                // 刷新tableview的所有内容,只要调用tableview的该方法就会自动重新调用数据源的所有方法
                [self.tableView reloadData];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"workItem数组为空");
        }
    }
}
- (void)viewDidLoad {       
    [super viewDidLoad];
    // 图标上的数字清零
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if (_contentLabel != nil) {
        _pushConArr = [_contentLabel componentsSeparatedByString:@"+"];
    }
    [self getNowDate];//抽取一个获取当前日期并显示到按钮上的方法
    [self other];//该方法的实现在上面
    // 获取userDefault中存储的值
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    num  = [userDefault objectForKey:@"num"];
    name = [userDefault objectForKey:@"name"];
    user = [userDefault objectForKey:@"user"];
    pwd  = [userDefault objectForKey:@"pwd"];
    NSLog(@"num:%@,name%@,user%@,pwd%@",num, name, user, pwd);
    if (num == nil) {
        num = @"1";
        [self showAlert:@"请亲先登录"];        
    } else {
        _btnLoginText.title = @"已登录";
        _btnLoginText.enabled = NO;
    }
    // 初始化标段的数组大小,一定要初始化大小，不然数组放不进东西
    bdIdArr     = [NSMutableArray arrayWithCapacity:20];
    yjIdArr     = [NSMutableArray arrayWithCapacity:20];
    ejIdArr     = [NSMutableArray arrayWithCapacity:20];
    sjIdArr     = [NSMutableArray arrayWithCapacity:20];
    bdNameArr   = [NSMutableArray arrayWithCapacity:20];
    yjNameArr   = [NSMutableArray arrayWithCapacity:20];
    ejNameArr   = [NSMutableArray arrayWithCapacity:20];
    sjNameArr   = [NSMutableArray arrayWithCapacity:20];
    bdarr       = [NSMutableArray arrayWithCapacity:20];
    sgarr       = [NSMutableArray arrayWithCapacity:20];
    workarr     = [NSMutableArray arrayWithCapacity:40];
    workItemarr = [NSMutableArray arrayWithCapacity:40];
    
    // 调用webservice获取返回的标段名称和id
    [self searchBiaoDuan:[num intValue]];
    if ([temp isEqualToString:@""]) {
        NSLog(@"标段为空");
        [bdNameArr addObject:@""];
        [bdarr     addObject:@""];
    } else {
        _bd_arr = [temp componentsSeparatedByString:@"$"];
        if (_bd_arr.count-1 != 0) {
            for (int i=0; i<_bd_arr.count-1; i += 2) {
                SXBiaoDuan *BD = [[SXBiaoDuan alloc] init];
                [bdIdArr addObject:[_bd_arr objectAtIndex:i]];
                NSLog(@"标段的id数组:%@",[_bd_arr objectAtIndex:i]);
                [BD setBDpid:[_bd_arr objectAtIndex:i]];//将标段id存进类中
                [bdNameArr addObject:[_bd_arr objectAtIndex:i+1]];
                NSLog(@"标段的名称数组:%@",[_bd_arr objectAtIndex:i+1]);
                [BD setBDpname:[_bd_arr objectAtIndex:i+1]];//将标段的名称存进类中
                [bdarr addObject:BD];// 将标段的id和那么存入实体类再存入数组
            }
        } else {
            NSLog(@"标段没有找到哦，亲");
        }
    }
    
    // 初始化一级的数组列表
    [self searchYiJi:[_bd_arr objectAtIndex:0] andryid:[num intValue]];//定位标段列表的第一个
//    NSString *strUrl = [temp stringByReplacingOccurrencesOfString:@"0203#" withString:@"\n"];
//    NSLog(@"searchYiJi的值是初始-----：%@",strUrl);
    if ([temp isEqualToString:@""]) {
        NSLog(@"该标段下项目为空");
        [yjNameArr addObject:@""];
        [ejNameArr addObject:@""];
        [sgarr     addObject:@""];
        [self showAlert:@"该标段下项目为空,请选择其它标段查看"];
    } else {
        _yjej_arr = [temp componentsSeparatedByString:@"$"];//将获取得到的字符串切开
        @try {
            if (_yjej_arr.count-1 != 0) {
                for (int i = 0; i<_yjej_arr.count-2; i += 3) {
                    SXProject *SP = [[SXProject alloc] init];// 必须将类的实例写进循环，才能添加成功
                    [SP setSgBDid: [_yjej_arr objectAtIndex:i]];
                    [SP setSgPid:  [_yjej_arr objectAtIndex:i+1]];
                    [SP setSgPname:[_yjej_arr objectAtIndex:i+2]];
                    [sgarr addObject:SP];
                }
                NSString *YJ = [[sgarr objectAtIndex:0] SgPid];//一级的第一个id
                NSLog(@"YJ%@%@",YJ,[[[sgarr objectAtIndex:1] SgPid] substringToIndex:2]);
                for (int i=0; i<sgarr.count; i++) {
                    if ([[[sgarr objectAtIndex:i] SgPid] length] == 2) {
                        [yjIdArr   addObject:[[sgarr objectAtIndex:i] SgPid]];
                        [yjNameArr addObject:[[sgarr objectAtIndex:i] SgPname]];//获取到一级的名称数组
                    } else if ([[[sgarr objectAtIndex:i] SgPid] length] == 4 &&
                               [[[[sgarr objectAtIndex:i] SgPid] substringToIndex:2] isEqualToString:YJ]) {
                        [ejIdArr   addObject:[[sgarr objectAtIndex:i] SgPid]];
                        [ejNameArr addObject:[[sgarr objectAtIndex:i] SgPname]];//获取到二级的名称数组
                    }else if ([[[sgarr objectAtIndex:i] SgPid] length] == 6) {
                        [sjIdArr   addObject:[[sgarr objectAtIndex:i] SgPid]];// 获得三级的id
                        [sjNameArr addObject:[[sgarr objectAtIndex:i] SgPname]];//三级名称
                    }
                }
            } else {
                NSLog(@"项目名称没找到哦，亲");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"项目名称加载失败-----");
        }
    }
    
    /* 定义下拉列表的数量 */
    chooseArray = [NSMutableArray arrayWithCapacity:3];
    /* 向下拉列表中添加数据 */
    [chooseArray addObject:bdNameArr];
    [chooseArray addObject:yjNameArr];
    [chooseArray addObject:ejNameArr];
    
    // 设置下拉列表的位置
    DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,108, self.view.frame.size.width, 40) dataSource:self delegate:self];
    // 将下拉列表的父视图设为当前的view
    dropDownView.mSuperView = self.view;
    // 然后将下拉列表的view添加到当前view
    [self.view addSubview:dropDownView];
    /* 只有在当标段的名称数组和项目的名称不为空的时候，再加载下面的数据 */
    if (bdarr.count-1>0 && sgarr.count-1>0) {
        choiseBD     = [[bdarr objectAtIndex:0] BDpid];
        choiseBdName = [[bdarr objectAtIndex:0] BDpname];
        NSLog(@"选中的标段id：%@,名称:%@",choiseBD, choiseBdName);
        choiseYjName = [[sgarr objectAtIndex:0] SgPname];
        NSLog(@"选中的一级名称:%@",choiseYjName);
        choiseEjName = [[sgarr objectAtIndex:1] SgPname];
        choiseProj   = [[sgarr objectAtIndex:1] SgPid];
        NSLog(@"选中的二级id：%@,名称:%@",choiseProj, choiseEjName);
        [self remoteAnimation:@"正在获取数据, 请稍候..."];
        // 状态栏网络请求效果
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        //[self getWebService];
        start = [[NSDate date] timeIntervalSince1970];
        [self performSelectorInBackground:@selector(getWebService) withObject:nil];
        end = [[NSDate date] timeIntervalSince1970];
        timeInterval = end - start;
        //请求结束状态栏隐藏网络活动标志：
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [remoteAlertView dismissWithClickedButtonIndex:0 animated:YES];
    } else {
        NSLog(@"下拉列表为空");
        [self showAlert:@"项目为空"];
    }
}

#pragma mark -- --------------------------dropDownListDelegate 实现代理
// 下拉列表选择的选项
- (void)chooseAtSection:(NSInteger)section index:(NSInteger)index {
    NSLog(@"郭大爷选了section:%ld ,index:%ld", section, index);
    // 当选择了标段，就调用该方法
    if (section == 0) {
        choiseBD = [[bdarr objectAtIndex:index] BDpid];
        NSLog(@"点击选中的标段id：%@",choiseBD);
        choiseBdName = [bdNameArr objectAtIndex:index];
        NSLog(@"点击选中的标段id：%@,名称:%@",choiseBD, choiseBdName);
        [self searchYiJi:[[bdarr objectAtIndex:index] BDpid] andryid:[num intValue]];// 选择哪个，就返回哪个标段的项目
//        NSString *strUrl = [temp stringByReplacingOccurrencesOfString:@"0211$" withString:@"\n"];
//        NSLog(@"searchYiJi的值是-----+++：%@",strUrl);
        
        if ([temp isEqualToString:@""]) {
            NSLog(@"该标段下项目为空");
            [self showAlert:@"该标段下项目为空,请选择其它标段查看"];
        } else {
            _yjej_arr = [temp componentsSeparatedByString:@"$"];
            [yjNameArr removeAllObjects];// 每选择一下，就将数组清空
            [ejNameArr removeAllObjects];
            [sgarr     removeAllObjects];
            for (int i = 0; i<_yjej_arr.count-2; i += 3) {
                SXProject *SP = [[SXProject alloc] init];// 必须将类的实例写进循环，才能添加成功
                [SP setSgBDid: [_yjej_arr objectAtIndex:i]];
                [SP setSgPid:  [_yjej_arr objectAtIndex:i+1]];
                [SP setSgPname:[_yjej_arr objectAtIndex:i+2]];
                [sgarr addObject:SP];
            }
        }
        [yjIdArr   removeAllObjects];// 将存放一级id的数组清空
        [ejIdArr   removeAllObjects];// 将存放二级id的数组清空
        [sjIdArr   removeAllObjects];// 将存放三级id的数组清空
        [yjNameArr removeAllObjects];// 将存放三级id的数组清空
        [ejNameArr removeAllObjects];// 将存放三级id的数组清空
        [sjNameArr removeAllObjects];// 将存放三级id的数组清空
        if (sgarr.count-1>0) {
            NSString *YJ = [[sgarr objectAtIndex:0] SgPid];//初始化一级的第一个id
            NSLog(@"YJ%@%@",YJ,[[[sgarr objectAtIndex:1] SgPid] substringToIndex:2]);
            for (int i=0; i<sgarr.count; i++) {
                if ([[[sgarr objectAtIndex:i] SgPid] length] == 2) {
                    [yjIdArr   addObject:[[sgarr objectAtIndex:i] SgPid]];//将所有一级的id获取到，之前清空
                    [yjNameArr addObject:[[sgarr objectAtIndex:i] SgPname]];//获取到一级的名称数组
                } else if ([[[sgarr objectAtIndex:i] SgPid] length] == 4 &&
                           [[[[sgarr objectAtIndex:i] SgPid] substringToIndex:2] isEqualToString:YJ]){
                    [ejIdArr   addObject:[[sgarr objectAtIndex:i] SgPid]];// 将所有二级的id获取到，之前清空
                    [ejNameArr addObject:[[sgarr objectAtIndex:i] SgPname]];//获取到二级的名称数组
                } else if ([[[sgarr objectAtIndex:i] SgPid] length] == 6) {
                    [sjIdArr   addObject:[[sgarr objectAtIndex:i] SgPid]];// 获得三级的id
                    [sjNameArr addObject:[[sgarr objectAtIndex:i] SgPname]];//三级名称
                }
            }
        } else {
            NSLog(@"下拉列表为空");
            [self showAlert:@"项目为空"];
        }
    } else if (section == 1) { // 选择一级的
        [ejNameArr removeAllObjects];
        [ejIdArr   removeAllObjects];
        choiseYjName = [yjNameArr objectAtIndex:index];
        NSLog(@"选中的一级名称:%@",choiseYjName);
        NSString *YJ = [yjIdArr objectAtIndex:index];//初始化选中的一级的id
        NSLog(@"选中的一级id：%@",YJ);
        for (int i=0; i<sgarr.count; i++) {
            if ([[[sgarr objectAtIndex:i] SgPid] length] == 4 &&
                [[[[sgarr objectAtIndex:i] SgPid] substringToIndex:2] isEqualToString:YJ]){
                [ejNameArr addObject:[[sgarr objectAtIndex:i] SgPname]];//获取到二级的名称数组
                [ejIdArr   addObject:[[sgarr objectAtIndex:i] SgPid]];
            }
        }
    } else {
        choiseProj   = [ejIdArr   objectAtIndex:index];
        choiseEjName = [ejNameArr objectAtIndex:index];
        NSLog(@"选中的标段id：%@",choiseBD);
        NSLog(@"选中的二级id：%@,名称:%@",choiseProj, choiseEjName);
        // 调用webservice方法获取数据
        [self remoteAnimation:@"正在获取数据, 请稍候..."];
        // 状态栏网络请求效果
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//        [self getWebService];
        start = [[NSDate date] timeIntervalSince1970];
        [self performSelectorInBackground:@selector(getWebService) withObject:nil];
        end = [[NSDate date] timeIntervalSince1970];
        timeInterval = end - start;
        //请求结束状态栏隐藏网络活动标志：
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [remoteAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}
#pragma mark -- dropdownList DataSource 实现设置数据资源
- (NSInteger) numberOfSections {
    return [chooseArray count];
}
- (NSInteger) numberOfRowsInSection:(NSInteger)section {
    NSArray *arry =chooseArray[section];
    return [arry count];
}
- (NSString *) titleInSection:(NSInteger)section index:(NSInteger) index {
    return chooseArray[section][index];
}
- (NSInteger) defaultShowSection:(NSInteger)section {
    return 0;
}
/********************************************************************************/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - -----UITableView的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return workarr.count;
}
/* 将获得到的数据显示到cell中 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 封装在SXItemCell类中
    SXItemCell *cell = [SXItemCell itemCellWithTableView:tableView];
    for (int i=0; i<workarr.count; i++) {
        if (indexPath.row == i) {
            cell.lblOne.text = [[workarr objectAtIndex:i] _sg_pname];
            cell.lblOne.numberOfLines = 3;
            cell.lblTwo.text = [NSString stringWithFormat:@"%@%@",[[workarr objectAtIndex:i] _dw_sjsw], [[workarr objectAtIndex:i] _sg_unit]];
            cell.lblTwo.numberOfLines = 0;
            cell.lblThree.text = [NSString stringWithFormat:@"%@%@",[[workItemarr objectAtIndex:i] SumWcsw], [[workarr objectAtIndex:i] _sg_unit]];
            cell.lblThree.numberOfLines = 0;
            cell.lblFour.text = [NSString stringWithFormat:@"%.2f%%",([[[workItemarr objectAtIndex:i] SumWcsw] doubleValue]/[[[workarr objectAtIndex:i] _dw_sjsw] doubleValue])*100];
            cell.lblFour.numberOfLines = 0;
        }
    }
    cell.backgroundColor = [UIColor clearColor];// 将cell 框设置成透明颜色
    return cell;
}
// 该方法实现点击cell跳转到另一个界面的功能
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 改行代码解决了，进去后退回来，cell的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (int i=0; i<workarr.count; i++) {
        if (workarr.count != 0) {
            if (indexPath.row == i) {
                SXCellDetailVC *detailView = [[SXCellDetailVC alloc]init];
                // 将获取到的数据传值到详细界面
                if (workItemarr.count-1 != 0) {
                    detailView.pNameTotal = [NSString stringWithFormat:@"%@-%@-%@-%@",choiseBdName,choiseYjName,choiseEjName,[[workarr objectAtIndex:i] _sg_pname]];
                } else {
                    detailView.pNameTotal = [NSString stringWithFormat:@"%@-%@-%@",choiseBdName,choiseYjName,choiseEjName];
                }
                detailView.nowTime  = [NSString stringWithFormat:@"%@.%@.%@",year,month,day];
                detailView.dwSjsw   = [[workarr objectAtIndex:i] _dw_sjsw];
                detailView.dwSjcz   = [[workarr objectAtIndex:i] _dw_sjcz];
                detailView.dwDwcsw  = [[workarr objectAtIndex:i] _dw_dwcsw];
                detailView.dwDwccz  = [[workarr objectAtIndex:i] _dw_dwccz];
                detailView.wcswSum  = [[workItemarr objectAtIndex:i] SumWcsw];
                detailView.wcczSum  = [[workItemarr objectAtIndex:i] SumWccz];
                detailView.sgUnit   = [[workarr objectAtIndex:i] _sg_unit];
                detailView.precent  = [NSString stringWithFormat:@"%.2f%%",([[[workItemarr objectAtIndex:i] SumWcsw] doubleValue]/[[[workarr objectAtIndex:i] _dw_sjsw] doubleValue])*100];
                detailView.infoNote = [[workarr objectAtIndex:i] _ds_infonote];
                detailView.remark   = [[workarr objectAtIndex:i] _ds_remark];
                [self.navigationController pushViewController:detailView animated:YES];
            }
        } else {
            NSLog(@"没有获取到东西，不能传值！");
            [self showAlert:@"亲，该项没有数据"];
        }
    }
}
// 设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *ICell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return 70;
}
// 右上角按钮的显示与否
- (void)showRightItem {
    self.rightItem.hidden = YES;
}
// 给右上角按钮设置点击事件
- (void)rightItemClick {
}

#pragma mark - 日期选择弹框
// 实现日期选择按钮
- (IBAction)btnDatePickClick {
    [self setupDateView:DateTypeOfStart];
}
//日期右翻
- (IBAction)btnRightClick {
    int DAY = [day intValue];
    int MONTH = [month intValue];
    int YEAR = [year intValue];
    DAY++;
    if (MONTH==1||MONTH==3||MONTH==5||MONTH==7||MONTH==8||MONTH==10||MONTH==12) {
        if (DAY>31) {
            DAY = 1;
            MONTH++;
        }
    } else if(MONTH==4||MONTH==6||MONTH==9||MONTH==11) {
        if (DAY>30) {
            DAY = 1;
            MONTH++;
        }
    } else if (((YEAR%4==0)&&(YEAR%100!=0))||(YEAR%400==0)) {
        if (DAY>29) {
            DAY = 1;
            MONTH++;
        }
    }else {
        if (DAY>28) {
            DAY = 1;
            MONTH++;
        }
    }
    if (MONTH>12) {
        MONTH = 1;
        YEAR++;
    }
    year  = [NSString stringWithFormat:@"%d",YEAR];
    if (MONTH <10) {
        month = [NSString stringWithFormat:@"0%ld", (long)MONTH];
    } else {
        month = [NSString stringWithFormat:@"%ld", (long)MONTH];
    }
    if (DAY <10) {
        day = [NSString stringWithFormat:@"0%ld", (long)DAY];
    } else {
        day = [NSString stringWithFormat:@"%ld", (long)DAY];
    }
    NSLog(@"右翻日期变为：%@年%@月%@日",year,month,day);
    _btnDatePick.titleLabel.text = [NSString stringWithFormat:@"%@年%@月%@日", year,month,day];
    [self remoteAnimation:@"正在获取数据, 请稍候..."];
    // 状态栏网络请求效果
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    [self getWebService];
    start = [[NSDate date] timeIntervalSince1970];
    [self performSelectorInBackground:@selector(getWebService) withObject:nil];
    end = [[NSDate date] timeIntervalSince1970];
    timeInterval = end - start;
    //请求结束状态栏隐藏网络活动标志：
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [remoteAlertView dismissWithClickedButtonIndex:0 animated:YES];
}
//日期左翻
- (IBAction)btnLeftClick {
    int DAY = [day intValue];
    int MONTH = [month intValue];
    int YEAR = [year intValue];
    DAY--;
    if (MONTH==1||MONTH==2||MONTH==4||MONTH==6||MONTH==8||MONTH==9||MONTH==11) {
        if (DAY<1) {
            DAY = 31;
            MONTH--;
        }
    } else if (MONTH==5||MONTH==7||MONTH==10||MONTH==12){
        if (DAY<1) {
            DAY = 30;
            MONTH--;
        }
    } else if (((YEAR%4==0)&&(YEAR%100!=0))||(YEAR%400==0)) {
        if (DAY<1) {
            DAY = 29;
            MONTH--;
        }
    } else {
        if (DAY<1) {
            DAY = 28;
            MONTH--;
        }
    }
    if (MONTH<1) {
        MONTH = 12;
        YEAR--;
    }
    year  = [NSString stringWithFormat:@"%d",YEAR];
    if (MONTH <10) {
        month = [NSString stringWithFormat:@"0%ld", (long)MONTH];
    } else {
        month = [NSString stringWithFormat:@"%ld", (long)MONTH];
    }
    if (DAY <10) {
        day = [NSString stringWithFormat:@"0%ld", (long)DAY];
    } else {
        day = [NSString stringWithFormat:@"%ld", (long)DAY];
    }
    NSLog(@"左翻日期变为：%@年%@月%@日",year,month,day);
    _btnDatePick.titleLabel.text = [NSString stringWithFormat:@"%@年%@月%@日", year,month,day];
    [self remoteAnimation:@"正在获取数据, 请稍候..."];
    // 状态栏网络请求效果
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    [self getWebService];
    start = [[NSDate date] timeIntervalSince1970];
    [self performSelectorInBackground:@selector(getWebService) withObject:nil];
    end = [[NSDate date] timeIntervalSince1970];
    timeInterval = end - start;
    //请求结束状态栏隐藏网络活动标志：
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [remoteAlertView dismissWithClickedButtonIndex:0 animated:YES];
}
// 登录按钮
- (IBAction)btnLogin:(id)sender {
    _btnLoginText.title = @"已登录";
    _btnLoginText.enabled = NO;
    // 加载登录界面
    SXLoginViewController *lVC = [[SXLoginViewController alloc] initWithNibName:@"SXLoginViewController" bundle:nil];
    [self presentViewController:lVC animated:YES completion:nil];
}
//设置日期选择弹框
- (void)setupDateView:(DateType)type {
    
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    _pikerView.frame = CGRectMake(0, 0, ScreenRectWidth, ScreenRectHeight + 20);
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    // 设置最小的时间，注释掉就可以不限制了
    //[_pikerView.datePickerView setMinimumDate:[NSDate date]];
    [self.view addSubview:_pikerView];
}
/**
 *  得到所选的日期
 *
 *  @param date 日期
 *  @param type 日期类型
 */
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    if (type == DateTypeOfStart) {
        // 将字符串date的内容用－切割，存入到数组中，获取年月日
        _date_arr = [date componentsSeparatedByString:@"-"];
        // 分别获取数组中的每一个元素，年月日
        year  = [_date_arr objectAtIndex:0];
        month = [_date_arr objectAtIndex:1];
        day   = [_date_arr objectAtIndex:2];
        NSLog(@"全局变量，选中的日期：%@年%@月%@日", year, month, day);
        _btnDatePick.titleLabel.numberOfLines = 0;
        _btnDatePick.titleLabel.text = [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
        // 选择日期之后，再调用一次webservice的方法
        [self remoteAnimation:@"正在获取数据, 请稍候..."];
        // 状态栏网络请求效果
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//        [self getWebService];
        start = [[NSDate date] timeIntervalSince1970];
        [self performSelectorInBackground:@selector(getWebService) withObject:nil];
        end = [[NSDate date] timeIntervalSince1970];
        timeInterval = end - start;
        //请求结束状态栏隐藏网络活动标志：
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [remoteAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}
#pragma mark - 调用webservice返回日进度数据
/**
 *  调用webservice的，返回的是日进度要显示的数据
 *
 *  @param chosedPid     标段ID
 *  @param chosedProject 项目ID
 *  @param year          年
 *  @param month         月
 *  @param day           日
 *  @param ryid          当前的人员ID
 */
- (void)searchDsWork:(NSString *)chosedPid chosedProject:(NSString *)chosedProject year:(NSString *)year month:(NSString *)month day:(NSString *)day ryid:(NSInteger)ryid {
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<searchdswork xmlns=\"http://com\">"
                                   "<biaoduan>%@</biaoduan>"
                                   "<xmbh>%@</xmbh>"
                                   "<year>%@</year>"
                                   "<month>%@</month>"
                                   "<day>%@</day>"
                                   "<ryid>%ld</ryid>"
                                   "</searchdswork>",chosedPid, chosedProject, year, month, day, (long)ryid];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                               "<soap:Body>\n"
                               "%@\n" // 参数部分
                               "</soap:Body>\n"
                               "</soap:Envelope>", webServiceBodyStr];//webService头
    NSString *SOAPActionStr = [NSString stringWithFormat:@"http://com/%@", @"searchdswork"];//SOAPAction
    NSLog(@"webServiceStr的内容：%@", webServiceStr);
    NSLog(@"SOAPActionStr的内容：%@", SOAPActionStr);
    
    NSURL *url = [NSURL URLWithString:@"http://112.124.30.42:8080/test/services/searchmswork"];
    // 初始化一个request给我们的connection调用
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", (unsigned long)webServiceStr.length];
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

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"-------------------start--------------");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    NSLog(@"1 parser: didStarElement:");
    if ([elementName isEqualToString:@"soap:Body"]) {
        NSLog(@"开始节点-开始创建可变字符串");
        if (!soapResults) {
            soapResults = [[NSMutableString alloc] init];
            NSLog(@"可变字符串创建成功");
        }
        recordResults = YES;
    }
}
// 如果节点中的内容过长的情况下，可能将内容进行分段，这样就应该进行合并
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSMutableString *)string {
    NSLog(@"2 parser: foundCharacters:");
    if (recordResults) {
        [soapResults appendString: string];// 将获取到的字符串添加到soapResults中
        [soapResults appendString:@"$"];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"3 parser: didEndElement:");
    
    if([elementName isEqualToString:@"soap:Body"]) {
        temp = soapResults;// 将获得的数据移出来
        recordResults = FALSE;
        soapResults = nil;
        NSLog(@"soapResults的值是+++++：%@解析到最后一个节点了-清空soapResults",soapResults);
    }
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"--------------------end---------------");
}

/**
 *  返回的是标段的名称
 *
 *  @param ryid 根据人员的id
 */
- (void)searchBiaoDuan:(NSInteger)ryid {
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<search_temp_biaoduan xmlns=\"http://com\">"
                                   "<ryid>%ld</ryid>"
                                   "</search_temp_biaoduan>", (long)ryid];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                               "<soap:Body>\n"
                               "%@\n" // 参数部分
                               "</soap:Body>\n"
                               "</soap:Envelope>", webServiceBodyStr];//webService头
    NSString *SOAPActionStr = [NSString stringWithFormat:@"http://com/%@", @"search_temp_biaoduan"];//SOAPAction
    NSLog(@"webServiceStr的内容：%@", webServiceStr);
    NSLog(@"SOAPActionStr的内容：%@", SOAPActionStr);
    
    NSURL *url = [NSURL URLWithString:@"http://112.124.30.42:8080/test/services/searchmswork"];
    // 初始化一个request给我们的connection调用
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", (unsigned long)webServiceStr.length];
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
/**
 *  返回的是下拉列表的一级项目
 *
 *  @param bdPid 标段名称
 *  @param ryid  人员的id
 */
- (void)searchYiJi:(NSString *)bdPid andryid:(NSInteger)ryid {
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<search_temp_yiji xmlns=\"http://com\">"
                                   "<biaoduan>%@</biaoduan>"
                                   "<ryid>%ld</ryid>"
                                   "</search_temp_yiji>",bdPid, (long)ryid];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                               "<soap:Body>\n"
                               "%@\n" // 参数部分
                               "</soap:Body>\n"
                               "</soap:Envelope>", webServiceBodyStr];// webService头
    NSString *SOAPActionStr = [NSString stringWithFormat:@"http://com/%@", @"search_temp_yiji"];//SOAPAction
    NSLog(@"webServiceStr的内容：%@", webServiceStr);
    NSLog(@"SOAPActionStr的内容：%@", SOAPActionStr);
    
    NSURL *url = [NSURL URLWithString:@"http://112.124.30.42:8080/test/services/searchmswork"];
    // 初始化一个request给我们的connection调用
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", (unsigned long)webServiceStr.length];
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
/**
 *  返回的是累计完成实物量和累计完成产值
 */
- (void)searchDsWorkItem:(NSString *)chosedPid chosedProject:(NSString *)chosedProject year:(NSString *)year month:(NSString *)month day:(NSString *)day {
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<searchdswork_item xmlns=\"http://com\">"
                                   "<biaoduan>%@</biaoduan>"
                                   "<xmbh>%@</xmbh>"
                                   "<year>%@</year>"
                                   "<month>%@</month>"
                                   "<day>%@</day>"
                                   "</searchdswork_item>",chosedPid, chosedProject, year, month, day];// 这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                               "<soap:Body>\n"
                               "%@\n" // 参数部分
                               "</soap:Body>\n"
                               "</soap:Envelope>", webServiceBodyStr]; // webService头
    NSString *SOAPActionStr = [NSString stringWithFormat:@"http://com/%@", @"searchdswork_item"];// SOAPAction
    NSLog(@"webServiceStr的内容：%@", webServiceStr);
    NSLog(@"SOAPActionStr的内容：%@", SOAPActionStr);
    
    NSURL *url = [NSURL URLWithString:@"http://112.124.30.42:8080/test/services/searchmswork"];
    // 初始化一个request给我们的connection调用
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", (unsigned long)webServiceStr.length];
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
    [par setDelegate:self]; //设置NSXMLParser对象的解析方法代理
    BOOL flag = [par parse]; //调用代理解析NSXMLParser对象，看解析是否成功
    if (flag) {
        NSLog(@"xml解析成功了");
    }
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
    
    [NSTimer scheduledTimerWithTimeInterval:30.0
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

#pragma mark - Animation
- (void)remoteAnimation:(NSString *)message {
    remoteAlertView =  [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125.0, 80.0, 30.0, 30.0)];
    aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    //check if os version is 7 or above. ios7.0及以上UIAlertView弃用了addSubview方法
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
        [remoteAlertView setValue:aiView forKey:@"accessoryView"];
    }else{
        [remoteAlertView addSubview:aiView];
    }
    [remoteAlertView show];
    [aiView startAnimating];
}
@end