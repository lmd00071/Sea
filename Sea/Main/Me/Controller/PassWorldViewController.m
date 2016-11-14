////
////  PassWorldViewController.m
////  SeaSwallowClassRoom
////
////  Created by 李明丹 on 16/6/7.
////  Copyright © 2016年 李明丹. All rights reserved.
////
//
//#import "PassWorldViewController.h"
//#import "loginManager.h"
//#import "MBProgressHUD.h"
//#import "Reachability.h"
////屏幕的宽度
//#define kScreenWidth [UIScreen mainScreen].bounds.size.width
////屏幕的高度
//#define kScreenHeight [UIScreen mainScreen].bounds.size.height
//@interface PassWorldViewController ()<UITextFieldDelegate,loginManagerDelegate>
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
//@property (nonatomic, strong) BWHttpRequestManager *manager;
//@end
//
//@implementation PassWorldViewController
//
//- (BWHttpRequestManager *)manager
//{
//    if (_manager == nil) {
//        BWHttpRequestManager *manager = [[BWHttpRequestManager alloc] init];
//        _manager = manager;
//    }
//    return _manager;
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor whiteColor];
//    //设置导航栏
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"修改密码";
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
//    self.phoneTextField.placeholder=@"  请输入原密码";
//    self.phoneTextField.layer.cornerRadius=2;
//    self.phoneTextField.delegate=self;
//    self.phoneTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    self.phoneTextField.layer.borderWidth=1;
//    //    self.phoneTextField.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1]);
//    //    self.phoneTextField.layer.shadowOffset=CGSizeMake(4, 4);
//    
//    [self.view addSubview:self.phoneTextField];
//    
//
//        self.NewPassWordTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, n/3+n/3/4-3,kScreenWidth-20,n/3/4)];
//        self.NewPassWordTextField.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
//        self.NewPassWordTextField.placeholder=@"  请输入新的密码";
//        self.NewPassWordTextField.layer.cornerRadius=2;
//        self.NewPassWordTextField.delegate=self;
//        self.NewPassWordTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//        self.NewPassWordTextField.layer.borderWidth=1;
//        //    self.NewPassWordTextField.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1]);
//        //    self.NewPassWordTextField.layer.shadowOffset=CGSizeMake(4, 4);
//        
//        [self.view addSubview:self.NewPassWordTextField];
//        
//        
//        self.tuerNewPassWordTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, n/3+n/3/4*2-6,kScreenWidth-20,n/3/4)];
//        self.tuerNewPassWordTextField.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
//        self.tuerNewPassWordTextField.placeholder=@"  确认密码";
//        self.tuerNewPassWordTextField.layer.cornerRadius=2;
//        self.tuerNewPassWordTextField.delegate=self;
//        self.tuerNewPassWordTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//        self.tuerNewPassWordTextField.layer.borderWidth=1;
//        //    self.tuerNewPassWordTextField.layer.shadowColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1]);
//        //    self.tuerNewPassWordTextField.layer.shadowOffset=CGSizeMake(4, 4);
//        
//        [self.view addSubview:self.tuerNewPassWordTextField];
//        
//   
//
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
//    self.button.frame=CGRectMake(30, n/3+n/3/4*5-9, kScreenWidth-60,n/3/4);
//    [self.button setTitle:@"修改密码" forState:UIControlStateNormal];
//
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
//    [self.navigationController popViewControllerAnimated:YES];
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
//
//
//- (void)buttonAction:(UIButton *)sender
//{
//    if ([self.phoneTextField.text isEqualToString:@""]||[self.NewPassWordTextField.text isEqualToString:@""]||[self.tuerNewPassWordTextField.text isEqualToString:@""]) {
//        
//        [SVProgressHUD showErrorWithStatus:@"请全部填写"];
//        return;
//    }
//    if (![self.NewPassWordTextField.text isEqualToString:self.tuerNewPassWordTextField.text]) {
//        
//        [SVProgressHUD showErrorWithStatus:@"您的两次密码输入不一致!"];
//        
//        return;
//    }
//    //先走网络判断
//    //判断是否有网络
//    BOOL net=[self serachNetWay];
//    if (net) {
//        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//       
//        parameter[@"trans_code"] = @"user_modify_psw";
//        parameter[@"old_password"] = self.phoneTextField.text;
//        parameter[@"new_password"] = self.NewPassWordTextField.text;
//  
//        [self.manager httpRequestManagerSetupRequestWithParametersDictionary:parameter action:@"" actionParameter:@"" hasParameter:NO dataBlock:^(NSDictionary *dict) {
//            //发送验证码失败
//            if (dict[@"error_code"]) {
//                //回到主线程刷新数据
//                dispatch_async(dispatch_get_main_queue(), ^{
//                //[SVProgressHUD dismiss];
//                [SVProgressHUD showErrorWithStatus:dict[@"error_string"]];
//                });
//                
//                
//            } else {  //发送验证码成功,
//                dispatch_async(dispatch_get_main_queue(), ^{
//                //[SVProgressHUD dismiss];
//                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//               // [self.navigationController popViewControllerAnimated:YES];
//                });
//                
//            }
//        }];
//
//    }else{
//    
//             [SVProgressHUD showErrorWithStatus:@"请先检查网络"];
//    }
//    
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
//            self.NewPassWordTextField.frame=CGRectMake(10, kScreenHeight-216-n/3/4*6,kScreenWidth-20,n/3/4);
//            self.tuerNewPassWordTextField.frame=CGRectMake(10, kScreenHeight-216-n/3/4*5,kScreenWidth-20,n/3/4);
//                
//        
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
//            self.NewPassWordTextField.frame=CGRectMake(10, n/3+n/3/4-3,kScreenWidth-20,n/3/4);
//            self.tuerNewPassWordTextField.frame=CGRectMake(10, n/3+n/3/4*2-6,kScreenWidth-20,n/3/4);
//         
//            
//        }];
//        
//    }
//}
//
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}
//
//@end
