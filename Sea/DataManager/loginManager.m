//
//  loginManager.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/1/18.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "loginManager.h"

@interface loginManager()<NSXMLParserDelegate>

//记录当前解析的是哪个标签
@property (nonatomic,strong)NSString *currentElementName;

@property (nonatomic,strong)loginOrReginModel *loginModel;
@property (nonatomic,strong)loginOrReginModel *sendModel;
@property (nonatomic,strong)loginOrReginModel *reginModel;

@property (nonatomic,assign)NSInteger way;
@end

@implementation loginManager
//单例方法
+ (instancetype)shareManager
{
    static loginManager *manager=nil;
    if (!manager) {
        
        static dispatch_once_t oneToken;
        dispatch_once(&oneToken, ^{
            
            manager=[[loginManager alloc]init];
        });
    }
    return manager;
}


- (void)searchFromNetDelegateAction:(id<loginManagerDelegate>)delegate way:(NSInteger)way user:(NSString *)user passWord:(NSString *)passWord verificationCode:(NSString *)verificationCode
{
    self.delegate=delegate;
    self.way=way;
    self.loginModel=nil;
    NSString *bodyStr=[[NSString alloc]init];
    //发送验证码
    if (way==1) {
        
        
        bodyStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><infobus><trans_code>send_verification_code</trans_code><from_system>海燕微客互动平台</from_system><from_client_id>%@</from_client_id><yc_user_role>parent</yc_user_role><msisdn>%@</msisdn></infobus>",AppUUID,user];
        
    }
    
    //注册
    if (way==2) {
        
        bodyStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><infobus><trans_code>user_register</trans_code><from_system>海燕微客互动平台</from_system><from_client_id>%@</from_client_id><yc_user_role>parent</yc_user_role><user_account>%@</user_account><user_password>%@</user_password><imei></imei><imsi></imsi><verification_code>123456</verification_code><is_new_terminal></is_new_terminal></infobus>",AppUUID,user,passWord];
        
        
    }
    
    //登录
    if (way==3) {
        
        bodyStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><infobus><trans_code>user_login</trans_code><from_system>海燕微课互动平台</from_system><from_client_id>%@</from_client_id><yc_user_role>teacher</yc_user_role><user_account>%@</user_account><user_password>%@</user_password><imei /><imsi /><is_new_terminal>N</is_new_terminal></infobus>",AppUUID,user,passWord];
        
    }
    

    //1.基础的url
    NSURL *url=[NSURL URLWithString:@"http://120.25.59.84/ZXHyan/service/zxcenter_service/zxcenter_service_v00_66_321.aspx"];
    //NSURL *url=[NSURL URLWithString:@"http://192.168.0.48/HNHaiyan/service/zxcenter_service/zxcenter_service_v00_66_321.aspx"];
                //单例对象 全局的session"];
    
    NSURLSession *session=[NSURLSession sharedSession];
    
    //网络请求类 NSURLRequest
    
    //post请求需要可变的网络请求对象
    NSMutableURLRequest *mURLRequest=[[NSMutableURLRequest alloc]initWithURL:url];
    
    //设置请求方式为post
    mURLRequest.HTTPMethod=@"POST";
    
    
    //将字符串转成NSData
    NSData *data=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [mURLRequest setHTTPBody:data];
    
    
    //5添加请求头的代码
    [mURLRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:mURLRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(passdataLoginModel:)]) {
                    
                    [self.delegate passdataLoginModel:nil];
                }
                
            });
            return;
        }
        
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        
        //self.stuArr=[NSMutableArray array];
        //XML SAX解析方式,逐行解析
        
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
        
        switch (self.way) {
            case 1:
                 self.sendModel=[[loginOrReginModel alloc]init];
                break;
            case 2:
                self.reginModel=[[loginOrReginModel alloc]init];
                break;
            case 3:
                self.loginModel=[[loginOrReginModel alloc]init];
                break;
            default:
                break;
        }
    }
    
    //开始解析某个标签时,给self.currentElementName赋值
    self.currentElementName=elementName;
    
    //    NSLog(@"%@",elementName);
    
}

