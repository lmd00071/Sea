//
//  BWHttpRequestManager.m
//  WidomStudy
//
//  Created by 李明丹 on 16/3/4.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "BWHttpRequestManager.h"
#import "LoginUserManager.h"
#import "loginOrReginModel.h"
#import <FCUUID/UIDevice+FCUUID.h>

@implementation BWHttpRequestManager

//判断数据是否过期,过期则网络请求,未过期则直接显示
- (BWHttpRequestDataStatus)isNeedHttpRequestWithAction:(NSString *)action action_parameter:(NSString *)action_parameter
{
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM csv_path WHERE action='%@' AND action_parameter='%@'", action, action_parameter];
    NSArray *csvModelArray = [BWCSVDatabase queryData:selectString];
    
    if (csvModelArray.count > 0) {
        BWCSVModel *model = csvModelArray.firstObject;
        if ([NSDate isLaterTimeThanNowWithDateString:model.overdueTime]) {    //未超时,直接赋值
            return BWHttpRequestDataStatusNoOverdue;
        } else {    //超过存储时间,进行请求
            return BWHttpRequestDataStatusOverdue;
        }
    } else {    //没有数据
        return BWHttpRequestDataStatusNoData;
    }
}

//进行数据获取
- (NSArray<NSDictionary *> *)httpRequestManagerGetDataWithAction:(NSString *)action action_parameter:(NSString *)action_parameter csvKey:(NSString *)csvKey
{
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM csv_path WHERE action='%@' AND action_parameter='%@'", action, action_parameter];
    NSArray *csvModelArray = [BWCSVDatabase queryData:selectString];
    
    NSArray *dataArray;
    for (BWCSVModel *csvModel in csvModelArray) {
        
        if ([csvModel.csvType isEqualToString:csvKey]) {    //数据csv对应的模型
            NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            NSString *csvPath = [cachePath stringByAppendingPathComponent:csvModel.csvPath];
            NSString *dataString = [NSString stringWithContentsOfFile:csvPath encoding:NSUTF8StringEncoding error:nil];
            dataArray = [dataString csvStringTransformToDictionary];
        }
    }
    return dataArray;
}

//自定义请求头的网络请求
- (void)httpRequestManagerWithRequest:(NSMutableURLRequest *)request dataBlock:(void (^)(NSDictionary *))dataBlock
{
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"正在请求数据中..."];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    //拿到dns服务器的请求
    NSURLSessionDataTask *dnsTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
            return;
        }
        NSDictionary *dnsDict = [NSDictionary dictionaryWithXMLData:data];
        
        request.URL = [NSURL URLWithString:dnsDict[@"dns.url"]];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            //拿到csv文件url的请求
            NSURLSessionDataTask *csvTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                        return;
                    });
                }
                
                NSDictionary *csvDict = [NSDictionary dictionaryWithXMLData:data];
                
                if (csvDict[@"yc_redirect_request_to"]) {   //需要获取学校地址
                    
                    request.URL = [NSURL URLWithString:csvDict[@"yc_redirect_request_to"]];
                    
                    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                                return;
                            });
                        }
                        NSDictionary *dataDict = [NSDictionary dictionaryWithXMLData:data];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (dataDict) {
                                dataBlock(dataDict);
                                
                            } else {
                                [SVProgressHUD showErrorWithStatus:@"拉取数据失败"];
                            }
                        });
                    }];
                    [dataTask resume];
                    
                } else {    //无需获取学校地址
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (csvDict) {
                            
                            dataBlock(csvDict);
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"拉取数据失败"];
                        }
                    });
                }
            }];
            [csvTask resume];
        });
    }];
    [dnsTask resume];
}

//无默认参数的网络请求
- (void)httpRequestManagerNoParameterWithDictionary:(NSMutableDictionary *)parameters dataBlock:(void (^)(NSDictionary *))dataBlock
{
    NSString *xmlString = [parameters newXMLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseUrlString]];
    
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    [self httpRequestManagerWithRequest:request dataBlock:dataBlock];
}

//带默认参数的网络请求
- (void)httpRequestManagerSetupRequestWithParametersDictionary:(NSMutableDictionary *)parameters action:(NSString *)action actionParameter:(NSString *)actionParameter hasParameter:(BOOL)hasParameter dataBlock:(void (^)(NSDictionary *))dataBlock
{
    //拿到当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    parameters[@"from_client_version"] = version;
    //拿到手机的MAC地址
    parameters[@"from_client_id"] = AppUUID;
    
    //来自版本名
    parameters[@"yc_user_role"] = @"parent";
    
    //拿到用户信息
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    if (userArray.count > 0) {
         loginOrReginModel *userMessage = userArray.lastObject;
        if (userMessage.user_account_uid.length > 0) {
            parameters[@"yc_user_account_uid"] = userMessage.user_account_uid;
            parameters[@"user_msisdn"] = userMessage.user_msisdn;
        }
    }
    
    //确定页目内容的两个参数
    if (action.length > 0 || actionParameter.length > 0) {
        parameters[@"action"] = action;
        if (hasParameter) {
            parameters[@"action_parameter"] = actionParameter;
        }
    }
    
    [self httpRequestManagerNoParameterWithDictionary:parameters dataBlock:dataBlock];
}

//ui_show类型的界面
- (void)httpRequestManagerUIShowRequestWithAction:(NSString *)action actionParameter:(NSString *)actionParameter hasParameter:(BOOL)hasParameter dataBlock:(void (^)(NSDictionary *))dataBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"trans_code"] = @"ui_show";
    [self httpRequestManagerSetupRequestWithParametersDictionary:dict action:action actionParameter:actionParameter hasParameter:hasParameter dataBlock:dataBlock];
}

//根据请求到的csv地址进行数据处理
- (NSArray<NSDictionary *> *)setupDatabaseWithCsvDict:(NSDictionary *)csvDict action:(NSString *)action actionParameter:(NSString *)actionParameter csvKey:(NSString *)csvKey
{
    //删除之前的csv文件
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM csv_path WHERE action='%@' AND action_parameter='%@'", action, actionParameter];
    NSArray *overModelArray = [BWCSVDatabase queryData:selectString];
    NSFileManager *manager = [NSFileManager defaultManager];
    for (BWCSVModel *csvModel in overModelArray) {
        
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *csvPath = [cachePath stringByAppendingPathComponent:csvModel.csvPath];
        [manager removeItemAtPath:csvPath error:nil];
    }
    
    NSString *deleteData = [NSString stringWithFormat:@"DELETE FROM csv_path WHERE action='%@' AND action_parameter='%@'", action, actionParameter];
    [BWCSVDatabase deleteData:deleteData];
    
    //将新数据写入沙盒
    NSArray *csvModelArray = [BWCSVDatabase writeCsvWithCsvDict:csvDict action:action action_parameter:actionParameter];
    NSArray *dataArray;
    for (BWCSVModel *csvModel in csvModelArray) {
        
        //插入数据
        [BWCSVDatabase insertModal:csvModel];
        
        if ([csvModel.csvType isEqualToString:DataCsvKey]) {
            
            NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            NSString *csvPath = [cachePath stringByAppendingPathComponent:csvModel.csvPath];
            NSString *dataString = [NSString stringWithContentsOfFile:csvPath encoding:NSUTF8StringEncoding error:nil];
            dataArray = [dataString csvStringTransformToDictionary];
        }
    }
    return dataArray;
}

@end
