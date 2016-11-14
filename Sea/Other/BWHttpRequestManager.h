//
//  BWHttpRequestManager.h
//  WidomStudy
//
//  Created by 李明丹 on 16/3/4.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BWHttpRequestDataStatus) {
    BWHttpRequestDataStatusNoData,      //没有数据
    BWHttpRequestDataStatusOverdue,     //数据过期
    BWHttpRequestDataStatusNoOverdue    //数据未过期
};

@interface BWHttpRequestManager : NSObject


/**
 判断数据是否过期,过期则网络请求,未过期则直接显示
 
 action:定位页目csv的参数一
 action_parameter:定位页目csv的参数二
 */
- (BWHttpRequestDataStatus)isNeedHttpRequestWithAction:(NSString *)action action_parameter:(NSString *)action_parameter;



/**
 进行数据获取
 
 action:定位页目csv的参数一
 action_parameter:定位页目csv的参数二
 csvKey:每个页目不同csv文件的key
 */
- (NSArray<NSDictionary *> *)httpRequestManagerGetDataWithAction:(NSString *)action action_parameter:(NSString *)action_parameter csvKey:(NSString *)csvKey;



/**
 自定义请求头的网络请求
 
 request:请求体
 dataBlock:网络请求返回数据
 */
- (void)httpRequestManagerWithRequest:(NSMutableURLRequest *)request dataBlock:(void (^)(NSDictionary *))dataBlock;



/**
 无默认参数的网络请求
 
 parameters:参数
 dataBlock:网络请求返回数据
 */
- (void)httpRequestManagerNoParameterWithDictionary:(NSMutableDictionary *)parameters dataBlock:(void (^)(NSDictionary *))dataBlock;



/**
 带参数的网络请求
 
 parameters:进行网络请求的参数
 action:定位页目csv的参数一
 action_parameter:定位页目csv的参数二
 hasParameter:本次请求是否有action_parameter这个参数
 dataBlock:网络请求返回数据
 */
- (void)httpRequestManagerSetupRequestWithParametersDictionary:(NSMutableDictionary *)parameters action:(NSString *)action actionParameter:(NSString *)actionParameter hasParameter:(BOOL)hasParameter dataBlock:(void (^)(NSDictionary *))dataBlock;



/**
 ui_show类型的界面
 
 action:定位页目csv的参数一
 action_parameter:定位页目csv的参数二
 hasParameter:本次请求是否有action_parameter这个参数
 dataBlock:网络请求返回数据
 */
- (void)httpRequestManagerUIShowRequestWithAction:(NSString *)action actionParameter:(NSString *)actionParameter hasParameter:(BOOL)hasParameter dataBlock:(void (^)(NSDictionary *))dataBlock;



/**
 根据请求到的csv地址进行数据处理
 
 csvDict:每个csv文件的url
 action:定位页目csv的参数一
 action_parameter:定位页目csv的参数二
 csvKey:每个页目不同csv文件的key
 */
- (NSArray<NSDictionary *> *)setupDatabaseWithCsvDict:(NSDictionary *)csvDict action:(NSString *)action actionParameter:(NSString *)actionParameter csvKey:(NSString *)csvKey;

@end
