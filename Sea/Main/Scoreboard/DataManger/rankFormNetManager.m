//
//  rankFormNetManager.m
//  WidomStudy
//
//  Created by 李明丹 on 16/3/22.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "rankFormNetManager.h"
#import "rankModel.h"
@interface rankFormNetManager ()
//网络请求任务队列
//获取地址的任务队列
@property (nonatomic, strong) NSURLSessionDataTask *dnsTask;
@property (nonatomic, strong) NSURLSessionDataTask *csvTask;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask1;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong)  RankUserModel *attModel;
@end

@implementation rankFormNetManager
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
//单例方法
+ (instancetype)shareManager
{
    static rankFormNetManager *manager=nil;
    if (!manager) {
        
        static dispatch_once_t oneToken;
        dispatch_once(&oneToken, ^{
            
            manager=[[rankFormNetManager alloc]init];
        });
    }
    return manager;
}


#pragma mark - 控制器生命周期方法

- (void)viewDisMiss
{
    
    [self.dnsTask cancel];
    [self.csvTask cancel];
    [self.dataTask1 cancel];
    [self.dataTask cancel];
    [SVProgressHUD dismiss];
    
}

- (void)makeCSVDelegateAction:(id<rankFormNetManagerDelegate>)delegate
{
    self.delegate=delegate;
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    
    [SVProgressHUD showWithStatus:@"正在加载中..."];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] = @"ui_show";
    parameters[@"from_system"] = FromSystem;
    //拿到手机的MAC地址
    parameters[@"from_client_id"] = AppUUID;
    //拿到当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    parameters[@"from_client_version"] = version;
    parameters[@"yc_user_role"] = UserRole;
    if (userArray.count > 0) {
        loginOrReginModel *userMessage = userArray.lastObject;
        parameters[@"yc_user_role"] = UserRole;
        parameters[@"yc_user_account_uid"] = userMessage.user_account_uid;
        
    }
    parameters[@"action"] = @"rank_total_yp";
    
    NSString *xmlString = [parameters newXMLString];
    
    __weak typeof(self) weakself = self;
    NSURL *url=[NSURL URLWithString:BaseUrlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dnsTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
            });
            return;
        }
        
        NSDictionary *dnsDict = [NSDictionary dictionaryWithXMLData:data];
        NSMutableURLRequest *dnsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dnsDict[@"dns.url"]]];
        
        [dnsRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        dnsRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
        dnsRequest.HTTPMethod = @"POST";
        
        NSURLSessionDataTask *csvTask = [session dataTaskWithRequest:dnsRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                });
                return;
            }
            
            NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];

            if (dict[@"error_code"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:dict[@"error_string"]];
                });
                return;
            }
            
            
            //非UTF-8编码
            NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t group = dispatch_group_create();
            
            
            dispatch_group_async(group, queue, ^{
                NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:dict[@"template_attr_csv"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                        });
                        return;
                    }
                    //回到主线程刷新数据
                    //dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *contents = [[NSString alloc] initWithData:data encoding:encode];
                    if (contents == nil || contents.length <= 0) {
                        return;
                    }
                    NSArray *newsArray = [contents csvStringTransformToDictionary];
                    if (newsArray != nil && newsArray.count > 0) {
                        NSMutableDictionary *newsDict = [NSMutableDictionary dictionary];
                        for (NSDictionary *dict in newsArray) {
                            
                            if ([dict[@"key"] isEqualToString:@"标题"]) {
                                newsDict[@"title"] = dict[@"value"];
                                
                            } else if ([dict[@"key"] isEqualToString:@"我的头像"]) {
                                newsDict[@"icon"] = dict[@"value"];
                                
                            }  else if ([dict[@"key"] isEqualToString:@"我的昵称"]) {
                                newsDict[@"name"] = dict[@"value"];
                                
                            }  else if ([dict[@"key"] isEqualToString:@"我的得分情况"]) {
                                newsDict[@"userMessager"] = dict[@"value"];
                                
                            } 
                        }
                        self.attModel = [[RankUserModel alloc]init];
                        [self.attModel setValuesForKeysWithDictionary:newsDict];
                        
                    }
                    
                }];
                [dataTask resume];
                weakself.dataTask = dataTask;
                
                
            });
            
            dispatch_group_async(group, queue, ^{

            NSURLSessionDataTask *dataTask1 = [session dataTaskWithURL:[NSURL URLWithString:dict[@"template_data_csv"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                    });
                    return;
                }
                //清楚上次的数组
                [weakself.dataArray removeAllObjects];
                NSString *contents = [[NSString alloc] initWithData:data encoding:encode];
                
                NSArray *picArray = [contents csvStringTransformToDictionary];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    if (picArray != nil && picArray.count > 0) {
                        for (NSMutableDictionary *picDict in picArray) {
                            
                            rankModel *model = [rankModel mj_objectWithKeyValues:picDict];
                            
                            [self.dataArray addObject:model];
                        }
                    }
                    
                    if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(passPostResultTopModelArray:attModel:)]) {
                        
                        [weakself.delegate passPostResultTopModelArray:self.dataArray attModel:self.attModel];
                    }
                    
                });
            }];
            
            [dataTask1 resume];
            weakself.dataTask1 = dataTask1;
                
        });
            
        }];
        [csvTask resume];
        weakself.csvTask = csvTask;
        
    }];
    [dnsTask resume];
    self.dnsTask=dnsTask;
    
}
@end
