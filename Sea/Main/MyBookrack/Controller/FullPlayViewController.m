//
//  FullPlayViewController.m
//  WidomStudy
//
//  Created by 李明丹 on 16/4/25.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "FullPlayViewController.h"
#define NavBarFgColor [UIColor whiteColor]
#define NavTextAttribute @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}
@interface FullPlayViewController (){
    WMPlayer *wmPlayer;
    CGRect playerFrame;
    BOOL fullSwich;
}

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)NSInteger watchSecond;
@end

@implementation FullPlayViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{

//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        fullSwich=YES;
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    
    [wmPlayer.palyImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.view.frame.size.width);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.view.frame.size.height);
    }];
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.view.frame.size.width-40);
        make.width.mas_equalTo(self.view.frame.size.height);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-self.view.frame.size.height/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    wmPlayer.isFullscreen = YES;
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}
-(void)toNormal{
    [wmPlayer removeFromSuperview];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        fullSwich=NO;
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        wmPlayer.center=CGPointMake(HBScreenWidth/2.0, HBScreenHeight/2.0);
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [self.view addSubview:wmPlayer];
        
//        [wmPlayer.palyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(wmPlayer).with.offset(0);
//            make.right.equalTo(wmPlayer).with.offset(0);
//            make.top.equalTo(wmPlayer).with.offset(35);
//            make.bottom.equalTo(wmPlayer).with.offset(-35);
//            
//        }];
        [wmPlayer.palyImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(playerFrame.size.height-75);
            make.bottom.equalTo(wmPlayer).with.offset(-35);
        }];
        
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
        
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
        
    }];
}
-(void)fullScreenBtnClick:(NSNotification *)notice{
//    UIButton *fullScreenBtn = (UIButton *)[notice object];
//    if (fullScreenBtn.isSelected) {//全屏显示
//        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
//    }else{
//        [self toNormal];
//    }
    
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [SVProgressHUD dismiss];
    [self.timer setFireDate:[NSDate distantFuture]];
    self.watchBlock(self.watchSecond,self.lesson_uid);
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (wmPlayer==nil||wmPlayer.superview==nil){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (wmPlayer.isFullscreen) {
                [self toNormal];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HBRGBColor(235, 235, 235, 1);
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"播放视频";
    self.navigationController.navigationBar.barTintColor=HBRGBColor(27, 169, 240, 1);
    self.navigationController.navigationBar.tintColor=NavBarFgColor;
    self.navigationController.navigationBar.titleTextAttributes=NavTextAttribute;
    //设置成导航栏下面开始计算
   // self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bookshop_1_back1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoPlay) name:@"videoPlay" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoPause) name:@"videoPause" object:nil];
    playerFrame = CGRectMake(0, 84, HBScreenWidth, (HBScreenWidth)*3/4);
    wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:self.URLString image:self.mp3image];
    wmPlayer.center=CGPointMake(HBScreenWidth/2.0, HBScreenHeight/2.0);
    wmPlayer.closeBtn.hidden = YES;
    [self.view addSubview:wmPlayer];
    [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    [wmPlayer.player play];
   
    self.watchSecond=0;
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(watchTime) userInfo:nil repeats:YES];
    
}

//观看时长timer
-(void)watchTime{

    self.watchSecond++;
}

//视频播放通知
-(void)videoPlay{
    
    self.timer.fireDate=[NSDate date];
}

//视频停止通知
-(void)videoPause{
    
    self.timer.fireDate=[NSDate distantFuture];
}

- (void)leftAction:(UIButton *)sender
{
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)releaseWMPlayer{
    [wmPlayer.player.currentItem cancelPendingSeeks];
    [wmPlayer.player.currentItem.asset cancelLoading];
    
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer = nil;
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
}

-(void)dealloc{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   // NSLog(@"player deallco");
}

- (BOOL)prefersStatusBarHidden
{
    if (fullSwich) {
        return YES;
    }
    return NO;//隐藏为YES，显示为NO

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
