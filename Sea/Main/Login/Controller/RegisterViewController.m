////
////  RegisterViewController.m
////  Login
////
////  Created by 李明丹 on 16/1/12.
////  Copyright © 2016年 李明丹. All rights reserved.
////
//
//#import "RegisterViewController.h"
//#import "loginManager.h"
//#import "MBProgressHUD.h"
//#import "Reachability.h"
//#import "SDImageCache.h"
////屏幕的宽度
//#define kScreenWidth [UIScreen mainScreen].bounds.size.width
////屏幕的高度
//#define kScreenHeight [UIScreen mainScreen].bounds.size.height
//@interface RegisterViewController ()<UITextFieldDelegate,loginManagerDelegate>
////头上面的相框
//@property (nonatomic,strong)UIImageView *titleImageView;
////请输入手机号
//@property(nonatomic,strong)UITextField *phoneTextField;
////请输入验证码
//@property(nonatomic,strong)UITextField *codeTextField;
////发送验证码的按键
//@property (nonatomic,strong)UIButton *sendButton;
////倒计时
//@property (nonatomic,assign)NSInteger num;
////请输入密码
//@property(nonatomic,strong)UITextField *passWordTextField;
////请出入新的密码
//@property(nonatomic,strong)UITextField *NewPassWordTextField;
////请输入确认密码
//@property(nonatomic,strong)UITextField *tuerNewPassWordTextField;
////Button点击的按键
//@property (nonatomic,strong)UIButton *button;
//@property (nonatomic, retain) MBProgressHUD *mbHUD;
//@end
//
//@implementation RegisterViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor whiteColor];
//    
//    //设置导航栏
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = self.titles;
//    title.font=[UIFont systemFontOfSize:20];
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
//    
//    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.113 green:0.588 blue:0.925 alpha:1];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
//    //设置成导航栏下面开始计算
//    self.navigationController.navigationBar.translucent = NO;
//    
//    [self setTextLabel];
//    [self recoverKey];
//    
//}
//
////设置手机号等的布局
//- (void)setTextLabel
//{
//    //判断当屏幕的高度是6P的时候
//    CGFloat m=700;
//    CGFloat n;
//    if ([UIScreen mainScreen].bounds.size.height>m) {
//        
//        n=[UIScreen mainScreen].bounds.size.height-(20+64);
//        
//    }else
//    {
//        
//        n=[UIScreen mainScreen].bounds.size.height-(20+44);
//    }
//    
//    self.titleImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 30,kScreenWidth, n/3/2+18)];
//    self.titleImageView.image=[UIImage imageNamed:@"login_logo2_03.png"];
//    [self.view addSubview:self.titleImageView];
//    self.phoneTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, n/3, kScreenWidth-20,n/3/4)];
//    self.phoneTextField.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
//    self.phoneTextField.placeholder=@"  请输入手机号码";
//    self.phoneTextField.layer.cornerRadius=2;
//    self.phoneTextField.delegate=self;
//    self.phoneTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    self.phoneTextField.layer.borderWidth=1;
////    self.phoneTextField.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1]);
////    self.phoneTextField.layer.shadowOffset=CGSizeMake(4, 4);
//    
//    [self.view addSubview:self.phoneTextField];
//    
//    //验证码
////    self.codeTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, n/3+n/3/4-3, (kScreenWidth-20)/2,n/3/4)];
////    self.codeTextField.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
////    self.codeTextField.placeholder=@"  请输入验证码";
////    self.codeTextField.layer.cornerRadius=2;
////    self.codeTextField.delegate=self;
////    self.codeTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
////    self.codeTextField.layer.borderWidth=1;
//////    self.codeTextField.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1]);
//////    self.codeTextField.layer.shadowOffset=CGSizeMake(4, 4);
////    
////    [self.view addSubview:self.codeTextField];
////    
////    
////    self.sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
////    self.sendButton.backgroundColor=[UIColor colorWithRed:0.717 green:0.725 blue:0.721 alpha:1];
////    self.sendButton.frame=CGRectMake(10+(kScreenWidth-20)/2, n/3+n/3/4-3, (kScreenWidth-20)/2,n/3/4);
////    self.sendButton.layer.cornerRadius=2;
////    self.sendButton.layer.borderColor=[[UIColor lightGrayColor]CGColor];
////    self.sendButton.layer.borderWidth=1;
////    [self.sendButton setTitle:@"点击获取验证码" forState:UIControlStateNormal];
////    [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    [self.sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
////    self.sendButton.titleLabel.font=[UIFont systemFontOfSize:15];
////    [self.view addSubview:self.sendButton];
//    
//    
//    if ([self.titles isEqualToString:@"注册"]) {
//        
//    self.passWordTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, n/3+n/3/4-3,kScreenWidth-20,n/3/4)];
//    self.passWordTextField.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
//    self.passWordTextField.placeholder=@"  请输入密码";
//    self.passWordTextField.layer.cornerRadius=2;
//    self.passWordTextField.delegate=self;
//    self.passWordTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    self.passWordTextField.layer.borderWidth=1;
////    self.passWordTextField.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1]);
////    self.passWordTextField.layer.shadowOffset=CGSizeMake(4, 4);
//    
//    [self.view addSubview:self.passWordTextField];
//        
//        
//    
//    }
//    
//    if ([self.titles isEqualToString:@"忘记密码"]) {
//        
//    self.NewPassWordTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, n/3+n/3/4-3,kScreenWidth-20,n/3/4)];
//    self.NewPassWordTextField.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
//    self.NewPassWordTextField.placeholder=@"  请输入新的密码";
//    self.NewPassWordTextField.layer.cornerRadius=2;
//    self.NewPassWordTextField.delegate=self;
//    self.NewPassWordTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    self.NewPassWordTextField.layer.borderWidth=1;
////    self.NewPassWordTextField.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1]);
////    self.NewPassWordTextField.layer.shadowOffset=CGSizeMake(4, 4);
//    
//    [self.view addSubview:self.NewPassWordTextField];
//    
//     }
//    
//    self.tuerNewPassWordTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, n/3+n/3/4*2-6,kScreenWidth-20,n/3/4)];
//    self.tuerNewPassWordTextField.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
//    self.tuerNewPassWordTextField.placeholder=@"  确认密码";
//    self.tuerNewPassWordTextField.layer.cornerRadius=2;
//    self.tuerNewPassWordTextField.delegate=self;
//    self.tuerNewPassWordTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    self.tuerNewPassWordTextField.layer.borderWidth=1;
////    self.tuerNewPassWordTextField.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1]);
////    self.tuerNewPassWordTextField.layer.shadowOffset=CGSizeMake(4, 4);
//    
//    [self.view addSubview:self.tuerNewPassWordTextField];
//    //注册或者修改密码的按键
//    self.button=[UIButton buttonWithType:UIButtonTypeCustom];
//    self.button.backgroundColor=[UIColor colorWithRed:0.878 green:0.122 blue:0.282 alpha:1];
//    
//    self.button.layer.cornerRadius=5;
//    self.button.layer.borderColor=[[UIColor clearColor]CGColor];
//    self.button.layer.borderWidth=1;
//    self.button.titleLabel.font=[UIFont systemFontOfSize:20];
//    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.button];
//    
//    if ([self.titles isEqualToString:@"注册"]) {
//        
//        self.button.frame=CGRectMake(30, n/3+n/3/4*4-6+20,kScreenWidth-60,n/3/4);
//        [self.button setTitle:@"注册" forState:UIControlStateNormal];
//    }else{
//        self.button.frame=CGRectMake(30, n/3+n/3/4*5-9, kScreenWidth-60,n/3/4);
//        [self.button setTitle:@"修改密码" forState:UIControlStateNormal];
//    
//    }
//}
//
////点击回来键盘
//- (void)recoverKey
//{
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huishou:)];
//    [self.view addGestureRecognizer:tap];
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
//#pragma --mark 方法
////点击左侧的按键的方法
//- (void)leftBarButtonAction:(UIBarButtonItem *)sender
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//}
//
//
//
////发送验证码协议传回来的值
//- (void)passdataSendCodeModel:(loginOrReginModel *)model
//{
////    // 数据回来之后让mb消失
////    [self.mbHUD hide:YES];
////    
////    NSString *errorStr=model.error_string;
////    if (model.error_code==nil) {
////        
////        UIAlertController *alertControll2=[UIAlertController alertControllerWithTitle:@"提示" message:@"发送成功" preferredStyle:UIAlertControllerStyleAlert];
////        
//////        UIAlertAction *alertAction2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
////        
////       // [alertControll2 addAction:alertAction2];
////        
////        [self presentViewController:alertControll2 animated:YES completion:nil];
////        
////        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:self repeats:NO];
////        
////    }else{
////        
////        UIAlertController *alertControll1=[UIAlertController alertControllerWithTitle:@"提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
////        
////        //UIAlertAction *alertAction1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
////        
////        //[alertControll1 addAction:alertAction1];
////        
////        [self presentViewController:alertControll1 animated:YES completion:nil];
////        
////        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:self repeats:NO];
////    }
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
//        //UIAlertAction *alertAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        
//        //[alertControll addAction:alertAction];
//        
//        [self presentViewController:alertControll animated:YES completion:nil];
//        
//        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:self repeats:NO];
//        
//        return NO;
//    }else{
//        
//        
//        
//        return YES;
//    }
//}
//
////- (void)buttonSengCode
////{
////    self.num--;
////    if (self.num<0) {
////        self.sendButton.userInteractionEnabled=YES;
////        [self.sendButton setTitle:@"点击获取验证码" forState:UIControlStateNormal];
////        //[self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////        return;
////        
////    }else{
////        NSString *titleNumber=[NSString stringWithFormat:@"有效时内%ld", self.num];
////       [self.sendButton setTitle:titleNumber forState:UIControlStateNormal];
////       //[self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////       
////    }
////
////}
//
//- (void)buttonAction:(UIButton *)sender
//{
//    if ([self.titles isEqualToString:@"注册"]) {
//        
//        if ([self.phoneTextField.text isEqualToString:@""]||[self.passWordTextField.text isEqualToString:@""]||[self.tuerNewPassWordTextField.text isEqualToString:@""]) {
//            
//            [SVProgressHUD showErrorWithStatus:@"请全部填写"];
//            return;
//        }
//        if (![self.passWordTextField.text isEqualToString:self.tuerNewPassWordTextField.text]) {
//            
//            [SVProgressHUD showErrorWithStatus:@"您的两次密码输入不一致!"];
//            
//            return;
//        }
//        //先走网络判断
//        //判断是否有网络
//        BOOL net=[self serachNetWay];
//        
//        if (net) {
//         //注册
//                [[loginManager shareManager] searchFromNetDelegateAction:self way:2 user:self.phoneTextField.text passWord:self.passWordTextField.text verificationCode:nil];
//                self.mbHUD = [[MBProgressHUD alloc] initWithView:self.view];
//                [self.view addSubview:self.mbHUD];
//                [self.mbHUD show:YES];
//                self.mbHUD.labelText = @"正在注册中";
//                //self.mbHUD.detailsLabelText = @"正在注册中";
//                self.mbHUD.dimBackground = YES;
//                
//        }else{
//        
//            [SVProgressHUD showErrorWithStatus:@"网络不可用"];
//        }
//        
//        
//    }else{
//    
//         //忘记密码
//        
//        
//    
//    }
//
//}
//
// //注册回来的方法
//- (void)passdataReginModel:(loginOrReginModel *)model
//{
//
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
//    if (model.error_code==nil&&model!=nil) {
//        
//        [[loginManager shareManager] searchFromNetDelegateAction:self way:3 user:self.phoneTextField.text passWord:self.passWordTextField.text verificationCode:nil];
//        
//        
////        [self dismissViewControllerAnimated:YES completion:nil];
////        //通知中心
////        NSNotificationCenter *notiCenter=[NSNotificationCenter defaultCenter];
////        [notiCenter postNotificationName:@"帅哥" object:self userInfo:nil];
//        
//        
//    }else{
//        
//        UIAlertController *alertControll1=[UIAlertController alertControllerWithTitle:@"提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
//        
//        //UIAlertAction *alertAction1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        
//        //[alertControll1 addAction:alertAction1];
//        
//        [self presentViewController:alertControll1 animated:YES completion:nil];
//        
//        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:self repeats:NO];
//        return;
//    }
//
//}
//
//
//
////注册成功后登录
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
//        UIAlertController *alertControl3=[UIAlertController alertControllerWithTitle:@"恭喜" message:@"注册成功。建议进一步完善您的个人资料" preferredStyle:UIAlertControllerStyleAlert];
//        
//        [self presentViewController:alertControl3 animated:YES completion:nil];
//        
//        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loginAction) userInfo:self repeats:NO];
//        
//        //文件的路径是文件夹的路径+文件名
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
//        //将用户数据存到数据库中
//        NSMutableArray *userArray=[NSMutableArray array];
//        userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
//        if (userArray.count > 0) {
//            NSString *modifyString = [NSString stringWithFormat:@"UPDATE loginUser SET user_account_uid = '%@',  user_name='%@', user_msisdn='%@', photo_icon_url='%@', photo_raw_url='%@'", model.user_account_uid, model.user_name, model.user_msisdn, model.photo_icon_url, model.photo_raw_url];
//            [LoginUserManager modifyData:modifyString];
//            
//        } else {
//            [LoginUserManager insertModal:model];
//        }
//        
//    }else{
//        
//        UIAlertController *alertControll1=[UIAlertController alertControllerWithTitle:@"提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
//        
//        //        UIAlertAction *alertAction1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        //
//        //        [alertControll1 addAction:alertAction1];
//        
//        [self presentViewController:alertControll1 animated:YES completion:nil];
//        
//        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:self repeats:NO];
//    }
//    
//}
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
////点击回收的方法
//- (void)huishou:(UITapGestureRecognizer *)tap
//{
//    [self.view endEditing:YES];
//}
//
////秒后自己消失
//- (void)time{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
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
//{CGFloat m=700;
//    CGFloat n;
//    if ([UIScreen mainScreen].bounds.size.height>m) {
//        
//        n=[UIScreen mainScreen].bounds.size.height-(20+64);
//        
//    }else
//    {
//        
//        n=[UIScreen mainScreen].bounds.size.height-(20+44);
//    }
//    //判断当屏幕的高度是5的时候
//    
//    CGFloat number6=670;
//    if ([UIScreen mainScreen].bounds.size.height<number6) {
//        
//        //iPhone键盘高度216，iPad的为352
//        [UIView animateWithDuration:0.1 animations:^{
//            
//            self.phoneTextField.frame=CGRectMake(10, kScreenHeight-216-n/3/4*7, kScreenWidth-20,n/3/4);
//            if ([self.titles isEqualToString:@"注册"]) {
//                
//                self.passWordTextField.frame=CGRectMake(10, kScreenHeight-216-n/3/4*6,kScreenWidth-20,n/3/4);
//                
//            }else{
//                
//                self.NewPassWordTextField.frame=CGRectMake(10, kScreenHeight-216-n/3/4*6,kScreenWidth-20,n/3/4);
//            }
//            self.tuerNewPassWordTextField.frame=CGRectMake(10, kScreenHeight-216-n/3/4*5,kScreenWidth-20,n/3/4);
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
//{
//    CGFloat m=700;
//    CGFloat n;
//    if ([UIScreen mainScreen].bounds.size.height>m) {
//        
//        n=[UIScreen mainScreen].bounds.size.height-(20+64);
//        
//    }else
//    {
//        
//        n=[UIScreen mainScreen].bounds.size.height-(20+44);
//    }
//    
//    CGFloat number6=670;
//    if ([UIScreen mainScreen].bounds.size.height<number6) {
//        
//        [UIView animateWithDuration:0.1 animations:^{
//            
//            self.phoneTextField.frame=CGRectMake(10, n/3, kScreenWidth-20,n/3/4);
//            if ([self.titles isEqualToString:@"注册"]) {
//                
//                self.passWordTextField.frame=CGRectMake(10, n/3+n/3/4-3,kScreenWidth-20,n/3/4);
//                
//            }else{
//                
//                self.NewPassWordTextField.frame=CGRectMake(10, n/3+n/3/4-3,kScreenWidth-20,n/3/4);
//            }
//             self.tuerNewPassWordTextField.frame=CGRectMake(10, n/3+n/3/4*2-6,kScreenWidth-20,n/3/4);
//            
//        }];
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
