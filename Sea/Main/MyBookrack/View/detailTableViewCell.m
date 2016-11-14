//
//  detailTableViewCell.m
//  Petrel
//
//  Created by 李明丹 on 16/1/18.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "detailTableViewCell.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation detailTableViewCell


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
        
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-40, n/12)];
        self.titleLabel.font=[UIFont systemFontOfSize:20];
        self.titleLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        
        
        self.seclectImage=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 15, 15, n/13/2-5)];
        self.seclectImage.image=[UIImage imageNamed:@"海燕平台_03(1).png"];
        [self.contentView addSubview:self.seclectImage];
        
        
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
