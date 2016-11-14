//
//  AvPalyTableViewController.m
//  avPlayModel
//
//  Created by 李明丹 on 16/1/14.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "AvPalyTableViewController.h"
#import "FullViewController.h"
#import "FMGVideoPlayView.h"
#import "RootTableViewCell.h"
#import "SDProgressView.h"
#import "SDDemoItemView.h"
#import "DataBase.h"
#import "playVideoModel.h"
#import "Reachability.h"
#import "NewLoginViewController.h"
#import "FullPlayViewController.h"
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
#define NavBarFgColor [UIColor whiteColor]
#define NavTextAttribute @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}
@interface AvPalyTableViewController ()<FMGVideoPlayViewDelegate>

@property (nonatomic, strong) FMGVideoPlayView * fmVideoPlayer; // 播放器
/* 全屏控制器 */
//@property (nonatomic, strong) FullViewController *fullVc;

@property (nonatomic,strong)DataBase *dataBase;
//所有的video
@property (nonatomic,strong)NSMutableArray *videoArray;
//本课的video
@property (nonatomic,strong)NSMutableArray *videoLessonArray;
//记录书本之前的数量
@property (nonatomic,assign)NSInteger bookNumber;

//设置定时器
@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)NSInteger watchSecond;

@end

@implementation AvPalyTableViewController


//懒加载
- (NSMutableArray *)videoArray
{
    if (!_videoArray) {
        self.videoArray=[NSMutableArray array];
    }
    
    return _videoArray;
}

//懒加载
- (NSMutableArray *)videoLessonArray
{
    if (!_videoLessonArray) {
        self.videoLessonArray=[NSMutableArray array];
    }
    
    return _videoLessonArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    self.bookNumber=0;
    self.dataBase=[[DataBase alloc]init];
    [self.dataBase creatVideoDataBaseUidName:self.uid];
    self.videoArray=[self.dataBase allVideoUidName:self.uid];
    
    NSMutableArray *videoArr=[NSMutableArray array];
    for (videoModel *model in self.videoArray) {
    
        if ([model.lesson_no isEqualToString:self.lectutNumber]&&[model.suit_no isEqualToString:self.suitNumber]) {
            
            [videoArr addObject:model];
            [self.videoLessonArray addObject:model];
            
        }
        
        if ([model.lesson_no isEqualToString:self.lectutNumber]&&([model.suit_no integerValue]<[self.suitNumber integerValue])) {
            
            self.bookNumber++;
            
        }
        if ([model.lesson_no integerValue]<[self.lectutNumber integerValue]) {
            
            self.bookNumber++;
            
        }
        
        
    }
    
    for (int i=0; i< videoArr.count; i++) {
        
        videoModel *modelj1=[[videoModel alloc]init];
        modelj1=videoArr[i];
        if (i==videoArr.count-1) {
            
        }else{
        for (int j=i+1; j< videoArr.count; j++) {
            
            videoModel *modelj2=[[videoModel alloc]init];
            modelj2=videoArr[j];
            
            if ([modelj1.lecture_name isEqualToString:modelj2.lecture_name]&&[modelj1.lecture_image isEqualToString:modelj2.lecture_image]&&[modelj1.video_url isEqualToString:modelj2.video_url]) {
               
                [self.videoLessonArray removeObject:modelj2];
                
            }
        }
        }
    }
    
    
    if (self.videoLessonArray.count>2) {
        for (int i=0; i<self.videoLessonArray.count-1; i++) {
            for (int j=0; j<self.videoLessonArray.count-1-i; j++) {
                
                videoModel *modelj1=[[videoModel alloc]init];
                videoModel *modelj2=[[videoModel alloc]init];
                videoModel *modeljtem=[[videoModel alloc]init];
                modelj1=self.videoLessonArray[j];
                modelj2=self.videoLessonArray[j+1];
                NSInteger j1=[modelj1.lecture_no integerValue];
                NSInteger j2=[modelj2.lecture_no integerValue];
                if (j1>j2) {
                    modeljtem = self.videoLessonArray[j];
                    self.videoLessonArray[j] = self.videoLessonArray[j+1];
                    self.videoLessonArray[j+1] = modeljtem;
                }
            }
        }
    }
    
    //[self.tableView registerClass:[RootTableViewCell class] forCellReuseIdentifier:@"avcell"];
    //设置导航栏
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = self.titleLesson;;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    self.navigationController.navigationBar.tintColor=NavBarFgColor;
    self.navigationController.navigationBar.titleTextAttributes=NavTextAttribute;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.113 green:0.588 blue:0.925 alpha:1];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    
    //设置成导航栏下面开始计算
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden = NO;
    // 删除多余的cell
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.tableView.backgroundColor=[UIColor colorWithRed:0.784 green:0.910 blue:1 alpha:1];
    [self.tableView registerClass:[RootTableViewCell class] forCellReuseIdentifier:@"avcell"];
   
    
}

