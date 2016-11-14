//
//  MeTableViewController.m
//  YoungWan
//
//  Created by 李明丹 on 16/4/11.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "MeTableViewController.h"
#import "UIImageView+WebCache.h"
#import "NewRegisterViewController.h"
#import "NewLoginViewController.h"
#import "BWPasswordController.h"
#import "SuggestViewController.h"
#define NavBarFgColor [UIColor whiteColor]
#define NavTextAttribute @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}
@interface MeTableViewController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSessionDataTask *csvTask;
@property (nonatomic, strong) NSURLSessionDataTask *userTask;
@property (nonatomic, strong) NSURLSessionDataTask *answerTask;
@property (nonatomic, strong) NSURLSessionDataTask *postTask;
@property (nonatomic, strong) NSURLSessionDataTask *dnsTask;
//头像
@property (strong, nonatomic) IBOutlet UIImageView *touImageView;
//名字
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
//电话号码
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLbael;

@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UILabel *errorStringLabel;
@property (nonatomic, strong) BWHttpRequestManager *manager;

@property (nonatomic, weak) UIView *hudView;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
//判断是否切换错误
@property (nonatomic,assign)BOOL account;

@property (strong, nonatomic) IBOutlet UIButton *changeButton;

@end

@implementation MeTableViewController
- (BWHttpRequestManager *)manager
{
    if (_manager == nil) {
        BWHttpRequestManager *manager = [[BWHttpRequestManager alloc] init];
        _manager = manager;
    }
    return _manager;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    [_touImageView sd_setImageWithURL:[NSURL URLWithString:userMessage.photo_icon_url] placeholderImage:[UIImage imageNamed:@"setting_default_head"]];
    if (userMessage.user_msisdn.length>0) {
        if (userMessage.user_name.length>0) {
            self.nameLable.text=userMessage.user_name;
        }else{
            NSString *fourStr=[userMessage.user_msisdn substringFromIndex:7];
            self.nameLable.text=fourStr;
        }
        self.phoneNumberLbael.text=userMessage.user_msisdn;

    }else{
        self.nameLable.text=@"游客";
        self.phoneNumberLbael.text=@"";
    
    }
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *tuisong=[user objectForKey:@"tuisong"];
    if ([tuisong isEqualToString:@"YES"]) {
        
        [self.changeButton setImage:[UIImage imageNamed:@"listview_item_checkbox_bg_checked"] forState:UIControlStateNormal];
        self.changeButton.selected=YES;
    }else{
        
        [self.changeButton setImage:[UIImage imageNamed:@"listview_item_checkbox_bg_normal"] forState:UIControlStateNormal];
        self.changeButton.selected=NO;
    }
    
    self.navigationController.navigationBarHidden = NO;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    self.tabBarController.navigationItem.titleView = [self titleView];
  
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=HBRGBColor(235, 235, 241, 1);
    self.navigationItem.title = @"应用设置";
    self.navigationController.navigationBar.barTintColor=HBRGBColor(27, 169, 240, 1);
    self.navigationController.navigationBar.tintColor=NavBarFgColor;
    self.navigationController.navigationBar.titleTextAttributes=NavTextAttribute;
    //设置成导航栏下面开始计算
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bookshop_1_back1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [self setupReviseIcon];
    [self setupCancelSuccess];
}

