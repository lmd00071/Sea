//
//  loginManager.h
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/1/18.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "loginOrReginModel.h"
//协议方法
@protocol loginManagerDelegate <NSObject>

//可以选择的
@optional

-(void)passdataLoginModel:(loginOrReginModel *)model;
-(void)passdataSendCodeModel:(loginOrReginModel *)model;
-(void)passdataReginModel:(loginOrReginModel *)model;

@end
@interface loginManager : NSObject


//单例初始化方法
+ (instancetype)shareManager;

- (void)searchFromNetDelegateAction:(id<loginManagerDelegate>)delegate way:(NSInteger)way user:(NSString *)user passWord:(NSString *)passWord verificationCode:(NSString *)verificationCode;

//协议传值
@property(nonatomic ,retain)id <loginManagerDelegate>delegate;

@end
