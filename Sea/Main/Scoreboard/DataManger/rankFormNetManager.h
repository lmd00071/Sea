//
//  rankFormNetManager.h
//  WidomStudy
//
//  Created by 李明丹 on 16/3/22.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RankUserModel.h"
//协议方法
@protocol  rankFormNetManagerDelegate <NSObject>

//可以选择的
@optional
-(void)passPostResultTopModelArray:(NSMutableArray *)ModelArray attModel:(RankUserModel *)attModel;

@end
@interface rankFormNetManager : NSObject
////单例初始化方法
+ (instancetype)shareManager;
- (void)viewDisMiss;

- (void)makeCSVDelegateAction:(id<rankFormNetManagerDelegate>)delegate;

//协议传值
@property(nonatomic ,retain)id <rankFormNetManagerDelegate>delegate;
@end
