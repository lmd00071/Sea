//
//  NewRegisterViewController.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/7/13.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "NewRegisterViewController.h"
#import "loginManager.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "SDImageCache.h"
@interface NewRegisterViewController ()<UITextFieldDelegate,loginManagerDelegate>
/*logo的高度*/
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoHeight;
/*logo距离顶部的距离*/
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoTop;
/*下面第一个view距离logo的距离*/
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoFofBottom;
/*中间视图的高度*/
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subViewHeight;
/*输入框及按键的高度*/
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
/*手机*/
@property (strong, nonatomic) IBOutlet UIView *phoneView;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
/*密码*/
@property (strong, nonatomic) IBOutlet UIView *passWorldView;
@property (strong, nonatomic) IBOutlet UITextField *passWorldTextField;
/*再密码*/
@property (strong, nonatomic) IBOutlet UIView *agianPassWorldView;
@property (strong, nonatomic) IBOutlet UITextField *agianPassWorldTextField;
/*注册*/
@property (strong, nonatomic) IBOutlet UIButton *registButton;
/*忘记密码*/
@property (strong, nonatomic) IBOutlet UIButton *forgeButton;

@property (nonatomic, retain) MBProgressHUD *mbHUD;
@property (nonatomic, strong) BWHttpRequestManager *manager;
@end

@implementation NewRegisterViewController

- (BWHttpRequestManager *)manager
{
    if (_manager == nil) {
        BWHttpRequestManager *manager = [[BWHttpRequestManager alloc] init];
        _manager = manager;
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //设置导航栏
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = self.titles;
    title.font=[UIFont systemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.113 green:0.588 blue:0.925 alpha:1];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    //设置成导航栏下面开始计算
    self.navigationController.navigationBar.translucent = NO;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huishou:)];
    [self.view addGestureRecognizer:tap];

    //设置信息
    [self setInf];
}

- (void)setInf{
    
    self.phoneTextField.delegate=self;
    self.passWorldTextField.delegate=self;
    self.agianPassWorldTextField.delegate=self;
    
    self.passWorldTextField.secureTextEntry=YES;
    self.agianPassWorldTextField.secureTextEntry=YES;
//    self.phoneView.layer.borderWidth=1;
//    self.phoneView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    
//    self.passWorldView.layer.borderWidth=1;
//    self.passWorldView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    
//    self.agianPassWorldView.layer.borderWidth=1;
//    self.agianPassWorldView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    
    
    //判断当屏幕的高度是6P的时候
    CGFloat number6p=736;
    CGFloat number6=667;
    CGFloat number5=568;
    CGFloat number4=480;
    if ([UIScreen mainScreen].bounds.size.height>=number6p) {
        
        self.logoHeight.constant=250;
        self.logoFofBottom.constant=60;
        self.buttonHeight.constant=40;
        self.subViewHeight.constant=250;
    }
    if ([UIScreen mainScreen].bounds.size.height==number6) {
        
        self.logoHeight.constant=220;
        self.logoFofBottom.constant=40;
        self.buttonHeight.constant=40;
        self.subViewHeight.constant=250;
    }
    if ([UIScreen mainScreen].bounds.size.height==number5) {
        
        self.logoHeight.constant=180;
        self.logoFofBottom.constant=30;
        self.buttonHeight.constant=40;
        self.subViewHeight.constant=250;
        
    }
    if ([UIScreen mainScreen].bounds.size.height==number4) {
        
        self.logoHeight.constant=170;
        self.logoFofBottom.constant=10;
        self.buttonHeight.constant=40;
        self.subViewHeight.constant=250;
    }
    
    if ([self.titles isEqualToString:@"注册"]) {
        self.registButton.hidden=NO;
        self.forgeButton.hidden=YES;
        
    }else{
        self.registButton.hidden=YES;
        self.forgeButton.hidden=NO;
        
        self.phoneTextField.secureTextEntry=YES;
        self.phoneTextField.placeholder=@"请输入原密码";
        self.passWorldTextField.placeholder=@"请输入新的密码";
        self.agianPassWorldTextField.placeholder=@"确认密码";
    }
}


