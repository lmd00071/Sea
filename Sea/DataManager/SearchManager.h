//
//  SearchManager.h
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/1/18.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "searchCsvModel.h"
//协议方法
@protocol  SearchManagerDelegate <NSObject>

//可以选择的
@optional
-(void)passCsvData:(searchCsvModel *)scvUrlModel;

@end
@interface SearchManager : NSObject


//单例初始化方法
+ (instancetype)shareManager;

- (void)searchFromNetDelegateAction:(id<SearchManagerDelegate>)delegate DnsUrl:(NSString *)dnsUrl action_parameter:(NSString *)action_parameter;

//协议传值
@property(nonatomic ,retain)id <SearchManagerDelegate>delegate;

@end
