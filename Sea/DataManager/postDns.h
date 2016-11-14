//
//  postDns.h
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/1/19.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>
//协议方法
@protocol  postDnsDelegate <NSObject>

//可以选择的
@optional
-(void)passDnsUrl:(NSString *)DnsUrl;

@end


@interface postDns : NSObject

//单例初始化方法
+ (instancetype)shareManager;

- (void)searchPostFromDnsDelegateAction:(id<postDnsDelegate>)delegate;

//协议传值
@property(nonatomic ,retain)id <postDnsDelegate>delegate;

@end
