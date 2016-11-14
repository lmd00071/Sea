//
//  FullViewController.m
//  02-远程视频播放(AVPlayer)
//
//  Created by apple on 15/8/16.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "FullViewController.h"
#import "DataBase.h"
#import "playVideoModel.h"
#import "ASIHTTPRequest.h"
#import "FMGVideoPlayView.h"
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
@interface FullViewController ()<FMGVideoPlayViewDelegate>

@property (nonatomic, strong) FMGVideoPlayView * fmVideoPlayer; // 播放器
@property (nonatomic,strong)DataBase *dataBase;
@property (nonatomic,strong)NSURL *fileURL;
//判断是否为MP3还是MP4
@property (nonatomic,strong)NSString *mpStr;
@property (nonatomic,strong)UIImageView *mp3ImageView;
//返回按键
@property (nonatomic,strong)UIButton *backButton;
@end

@implementation FullViewController

- (void)loadView
{
    FullView *fullView = [[FullView alloc] init];
    
    
    self.view = fullView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blackColor];
    self.swich=NO;
    
    self.demoView=[SDDemoItemView demoItemViewWithClass:[SDBallProgressView class]];
    self.demoView.frame=CGRectMake(kScreenHeight/2,kScreenWidth/2, 100, 100);
    self.demoView.center=CGPointMake(kScreenHeight/2, kScreenWidth/2);
    [self.view addSubview:self.demoView];
    self.demoView.progressView.progress=0;
    self.progress=0;
    self.demoView.alpha=1;
    
    self.backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame=CGRectMake(5, 5, 50, 50);
    [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    self.backButton.alpha=1;
    
    
    
    [self downVideoFlie];
    
}


- (void)downVideoFlie
{
    
    NSLog(@"%@",NSHomeDirectory());
    
    //处理文件名
    NSRange range1={self.videoUrl.length-4,4};
    NSRange range2={0,self.videoUrl.length-4};
    
    NSString *vedioTou=[self.videoUrl substringWithRange:range2];
    NSString *vedioWei=[self.videoUrl substringWithRange:range1];
    
    //赋值给判断
    self.mpStr=vedioWei;
    
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld%@",(unsigned long)[vedioTou hash],vedioWei]]]) {

            
                // 模拟下载进度
        [NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(progressAction) userInfo:self repeats:YES];
            self.progress=0;
           videoRequest = nil;
       
        

    }else{
        
           
            ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:self.videoUrl]];
            //下载完存储目录
            [request setDownloadDestinationPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld%@",(unsigned long)[vedioTou hash],vedioWei]]];
            //临时存储目录
            [request setTemporaryFileDownloadPath:[webPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld%@",(unsigned long)[vedioTou hash],vedioWei]]];
            [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    Recordull += size;//Recordull全局变量，记录已下载的文件的大小
                    self.demoView.progressView.progress =1.0*Recordull/total;
                    
                    if (Recordull/total ==1) {
                        isPlay = !isPlay;
                        self.backButton.alpha=0;
                        [self videoFinished];
                        
                    }
                });
            }];
            //断点续载
            [request setAllowResumeForFileDownloads:YES];
            [request startAsynchronous];
            videoRequest = request;
        
    }
}



//下载完成
- (void)videoFinished{
    if (videoRequest) {
        isPlay = !isPlay;
        [videoRequest clearDelegatesAndCancel];
        
        if ([self.mpStr isEqualToString:@".mp3"]) {
            
            self.mp3ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight)];
            self.mp3ImageView.image=self.mp3image;
            [self.view addSubview:self.mp3ImageView];
        }
        //self.pushAvPlay(self.mpStr);
        [self palyVideo];
        self.demoView.progressView.progress=0;
        videoRequest = nil;
    }
}


- (void)progressAction
{
    
    if (self.progress < 1.0){
        //self.demoView.alpha=1;
        self.progress += 0.01;
        
        // 循环
        if (self.progress >= 1.0){
            //self.progress = 0;
            self.demoView.alpha=0;
            self.backButton.alpha=0;
            self.swich=YES;
            
            if ([self.mpStr isEqualToString:@".mp3"]) {
                
                self.mp3ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
                self.mp3ImageView.image=self.mp3image;
                [self.view addSubview:self.mp3ImageView];
            }
            [self palyVideo];
            
            self.demoView.progressView.progress=0;
            return;
        }
        
       
        self.demoView.progressView.progress = self.progress;
        
    }
}


- (void)palyVideo
{
    self.fmVideoPlayer = [FMGVideoPlayView videoPlayView];// 创建播放器
    self.fmVideoPlayer.delegate = self;
    [self.fmVideoPlayer setUrlModel:self.videoUrl];
    
     self.fmVideoPlayer.backgroundColor=[UIColor clearColor];
    self.fmVideoPlayer.center = self.view.center;
    
    [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.fmVideoPlayer.frame = self.view.bounds;
        
        
    } completion:nil];
    
    
    [self.view addSubview:self.fmVideoPlayer];
    
    self.fmVideoPlayer.contrainerViewController = self;
    [self.fmVideoPlayer.player play];
    [self.fmVideoPlayer showToolView:NO];
    self.fmVideoPlayer.playOrPauseBtn.selected = YES;
    self.fmVideoPlayer.hidden = NO;



}

//退出全屏
- (void)videoplayViewSwitchOrientation:(BOOL)isFull{
    
    [self.fmVideoPlayer.player pause];
    
    self.fmVideoPlayer.hidden = YES;
    [self.fmVideoPlayer removeFromSuperview];
    //self.pushAvPlay(nil);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


//点击button
- (void)backAction:(UIButton *)senfer
{
    [videoRequest clearDelegatesAndCancel];
    videoRequest = nil;
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


//支持横屏
- (BOOL)shouldAutorotate
{
    return YES;
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return YES;
//}

@end
