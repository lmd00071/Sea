//
//  FullViewController.h
//  02-远程视频播放(AVPlayer)
//
//  Created by apple on 15/8/16.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullView.h"
#import "SDProgressView.h"
#import "SDDemoItemView.h"
@class ASIHTTPRequest;
@interface FullViewController : UIViewController{
    ASIHTTPRequest *videoRequest;
    unsigned long long Recordull;
    BOOL isPlay;
}


@property (nonatomic,assign)BOOL swich;

@property(nonatomic,copy)void(^pushAvPlay)(NSString *);
@property (nonatomic,assign)CGFloat progress;
@property (nonatomic,strong)SDDemoItemView *demoView;

//需要下载的video_url
@property (nonatomic,strong)NSString *videoUrl;
@property (nonatomic,strong)NSString *uid;

//用来放MP3传过来的图像
@property (nonatomic,strong)UIImage *mp3image;


@end
