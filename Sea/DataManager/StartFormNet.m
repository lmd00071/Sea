//
//  StartFormNet.m
//  WidomStudy
//
//  Created by 李明丹 on 16/3/15.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "StartFormNet.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "detaiModel.h"
#import "ABModel.h"
#import "videoModel.h"
#import "DataBase.h"
@interface StartFormNet ()<NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>
//网络请求任务队列
//获取地址的任务队列
@property (nonatomic, strong) NSURLSessionDataTask *dnsTask;
@property (nonatomic, strong) NSURLSessionDataTask *csvTask;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask1;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic,strong)DataBase *dataBase;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,assign)NSInteger cellNumber;
//@property (nonatomic,strong)StratScore *attModel;


@end
@implementation StartFormNet
//单例方法
//+ (instancetype)shareManager
//{
//    static StartFormNet *manager=nil;
//    if (!manager) {
//        
//        static dispatch_once_t oneToken;
//        dispatch_once(&oneToken, ^{
//            
//            manager=[[StartFormNet alloc]init];
//        });
//    }
//    return manager;
//}
#pragma mark - 控制器生命周期方法

- (void)viewDisMiss
{
    
    [self.dnsTask cancel];
    [self.csvTask cancel];
    [self.dataTask cancel];
    [self.dataTask1 cancel];
    [self.downloadTask cancel];
    [[SDWebImageManager sharedManager] cancelAll];
    [SVProgressHUD dismiss];
    
}
#pragma mark - 网络请求
//网络请求
- (void)searchFromNetDelegateAction:(id<StartFormNetDelegate>)delegate DnsUrl:(NSString *)dnsUrl action_parameter:(NSString *)action_parameter cellNumber:(NSInteger)cellNumber
{
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    self.delegate=delegate;
    self.uid=action_parameter;
    self.cellNumber=cellNumber;
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"trans_code"] = @"ui_show";
    parameters[@"from_system"] = FromSystem;
    //拿到当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    parameters[@"from_client_version"] = version;
    //拿到手机的MAC地址
    parameters[@"from_client_id"] = AppUUID;
    
    if (userArray.count > 0) {
        loginOrReginModel *userMessage = userArray.lastObject;
        parameters[@"yc_user_account_uid"] = userMessage.user_account_uid;
    }
    
    parameters[@"yc_user_role"] = UserRole;
    parameters[@"action"] = @"hyan_tmat_download_book";
    NSString *action_parameterA=[NSString stringWithFormat:@"textbook_uid=%@",action_parameter];
    parameters[@"action_parameter"] = action_parameterA;
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
            
            NSDictionary *csvDict = [NSDictionary dictionaryWithXMLData:data];
            if (csvDict[@"error_code"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:csvDict[@"error_string"]];
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(passErrpr)]) {
                        
                        [self.delegate passErrpr];
                    }
                    
                });
                return ;
            }
            
            NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t group = dispatch_group_create();
            
            dispatch_group_async(group, queue, ^{
                
                NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:csvDict[@"template_data_csv"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                        return;
                    }
                    NSString *contents = [[NSString alloc] initWithData:data encoding:encode];
                    NSMutableArray *dataArr=[NSMutableArray array];
                    NSArray *picArray = [contents csvStringTransformToDictionary];
                        if (picArray != nil && picArray.count > 0) {
                            for (NSMutableDictionary *picDict in picArray) {
                                
                                detaiModel *getModel=[[detaiModel alloc]init];
                                [getModel setValuesForKeysWithDictionary:picDict];
                                [dataArr addObject:getModel];
                            }
    
                            self.dataBase=[[DataBase alloc]init];
                            [self.dataBase creatUnitDataBaseUidName:self.uid];
                            [self.dataBase deleteUnitFromBriefUid:self.uid];
                            [self.dataBase creatUnitDataBaseUidName:self.uid];
                            [self.dataBase addUnitFromBriefAarray:dataArr UidName:self.uid];
                        }
                        
                   
                }];
                
                [dataTask resume];
                self.dataTask=dataTask;
            });
            
            dispatch_group_async(group, queue, ^{
                
                NSURLSessionDataTask *dataTask1 = [session dataTaskWithURL:[NSURL URLWithString:csvDict[@"template_data_csv1"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                        return;
                    }
                    NSString *contents = [[NSString alloc] initWithData:data encoding:encode];
                    NSMutableArray *dataArr=[NSMutableArray array];
                    NSArray *picArray = [contents csvStringTransformToDictionary];
                    if (picArray != nil && picArray.count > 0) {
                        for (NSMutableDictionary *picDict in picArray) {
                            
                            ABModel *AModel=[[ABModel alloc]init];
                            [AModel setValuesForKeysWithDictionary:picDict];
                            [dataArr addObject:AModel];
                        }
                        
                    
                        
                         self.dataBase=[[DataBase alloc]init];
                        [self.dataBase creatABJuanDataBaseUidName:self.uid];
                        [self.dataBase deleteABJuanFromBriefUid:self.uid];
                        [self.dataBase creatABJuanDataBaseUidName:self.uid];
                        [self.dataBase addABJuanFromBriefAarray:dataArr UidName:self.uid];
                    }
                    
                    
                }];
                
                [dataTask1 resume];
                self.dataTask1=dataTask1;
            });
            
            dispatch_group_async(group, queue, ^{
                
                NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
                
                //参数3:操作队列
                NSURLSession *session=[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
                
                NSURLSessionDownloadTask *downloadTask=[session downloadTaskWithURL:[NSURL URLWithString:csvDict[@"template_data_csv2"]]];
                //downloadTask.taskIdentifier=1;
                
                [downloadTask resume];
                self.downloadTask=downloadTask;
              });
        }];
       
        [csvTask resume];
        weakself.csvTask = csvTask;
        
        
    }];
    [dnsTask resume];
    self.dnsTask=dnsTask;
    
}

