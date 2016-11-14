//
//  BWShakeController.m
//  WidomStudy
//
//  Created by 李明丹 on 16/4/15.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import <POP.h>

#import "BWShakeController.h"

#import "BWWinningAnnouncement.h"
#import "LoginUserManager.h"
#import "loginOrReginModel.h"
@interface BWShakeController ()

@property (nonatomic, strong) NSURLSessionDataTask *dnsTask;

@property (nonatomic, strong) NSURLSessionDataTask *csvTask;

@property (nonatomic, weak) UIView *hudView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *showImage;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *shakeTreeImage;
@property (weak, nonatomic) IBOutlet UIButton *shakeBtn;

@property (nonatomic, strong) NSArray *winningArray;
@property (nonatomic, strong) NSArray *labelArray;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BWShakeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //使控制器支持摇一摇功能
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    //摇奖提示控件
    [self setupHudView];
//    [self animationPic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //中奖公告
    [self setupData];
    
    self.navigationController.navigationBarHidden = YES;
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self resignFirstResponder];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setupHudView
{
    //黑色背景控件
    UIView *hudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    hudView.hidden = YES;
    self.hudView = hudView;
    [self.view addSubview:hudView];
    
    //中央内容控件
    UIView *contentView = [[UIView alloc] init];
    CGFloat contentW = HBScreenWidth * 0.7;
    //CGFloat contentH = contentW / 0.75;
    CGFloat contentH = contentW-20;
    contentView.frame = CGRectMake((HBScreenWidth - contentW) * 0.5, (HBScreenHeight - contentH) * 0.5, contentW, contentH);
    [hudView addSubview:contentView];
    
    //内容控件的背景图
    UIImage *backgroundImg = [UIImage imageNamed:@"shake_dialog_bg_bottom.9"];
    UIEdgeInsets insets = UIEdgeInsetsMake(50, 50, 50, 50);
    backgroundImg = [backgroundImg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:backgroundImg];
    backgroundImage.frame = contentView.bounds;
    [contentView addSubview:backgroundImage];
    
    //头部图片
    CGFloat titleImageW = contentView.bw_width / 2.4;
    CGFloat titleImageH = titleImageW * 0.9;
    CGFloat titleX = (contentView.bw_width - titleImageW) * 0.5;
    CGFloat titleY = -(titleImageH / 3);
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(titleX, titleY, titleImageW, titleImageH)];
    titleImage.image = [UIImage imageNamed:@"shake_dialog_bg_top"];
    [contentView addSubview:titleImage];
    
    //提示内容
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.bw_x = 3 * HBMargin;
    titleLabel.bw_y = CGRectGetMaxY(titleImage.frame) + HBSmallMargin;
    titleLabel.bw_width = contentView.bw_width - 6 * HBMargin;
    self.titleLabel = titleLabel;
    [contentView addSubview:titleLabel];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = HBRGBColor(250, 23, 95, 1);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    backBtn.bw_width = titleLabel.bw_width;
    backBtn.bw_height = 25;
    backBtn.bw_x = titleLabel.bw_x;
    backBtn.bw_y = contentView.bw_height - backBtn.bw_height - 3 * HBMargin;
    [backBtn addTarget:self action:@selector(hudDismiss) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:backBtn];
    
    //展示图片
    UIImageView *showImage = [[UIImageView alloc] init];
    //showImage.image = [UIImage imageNamed:@"海燕平台_12"];
    showImage.bw_width = backBtn.bw_width;
    showImage.bw_height = showImage.bw_width * 0.5;
    showImage.bw_x = backBtn.bw_x;
    showImage.bw_y = backBtn.bw_y - showImage.bw_height - HBMargin;
    self.showImage = showImage;
    [contentView addSubview:showImage];
}

//隐藏提示控件
- (void)hudDismiss
{
    self.hudView.hidden = YES;
//    NSArray *imageNameArray = @[@"海燕平台_12", @"海燕平台_14", @"海燕平台_23", @"海燕平台_24"];
//    int index = arc4random() % imageNameArray.count;
//    self.showImage.image = [UIImage imageNamed:imageNameArray[index]];
}

//返回
- (IBAction)backClick:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//摇一摇
- (IBAction)shakeClick:(UIButton *)sender {
    
    [self vibrate];
    [self setupHttpRequest];
}

//检测到摇动
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self vibrate];
    [self setupHttpRequest];
}