//判断有没有网络的方法,
- (BOOL)serachNetWay
{
    Reachability *reachAbility = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NSInteger stateNet = [reachAbility currentReachabilityStatus];
    
    if (stateNet == 0) {
        
        UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:@"提示" message:@"网络没有连接,请先连接网络" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertControll animated:YES completion:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:self repeats:NO];
        
        return NO;
    }else{
        
        
        
        return YES;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

//注册
- (IBAction)registAction:(UIButton *)sender {
    
    if ([self.phoneTextField.text isEqualToString:@""]||[self.passWorldTextField.text isEqualToString:@""]||[self.agianPassWorldTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showErrorWithStatus:@"请全部填写"];
        return;
    }
    if (![self.passWorldTextField.text isEqualToString:self.agianPassWorldTextField.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"您的两次密码输入不一致!"];
        
        return;
    }
    //先走网络判断
    //判断是否有网络
    BOOL net=[self serachNetWay];
    
    if (net) {
        //注册
        [[loginManager shareManager] searchFromNetDelegateAction:self way:2 user:self.phoneTextField.text passWord:self.passWorldTextField.text verificationCode:nil];
        self.mbHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.mbHUD];
        [self.mbHUD show:YES];
        self.mbHUD.labelText = @"正在注册中";
        //self.mbHUD.detailsLabelText = @"正在注册中";
        self.mbHUD.dimBackground = YES;
        
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"网络不可用"];
    }

}

//注册回来的方法
- (void)passdataReginModel:(loginOrReginModel *)model
{
    
    // 数据回来之后让mb消失
    [self.mbHUD hide:YES];
    
    NSString *errorStr;
    
    if (model==nil) {
        errorStr=@"网络超时";
        
    }else if(![model.error_string isEqualToString:@""]) {
        
        errorStr=model.error_string;
        
    }
    if (model.error_code==nil&&model!=nil) {
        
        [[loginManager shareManager] searchFromNetDelegateAction:self way:3 user:self.phoneTextField.text passWord:self.passWorldTextField.text verificationCode:nil];
        
        
        //        [self dismissViewControllerAnimated:YES completion:nil];
        //        //通知中心
        //        NSNotificationCenter *notiCenter=[NSNotificationCenter defaultCenter];
        //        [notiCenter postNotificationName:@"帅哥" object:self userInfo:nil];
        
        
    }else{
        
        UIAlertController *alertControll1=[UIAlertController alertControllerWithTitle:@"提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        
        //UIAlertAction *alertAction1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        //[alertControll1 addAction:alertAction1];
        
        [self presentViewController:alertControll1 animated:YES completion:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:self repeats:NO];
        return;
    }
    
}



//注册成功后登录
//协议传回来的值
- (void)passdataLoginModel:(loginOrReginModel *)model
{
    // 数据回来之后让mb消失
   
    NSString *errorStr;
    
    if (model==nil) {
        [self.mbHUD hide:YES];
        errorStr=@"网络超时";
        
    }else if(![model.error_string isEqualToString:@""]) {
        [self.mbHUD hide:YES];
        errorStr=model.error_string;
        
    }
    
    if (model.error_code==nil&&model!=nil) {
        
        //文件的路径是文件夹的路径+文件名
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSString *document1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *filePath1 = [document1 stringByAppendingPathComponent:@"UnitDataBase.db"];
        [fileManager removeItemAtPath:filePath1 error:NULL];
        
        NSString *filePath2 = [document1 stringByAppendingPathComponent:@"ABDataBase.db"];
        [fileManager removeItemAtPath:filePath2 error:NULL];
        
        NSString *filePath3= [document1 stringByAppendingPathComponent:@"VideoDataBase.db"];
        [fileManager removeItemAtPath:filePath3 error:NULL];
        
        NSString *filePath4 = [document1 stringByAppendingPathComponent:@"UserDataBase.db"];
        [fileManager removeItemAtPath:filePath4 error:NULL];
        
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        [user setObject:@"" forKey:@"请填写收货姓名"];
        [user setObject:@"" forKey:@"请输入手机号码"];
        [user setObject:@"" forKey:@"请填写配送地址"];
        //清楚缓存
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
        //将用户数据存到数据库中
        NSMutableArray *userArray=[NSMutableArray array];
        userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
        if (userArray.count > 0) {
            NSString *modifyString = [NSString stringWithFormat:@"UPDATE loginUser SET user_account_uid = '%@',  user_name='%@', user_msisdn='%@', photo_icon_url='%@', photo_raw_url='%@'", model.user_account_uid, model.user_name, model.user_msisdn, model.photo_icon_url, model.photo_raw_url];
            [LoginUserManager modifyData:modifyString];
            
        } else {
            [LoginUserManager insertModal:model];
        }
        
        [self.mbHUD hide:YES];
        
        UIAlertController *alertControl3=[UIAlertController alertControllerWithTitle:@"恭喜" message:@"注册成功。建议进一步完善您的个人资料" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertControl3 animated:YES completion:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loginAction) userInfo:self repeats:NO];
        
    }else{
        
        [self.mbHUD hide:YES];
        
        UIAlertController *alertControll1=[UIAlertController alertControllerWithTitle:@"提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        
        //        UIAlertAction *alertAction1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        //
        //        [alertControll1 addAction:alertAction1];
        
        [self presentViewController:alertControll1 animated:YES completion:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:self repeats:NO];
    }
    
}

//登录成功后
- (void)loginAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    //通知中心
    NSNotificationCenter *notiCenter=[NSNotificationCenter defaultCenter];
    [notiCenter postNotificationName:@"帅哥" object:self userInfo:nil];
}

