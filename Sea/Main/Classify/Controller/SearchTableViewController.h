//
//  SearchTableViewController.h
//  Petrel
//
//  Created by 李明丹 on 16/1/17.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController

//记录数学语文英文
@property (nonatomic,strong)NSMutableArray *classArray;
//记录年级
@property (nonatomic,strong)NSMutableArray *classNumberArray;
//记录上下册
@property (nonatomic,strong)NSMutableArray *shangxiaArray;
//记录上下册
@property (nonatomic,strong)NSMutableArray *versionsArray;

//下载资源存储容器
@property (atomic,strong) NSMutableArray *downNames;

// 当前加载的下载索引
@property (atomic,assign) int currentIndex;
@end
