////
////  downProgaess.m
////  SeaSwallowClassRoom
////
////  Created by 李明丹 on 16/1/19.
////  Copyright © 2016年 李明丹. All rights reserved.
////
//
//#import "downProgaess.h"
//#import "detaiModel.h"
//#import "ABModel.h"
//#import "videoModel.h"
//#import "DataBase.h"
//@interface downProgaess()<NSURLSessionDownloadDelegate,NSURLSessionDataDelegate,DataBaseDelegate>
//
////记录当前解析的是哪个标签
//@property (nonatomic,strong)NSString *currentElementName;
//
//@property (nonatomic,strong)searchCsvModel *csvModel;
//@property (nonatomic,assign)float progress;
//
//@property (nonatomic,strong)NSMutableArray *detaArray;
//@property (nonatomic,strong)NSMutableArray *ABArray;
//@property (nonatomic,strong)NSMutableArray *videoArray;
//
//@property (nonatomic,strong)DataBase *dataBase;
//@property (nonatomic,strong)NSString *uid;
//@property (nonatomic,assign)NSInteger cellNumber;
//
////标记第几次
//@property (nonatomic,assign)NSInteger number;
//@property(nonatomic,assign)NSInteger numberCsv;
//@end
//@implementation downProgaess
//
//
////单例方法
////+ (instancetype)shareManager
////{
////    static downProgaess *manager=nil;
////    if (!manager) {
////        
////        static dispatch_once_t oneToken;
////        dispatch_once(&oneToken, ^{
////            
////            manager=[[downProgaess alloc]init];
////        });
////    }
////    return manager;
////}
//
//
////懒加载
//- (NSMutableArray *)detaArray
//{
//    if (!_detaArray) {
//        self.detaArray=[NSMutableArray array];
//    }
//    
//    return _detaArray;
//}
////懒加载
//- (NSMutableArray *)ABArray
//{
//    if (!_ABArray) {
//        self.ABArray=[NSMutableArray array];
//    }
//    
//    return _ABArray;
//}
////懒加载
//- (NSMutableArray *)videoArray
//{
//    if (!_videoArray) {
//        self.videoArray=[NSMutableArray array];
//    }
//    
//    return _videoArray;
//}
//
//
//- (void)searchFromNetDelegateAction:(id<downProgaessDelegate>)delegate uid:(NSString *)uid DnsUrl:(NSString *)dnsUrl searchModl:(searchCsvModel *)dearchModel cellNumber:(NSInteger)cellNumber
//{
//    self.delegate=delegate;
//    self.uid=uid;
//    self.number=0;
//    self.cellNumber=cellNumber;
//    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    //参数3:操作队列
//    NSURLSession *session=[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    
//    NSURLSessionDownloadTask *downloadTask=[session downloadTaskWithURL:[NSURL URLWithString:dearchModel.template_data_csv]];
//    
//    [downloadTask resume];
//    
//    NSURLSessionDownloadTask *downloadTask1=[session downloadTaskWithURL:[NSURL URLWithString:dearchModel.template_data_csv1]];
//    
//    [downloadTask1 resume];
//    
//    NSURLSessionDownloadTask *downloadTask2=[session downloadTaskWithURL:[NSURL URLWithString:dearchModel.template_data_csv2]];
//    
//    [downloadTask2 resume];
//    
//    
//}
//
//
////下载完成
//-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
//{
//     NSData *data=[[NSData alloc]initWithContentsOfURL:location];
//    //********************************************************************
//    if (downloadTask.taskIdentifier==1) {
//        [self.detaArray removeAllObjects];
//        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//        NSString *fileContents = [[NSString alloc] initWithData:data encoding:enc];
//        
//        NSArray* allLinedStrings =[fileContents componentsSeparatedByString:@"\r\n"];
//        
//        for (int i=0;i<allLinedStrings.count-1;i++){
//            if (i==0) {
//                
//            }else{
//                
//                NSString* strsInOneLine =[allLinedStrings objectAtIndex:i];
//                NSString *trimmedString = [strsInOneLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                NSArray* singleStrs =
//                [trimmedString componentsSeparatedByString:@","];
//                
//                detaiModel *getModel=[[detaiModel alloc]init];
//                
//                if (![singleStrs[0]isEqualToString:@""]) {
//                    getModel.lesson_no=singleStrs[0];
//                }
//                if (![singleStrs[1]isEqualToString:@""]) {
//                    getModel.lesson_name=singleStrs[1];
//                    
//                }
//                
//                [self.detaArray addObject:getModel];
//            }
//        }
//        
//        self.dataBase=[[DataBase alloc]init];
//        [self.dataBase creatUnitDataBaseUidName:self.uid];
//        [self.dataBase addUnitFromBriefAarray:self.detaArray UidName:self.uid];
//        
//    }
//    //*******************************************************************
//    if (downloadTask.taskIdentifier==2) {
//        [self.ABArray removeAllObjects];
//        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//        NSString *fileContents = [[NSString alloc] initWithData:data encoding:enc];
//        
//        NSArray* allLinedStrings =[fileContents componentsSeparatedByString:@"\r\n"];
//        
//        for (int i=0;i<allLinedStrings.count-1;i++){
//            if (i==0) {
//                
//            }else{
//                
//                NSString* strsInOneLine =[allLinedStrings objectAtIndex:i];
//                NSString *trimmedString = [strsInOneLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                NSArray* singleStrs =
//                [trimmedString componentsSeparatedByString:@","];
//                
//                ABModel *getModel=[[ABModel alloc]init];
//                
//                if (![singleStrs[0]isEqualToString:@""]) {
//                    getModel.lesson_no=singleStrs[0];
//                }
//                if (![singleStrs[1]isEqualToString:@""]) {
//                    getModel.suit_no=singleStrs[1];
//                    
//                }
//                if (![singleStrs[1]isEqualToString:@""]) {
//                    getModel.suit_name=singleStrs[2];
//                    
//                }
//                
//                [self.ABArray addObject:getModel];
//            }
//        }
//        
//        self.dataBase=[[DataBase alloc]init];
//        [self.dataBase creatABJuanDataBaseUidName:self.uid];
//        [self.dataBase addABJuanFromBriefAarray:self.ABArray UidName:self.uid];
//        
//    }
//    
//    if (downloadTask.taskIdentifier==3) {
//        
//        [self.videoArray removeAllObjects];
//        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//        NSString *fileContents = [[NSString alloc] initWithData:data encoding:enc];
//        
//        NSArray* allLinedStrings =[fileContents componentsSeparatedByString:@"\r\n"];
//        
//       //self.numberCsv=1;
//        self.progress=0;
//        
//        for (int i=0;i<allLinedStrings.count-1;i++){
//            if (i==0) {
//                
//            }else{
//                
//                NSString* strsInOneLine =[allLinedStrings objectAtIndex:i];
//                NSString *trimmedString = [strsInOneLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                NSArray* singleStrs =
//                [trimmedString componentsSeparatedByString:@","];
//                
//                videoModel *getModel=[[videoModel alloc]init];
//                
//                if (![singleStrs[0]isEqualToString:@""]) {
//                    getModel.lesson_no=singleStrs[0];
//                }
//                if (![singleStrs[1]isEqualToString:@""]) {
//                    getModel.suit_no=singleStrs[1];
//                    
//                }
//                if (![singleStrs[2]isEqualToString:@""]) {
//                    getModel.lecture_no=singleStrs[2];
//                    
//                }
//                if (![singleStrs[3]isEqualToString:@""]) {
//                    getModel.lecture_name=singleStrs[3];
//                    
//                }
//                if (![singleStrs[4]isEqualToString:@""]) {
//                    getModel.lecture_image=singleStrs[4];
//                    
//                    
//                }
//                if (![singleStrs[5]isEqualToString:@""]) {
//                    getModel.video_url=singleStrs[5];
//                    
//                }
//                
//                [self.videoArray addObject:getModel];
//                
////            dispatch_async(dispatch_get_main_queue(), ^{
////                
////                self.progress=1.0*self.videoArray.count/(allLinedStrings.count-1)*0.3+0.15;
////                if (self.delegate && [self.delegate respondsToSelector:@selector(passProgaessDataMore:)]) {
////                    
////                    [self.delegate passProgaessDataMore:self.progress cellNumber:self.cellNumber];
////                }
//                //self.numberCsv++;
////            });
//                
//            }
//        }
//        
//
//        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(globalQueue, ^{
//            
//        
////        dispatch_queue_t conCurrenQueue=dispatch_queue_create("conCurrenQueue", DISPATCH_QUEUE_CONCURRENT);
////        
////        dispatch_async(conCurrenQueue, ^{
//        
//            self.dataBase=[[DataBase alloc]init];
//            [self.dataBase creatVideoDataBaseUidName:self.uid];
//            // 模拟下载进度
//            //           self.progress=0.15;
//            //            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressSimulation) userInfo:self repeats:YES];
//            BOOL progess=[self.dataBase addVideoFromDelegateAction:self BriefAarray:self.videoArray UidName:self.uid];
//            if (progess) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.progress=1;
//                    if (self.delegate && [self.delegate respondsToSelector:@selector(passProgaessDataMore:cellNumber:)]) {
//                        
//                        [self.delegate passProgaessDataMore:self.progress cellNumber:self.cellNumber];
//                    }
//                });
//            }
//            
//            
//        });
//        
//       
//        
//    }
//}
//
//
////- (void)passProgess:(float)progress
////{
////
////    //self.progress=1;
////    //dispatch_async(dispatch_get_main_queue(), ^{
////    if (self.delegate && [self.delegate respondsToSelector:@selector(passProgaessDataMore:)]) {
////        
////        [self.delegate passProgaessDataMore:progress cellNumber:self.cellNumber];
////    }
////    //});
////
////
////}
//
//
//
////每次下载一点数据,就会调用该方法
//-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//{
//    self.number=self.number+1;
//   dispatch_async(dispatch_get_main_queue(), ^{
//    
//    if (downloadTask.taskIdentifier==1) {
//         self.progress=0.1*1.0*totalBytesWritten/totalBytesExpectedToWrite;
//    }
//    if (downloadTask.taskIdentifier==2) {
//        self.progress=0.1+0.3*1.0*totalBytesWritten/totalBytesExpectedToWrite;
//        
//    }
//    if (downloadTask.taskIdentifier==3) {
//        
//        self.progress=0.4+0.5*1.0*totalBytesWritten/totalBytesExpectedToWrite;
//    }
//        //self.progress=1.0*totalBytesWritten/totalBytesExpectedToWrite;
////        if (self.number==1) {
////            self.progress=0.1;
////        }
////        if (self.number==2) {
////            self.progress=0.5;
////        }
////        if (self.number==3) {
////            self.progress=1;
////        }
//        if (self.delegate && [self.delegate respondsToSelector:@selector(passProgaessDataMore:cellNumber:)]) {
//            
//            [self.delegate passProgaessDataMore:self.progress cellNumber:self.cellNumber];
//        }
//    
//    });
//    
//    
//}
//
////- (void)progressSimulation
////{
////    
////    if (self.progress < 1.0){
////        //self.demoView.alpha=1;
////        self.progress += 0.01;
////        
////        // 循环
////        if (self.progress >= 0.9){
////           
////            
////            return;
////        }
////        
////
////        if (self.delegate && [self.delegate respondsToSelector:@selector(passProgaessDataMore:)]) {
////            
////            [self.delegate passProgaessDataMore:self.progress];
////        }
////        
////    }
////}
//
//@end
