//
//  RootTableViewCell.h
//  ioshuanwu
//
//  Created by 幻音 on 15/12/28.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMGVideoPlayView.h"
#import "videoModel.h"
@interface RootTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel          * title;
@property (nonatomic, strong) FMGVideoPlayView * playerView;

@property (nonatomic, strong) UIView           * backView;
@property (nonatomic, strong) UIView           * titleView;
@property (nonatomic, strong) UIView           * passView;

@property (nonatomic, strong) UIImageView      * backImage;
@property (nonatomic, strong) UIButton         * playButton;

@property (nonatomic, strong) videoModel        * video;
//- (void)setButton;

@end
