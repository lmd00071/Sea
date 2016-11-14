//
//  AvPalyTableViewController.h
//  avPlayModel
//
//  Created by 李明丹 on 16/1/14.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvPalyTableViewController : UITableViewController
//记录过来的是几课
@property (nonatomic,strong)NSString *lectutNumber;
//记录是几单元
@property (nonatomic,strong)NSString *suitNumber;

@property (nonatomic,strong)NSString *uid;
//标题
@property (nonatomic,strong)NSString *titleLesson;

@end