//修改密码
- (IBAction)forgeAction:(UIButton *)sender {
    
    if ([self.phoneTextField.text isEqualToString:@""]||[self.passWorldTextField.text isEqualToString:@""]||[self.agianPassWorldTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showErrorWithStatus:@"请全部填写"];
        return;
    }
    if (![self.passWorldTextField.text isEqualToString:self.agianPassWorldTextField.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"您的两次密码输入不一致!"];
        
        return;
    }
    //先走网络判断
    //判断是否有网络
    BOOL net=[self serachNetWay];
    if (net) {
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        
        parameter[@"trans_code"] = @"user_modify_psw";
        parameter[@"old_password"] = self.phoneTextField.text;
        parameter[@"new_password"] = self.passWorldTextField.text;
        
        [self.manager httpRequestManagerSetupRequestWithParametersDictionary:parameter action:@"" actionParameter:@"" hasParameter:NO dataBlock:^(NSDictionary *dict) {
            //发送验证码失败
            if (dict[@"error_code"]) {
                //回到主线程刷新数据
                dispatch_async(dispatch_get_main_queue(), ^{
        
                    [SVProgressHUD showErrorWithStatus:dict[@"error_string"]];
                });
                
                
            } else {  //发送验证码成功,
                dispatch_async(dispatch_get_main_queue(), ^{
                  
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
                   
                });
                
            }
        }];
        
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"请先检查网络"];
    }
}

- (void)delayMethod
{
     [self.navigationController popViewControllerAnimated:YES];

}

#pragma --mark 方法
//点击左侧的按键的方法
- (void)leftBarButtonAction:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
    if ([self.titles isEqualToString:@"注册"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}



//点击回收的方法
- (void)huishou:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

//秒后自己消失
- (void)time{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//只支持竖屏
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

//适配在5s以下的能在输入用户名的时候上升
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat number5=568;
    if ([UIScreen mainScreen].bounds.size.height<number5) {
        //iPhone键盘高度216，iPad的为352
        [UIView animateWithDuration:0.1 animations:^{
            
            self.logoTop.constant=-85;
            
        }];
    }
    if ([UIScreen mainScreen].bounds.size.height==number5) {
        //iPhone键盘高度216，iPad的为352
        [UIView animateWithDuration:0.1 animations:^{
            
            self.logoTop.constant=-20;
            
        }];
    }

}

//输入框编辑完成以后，将视图恢复到原始状态

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGFloat number5=570;
    if ([UIScreen mainScreen].bounds.size.height<=number5) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.logoTop.constant=40;
        }];
    }
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
