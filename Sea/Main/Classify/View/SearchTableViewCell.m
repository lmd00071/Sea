//
//  SearchTableViewCell.m
//  Petrel
//
//  Created by 李明丹 on 16/1/17.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "UIImageView+WebCache.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation SearchTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        CGFloat m=700;
        CGFloat n;
        if ([UIScreen mainScreen].bounds.size.height>m) {
            
            n=[UIScreen mainScreen].bounds.size.height-(20+64);
            
        }else
        {
            
            n=[UIScreen mainScreen].bounds.size.height-(20+44);
        }
        
        
        self.classImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH/5, n/5-20)];
        //self.classImageView.backgroundColor=[UIColor redColor];
        //测试
        //self.classImageView.image=[UIImage imageNamed:@"海燕平台_12.png"];
        [self.contentView addSubview:self.classImageView];
        
        self.classNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5+30, SCREEN_WIDTH*0.08, SCREEN_WIDTH-SCREEN_WIDTH/5+30, SCREEN_WIDTH*0.08)];
        self.classNameLabel.textColor=[UIColor blackColor];
        
        [self.contentView addSubview:self.classNameLabel];
        
        self.classNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5+30, SCREEN_WIDTH*0.08*2+5, SCREEN_WIDTH/5, SCREEN_WIDTH*0.08)];
        self.classNumberLabel.textColor=[UIColor lightGrayColor];
        
        [self.contentView addSubview:self.classNumberLabel];
        
        self.shangxiaLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5*2+30, SCREEN_WIDTH*0.08*2+5, SCREEN_WIDTH/5, SCREEN_WIDTH*0.08)];
        self.shangxiaLabel.textColor=[UIColor lightGrayColor];
        
        [self.contentView addSubview:self.shangxiaLabel];

        
        //下载
        self.downButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.downButton.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.12, SCREEN_WIDTH*0.12);
        self.downButton.center=CGPointMake(SCREEN_WIDTH-SCREEN_WIDTH*0.10, n/5/2);
        self.downButton.backgroundColor=[UIColor clearColor];
        [self.downButton setImage:[[UIImage imageNamed:@"海燕平台_08.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        //self.downButton.hidden=NO;
        [self.contentView addSubview:self.downButton];

        
        self.demoView=[SDDemoItemView demoItemViewWithClass:[SDBallProgressView class]];
        self.demoView.frame=CGRectMake(0,0, SCREEN_WIDTH*0.133, SCREEN_WIDTH*0.133);
        //self.demoView.alpha=0;
        //self.demoView.hidden=YES;
        self.demoView.center=CGPointMake(SCREEN_WIDTH-SCREEN_WIDTH*0.10, n/5/2);
        self.demoView.userInteractionEnabled=NO;
        [self.contentView addSubview:self.demoView];
        
        self.finshImageView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH*0.133, SCREEN_WIDTH*0.133)];
        self.finshImageView.center=CGPointMake(SCREEN_WIDTH-SCREEN_WIDTH*0.10, n/5/2);
//        self.finshImageView.text=@"已完成";
       
        self.finshImageView.textColor=[UIColor blackColor];
        //self.finshImageView.hidden=YES;
        self.finshImageView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.finshImageView];
        
    
        //判断当屏幕的高度是6P的时候
        CGFloat number6p=736;
        CGFloat number6=667;
        CGFloat number5=568;
        CGFloat number4=480;
        if ([UIScreen mainScreen].bounds.size.height==number6p) {
            
            self.classNameLabel.font=[UIFont systemFontOfSize:22];
            self.classNumberLabel.font=[UIFont systemFontOfSize:22];
            self.shangxiaLabel.font=[UIFont systemFontOfSize:22];
            self.finshImageView.font=[UIFont systemFontOfSize:17];
            
            
        }
        if ([UIScreen mainScreen].bounds.size.height==number6) {
            
            self.classNameLabel.font=[UIFont systemFontOfSize:20];
            self.classNumberLabel.font=[UIFont systemFontOfSize:20];
             self.shangxiaLabel.font=[UIFont systemFontOfSize:20];
             self.finshImageView.font=[UIFont systemFontOfSize:15];
        }
        if ([UIScreen mainScreen].bounds.size.height==number5) {
            
            self.classNameLabel.font=[UIFont systemFontOfSize:18];
            self.classNumberLabel.font=[UIFont systemFontOfSize:18];
            self.shangxiaLabel.font=[UIFont systemFontOfSize:18];
            self.finshImageView.font=[UIFont systemFontOfSize:13];
            
            
        }
        if ([UIScreen mainScreen].bounds.size.height==number4) {
            
            self.classNameLabel.font=[UIFont systemFontOfSize:16];
            self.classNumberLabel.font=[UIFont systemFontOfSize:16];
            self.shangxiaLabel.font=[UIFont systemFontOfSize:16];
            self.finshImageView.font=[UIFont systemFontOfSize:11];
            
            
        }
        
        
    }

    return self;

}


- (void)setModel:(userBookModel *)model
{
    
    [self.classImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        model.iconImage=self.classImageView.image;
    }];
    self.classNameLabel.text=model.textbook_name;
    
    NSInteger n=[model.grade_order_no integerValue];
    switch (n) {
        case 1:
            self.classNumberLabel.text=@"一年级";
            break;
        case 2:
            self.classNumberLabel.text=@"二年级";
            break;
        case 3:
            self.classNumberLabel.text=@"三年级";
            break;
        case 4:
            self.classNumberLabel.text=@"四年级";
            break;
        case 5:
            self.classNumberLabel.text=@"五年级";
            break;
        case 6:
            self.classNumberLabel.text=@"六年级";
            break;
        default:
            break;
    }
    
    NSInteger m=[model.grade_half_order_no integerValue];
    switch (m) {
        case 1:
            self.shangxiaLabel.text=@"上册";
            break;
        case 2:
            self.shangxiaLabel.text=@"下册";
            break;
        default:
            break;
    }



}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
