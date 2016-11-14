//
//  MyBookTableViewCell.m
//  book
//
//  Created by 李明丹 on 16/1/13.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "MyBookTableViewCell.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation MyBookTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        
        self.photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_HEIGHT*0.03,(SCREEN_HEIGHT*0.09-SCREEN_HEIGHT*0.06)/2.0, SCREEN_HEIGHT*0.06, SCREEN_HEIGHT*0.06)];
        [self.contentView addSubview:self.photoImageView];
        
        self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_HEIGHT*0.12, (SCREEN_HEIGHT*0.09-SCREEN_HEIGHT*0.045)/2.0, SCREEN_HEIGHT*0.2, SCREEN_HEIGHT*0.045)];
        self.nameLabel.textColor=[UIColor whiteColor];
        //self.nameLabel.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:self.nameLabel];
        
        self.backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_HEIGHT*0.135, (SCREEN_HEIGHT*0.09-SCREEN_HEIGHT*0.037)/2.0,SCREEN_HEIGHT*0.024, SCREEN_HEIGHT*0.037)];
        [self.contentView addSubview:self.backImageView];
        
        
        //判断当屏幕的高度是6P的时候
        CGFloat number6p=736;
        CGFloat number6=667;
        CGFloat number5=568;
        CGFloat number4=480;
        if ([UIScreen mainScreen].bounds.size.height==number6p) {
            
              self.nameLabel.font=[UIFont systemFontOfSize:22];
        }
        if ([UIScreen mainScreen].bounds.size.height==number6) {
            
             self.nameLabel.font=[UIFont systemFontOfSize:20];
            
        }
        if ([UIScreen mainScreen].bounds.size.height==number5) {
            
          
              self.nameLabel.font=[UIFont systemFontOfSize:18];
            
        }
        if ([UIScreen mainScreen].bounds.size.height==number4) {
            
            
             self.nameLabel.font=[UIFont systemFontOfSize:16];
            
        }
        
        
    }

    return self;

}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
