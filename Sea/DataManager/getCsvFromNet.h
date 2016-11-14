//
//  getCsvFromNet.h
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/1/19.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>
//协议方法
@protocol getCsvFromNetDelegate <NSObject>

//可以选择的
@optional

-(void)passdataModelArray:(NSMutableArray *)modelArray;

@end
@interface getCsvFromNet : NSObject

//单例初始化方法
+ (instancetype)shareManager;

- (void)searchDataFromNetDelegateAction:(id<getCsvFromNetDelegate>)delegate csvUrl:(NSString *)csvUrl;

//协议传值
@property(nonatomic ,retain)id <getCsvFromNetDelegate>delegate;

@end
