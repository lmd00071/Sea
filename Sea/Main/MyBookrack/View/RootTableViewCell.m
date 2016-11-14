//
//  RootTableViewCell.m
//  ioshuanwu
//
//  Created by 幻音 on 15/12/28.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import "RootTableViewCell.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation RootTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //背景图片
            self.backImage=[[UIImageView alloc]init];
            [self.contentView addSubview:_backImage];
        
        [self.contentView addSubview:self.backView];
        
        //透明度
        self.backView = [[UIView alloc] init];
        self.backView.backgroundColor=[UIColor blackColor];
        self.backView.alpha=0.45;
        [self.contentView addSubview:self.backView];
        
        //播放按键
        self.playButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:self.playButton];
        
        //标题的透明度
        self.titleView = [[UIView alloc] init];
        self.titleView.backgroundColor=[UIColor blackColor];
        self.titleView.alpha=0.51;
        [self.contentView addSubview:self.titleView];
        
        
        //标题
        
        self.title = [[UILabel alloc] init];
        self.title.font = [UIFont systemFontOfSize:16];
        //self.title.text=@"听一听";
        self.title.textColor=[UIColor whiteColor];
        [self.contentView addSubview:self.title];
        
        //各行的颜色
        self.passView = [[UIView alloc] init];
        self.passView.backgroundColor=[UIColor colorWithRed:0.514 green:0.788 blue:0.992 alpha:1];
        [self.contentView addSubview:self.passView];
    }
    
    
    return self;
    
}


//- (void)setButton
//{
//     //[self.playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
//    [self.playButton setImage:[[UIImage imageNamed:@"play2.png" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    self.backImage.image=[UIImage imageNamed:@"英语三下11听力01.jpg"];
//}


- (void)setVideo:(videoModel *)video
{
    [self.playButton setImage:[[UIImage imageNamed:@"play2.png" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.backImage.image=video.lecture_images;
    self.title.text=video.lecture_name;

}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat m=700;
    CGFloat n;
    if ([UIScreen mainScreen].bounds.size.height>m) {
        
        n=[UIScreen mainScreen].bounds.size.height-(20+64);
        
    }else
    {
        
        n=[UIScreen mainScreen].bounds.size.height-(20+44);
    }
    
    self.backImage.frame=CGRectMake(0, 0, kScreenWidth, n/3);
    self.backView.frame=CGRectMake(0, 0, kScreenWidth, n/3);
    self.playButton.frame = CGRectMake(0, 0, 50, 50);
    self.playButton.center = self.backImage.center;
    self.titleView.frame=CGRectMake(0,n/3-n/3/7,kScreenWidth,n/3/7);
    self.title.frame=CGRectMake(5,n/3-n/3/7,kScreenWidth-10,n/3/7);
    self.passView.frame=CGRectMake(0,n/3,kScreenWidth,n/3/7/2);
    
}




- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}



//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end
