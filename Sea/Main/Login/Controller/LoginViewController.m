////
////  LoginViewController.m
////  Login
////
////  Created by 李明丹 on 16/1/11.
////  Copyright © 2016年 李明丹. All rights reserved.
////
//
//#import "LoginViewController.h"
//#import "RegisterViewController.h"
//#import "Reachability.h"
//#import "loginManager.h"
//#import "MBProgressHUD.h"
//#import "LoginUserManager.h"
//#import "DataBase.h"
//#import "SDImageCache.h"
////屏幕的宽度
//#define kScreenWidth [UIScreen mainScreen].bounds.size.width
////屏幕的高度
//#define kScreenHeight [UIScreen mainScreen].bounds.size.height
//@interface LoginViewController ()<UITextFieldDelegate,loginManagerDelegate>
//
////用户名
//@property (nonatomic,strong)UITextField *userTextField;
////密码
//@property (nonatomic,strong)UITextField *passWrodTextField;
////登录
//@property (nonatomic,strong)UIButton *loginButton;
////游客登录
//@property (nonatomic,strong)UIButton *visitorLoginButton;
////忘记密码
//@property (nonatomic,strong)UIButton *forgottenButton;
////用户注册
//@property (nonatomic,strong)UIButton *registerButton;
//@property (nonatomic, retain) MBProgressHUD *mbHUD;
//@property (nonatomic,strong)DataBase *dataBase;
//
//@property (nonatomic,strong)UIView *userVIew;
//@property (nonatomic,strong)UIView *passVIew;
//@end
//
//@implementation LoginViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor whiteColor];
//    [self setImageView];
//    [self setUserAndPassWord];
//    [self setbutton];
//    [self setPasswrodButton];
//    [self recoverKey];
//    
//    
//}
//
////两个imageView
//- (void)setImageView
//{
//    for (int i=0; i<2; i++) {
//        
//        UIView *imageView=[[UIView alloc]initWithFrame:CGRectMake(0, i*(kScreenHeight/2), kScreenWidth, kScreenHeight/2)];
//        if (i==0) {
//            imageView.backgroundColor=[UIColor colorWithRed:0.113 green:0.588 blue:0.925 alpha:1];
//            
//        }else{
//            imageView.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
//    
//        }
//        
//        [self.view addSubview:imageView];
//        
//    }
//    
//    UIImageView *titleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,kScreenHeight/2/5, kScreenWidth, kScreenHeight/2/5*2)];
//    titleImage.image=[UIImage imageNamed:@"login_logo2_02.png"];
//    [self.view addSubview:titleImage];
//    
//}
//
//
////用户名及密码
//- (void)setUserAndPassWord
//{
//    self.userVIew=[[UIView alloc]initWithFrame:CGRectMake(30, kScreenHeight/2/6*5+1, kScreenWidth-60, kScreenHeight/2/6)];
//    self.userVIew.backgroundColor=[UIColor colorWithRed:0.988 green:0.984 blue:0.976 alpha:1];
//    self.userVIew.layer.cornerRadius=2;
//    self.userVIew.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    self.userVIew.layer.borderWidth=1;
//    self.userVIew.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1]);
//    self.userVIew.layer.shadowOffset=CGSizeMake(4, 4);
//    [self.view addSubview:self.userVIew];
//    
//    self.userTextField=[[UITextField alloc]initWithFrame:CGRectMake(38, kScreenHeight/2/6*5+1+3, kScreenWidth-70-6, kScreenHeight/2/6-6)];
//    self.userTextField.backgroundColor=[UIColor colorWithRed:0.988 green:0.984 blue:0.976 alpha:1];
//    self.userTextField.placeholder=@"用户名";
////    self.userTextField.layer.cornerRadius=2;
////    self.userTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
////    self.userTextField.layer.borderWidth=1;
//    self.userTextField.delegate=self;
////    self.userTextField.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1]);
////    self.userTextField.layer.shadowOffset=CGSizeMake(4, 4);
//    
//    [self.view addSubview:self.userTextField];
//    
//    
//    self.passVIew=[[UIView alloc]initWithFrame:CGRectMake(30, kScreenHeight/2-1, kScreenWidth-60, kScreenHeight/2/6)];
//    self.passVIew.backgroundColor=[UIColor colorWithRed:0.988 green:0.984 blue:0.976 alpha:1];
//    self.passVIew.layer.cornerRadius=2;
//    self.passVIew.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    self.passVIew.layer.borderWidth=1;
//    self.passVIew.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1]);
//    self.passVIew.layer.shadowOffset=CGSizeMake(10, 10);
//    [self.view addSubview:self.passVIew];
//    
//    self.passWrodTextField=[[UITextField alloc]initWithFrame:CGRectMake(38, kScreenHeight/2-1+3, kScreenWidth-70-6, kScreenHeight/2/6-6)];
//    self.passWrodTextField.backgroundColor=[UIColor colorWithRed:0.988 green:0.984 blue:0.976 alpha:1];
//    self.passWrodTextField.placeholder=@"密码";
//    self.passWrodTextField.secureTextEntry=YES;
////    self.passWrodTextField.layer.cornerRadius=2;
////    self.passWrodTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
////    self.passWrodTextField.layer.borderWidth=1;
//    self.passWrodTextField.delegate=self;
////    self.passWrodTextField.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1]);
////    self.passWrodTextField.layer.shadowOffset=CGSizeMake(10, 10);
//    
//    [self.view addSubview:self.passWrodTextField];
//    
//
//
//}
//
//
////设置登录按键
//- (void)setbutton{
//
//    self.loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    self.loginButton.backgroundColor=[UIColor colorWithRed:0.233 green:0.454 blue:0.976 alpha:1];
//    self.loginButton.frame=CGRectMake((kScreenWidth-(kScreenWidth-30)/2)/2, kScreenHeight/2+kScreenHeight/2/6+50,(kScreenWidth-30)/2, kScreenHeight/2/6-5);
//    self.loginButton.layer.cornerRadius=5;
//    self.loginButton.layer.borderWidth=1;
//    self.loginButton.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
////    self.loginButton.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor redColor]);
////    self.loginButton.layer.shadowOffset=CGSizeMake(2, 4);
//    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
//    self.loginButton.tintColor=[UIColor whiteColor];
//    [self.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.loginButton.titleLabel.font=[UIFont systemFontOfSize:18];
//    [self.view addSubview:self.loginButton];
//
//    self.visitorLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    self.visitorLoginButton.backgroundColor=[UIColor colorWithRed:0.233 green:0.454 blue:0.976 alpha:1];
//    self.visitorLoginButton.frame=CGRectMake((kScreenWidth-(kScreenWidth-30)/2)/2, kScreenHeight/2+kScreenHeight/2/6+50+kScreenHeight/2/6-5+kScreenHeight/2/6-25,(kScreenWidth-30)/2, kScreenHeight/2/6-5);
//    self.visitorLoginButton.layer.cornerRadius=5;
//    self.visitorLoginButton.layer.borderWidth=1;
//    self.visitorLoginButton.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
//    [self.visitorLoginButton setTitle:@"游客登录" forState:UIControlStateNormal];
//    self.visitorLoginButton.tintColor=[UIColor whiteColor];
//    [self.visitorLoginButton addTarget:self action:@selector(visitorLoginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.visitorLoginButton.titleLabel.font=[UIFont systemFontOfSize:18];
//    [self.view addSubview:self.visitorLoginButton];
//    
//}
//
////忘记密码及用户注册
//- (void)setPasswrodButton{
//
////    self.forgottenButton=[UIButton buttonWithType:UIButtonTypeCustom];
////    self.forgottenButton.frame=CGRectMake(0, kScreenHeight-40,kScreenWidth/4,30);
////    [self.forgottenButton setTitle:@"忘记密码" forState:UIControlStateNormal];
////    [self.forgottenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    [self.forgottenButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
////    [self.forgottenButton addTarget:self action:@selector(forgottenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
////    self.forgottenButton.titleLabel.font=[UIFont systemFontOfSize:15];
////    self.forgottenButton.titleLabel.textAlignment=NSTextAlignmentLeft;
////    [self.view addSubview:self.forgottenButton];
//    
//    self.registerButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    self.registerButton.frame=CGRectMake(kScreenWidth-kScreenWidth/4, kScreenHeight-40,kScreenWidth/4,30);
//    [self.registerButton setTitle:@"注册用户" forState:UIControlStateNormal];
//     [self.registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.registerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [self.registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.registerButton.titleLabel.font=[UIFont systemFontOfSize:15];
//    self.registerButton.titleLabel.textAlignment=NSTextAlignmentRight;
//    [self.view addSubview:self.registerButton];
//
//
//
//}
//
//
////点击回来键盘
//- (void)recoverKey
//{
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huishou:)];
//    [self.view addGestureRecognizer:tap];
//
//}
//
//
//
//#pragma --mark 方法的实现
////登录点击的方法
//- (void)loginButtonAction:(UIButton *)sender
//{
//
//    //先走网络判断
//    //判断是否有网络
//    BOOL net=[self serachNetWay];
//    
//    if (net) {
//        
//        [[loginManager shareManager] searchFromNetDelegateAction:self way:3 user:self.userTextField.text passWord:self.passWrodTextField.text verificationCode:nil];
//        self.mbHUD = [[MBProgressHUD alloc] initWithView:self.view];
//        [self.view addSubview:self.mbHUD];
//        [self.mbHUD show:YES];
//        self.mbHUD.labelText = @"正在登录中";
//        //self.mbHUD.detailsLabelText = @"正在登录中";
//        self.mbHUD.dimBackground = YES;
//        
//    }
//  
//
//}
//
////协议传回来的值
//- (void)passdataLoginModel:(loginOrReginModel *)model
//{
//    // 数据回来之后让mb消失
//    [self.mbHUD hide:YES];
//   
//    NSString *errorStr;
//    
//    if (model==nil) {
//        errorStr=@"网络超时";
//        
//    }else if(![model.error_string isEqualToString:@""]) {
//        
//        errorStr=model.error_string;
//       
//    }
//    
//    if (model.error_code==nil&&model!=nil) {
//        
//        UIAlertController *alertControl3=[UIAlertController alertControllerWithTitle:@"恭喜" message:model.login_result_msg preferredStyle:UIAlertControllerStyleAlert];
//        
//        [self presentViewController:alertControl3 animated:YES completion:nil];
//        
//        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loginAction) userInfo:self repeats:NO];
//        
//        //将用户数据存到数据库中
//        NSMutableArray *userArray=[NSMutableArray array];
//        userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
//        loginOrReginModel *userMessage = userArray.lastObject;
//        if (userArray.count > 0) {
//            
//            if (![userMessage.user_msisdn isEqualToString:model.user_msisdn]) {
//                //文件的路径是文件夹的路径+文件名
//                
//                NSFileManager *fileManager=[NSFileManager defaultManager];
//                NSString *document1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//                NSString *filePath1 = [document1 stringByAppendingPathComponent:@"UnitDataBase.db"];
//                [fileManager removeItemAtPath:filePath1 error:NULL];
//                
//                NSString *filePath2 = [document1 stringByAppendingPathComponent:@"ABDataBase.db"];
//                [fileManager removeItemAtPath:filePath2 error:NULL];
//                
//                NSString *filePath3= [document1 stringByAppendingPathComponent:@"VideoDataBase.db"];
//                [fileManager removeItemAtPath:filePath3 error:NULL];
//                
//                NSString *filePath4 = [document1 stringByAppendingPathComponent:@"UserDataBase.db"];
//                [fileManager removeItemAtPath:filePath4 error:NULL];
//                
//                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//                [user setObject:@"" forKey:@"请填写收货姓名"];
//                [user setObject:@"" forKey:@"请输入手机号码"];
//                [user setObject:@"" forKey:@"请填写配送地址"];
//                //清楚缓存
//                [[SDImageCache sharedImageCache] clearDisk];
//                [[SDImageCache sharedImageCache] clearMemory];
//                
//            }
//            
//            NSString *modifyString = [NSString stringWithFormat:@"UPDATE loginUser SET user_account_uid = '%@',  user_name='%@', user_msisdn='%@', photo_icon_url='%@', photo_raw_url='%@'", model.user_account_uid, model.user_name, model.user_msisdn, model.photo_icon_url, model.photo_raw_url];
//            [LoginUserManager modifyData:modifyString];
//            
//        } else {
//            //文件的路径是文件夹的路径+文件
//            
//            [LoginUserManager insertModal:model];
//        }
//        
//    }else{
//        
//        UIAlertController *alertControll1=[UIAlertController alertControllerWithTitle:@"提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
//        
////        UIAlertAction *alertAction1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
////        
////        [alertControll1 addAction:alertAction1];
//        
//        [self presentViewController:alertControll1 animated:YES completion:nil];
//        
//        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:self repeats:NO];
//    }
//    
//}
//
//
////判断有没有网络的方法,
//- (BOOL)serachNetWay
//{
//    Reachability *reachAbility = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    NSInteger stateNet = [reachAbility currentReachabilityStatus];
//    
//    if (stateNet == 0) {
//        
//        UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:@"提示" message:@"网络没有连接,请先连接网络" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *alertAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        
//        [alertControll addAction:alertAction];
//        
//        [self presentViewController:alertControll animated:YES completion:nil];
//        
//        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:self repeats:NO];
//        
//        return NO;
//    }else{
//        
//    
//        return YES;
//    }
//}
//
//
//
////游客登录的方法
//- (void)visitorLoginButtonAction:(UIButton *)sender
//{
//    NSMutableArray *userArray=[NSMutableArray array];
//    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
//    loginOrReginModel *userMessage = userArray.lastObject;
//    
//    if (userMessage.user_msisdn.length>0) {
//        
//        NSFileManager *fileManager=[NSFileManager defaultManager];
//        NSString *document1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//        NSString *filePath1 = [document1 stringByAppendingPathComponent:@"UnitDataBase.db"];
//        [fileManager removeItemAtPath:filePath1 error:NULL];
//        
//        NSString *filePath2 = [document1 stringByAppendingPathComponent:@"ABDataBase.db"];
//        [fileManager removeItemAtPath:filePath2 error:NULL];
//        
//        NSString *filePath3= [document1 stringByAppendingPathComponent:@"VideoDataBase.db"];
//        [fileManager removeItemAtPath:filePath3 error:NULL];
//        
//        NSString *filePath4 = [document1 stringByAppendingPathComponent:@"UserDataBase.db"];
//        [fileManager removeItemAtPath:filePath4 error:NULL];
//        
//        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//        [user setObject:@"" forKey:@"请填写收货姓名"];
//        [user setObject:@"" forKey:@"请输入手机号码"];
//        [user setObject:@"" forKey:@"请填写配送地址"];
//        //清楚缓存
//        [[SDImageCache sharedImageCache] clearDisk];
//        [[SDImageCache sharedImageCache] clearMemory];
//
//    }
//    
//    //清空用户信息
//    NSString *modifyString = [NSString stringWithFormat:@"UPDATE loginUser SET user_account_uid = '',  user_name='', user_msisdn='', photo_icon_url='', photo_raw_url=''"];
//    [LoginUserManager modifyData:modifyString];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    NSNotificationCenter *notiCenter=[NSNotificationCenter defaultCenter];
//    [notiCenter postNotificationName:@"帅哥" object:self userInfo:nil];
//    
//}
//
////忘记密码
//- (void)forgottenButtonAction:(UIButton *)sender
//{
//    RegisterViewController *rigVC=[[RegisterViewController alloc]init];
//    UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:rigVC];
//    rigVC.titles=@"忘记密码";
//    
//    [self presentViewController:navi animated:YES completion:nil];
//    
//    
//}
//
////用户注册
//- (void)registerButtonAction:(UIButton *)sender
//{
//    RegisterViewController *regVC=[[RegisterViewController alloc]init];
//    UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:regVC];
//    regVC.titles=@"注册";
//    
//    [self presentViewController:navi animated:YES completion:nil];
//
//}
//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//
//    [textField resignFirstResponder];
//    return YES;
//}
//
////点击回收的方法
//- (void)huishou:(UITapGestureRecognizer *)tap
//{
//
//     [self.view endEditing:YES];
//}
//
////一秒后自己消失
//- (void)time{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}
//
//
////登录成功后
//- (void)loginAction
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    //通知中心
//    NSNotificationCenter *notiCenter=[NSNotificationCenter defaultCenter];
//    [notiCenter postNotificationName:@"帅哥" object:self userInfo:nil];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
////只支持竖屏
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait ;
//}
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//
////适配在5s以下的能在输入用户名的时候上升
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//
//{
//    //判断当屏幕的高度是5的时候
//
//    CGFloat number5=570;
//    if ([UIScreen mainScreen].bounds.size.height<number5) {
//        
//        //iPhone键盘高度216，iPad的为352
//        [UIView animateWithDuration:0.1 animations:^{
//            
//            // 设置view弹出来的位置
//            self.userVIew.frame=CGRectMake(30, kScreenHeight-216-kScreenHeight/2/6*3, kScreenWidth-60,kScreenHeight/2/6);
//            self.userTextField.frame=CGRectMake(38, kScreenHeight-216-kScreenHeight/2/6*3+3, kScreenWidth-76,kScreenHeight/2/6-6);
//            self.passVIew.frame=CGRectMake(30, kScreenHeight-216-kScreenHeight/2/6*2, kScreenWidth-60, kScreenHeight/2/6);
//            self.passWrodTextField.frame=CGRectMake(38, kScreenHeight-216-kScreenHeight/2/6*2+3, kScreenWidth-76, kScreenHeight/2/6-6);
//            
//        }];
//    }
//}
//
//
//
//
//
////输入框编辑完成以后，将视图恢复到原始状态
//
//-(void)textFieldDidEndEditing:(UITextField *)textField
//
//{
//    CGFloat number5=570;
//    if ([UIScreen mainScreen].bounds.size.height<number5) {
//    
//    [UIView animateWithDuration:0.1 animations:^{
//        
//        self.userVIew.frame=CGRectMake(30, kScreenHeight/2/6*5+1, kScreenWidth-60, kScreenHeight/2/6);
//        self.userTextField.frame=CGRectMake(38, kScreenHeight/2/6*5+1+3, kScreenWidth-76, kScreenHeight/2/6-6);
//        self.passVIew.frame=CGRectMake(30, kScreenHeight/2-1, kScreenWidth-60, kScreenHeight/2/6);
//        self.passWrodTextField.frame=CGRectMake(38, kScreenHeight/2-1+3, kScreenWidth-76, kScreenHeight/2/6-6);
//        
//    }];
//    
//    }
//}
//
//
//
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}
//
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
