//
//  SearchManager.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/1/18.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "SearchManager.h"

@interface SearchManager()<NSXMLParserDelegate>

//记录当前解析的是哪个标签
@property (nonatomic,strong)NSString *currentElementName;

@property (nonatomic,strong)searchCsvModel *csvModel;
@end

@implementation SearchManager

//单例方法
+ (instancetype)shareManager
{
    static SearchManager *manager=nil;
    if (!manager) {
        
        static dispatch_once_t oneToken;
        dispatch_once(&oneToken, ^{
            
            manager=[[SearchManager alloc]init];
        });
    }
    return manager;
}


- (void)searchFromNetDelegateAction:(id<SearchManagerDelegate>)delegate DnsUrl:(NSString *)dnsUrl action_parameter:(NSString *)action_parameter
{
    self.delegate=delegate;

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
    parameters[@"action"] = @"hyan_tmat_search_book";
    parameters[@"action_parameter"] = action_parameter;
     NSString *xmlString = [parameters newXMLString];
//  NSString *bodyStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><infobus><trans_code>ui_show</trans_code><from_system>海燕微客互动平台</from_system><from_client_id>54:59:C2:2A:0A:B2</from_client_id><yc_user_role>parent</yc_user_role><cmd /><action>hyan_tmat_search_book</action><action_parameter>%@</action_parameter></infobus>",action_parameter];
//    
  

    //1.基础的url
    NSURL *url=[NSURL URLWithString:dnsUrl];
    
    //单例对象 全局的session
    NSURLSession *session=[NSURLSession sharedSession];
    
    //网络请求类 NSURLRequest
    
    //post请求需要可变的网络请求对象
    NSMutableURLRequest *mURLRequest=[[NSMutableURLRequest alloc]initWithURL:url];
    
    //设置请求方式为post
    mURLRequest.HTTPMethod=@"POST";
    
    
    //将字符串转成NSData
    NSData *data=[xmlString dataUsingEncoding:NSUTF8StringEncoding];
    [mURLRequest setHTTPBody:data];
    
    
    //5添加请求头的代码
    [mURLRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:mURLRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showErrorWithStatus:@"网络超时"];
                
            });
            
            return ;
        }
        //3.利用data创建一个解析对象
        NSXMLParser *parser=[[NSXMLParser alloc]initWithData:data];
        
        parser.delegate=self;
        
        //让解析对象开始解析
        [parser parse];
        
        
    }];
    
    [dataTask resume];
    
}

// 开始解析文档
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"开始解析文档");
    
}

//开始解析某个标签
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //当开始标签是 student 的时候,创建一个student 对象
    if ([elementName isEqualToString:@"infobus"]) {
        
        self.csvModel=[[searchCsvModel alloc]init];
        
    }
    
    self.currentElementName=elementName;
    
    
}

//取值的方法
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    //如果当前解析的是name,而且 name 属性没有值的时候(说明当前取值是对开始标签取值),才利用string对student.name赋值
        if ([self.currentElementName isEqualToString:@"general_csv"]&&self.csvModel.general_csv==nil) {
    
            self.csvModel.general_csv=string;
    
        }
    
        if ([self.currentElementName isEqualToString:@"template_attr_csv"]&&self.csvModel.template_attr_csv==nil) {
    
            self.csvModel.template_attr_csv=string;
    
        }
    
        if ([self.currentElementName isEqualToString:@"template_data_csv"]&&self.csvModel.template_data_csv==nil) {
    
            self.csvModel.template_data_csv=string;
            
        }
    
}


//结束某个标签
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    
    //当结束student标签的解析的时候,证明这个学生的对象所有数据已经获取完毕,可以将该学生对象加入到数组中
    if ([elementName isEqualToString:@"infobus"]) {
        
        
    }
    
    
}


//结束文档的解析
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    
    NSLog(@"文档解析结束");
    
    //代理把解析出来的数组传出去
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(passCsvData:)]) {
            
            [self.delegate passCsvData:self.csvModel];
        }
        
        
    });

    
}

@end