//使图片左右摇动
- (void)animationPic
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    
    CGPoint btnPoint = self.shakeBtn.center;
    CGFloat btnX = HBScreenWidth * 0.5 + 148 - 55 - 30;
    
    if (btnPoint.x == (btnX - 10)) {
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(btnX + 10, btnPoint.y)];
        
    } else {
        springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(btnX - 10, btnPoint.y)];
    }
    
    //弹性值
    springAnimation.springBounciness = 20.0;
    //弹性速度
    springAnimation.springSpeed = 20.0;
    
    [self.shakeBtn pop_addAnimation:springAnimation forKey:@"changeposition"];
}

//手机震动
- (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)setupHttpRequest
{
    self.hudView.hidden = NO;
    self.titleLabel.text = @"正在摇奖,请稍后...";
    self.titleLabel.bw_width = HBScreenWidth * 0.7 - 6 * HBMargin;
    [self.titleLabel sizeToFit];
    NSMutableArray *userArray=[NSMutableArray array];
   userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] = @"shake_over";
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
        //        parameters[@"yc_school_id"] = userMessage.school_id;
        //        parameters[@"yc_dept_id"] = userMessage.dept_id;
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
                weakself.titleLabel.text = @"网络繁忙,请稍后再试";
                weakself.titleLabel.bw_width = HBScreenWidth * 0.7 - 6 * HBMargin;
                [weakself.titleLabel sizeToFit];
            });
            return;
        }
        NSDictionary *dnsDict = [NSDictionary dictionaryWithXMLData:data];
         NSLog(@"%@",dnsDict[@"dns.url"]);
        NSMutableURLRequest *csvRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dnsDict[@"dns.url"]]];
        [csvRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        csvRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
        csvRequest.HTTPMethod = @"POST";
        csvRequest.timeoutInterval = 10;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSURLSessionDataTask *csvTask = [session dataTaskWithRequest:csvRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakself.titleLabel.text = @"网络繁忙,请稍后再试";
                        weakself.titleLabel.bw_width = HBScreenWidth * 0.7 - 6 * HBMargin;
                        [weakself.titleLabel sizeToFit];
                    });
                    return;
                }
                
                NSDictionary *dataDict = [NSDictionary dictionaryWithXMLData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (dataDict[@"bonus_title_text"]) {
                        weakself.titleLabel.text = dataDict[@"bonus_title_text"];
                        weakself.titleLabel.bw_width = HBScreenWidth * 0.7 - 6 * HBMargin;
                        [weakself.titleLabel sizeToFit];
                    } else if (dataDict[@"hint_message_text"]) {
                        weakself.titleLabel.text = dataDict[@"hint_message_text"];
                        weakself.titleLabel.bw_width = HBScreenWidth * 0.7 - 6 * HBMargin;
                        [weakself.titleLabel sizeToFit];
                    } else {
                        weakself.titleLabel.text = @"网络繁忙,请稍后再试";
                        weakself.titleLabel.bw_width = HBScreenWidth * 0.7 - 6 * HBMargin;
                        [weakself.titleLabel sizeToFit];
                    }
                    
                });
            }];
            [csvTask resume];
        });
    }];
    [dnsTask resume];
}

#pragma mark - 中奖公告
- (void)setupWinningAnnouncement
{
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    
   NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] = @"ui_show";
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
//        parameters[@"yc_school_id"] = userMessage.school_id;
//        parameters[@"yc_dept_id"] = userMessage.dept_id;
   }
    parameters[@"action"] = @"win_prize_query";
    
    NSString *xmlString = [parameters newXMLString];
    
    NSMutableURLRequest *dnsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseUrlString]];
    
    [dnsRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    dnsRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    dnsRequest.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak typeof(self) weakself = self;
    
    //拿到dns服务器的请求
    NSURLSessionDataTask *dnsTask = [session dataTaskWithRequest:dnsRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dnsDict = [NSDictionary dictionaryWithXMLData:data];
        
        NSMutableURLRequest *csvRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dnsDict[@"dns.url"]]];
        [csvRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        csvRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
        csvRequest.HTTPMethod = @"POST";
        csvRequest.timeoutInterval = 10;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSURLSessionDataTask *csvTask = [session dataTaskWithRequest:csvRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    return;
                }
                
                NSDictionary *csvDict = [NSDictionary dictionaryWithXMLData:data];
                NSLog(@"%@",csvDict[@"template_data_csv"]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakself setupDatabaseWithCsvDict:csvDict];
                    
                });
            }];
            [csvTask resume];
            weakself.csvTask = csvTask;
        });
    }];
    [dnsTask resume];
    self.dnsTask = dnsTask;
}

