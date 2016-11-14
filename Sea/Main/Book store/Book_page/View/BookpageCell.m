//
//  BookpageCell.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/5/19.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "BookpageCell.h"
#import "UIImageView+WebCache.h"
@interface BookpageCell ()

@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *payLabel;
@property (strong, nonatomic) IBOutlet UILabel *payMoneyLable;

@end
@implementation BookpageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMicoCellDataModel:(dataModel *)model
{
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"bookshop_1_icon"]];
    self.titleLabel.text=model.book_name;
    self.detailLabel.text=model.book_desc;
    self.payMoneyLable.text=[NSString stringWithFormat:@"可抵扣金额%@元",model.discount_price];
    self.payLabel.text=[NSString stringWithFormat:@"¥%@",model.book_prices];

}

@end
