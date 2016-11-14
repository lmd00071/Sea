//
//  PHBRankCell.m
//  WidomStudy
//
//  Created by 李明丹 on 16/3/22.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "PHBRankCell.h"
#import "UIImageView+WebCache.h"
@interface PHBRankCell ()

@property (nonatomic,assign)CGFloat height;
@end
@implementation PHBRankCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.topView=[[UIView alloc]init];
        self.topView.backgroundColor=HBRGBColor(253, 251, 219,1);
        [self.contentView addSubview:self.topView];
    
        self.topLabel=[[UILabel alloc]init];
        self.topLabel.textColor=[UIColor blackColor];
        self.topLabel.font=[UIFont boldSystemFontOfSize:16];
        self.topLabel.textAlignment=NSTextAlignmentCenter;
        [self.topView addSubview:self.topLabel];
        
        self.userImageView=[[UIImageView alloc]init];
        self.userImageView.layer.cornerRadius=(HBScreenWidth/11.0*3.0)/2;
        self.userImageView.layer.borderWidth=2;
        self.userImageView.layer.borderColor=[HBRGBColor(244, 246, 141,1) CGColor];
        self.userImageView.clipsToBounds=YES;
        [self.topView addSubview:self.userImageView];
        

        self.nameLabel=[[UILabel alloc]init];
        self.nameLabel.textColor=[UIColor blackColor];
        self.nameLabel.font=[UIFont systemFontOfSize:16];
        [self.topView addSubview:self.nameLabel];
        
        
        self.detailLabel=[[UILabel alloc]init];
        self.detailLabel.textColor=[UIColor blackColor];
        self.detailLabel.font=[UIFont systemFontOfSize:14];
        self.detailLabel.numberOfLines=0;
        [self.topView addSubview:self.detailLabel];
        
        
    }
    
    return self;
    
}

- (void)setRankModel:(rankModel *)model
{
    self.model=model;
    self.topLabel.text=model.user_rank;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.user_icon] placeholderImage:[UIImage imageNamed:@"setting_default_head"]];
    self.nameLabel.text=model.user_name;
    self.detailLabel.text=model.total_yp;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width=self.contentView.frame.size.width;
    CGFloat height=self.contentView.frame.size.height;
    self.topView.frame=CGRectMake(0, 0, width,height-1);
    self.topLabel.frame=CGRectMake(5, (height-20)/2,30,20);
    self.userImageView.frame=CGRectMake(40, (height-70)/2, 70,70);
    self.userImageView.layer.cornerRadius=35;
    self.nameLabel.frame=CGRectMake(120, 20, (width-130),20);
    self.detailLabel.frame=CGRectMake(120, 50, (width-130),height-60-10);

}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    
//    NSString *str1=@"var div = document.createElement('div');"
//                    "margin-top:'2px'"
//                    "margin-left:'2px"
//                    "margin-right:'2px"
//                    "margin-down:'2px";
//    [webView stringByEvaluatingJavaScriptFromString:str1];
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '350%'"];
//    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background= 'gray'"];
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background = 'rgb(253, 251, 219)'"];
//    
//}
@end