//根据请求到的csv地址进行数据处理
- (void)setupDatabaseWithCsvDict:(NSDictionary *)csvDict
{
    NSString *action = @"win_prize_query";
    NSString *action_parameter = @"win_prize_query";
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM csv_path WHERE action='%@' AND action_parameter='%@'", action, action_parameter];
    NSArray *overModelArray = [BWCSVDatabase queryData:selectString];
    NSFileManager *manager = [NSFileManager defaultManager];
    for (BWCSVModel *csvModel in overModelArray) {
        
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *csvPath = [cachePath stringByAppendingPathComponent:csvModel.csvPath];
        [manager removeItemAtPath:csvPath error:nil];
    }
    
    NSString *deleteData = [NSString stringWithFormat:@"DELETE FROM csv_path WHERE action='%@' AND action_parameter='%@'", action, action_parameter];
    [BWCSVDatabase deleteData:deleteData];
    
    NSArray *csvModelArray = [BWCSVDatabase writeCsvWithCsvDict:csvDict action:action action_parameter:action_parameter];
    for (BWCSVModel *csvModel in csvModelArray) {
        
        //插入数据
        [BWCSVDatabase insertModal:csvModel];
        
        if ([csvModel.csvType isEqualToString:DataCsvKey]) {
            
            NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            NSString *csvPath = [cachePath stringByAppendingPathComponent:csvModel.csvPath];
            NSString *dataString = [NSString stringWithContentsOfFile:csvPath encoding:NSUTF8StringEncoding error:nil];
            NSArray *dataArray = [dataString csvStringTransformToDictionary];
            NSMutableArray *modelArray = [NSMutableArray array];
            for (NSDictionary *dataDict in dataArray) {
                BWWinningAnnouncement *model = [BWWinningAnnouncement mj_objectWithKeyValues:dataDict];
                [modelArray addObject:model];
            }
            self.winningArray = modelArray;
            
        }
    }
}

//进行数据获取
- (void)setupData
{
    NSString *action = @"win_prize_query";
    NSString *action_parameter = @"win_prize_query";
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM csv_path WHERE action='%@' AND action_parameter='%@'", action, action_parameter];
    NSArray *csvModelArray = [BWCSVDatabase queryData:selectString];
    if (csvModelArray.count > 0) {
        
        //先将数据显示出来,然后进行判断
        for (BWCSVModel *csvModel in csvModelArray) {
            
            if ([csvModel.csvType isEqualToString:DataCsvKey]) {    //数据csv对应的模型
                NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
                NSString *csvPath = [cachePath stringByAppendingPathComponent:csvModel.csvPath];
                NSString *dataString = [NSString stringWithContentsOfFile:csvPath encoding:NSUTF8StringEncoding error:nil];
                NSArray *dataArray = [dataString csvStringTransformToDictionary];
                NSMutableArray *modelArray = [NSMutableArray array];
                for (NSDictionary *dataDict in dataArray) {
                    BWWinningAnnouncement *model = [BWWinningAnnouncement mj_objectWithKeyValues:dataDict];
                    [modelArray addObject:model];
                }
                self.winningArray = modelArray;
                [self setWinningArray:self.winningArray];
            }
        }
        BWCSVModel *model = csvModelArray.firstObject;
        if ([NSDate isLaterTimeThanNowWithDateString:model.overdueTime]) {    //未超时,直接赋值
            
        } else {    //超过存储时间,进行请求
            [self setupWinningAnnouncement];
        }
        
    } else {
        [self setupWinningAnnouncement];
    }
}

//处理拿到的中奖公告数据
- (void)setWinningArray:(NSArray *)winningArray
{
    _winningArray = winningArray;
    
    for (UILabel *label in self.labelArray) {
        [label removeFromSuperview];
    }
    self.labelArray = nil;
    
    NSMutableArray *labelArray = [NSMutableArray array];
    CGFloat labelX = 5;
    CGFloat labelY = 7;
    for (int i = 0; i < winningArray.count; i ++) {
        
        BWWinningAnnouncement *model = winningArray[i];
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 1;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        label.text = model.show_text;
        label.bw_x = labelX;
        label.bw_y = labelY;
        [label sizeToFit];
        labelX += label.bw_width + 2 * HBMargin;
        [self.contentScroll addSubview:label];
        if (i == (winningArray.count - 1)) {
            
            self.contentScroll.contentSize = CGSizeMake(CGRectGetMaxX(label.frame), 0);
        }
        [labelArray addObject:label];
    }
    self.labelArray = labelArray;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollLabel) userInfo:nil repeats:YES];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

static CGFloat offsetX = 0;

- (void)scrollLabel
{
    offsetX ++;
    if (offsetX > self.contentScroll.contentSize.width + 2 * HBMargin) {
        offsetX = -HBScreenWidth;
        [self.contentScroll setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    } else {
        [self.contentScroll setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
}


@end