#pragma mark - 返回按键的方法
- (void)leftAction{
    
    [self.dnsTask cancel];
    [self.csvTask cancel];
    [self.userTask cancel];
    [self.answerTask cancel];
    [self.postTask cancel];
    [self.dnsTask cancel];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
}
//推送按键
- (IBAction)changButton:(UIButton *)sender {
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    if (sender.selected) {
     
        [self.changeButton setImage:[UIImage imageNamed:@"listview_item_checkbox_bg_normal"] forState:UIControlStateNormal];
        sender.selected=NO;
        [user setObject:@"NO" forKey:@"tuisong"];
        
    }else{
        [self.changeButton setImage:[UIImage imageNamed:@"listview_item_checkbox_bg_checked"] forState:UIControlStateNormal];
        sender.selected=YES;
        [user setObject:@"YES" forKey:@"tuisong"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//注销登录按钮的布局
//- (void)setupCancelLogin
//{
//    self.tableView.bounces=NO;
//    UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
//    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelbtn.backgroundColor=HBRGBColor(245, 85, 30, 1);
//    [cancelbtn setTitle:@"注销登录" forState:UIControlStateNormal];
//    cancelbtn.titleLabel.font=[UIFont systemFontOfSize:17];
//    cancelbtn.frame=CGRectMake(30, 0, HBScreenWidth-60, 40);
//    cancelbtn.layer.cornerRadius=15;
//    cancelbtn.clipsToBounds=YES;
//    [cancelbtn addTarget:self action:@selector(cancelLogin:) forControlEvents:UIControlEventTouchUpInside];
//    [cancelView addSubview:cancelbtn];
//    self.tableView.tableFooterView = cancelView;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //允许消息推送
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        
        return;
    }
    //清楚缓存
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        
        [SVProgressHUD showWithStatus:@"正在清除缓存..."];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(clear) userInfo:nil repeats:NO];
        
        return;
    }
    //意见反馈
    if (indexPath.section == 1 && indexPath.row == 2) {
        
        SuggestViewController *suVC=[[SuggestViewController alloc]init];
        [self.navigationController pushViewController:suVC animated:YES];
        
        return;
    }
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    if (userMessage.user_msisdn.length>0) {
        
        //修改头像
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            self.hudView.hidden = NO;
            
        }
        //修改昵称
        if (indexPath.section == 0 && indexPath.row == 1) {
            
            BWPasswordController *passwordController = [[BWPasswordController alloc] initWithNibName:@"BWPasswordController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:passwordController animated:YES];
            
        }
        //电话号码
        if (indexPath.section == 0 && indexPath.row == 2) {
            
        }
        //修改密码
        if (indexPath.section == 0 && indexPath.row == 3) {
            
            NewRegisterViewController *paVC=[[NewRegisterViewController alloc]init];
            paVC.titles=@"修改密码";
            [self.navigationController pushViewController:paVC animated:YES];
        }
        
        //退出登录
        if (indexPath.section == 2 && indexPath.row == 0) {
            
            [self logout];
        }
        
    }else{
    
        [self pushView];
    
    }
   
    
}

//清除缓存
- (void)clear
{
    //清楚缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [SVProgressHUD dismiss];
    self.errorStringLabel.text=@"清除成功";
    self.backgroundView.hidden=NO;

}


- (void)pushView
{
    UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:@"提示" message:@"您还没登录，请先登录" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NewLoginViewController *logVC=[[NewLoginViewController alloc]init];
        logVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:logVC animated:YES completion:nil];
        
    }];
    
    UIAlertAction *alertAction1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alertControll addAction:alertAction];
    [alertControll addAction:alertAction1];
    [self presentViewController:alertControll animated:YES completion:nil];
    
    //[SVProgressHUD showErrorWithStatus:@"请先登录"];
    
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

- (void)logout{

    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    
    [SVProgressHUD showWithStatus:@"正在注销用户..."];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] = @"user_logout";
    parameters[@"from_system"] = FromSystem;
    //拿到当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    parameters[@"from_client_version"] = version;
    //拿到手机的MAC地址
    parameters[@"from_client_id"] = AppUUID;
    parameters[@"yc_user_role"] = UserRole;
    parameters[@"yc_user_account_uid"] = userMessage.user_account_uid;
    
    NSString *xmlString = [parameters newXMLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseUrlString]];
    
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak typeof(self) weakself = self;
    NSURLSessionDataTask *csvTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"注销失败"];
            });
            return;
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];
        
        NSMutableURLRequest *dnsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dict[@"dns.url"]]];
        
        [dnsRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        dnsRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
        dnsRequest.HTTPMethod = @"POST";
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:dnsRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:@"注销失败"];
                });
                return;
            }
            
            NSDictionary *dataDict = [NSDictionary dictionaryWithXMLData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!dataDict[@"error_string"]) {
                    [SVProgressHUD showSuccessWithStatus:@"注销成功"];
                    
//                    //文件的路径是文件夹的路径+文件名
//                    NSFileManager *fileManager=[NSFileManager defaultManager];
//                    NSString *document1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//                    NSString *filePath1 = [document1 stringByAppendingPathComponent:@"UnitDataBase.db"];
//                    [fileManager removeItemAtPath:filePath1 error:NULL];
//                    
//                    NSString *filePath2 = [document1 stringByAppendingPathComponent:@"ABDataBase.db"];
//                    [fileManager removeItemAtPath:filePath2 error:NULL];
//                    
//                    NSString *filePath3= [document1 stringByAppendingPathComponent:@"VideoDataBase.db"];
//                    [fileManager removeItemAtPath:filePath3 error:NULL];
//                    
//                    NSString *filePath4 = [document1 stringByAppendingPathComponent:@"UserDataBase.db"];
//                    [fileManager removeItemAtPath:filePath4 error:NULL];
//                    
//                    //清空用户信息
//                    NSString *modifyString = [NSString stringWithFormat:@"UPDATE loginUser SET user_account_uid = '',  user_name='', user_msisdn='', photo_icon_url='', photo_raw_url=''"];
//                    [LoginUserManager modifyData:modifyString];
//                    
//                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//                    
//                        [user setObject:@"" forKey:@"请填写收货姓名"];
//                        [user setObject:@"" forKey:@"请输入手机号码"];
//                        [user setObject:@"" forKey:@"请填写配送地址"];
//                    //清楚缓存
//                    [[SDImageCache sharedImageCache] clearDisk];
//                    [[SDImageCache sharedImageCache] clearMemory];
               
                    //清空所有数据
                    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM csv_path"];
                    NSArray *overModelArray = [BWCSVDatabase queryData:sqlString];
                    NSFileManager *manager = [NSFileManager defaultManager];
                    for (BWCSVModel *csvModel in overModelArray) {
                        
                        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
                        NSString *csvPath = [cachePath stringByAppendingPathComponent:csvModel.csvPath];
                        [manager removeItemAtPath:csvPath error:nil];
                    }
                    
                    NSString *deleteString = [NSString stringWithFormat:@"DELETE FROM csv_path"];
                    [BWCSVDatabase deleteData:deleteString];
                    
                    NewLoginViewController *logVC=[[NewLoginViewController alloc]init];
                    logVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:logVC animated:YES completion:nil];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:@"注销失败"];
                }
            });
        }];
        [dataTask resume];
        self.dataTask=dataTask;
    }];
    [csvTask resume];
    self.csvTask=csvTask;


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