//取值的方法
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    switch (self.way) {
        case 1:
            //如果当前解析的是name,而且 name 属性没有值的时候(说明当前取值是对开始标签取值),才利用string对student.name赋值
            if ([self.currentElementName isEqualToString:@"error_code"]&&self.sendModel.error_code==nil) {
                
                self.sendModel.error_code=string;
                //        NSLog(@"%@",self.student.name);
                
            }
            
            if ([self.currentElementName isEqualToString:@"error_string"]&&self.sendModel.error_string==nil) {
                
                self.sendModel.error_string=string;
                //        NSLog(@"%@",self.student.sex);
                
            }
            
            if ([self.currentElementName isEqualToString:@"login_result_msg"]&&self.sendModel.login_result_msg==nil) {
                
                self.sendModel.login_result_msg=string;
                //        NSLog(@"%@",self.student.age);
                
            }
            
            if ([self.currentElementName isEqualToString:@"register_result_msg"]&&self.sendModel.register_result_msg==nil) {
                
                self.sendModel.register_result_msg=string;
                //        NSLog(@"%@",self.student.age);
                
            }
            break;
        case 2:
            //如果当前解析的是name,而且 name 属性没有值的时候(说明当前取值是对开始标签取值),才利用string对student.name赋值
            if ([self.currentElementName isEqualToString:@"error_code"]&&self.reginModel.error_code==nil) {
                
                self.reginModel.error_code=string;
                //        NSLog(@"%@",self.student.name);
                
            }
            
            if ([self.currentElementName isEqualToString:@"error_string"]&&self.reginModel.error_string==nil) {
                
                self.reginModel.error_string=string;
                //        NSLog(@"%@",self.student.sex);
                
            }
            
            if ([self.currentElementName isEqualToString:@"login_result_msg"]&&self.reginModel.login_result_msg==nil) {
                
                self.reginModel.login_result_msg=string;
                //        NSLog(@"%@",self.student.age);
                
            }
            
            if ([self.currentElementName isEqualToString:@"register_result_msg"]&&self.reginModel.register_result_msg==nil) {
                
                self.reginModel.register_result_msg=string;
                //        NSLog(@"%@",self.student.age);
                
            }
            break;
        case 3:
            //如果当前解析的是name,而且 name 属性没有值的时候(说明当前取值是对开始标签取值),才利用string对student.name赋值
            if ([self.currentElementName isEqualToString:@"error_code"]&&self.loginModel.error_code==nil) {
                
                self.loginModel.error_code=string;
                //        NSLog(@"%@",self.student.name);
                
            }
            
            if ([self.currentElementName isEqualToString:@"error_string"]&&self.loginModel.error_string==nil) {
                
                self.loginModel.error_string=string;
                //        NSLog(@"%@",self.student.sex);
                
            }
            
            if ([self.currentElementName isEqualToString:@"login_result_msg"]&&self.loginModel.login_result_msg==nil) {
                
                self.loginModel.login_result_msg=string;
                //        NSLog(@"%@",self.student.age);
                
            }
            
//            if ([self.currentElementName isEqualToString:@"new_terminal_mac"]&&self.loginModel.register_result_msg==nil) {
//                
//                self.loginModel.new_terminal_mac=string;
//                //        NSLog(@"%@",self.student.age);
//                
//            }
            if ([self.currentElementName isEqualToString:@"user_account_uid"]&&self.loginModel.user_account_uid==nil) {
                
                self.loginModel.user_account_uid=string;
                //        NSLog(@"%@",self.student.age);
                
            }
            if ([self.currentElementName isEqualToString:@"user_name"]&&self.loginModel.user_name==nil) {
                
                self.loginModel.user_name=string;
                //        NSLog(@"%@",self.student.age);
                
            }
            if ([self.currentElementName isEqualToString:@"user_msisdn"]&&self.loginModel.user_msisdn==nil) {
                
                self.loginModel.user_msisdn=string;
                //        NSLog(@"%@",self.student.age);
                
            }
            if ([self.currentElementName isEqualToString:@"photo_icon_url"]&&self.loginModel.photo_icon_url==nil) {
                
                self.loginModel.photo_icon_url=string;
                //        NSLog(@"%@",self.student.age);
                
            }
            if ([self.currentElementName isEqualToString:@"photo_raw_url"]&&self.loginModel.photo_raw_url==nil) {
                
                self.loginModel.photo_raw_url=string;
                //        NSLog(@"%@",self.student.age);
                
            }
            break;
        default:
            break;
    }
    
    
    

    //NSLog(@"%@",string);
}


//结束某个标签
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"%@",elementName);
    
    

    
}


//结束文档的解析
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    
    NSLog(@"文档解析结束");
    dispatch_async(dispatch_get_main_queue(), ^{
    switch (self.way) {
        case 1:
            //代理把解析出来的数组传出去
            
                if (self.delegate && [self.delegate respondsToSelector:@selector(passdataSendCodeModel:)]) {
                    
                    [self.delegate passdataSendCodeModel:self.sendModel];
                }

            break;
        case 2:
            //代理把解析出来的数组传出去
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(passdataReginModel:)]) {
                    
                    [self.delegate passdataReginModel:self.reginModel];
                }
            
            break;
        case 3:
            //代理把解析出来的数组传出去
                if (self.delegate && [self.delegate respondsToSelector:@selector(passdataLoginModel:)]) {
                    
                    [self.delegate passdataLoginModel:self.loginModel];
                }
            break;
    }
      });
    
}


@end
