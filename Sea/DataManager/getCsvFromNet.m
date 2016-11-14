//
//  getCsvFromNet.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/1/19.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "getCsvFromNet.h"
#import "userBookModel.h"

@interface getCsvFromNet ()


@property (nonatomic,retain)NSMutableArray *dataArray;


@end

@implementation getCsvFromNet
//懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray=[NSMutableArray array];
    }
    
    return _dataArray;
}

//单例方法
+ (instancetype)shareManager
{
    static getCsvFromNet *manager=nil;
    if (!manager) {
        
        static dispatch_once_t oneToken;
        dispatch_once(&oneToken, ^{
            
            manager=[[getCsvFromNet alloc]init];
        });
    }
    return manager;
}

- (void)searchDataFromNetDelegateAction:(id<getCsvFromNetDelegate>)delegate csvUrl:(NSString *)csvUrl
{

     self.delegate=delegate;
    
    NSURL *url = [NSURL URLWithString:csvUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse *response, NSError *error) {
        
        
        [self.dataArray removeAllObjects];
        
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showErrorWithStatus:@"网络超时"];
                
            });
            
            return ;
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *fileContents = [[NSString alloc] initWithData:data encoding:enc];
            
            NSArray* allLinedStrings =[fileContents componentsSeparatedByString:@"\r\n"];
                        
            for (int i=0;i<allLinedStrings.count-1;i++){
                if (i==0) {
                    
                }else{
                    
                NSString* strsInOneLine =[allLinedStrings objectAtIndex:i];
                NSString *trimmedString = [strsInOneLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSArray* singleStrs =
                [trimmedString componentsSeparatedByString:@","];
                
                userBookModel *getModel=[[userBookModel alloc]init];
                
                if (![singleStrs[0]isEqualToString:@""]) {
                    getModel.icon=singleStrs[0];
                }
                if (![singleStrs[1]isEqualToString:@""]) {
                    getModel.textbook_name=singleStrs[1];
                    
                }
                if (![singleStrs[2]isEqualToString:@""]) {
                    getModel.grade_order_no=singleStrs[2];
                    
                }
                if (![singleStrs[3]isEqualToString:@""]) {
                    getModel.grade_half_order_no=singleStrs[3];
                }
                if (![singleStrs[4]isEqualToString:@""]) {
                    getModel.text_book_uid=singleStrs[4];
                }
                if (![singleStrs[5]isEqualToString:@""]) {
                    getModel.course_id=singleStrs[5];
                }
                if (![singleStrs[6]isEqualToString:@""]) {
                    getModel.course_name=singleStrs[6];
                }
                if (![singleStrs[7]isEqualToString:@""]) {
                    getModel.lecture_cnt=singleStrs[7];
                }
                if (![singleStrs[8]isEqualToString:@""]) {
                    getModel.modify_time=singleStrs[8];
                }
                
                
                [self.dataArray addObject:getModel];
             }
            }
        
                
                //代理把解析出来的数组传出去
                
               if (self.delegate && [self.delegate respondsToSelector:@selector(passdataModelArray:)]) {
            
                    
                    [self.delegate passdataModelArray:self.dataArray];
                    
               }
            
                     
        });
        

            
       
        
    }];
    
    [dataTask resume];

}

@end