//修改头像界面布局
- (void)setupReviseIcon
{
    UIView *hudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hudDismiss)];
    [hudView addGestureRecognizer:tap];
    hudView.hidden = YES;
    self.hudView = hudView;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, HBScreenHeight - 130, HBScreenWidth, 130)];
    contentView.backgroundColor = [UIColor whiteColor];
    [hudView addSubview:contentView];
    
    NSArray *titleArray = @[@"拍照", @"选择本地图片", @"取消"];
    CGFloat btnW = contentView.bw_width - 2 * HBMargin;
    CGFloat btnH = 30;
    CGFloat btnX = HBMargin;
    CGFloat btnY = HBMargin;
    
    for (int i = 0; i < titleArray.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setBackgroundColor:HBConstColor];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            [btn addTarget:self action:@selector(photographClick) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 1) {
            [btn addTarget:self action:@selector(choosePhotoClick) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 2) {
            [btn addTarget:self action:@selector(cancelChoose) forControlEvents:UIControlEventTouchUpInside];
        }
        [contentView addSubview:btn];
        
        btnY += (btnH + HBMargin);
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:hudView];
}

- (void)hudDismiss
{
    self.hudView.hidden = YES;
}

//拍照点击事件
- (void)photographClick
{
    self.hudView.hidden = YES;
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

//选择本地图片点击事件
- (void)choosePhotoClick
{
    self.hudView.hidden = YES;
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

//修改头像界面的取消按钮的点击事件
- (void)cancelChoose
{
    self.hudView.hidden = YES;
}

//懒加载imagePickerController
- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        _imagePicker = imagePicker;
    }
    return _imagePicker;
}