//上报视频观看时间
- (void)effectiveWctchTimePostUid:(NSString *)lessonUid play_seconds:(NSInteger)play_seconds
{
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] = @"hyan_tmat_lecture_play_report";
    parameters[@"from_system"] = FromSystem;
    //拿到当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    parameters[@"from_client_version"] = version;
    //拿到手机的MAC地址
    parameters[@"from_client_id"] = AppUUID;
    parameters[@"yc_user_role"] = UserRole;
    parameters[@"yc_user_account_uid"] = userMessage.user_account_uid;
    
    parameters[@"lecture_uid"] = lessonUid;
    parameters[@"play_seconds"] = [NSString stringWithFormat:@"%zd",play_seconds];
    
    NSString *xmlString = [parameters newXMLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseUrlString]];
    
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak typeof(self) weakself = self;
    NSURLSessionDataTask *csvTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        if (error) {
            return ;
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];
        
        NSMutableURLRequest *dnsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dict[@"dns.url"]]];
        
        [dnsRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        dnsRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
        dnsRequest.HTTPMethod = @"POST";
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:dnsRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                return ;
            }
             NSDictionary *dataDict = [NSDictionary dictionaryWithXMLData:data];
            
            if (dataDict[@"pop_message"]) {
                [SVProgressHUD showSuccessWithStatus:dataDict[@"pop_message"]];
            }
            
        }];
        [dataTask resume];
       
    }];
    [csvTask resume];
    

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.videoLessonArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat m=700;
    CGFloat n;
    if ([UIScreen mainScreen].bounds.size.height>m) {
        
        n=[UIScreen mainScreen].bounds.size.height-(20+64);
        
    }else
    {
        
        n=[UIScreen mainScreen].bounds.size.height-(20+44);
    }
    
    return n/3+n/3/7/2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   //RootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"avcell"];
    RootTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[RootTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"avcell"];
    }
    videoModel *model=[[videoModel alloc]init];
    model=self.videoLessonArray[indexPath.row];
    
    cell.video=model;
    [cell.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.playButton.tag = 100 + indexPath.row;
    //取消点击效果
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

// 点击的Cell控制播放器
- (void)playButtonAction:(UIButton *)sender{
    
    NSInteger number=sender.tag-100;
    //判断是否为游客
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    if (userMessage.user_msisdn.length>0) {
        
    }else{
        if (number+1+self.bookNumber>10) {
            [self pushView];
            return;
        }
        
    }


    videoModel *model=self.videoLessonArray[number];
    
    //判断是否已经下载
    //处理文件名
//    NSRange range1={model.video_url.length-4,4};
//    NSRange range2={0,model.video_url.length-4};
//    
//    NSString *vedioTou=[model.video_url substringWithRange:range2];
//    NSString *vedioWei=[model.video_url substringWithRange:range1];
//    
//    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
//    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    if(![fileManager fileExistsAtPath:cachePath])
//    {
//        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld%@",[vedioTou hash],vedioWei]]]) {
//        
//        FullViewController *fullVc=[[FullViewController alloc]init];
//        fullVc.videoUrl=model.video_url;
//        fullVc.mp3image=model.lecture_images;
//        fullVc.uid=self.uid;
//        fullVc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//        
//        [self presentViewController:fullVc animated:YES completion:nil];
//        
////        #pragma mark--block传值第三步:实现block
////        __block AvPalyTableViewController *mainVC=self;
////        //用__block修饰不会造成内存泄漏
////        
////        fullVc.pushAvPlay=^(NSString *str){
////        
////            [mainVC viewDidLoad];
////            
////        };
//        
//    }else{
    
    
        //判断是否有网络
        BOOL net= [self serachNet];
        
        if (net) {
            
//            FullViewController *fullVc=[[FullViewController alloc]init];
//            fullVc.videoUrl=model.video_url;
//            fullVc.mp3image=model.lecture_images;
//            fullVc.uid=self.uid;
//            fullVc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//            [self presentViewController:fullVc animated:YES completion:nil];
            
        
            FullPlayViewController *fullVc=[[FullPlayViewController alloc]init];
            fullVc.URLString=model.video_url;
            fullVc.mp3image=model.lecture_images;
            fullVc.lesson_uid=model.lecture_uid;
            fullVc.watchBlock=^(NSInteger watchTime,NSString *lecture_uid){
            
                if (watchTime>10) {
                    
                    NSMutableArray *userArray=[NSMutableArray array];
                    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
                    loginOrReginModel *userMessage = userArray.lastObject;
                    
                    if (userMessage.user_msisdn.length>0) {
                        
                        [self effectiveWctchTimePostUid:lecture_uid play_seconds:watchTime];
                    }
                    
                }
            };

            [self.navigationController pushViewController:fullVc animated:YES];

        }else{
        
            [SVProgressHUD showErrorWithStatus:@"无网络可用!"];
        }
    
    //}
    
}



// 根据Cell位置隐藏并暂停播放
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == _fmVideoPlayer.index) {
//        [_fmVideoPlayer.player pause];
//        _fmVideoPlayer.hidden = YES;
//    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [_fmVideoPlayer.player pause];
//    _fmVideoPlayer.hidden = YES;
    RootTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)pushView
{
    UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:@"提示" message:@"注册登录可继续观看，否则仅能观看本书前十题讲解" preferredStyle:UIAlertControllerStyleAlert];
    
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

//判断有没有网络的方法,
- (BOOL)serachNet
{
    Reachability *reachAbility = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NSInteger stateNet = [reachAbility currentReachabilityStatus];
    
    if (stateNet == 0) {

        UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:@"提示" message:@"此视频还没有下载,请先连接网络下载" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alertControll addAction:alertAction];
        
        [self presentViewController:alertControll animated:YES completion:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(time) userInfo:self repeats:NO];
        
        return NO;
    }else{
        return YES;
    }
}


//一秒后自己消失
- (void)time{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma --mark 方法
//点击左侧的按键的方法
- (void)leftBarButtonAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//只支持竖屏
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


@end
