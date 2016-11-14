//
//  SearchTableViewCell.h
//  Petrel
//
//  Created by 李明丹 on 16/1/17.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDProgressView.h"
#import "SDDemoItemView.h"
#import "userBookModel.h"
@interface SearchTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *classImageView;
@property (nonatomic,strong)UILabel *classNameLabel;
@property (nonatomic,strong)UILabel *classNumberLabel;
@property (nonatomic,strong)UILabel *shangxiaLabel;
@property (nonatomic,strong)UIButton *downButton;
//@property (nonatomic,strong)UIImageView *classImageView;
@property (nonatomic,strong)UILabel *finshImageView;

@property (nonatomic,strong)SDDemoItemView *demoView;

@property (nonatomic,strong)userBookModel *model;
@end