//选择图片后调用的方法
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    [SVProgressHUD showWithStatus:@"正在上传图片..."];
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    //拿到用户信息
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] = @"user_info_set";
    parameters[@"yc_user_role"] = @"none";
    
    NSString *xmlString = [parameters newXMLString];
    
    NSMutableURLRequest *dnsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseUrlString]];
    
    [dnsRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    dnsRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    dnsRequest.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak typeof(self) weakself = self;
    
    //获取上传地址的请求
    NSURLSessionDataTask *dnsTask = [session dataTaskWithRequest:dnsRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"获取地址失败"];
            });
            return;
        }
        NSDictionary *dnsDict = [NSDictionary dictionaryWithXMLData:data];
        NSMutableString *dnsString = dnsDict[@"dns.url"];
        NSRange range = [dnsString rangeOfString:@".aspx"];
        if (range.length) {
            [dnsString insertString:@"_upload" atIndex:(range.location)];
        }
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dnsString]];
        
        [postRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        postRequest.HTTPBody = imageData;
        postRequest.HTTPMethod = @"POST";
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //上传文件
            NSURLSessionDataTask *postTask = [session dataTaskWithRequest:postRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
                    });
                    
                    return;
                }
                
                NSDictionary *postDict = [NSDictionary dictionaryWithXMLData:data];
                NSString *subString = postDict[@"receipt.receipt"];
                
                NSMutableDictionary *dataPara = [NSMutableDictionary dictionary];
                dataPara[@"trans_code"] = @"user_info_set";
                dataPara[@"from_system"] = FromSystem;
                //拿到当前版本号
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                dataPara[@"from_client_version"] = version;
                //拿到手机的MAC地址
                dataPara[@"from_client_id"] = AppUUID;
                dataPara[@"yc_user_role"] = UserRole;
                dataPara[@"yc_user_account_uid"] = userMessage.user_account_uid;
                //                dataPara[@"yc_school_id"] = userMessage.school_id;
                //                dataPara[@"yc_dept_id"] = userMessage.dept_id;
                dataPara[@"upload_receipt_photo"] = subString;
                dataPara[@"user_name"] = @"";
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:date];
                NSString *fileName = [NSString stringWithFormat:@"%@.png",dateString];
                dataPara[@"upload_photo_file"] = fileName;
                
                NSString *dataXmlString = [dataPara newXMLString];
                
                NSString *answerString = [dnsString stringByReplacingOccurrencesOfString:@"_upload" withString:@""];
                NSMutableURLRequest *answerRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:answerString]];
                [answerRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                answerRequest.HTTPBody = [dataXmlString dataUsingEncoding:NSUTF8StringEncoding];
                answerRequest.HTTPMethod = @"POST";
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //将上传的头像告诉中控
                    NSURLSessionDataTask *answerTask = [session dataTaskWithRequest:answerRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD showErrorWithStatus:@"中控拉取头像失败"];
                                
                            });
                            
                            return;
                        }
                        
                        NSDictionary *schoolDict = [NSDictionary dictionaryWithXMLData:data];
                        
                        if (schoolDict[@"error_code"]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //[SVProgressHUD dismiss];
                                [SVProgressHUD showErrorWithStatus:schoolDict[@"error_string"]];
                            });
                            return;
                        }
                        
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            NSMutableDictionary *para = [NSMutableDictionary dictionary];
                            
                            para[@"trans_code"] = @"user_info_get";
                            para[@"from_system"] = FromSystem;
                            //拿到手机的MAC地址
                            para[@"from_client_id"] = AppUUID;
                            //拿到当前版本号
                            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                            NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                            para[@"from_client_version"] = version;
                            para[@"yc_user_role"] = UserRole;
                            para[@"yc_user_account_uid"] = userMessage.user_account_uid;
                            //                                    para[@"yc_school_id"] = userMessage.school_id;
                            //                                    para[@"yc_dept_id"] = userMessage.dept_id;
                            //登录成功,请求用户信息
                            NSString *requestString = [para newXMLString];
                            
                            NSMutableURLRequest *userRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:answerString]];
                            
                            [userRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                            userRequest.HTTPBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
                            userRequest.HTTPMethod = @"POST";
                            
                            NSURLSessionDataTask *userTask = [session dataTaskWithRequest:userRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                
                                if (error) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [SVProgressHUD showErrorWithStatus:@"请求失败..."];
                                    });
                                    return;
                                }
                                
                                NSDictionary *xmlDict = [NSDictionary dictionaryWithXMLData:data];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    NSString *user_accout_uid = xmlDict[@"user_account_uid"];
                                    if (user_accout_uid.length > 0) {
                                        [SVProgressHUD showSuccessWithStatus:@"修改头像成功"];
                                        
                                        for (UINavigationController *navVc in weakself.tabBarController.childViewControllers) {
                                            
                                            if (navVc.childViewControllers.count > 1) {
                                                
                                                [navVc popViewControllerAnimated:YES];
                                            }
                                        }
                                        
                                        //将用户数据存到数据库中
                                        loginOrReginModel *model = [loginOrReginModel mj_objectWithKeyValues:xmlDict];
                                        //                                                model.account =  userMessage.account;
                                        //                                                model.password = userMessage.password;
                                        NSMutableArray *userArray=[NSMutableArray array];
                                        userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
                                        if (userArray.count > 0) {
                                            NSString *modifyString = [NSString stringWithFormat:@"UPDATE loginUser SET user_account_uid = '%@',  user_name='%@', user_msisdn='%@', photo_icon_url='%@', photo_raw_url='%@'", model.user_account_uid, model.user_name, model.user_msisdn, model.photo_icon_url, model.photo_raw_url];
                                            [LoginUserManager modifyData:modifyString];
                                            [weakself.touImageView sd_setImageWithURL:[NSURL URLWithString:model.photo_icon_url] placeholderImage:[UIImage imageNamed:@"setting_default_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                weakself.touImageView.image = image;
                                            }];
                                        } else {
                                            [LoginUserManager insertModal:model];
                                        }
                                    } else {
                                        [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                                    }
                                });
                            }];
                            [userTask resume];
                            self.userTask=userTask;
                        });
                    }];
                    //                            [schoolTask resume];
                    //});
                    //}];
                    [answerTask resume];
                    self.answerTask=answerTask;
                });
            }];
            [postTask resume];
            self.postTask=postTask;
        });
    }];
    [dnsTask resume];
    self.dnsTask=dnsTask;
}

@end
