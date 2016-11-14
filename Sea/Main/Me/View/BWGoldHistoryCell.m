//
//  BWGoldHistoryCell.m
//  WidomStudy
//
//  Created by 李明丹 on 16/4/15.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "BWGoldHistoryCell.h"

#import "BWGoldHistory.h"

#import <UIImageView+WebCache.h>

@interface BWGoldHistoryCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalAndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *getWayLabel;

@end

@implementation BWGoldHistoryCell

- (void)setGoldHistory:(BWGoldHistory *)goldHistory
{
    _goldHistory = goldHistory;
    
    self.totalAndTimeLabel.text = goldHistory.sub_title;
    self.getWayLabel.text = goldHistory.title;
    if (goldHistory.icon.length > 0) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:goldHistory.icon]];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"account_history_gold"];
    }
}

@end
