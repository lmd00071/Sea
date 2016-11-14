//
//  AppDelegate.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/1/18.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "AppDelegate.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyBookViewController.h"
#import "NewLoginViewController.h"
#import "CustomNavigationController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
@interface AppDelegate ()<WXApiDelegate>


@property (nonatomic,strong)MyBookViewController *mbVC;
@property (nonatomic,strong)CustomNavigationController *navi;
@end

@implementation AppDelegate



- (void)startServer
{
    // Start the server (and check for problems)
    
    NSError *error;
    if([httpServer start:&error])
    {
        NSLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
    }
    else
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    // Configure our logging framework.
    // To keep things simple and fast, we're just going to log to the Xcode console.
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Create server using our custom MyHTTPServer class
    httpServer = [[HTTPServer alloc] init];
    
    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [httpServer setType:@"_http._tcp."];
    
    // Normally there's no need to run our server on any specific port.
    // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
    // However, for easy testing you may want force a certain port so you can just hit the refresh button.
    [httpServer setPort:12345];
    
    // Serve files from our embedded Web folder
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:webPath])
    {
        [fileManager createDirectoryAtPath:webPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [httpServer setDocumentRoot:webPath];
    
    [self startServer];

    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    if (userMessage.user_msisdn.length>0) {
        
        self.mbVC=[[MyBookViewController alloc]init];
        self.navi=[[CustomNavigationController alloc]initWithRootViewController:self.mbVC];
        self.window.rootViewController=self.navi;
 
    }else{
        NewLoginViewController *loginVC=[[NewLoginViewController alloc]init];
        self.window.rootViewController=loginVC;
    }
    
    
    NSNotificationCenter *notiCenter=[NSNotificationCenter defaultCenter];
    
    //参数1:观察者
    //参数2:收到消息的时候执行方法,带一个NSNotification类型的参数,就是别的对象发送通知
    //参数3:想接收的消息的名字
    //参数4:想接收谁发的消息
    [notiCenter addObserver:self selector:@selector(recieveNotification:) name:@"帅哥" object:nil];
    

    //微信测试APPID : wxb4ba3c02aa476ea1
    
    // 1.导入微信支付SDK,注册微信支付
    
    // 2.设置微信APPID为URL Schemes
    
    // 3.发起支付.调用微信支付
    
    // 4.处理支付结果
    //wxb4ba3c02aa476ea1
    [WXApi registerApp:@"wx9d99111f9f808c34" withDescription:@"haiyan"];
    
    return YES;

}
//支付宝





// 微信支付成功或者失败回调
- (void)onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

//支付宝返回的方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            if ([resultDic[@"memo"] isEqualToString:@""]) {
                NSString * strMsg = [NSString stringWithFormat:@"支付结果：支付成功"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
          NSString * strMsg = [NSString stringWithFormat:@"支付结果：支付失败,%@", resultDic[@"memo"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            }
        }];
    }
    
    
    [WXApi handleOpenURL:url delegate:self];
    
    return  YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([resultDic[@"memo"] isEqualToString:@""]) {
                NSString * strMsg = [NSString stringWithFormat:@"支付结果：支付成功"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                NSString * strMsg = [NSString stringWithFormat:@"支付结果：支付失败,%@", resultDic[@"memo"]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
    
    [WXApi handleOpenURL:url delegate:self];
    
    return YES;
    
}


//通知回来的方法
- (void)recieveNotification:(NSNotification *)noti
{
    
    self.mbVC=[[MyBookViewController alloc]init];
    self.navi=[[CustomNavigationController alloc]initWithRootViewController:self.mbVC];
    self.window.rootViewController=self.navi;
    
}

- (void)dealloc
{
    
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"帅哥" object:nil];
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
