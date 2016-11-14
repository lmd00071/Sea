//
//  NewLoginViewController.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/7/12.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "NewLoginViewController.h"
#import "Reachability.h"
#import "loginManager.h"
#import "MBProgressHUD.h"
#import "LoginUserManager.h"
#import "DataBase.h"
#import "SDImageCache.h"
#import "NewRegisterViewController.h"
@interface NewLoginViewController ()<UITextFieldDelegate,loginManagerDelegate>
/*logo的高度*/
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleImageViewHeight;
/*手机距离logo的距离*/
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleForHegiht;
/*button的高度*/
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
/*地步视图的高度*/
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
/*标题的高度*/
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;

/*手机号*/
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
/*密码*/
@property (strong, nonatomic) IBOutlet UITextField *passWroldTextField;

/*logo距离顶部的高度*/
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoTop;

@property (nonatomic, retain) MBProgressHUD *mbHUD;
@property (nonatomic,strong)DataBase *dataBase;

@end

@implementation NewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huishou:)];
    [self.view addGestureRecognizer:tap];
    
    self.phoneTextField.delegate=self;
    self.passWroldTextField.delegate=self;
    self.passWroldTextField.secureTextEntry=YES;
    
    //判断当屏幕的高度是6P的时候
    CGFloat number6p=736;
    CGFloat number6=667;
    CGFloat number5=568;
    CGFloat number4=480;
    if ([UIScreen mainScreen].bounds.size.height>=number6p) {
        
        self.titleImageViewHeight.constant=250;
        self.titleForHegiht.constant=60;
        self.buttonHeight.constant=40;
        self.bottomHeight.constant=280;
    }
    if ([UIScreen mainScreen].bounds.size.height==number6) {
        
        self.titleImageViewHeight.constant=220;
        self.titleForHegiht.constant=40;
        self.buttonHeight.constant=40;
        self.bottomHeight.constant=280;
    }
    if ([UIScreen mainScreen].bounds.size.height==number5) {
        
        self.titleImageViewHeight.constant=180;
        self.titleForHegiht.constant=30;
        self.buttonHeight.constant=30;
        self.bottomHeight.constant=260;
        self.titleHeight.constant=40;
    }
    if ([UIScreen mainScreen].bounds.size.height==number4) {
        
        self.titleImageViewHeight.constant=170;
        self.titleForHegiht.constant=20;
        self.buttonHeight.constant=30;
        self.bottomHeight.constant=250;
        self.titleHeight.constant=40;
        
    }
    
    
}


- (IBAction)zhuceAction:(UIButton *)sender {
    
    NewRegisterViewController *regVC=[[NewRegisterViewController alloc]init];
    UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:regVC];
    regVC.titles=@"注册";
    [self presentViewController:navi animated:YES completion:nil];
}

- (IBAction)loginAction:(UIButton *)sender {
    
    //先走网络判断
    //判断是否有网络
    BOOL net=[self serachNetWay];
    
    if (net) {
        
        [[loginManager shareManager] searchFromNetDelegateAction:self way:3 user:self.phoneTextField.text passWord:self.passWroldTextField.text verificationCode:nil];
        self.mbHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.mbHUD];
        [self.mbHUD show:YES];
        self.mbHUD.labelText = @"正在登录中";
        self.mbHUD.dimBackground = YES;
        
    }
    
}

- (IBAction)visitorAction:(UIButton *)sender {
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    
    if (userMessage.user_msisdn.length>0) {
        
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
        
    }
    
    //清空用户信息
    NSString *modifyString = [NSString stringWithFormat:@"UPDATE loginUser SET user_account_uid = '',  user_name='', user_msisdn='', photo_icon_url='', photo_raw_url=''"];
    [LoginUserManager modifyData:modifyString];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSNotificationCenter *notiCenter=[NSNotificationCenter defaultCenter];
    [notiCenter postNotificationName:@"帅哥" object:self userInfo:nil];

    
}


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
        
        //将用户数据存到数据库中
        NSMutableArray *userArray=[NSMutableArray array];
        userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
        loginOrReginModel *userMessage = userArray.lastObject;
        if (userArray.count > 0) {
            
            if (![userMessage.user_msisdn isEqualToString:model.user_msisdn]) {
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
                
            }
            
            NSString *modifyString = [NSString stringWithFormat:@"UPDATE loginUser SET user_account_uid = '%@',  user_name='%@', user_msisdn='%@', photo_icon_url='%@', photo_raw_url='%@'", model.user_account_uid, model.user_name, model.user_msisdn, model.photo_icon_url, model.photo_raw_url];
            [LoginUserManager modifyData:modifyString];
            
        } else {
            //文件的路径是文件夹的路径+文件
            
            [LoginUserManager insertModal:model];
        }
        
         [self.mbHUD hide:YES];
        UIAlertController *alertControl3=[UIAlertController alertControllerWithTitle:@"恭喜" message:model.login_result_msg preferredStyle:UIAlertControllerStyleAlert];
        
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


//判断有没有网络的方法,
- (BOOL)serachNetWay
{
    Reachability *reachAbility = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NSInteger stateNet = [reachAbility currentReachabilityStatus];
    
    if (stateNet == 0) {
        
        UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:@"提示" message:@"网络没有连接,请先连接网络" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alertControll addAction:alertAction];
        
        [self presentViewController:alertControll animated:YES completion:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:self repeats:NO];
        
        return NO;
    }else{
        
        
        return YES;
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//点击回收的方法
- (void)huishou:(UITapGestureRecognizer *)tap
{
    
    [self.view endEditing:YES];
}

//一秒后自己消失
- (void)time{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
{   CGFloat number5=568;
    if ([UIScreen mainScreen].bounds.size.height<number5) {
        //iPhone键盘高度216，iPad的为352
        [UIView animateWithDuration:0.1 animations:^{
            
            self.logoTop.constant=-25;
            
        }];
    }
    if ([UIScreen mainScreen].bounds.size.height==number5) {
        //iPhone键盘高度216，iPad的为352
        [UIView animateWithDuration:0.1 animations:^{
            
            self.logoTop.constant=25;
            
        }];
    }
}





//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{    CGFloat number5=570;
    if ([UIScreen mainScreen].bounds.size.height<=number5) {
        
        [UIView animateWithDuration:0.1 animations:^{
    
                self.logoTop.constant=60;
        }];
    }

}



-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
