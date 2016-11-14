//
//  StartFormNet.h
//  WidomStudy
//
//  Created by 李明丹 on 16/3/15.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "searchCsvModel.h"
//协议方法
@protocol  StartFormNetDelegate <NSObject>

//可以选择的
@optional
//-(void)passStartModel:(StratScore *)model startQuArr:(NSArray *)startArr imagerArray:(NSMutableArray *)imageArray;
-(void)passProgaessDataMore:(float)progaess cellNumber:(NSInteger)cellNumber;

- (void)passFinshCelllNumber:(NSInteger)cellNumber;

-(void)passErrpr;
@end
@interface StartFormNet : NSObject
//单例初始化方法
//+ (instancetype)shareManager;

- (void)viewDisMiss;

- (void)searchFromNetDelegateAction:(id<StartFormNetDelegate>)delegate DnsUrl:(NSString *)dnsUrl action_parameter:(NSString *)action_parameter cellNumber:(NSInteger)cellNumber;
//协议传值
@property(nonatomic ,retain)id <StartFormNetDelegate>delegate;
@end
