//
//  PHBRankCell.h
//  WidomStudy
//
//  Created by 李明丹 on 16/3/22.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rankModel.h"
@interface PHBRankCell : UITableViewCell
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UILabel *topLabel;
@property (nonatomic,strong)UIImageView *userImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *detailLabel;

@property (nonatomic,strong)rankModel *model;
- (void)setRankModel:(rankModel *)model;
@end