//下载完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
    
    //非UTF-8编码
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data=[[NSData alloc]initWithContentsOfURL:location];
    NSString *contents = [[NSString alloc] initWithData:data encoding:encode];
    
    NSArray *picArray = [contents csvStringTransformToDictionary];
    NSMutableArray *questionArr=[NSMutableArray array];
//    NSMutableArray *startArray=[NSMutableArray array];
    //dispatch_async(dispatch_get_main_queue(), ^{
    
        if (picArray != nil && picArray.count > 0) {
            for (int i=0; i<picArray.count; i++) {
                NSMutableDictionary *picDict=[[NSMutableDictionary alloc]init];
                picDict=picArray[i];
                
                videoModel *modelQu=[[videoModel alloc]init];
                [modelQu setValuesForKeysWithDictionary:picDict];
                
                NSURL *url = [NSURL URLWithString:modelQu.lecture_image];
                
                [[SDWebImageManager sharedManager]downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                    float received=receivedSize*1.0;
                    float expected=expectedSize*1.0;
                    float progress=received/expected;
                    float quetionArrNumber=questionArr.count*0.98;
                    float progressFin=(((quetionArrNumber*1.0)/(picArray.count*1.0))+(1.0/(picArray.count*1.0)*progress))*1.0;
                    //dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(passProgaessDataMore:cellNumber:)]) {
                            
                            [self.delegate passProgaessDataMore:progressFin cellNumber:self.cellNumber];
                        }
                        
                    //});
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                    if (finished) {
                        
                            modelQu.lecture_images=image;
                            [questionArr addObject:modelQu];
                            // NSLog(@"总数=%ld",picArray.count);
                            // NSLog(@"个数=%ld",questionArr.count);
                            if (questionArr.count==picArray.count) {
                                
                                
//                                dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                                dispatch_async(globalQueue, ^{
                                
                                    self.dataBase=[[DataBase alloc]init];
                                    [self.dataBase creatVideoDataBaseUidName:self.uid];
                                    [self.dataBase deleteVideoFromBriefUid:self.uid];
                                    [self.dataBase creatVideoDataBaseUidName:self.uid];
                                    [self.dataBase addVideoFromBriefAarray:questionArr UidName:self.uid];
                               
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        if (self.delegate && [self.delegate respondsToSelector:@selector(passFinshCelllNumber:)]) {
                                            
                                            [self.delegate passFinshCelllNumber:self.cellNumber];
                                        }
                                        
                                    });
                                    
                                
                                //});
                                
                              
                                
                            }
                            
                        


                    }
                    
                    
                }];
                
            }
        }
    
}

//每次下载一点数据,就会调用该方法
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //每次下载多少
   // NSLog(@"%lld",bytesWritten);
    
    //下载一共多少
   // NSLog(@"%f",1.0*totalBytesWritten/totalBytesExpectedToWrite);
    
    //下载的内容一共有多少
    //NSLog(@"%lld",totalBytesExpectedToWrite);
    float x=1.0*totalBytesWritten;
    float y=1.0*totalBytesExpectedToWrite;
    float progress=0.2*x/y;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        if (self.delegate && [self.delegate respondsToSelector:@selector(passProgaessDataMore:cellNumber:)]) {
//            
//            [self.delegate passProgaessDataMore:progress cellNumber:self.cellNumber];
//        }
//    });
}

@end
