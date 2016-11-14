//
//  GoldTableViewController.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/6/13.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "GoldTableViewController.h"
#import "UIImageView+WebCache.h"
#import "BWGoldHistoryController.h"
#define NavBarFgColor [UIColor whiteColor]
#define NavTextAttribute @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}
@interface GoldTableViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *goldNumberLabel;

@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UILabel *errorStringLabel;
//判断是否切换错误
@property (nonatomic,assign)BOOL account;

@property (nonatomic, strong) NSURLSessionDataTask *csvTask;
@property (nonatomic, strong) NSURLSessionDataTask *dnsTask;
@end

@implementation GoldTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:userMessage.photo_icon_url] placeholderImage:[UIImage imageNamed:@"setting_default_head"]];
    if (userMessage.user_name) {
        
    }else{
        
    }
    self.userNameLabel.text=userMessage.user_name;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    self.tabBarController.navigationItem.titleView = [self titleView];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    self.view.backgroundColor=HBRGBColor(235, 235, 241, 1);
    self.navigationItem.title = @"我的收益";
    self.navigationController.navigationBar.barTintColor=HBRGBColor(27, 169, 240, 1);
    self.navigationController.navigationBar.tintColor=NavBarFgColor;
    self.navigationController.navigationBar.titleTextAttributes=NavTextAttribute;
    //设置成导航栏下面开始计算
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bookshop_1_back1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    //self.navigationItem.title=@"我的";
    // [self setupCancelLogin];
    [self setupCancelSuccess];
    [self setupHttpRequest];
}

#pragma mark - 返回按键的方法
- (void)leftAction{
    
    [self.csvTask cancel];
    [self.dnsTask cancel];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //消费记录
    if (indexPath.section == 0 && indexPath.row == 2) {
        
        BWGoldHistoryController *goldHistoryVc = [[BWGoldHistoryController alloc] init];
        [self.navigationController pushViewController:goldHistoryVc animated:YES];
        
    }else{
        return;
    }
}

- (void)setupHttpRequest
{
    [SVProgressHUD showWithStatus:@"正在请求数据中..."];
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] = @"user_account_info_get";
    parameters[@"from_system"] = FromSystem;
    //拿到当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    parameters[@"from_client_version"] = version;
    //拿到手机的MAC地址
    parameters[@"from_client_id"] = AppUUID;
    if (userArray.count > 0) {
        loginOrReginModel *userMessage = userArray.lastObject;
        parameters[@"yc_user_role"] = UserRole;
        parameters[@"yc_user_account_uid"] = userMessage.user_account_uid;
        
    }
    NSString *xmlString = [parameters newXMLString];
    
    NSMutableURLRequest *dnsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseUrlString]];
    
    [dnsRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    dnsRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    dnsRequest.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak typeof(self) weakself = self;
    
    //拿到dns服务器的请求
    NSURLSessionDataTask *dnsTask = [session dataTaskWithRequest:dnsRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
            });
            return;
        }
        NSDictionary *dnsDict = [NSDictionary dictionaryWithXMLData:data];
        
        NSMutableURLRequest *csvRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dnsDict[@"dns.url"]]];
        [csvRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        csvRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
        csvRequest.HTTPMethod = @"POST";
        csvRequest.timeoutInterval = 10;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSURLSessionDataTask *csvTask = [session dataTaskWithRequest:csvRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                    });
                    return;
                }
                
                NSDictionary *csvDict = [NSDictionary dictionaryWithXMLData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakself.goldNumberLabel.text = csvDict[@"current_yp"];
                    [SVProgressHUD dismiss];
                });
            }];
            [csvTask resume];
            weakself.csvTask = csvTask;
        });
    }];
    [dnsTask resume];
    self.dnsTask = dnsTask;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 圆角弧度半径
    CGFloat cornerRadius = 6.f;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds, 10, 0);
    
    // CGRectGetMinY：返回对象顶点坐标
    // CGRectGetMaxY：返回对象底点坐标
    // CGRectGetMinX：返回对象左边缘坐标
    // CGRectGetMaxX：返回对象右边缘坐标
    // CGRectGetMidX: 返回对象中心点的X坐标
    // CGRectGetMidY: 返回对象中心点的Y坐标
    
    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    if ([tableView numberOfRowsInSection:indexPath.section]==1) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        
        
    }else{
        
        // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        if (indexPath.row == 0) {
            // 初始起点为cell的左下角坐标
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            // 初始起点为cell的左上角坐标
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            // 添加cell的rectangle信息到path中（不包括圆角）
            CGPathAddRect(pathRef, nil, bounds);
        }
        
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    // cell的背景view
    cell.backgroundView = roundView;
    
    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    backgroundLayer.fillColor = [UIColor cyanColor].CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
    
}
//注销成功界面布局
- (void)setupCancelSuccess
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:backgroundView];
    backgroundView.hidden = YES;
    self.backgroundView = backgroundView;
    
    UIView *remindView = [[UIView alloc] init];
    remindView.bw_width = HBScreenWidth - 60;
    remindView.bw_height = 120;
    remindView.center = CGPointMake(HBScreenWidth * 0.5, HBScreenHeight * 0.5);
    remindView.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:remindView];
    
    UILabel *warmLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, remindView.bw_width, 40)];
    warmLabel.text = @"温馨提示";
    warmLabel.font = [UIFont systemFontOfSize:20];
    warmLabel.textColor = [UIColor whiteColor];
    warmLabel.backgroundColor = HBConstColor;
    warmLabel.textAlignment = NSTextAlignmentCenter;
    [remindView addSubview:warmLabel];
    
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, remindView.bw_width - 2 * 10, 40)];
    remindLabel.textColor = [UIColor blackColor];
    remindLabel.font = [UIFont systemFontOfSize:15];
    remindLabel.textAlignment=NSTextAlignmentCenter;
    [remindView addSubview:remindLabel];
    self.errorStringLabel = remindLabel;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 80, remindView.bw_width - 2 * 10, 30);
    sureBtn.backgroundColor = HBConstColor;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [remindView addSubview:sureBtn];
}
//温馨提示框上的确定按钮的点击事件
- (void)sureClick
{
    self.backgroundView.hidden = YES;
    
}

@end
