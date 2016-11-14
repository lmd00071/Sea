//
//  MeViewController.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/6/6.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "MeViewController.h"
#import "UIImageView+WebCache.h"
#import "NewRegisterViewController.h"
#import "NewLoginViewController.h"
#import "BWPasswordController.h"
#import "SDImageCache.h"
#define NavBarFgColor [UIColor whiteColor]
#define NavTextAttribute @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}
@interface MeViewController ()< UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSessionDataTask *csvTask;
@property (nonatomic, strong) NSURLSessionDataTask *userTask;
@property (nonatomic, strong) NSURLSessionDataTask *answerTask;
@property (nonatomic, strong) NSURLSessionDataTask *postTask;
@property (nonatomic, strong) NSURLSessionDataTask *dnsTask;

@property (strong, nonatomic) IBOutlet UIImageView *IconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

@property (nonatomic, weak) UIView *hudView;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) BWHttpRequestManager *manager;
@end

@implementation MeViewController

- (BWHttpRequestManager *)manager
{
    if (_manager == nil) {
        BWHttpRequestManager *manager = [[BWHttpRequestManager alloc] init];
        _manager = manager;
    }
    return _manager;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    [_IconImageView sd_setImageWithURL:[NSURL URLWithString:userMessage.photo_icon_url] placeholderImage:[UIImage imageNamed:@"setting_default_head"]];
 
    if (userMessage.user_name.length>0) {
        self.nameLabel.text=userMessage.user_name;
    }else{
        if (userMessage.user_msisdn.length>0) {
            
            NSString *fourStr=[userMessage.user_msisdn substringFromIndex:7];
            self.nameLabel.text=fourStr;
        }
       
    }
    
    self.phoneLabel.text=userMessage.user_msisdn;
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    self.navigationController.navigationBar.barTintColor=HBRGBColor(27, 169, 240, 1);
    self.navigationController.navigationBar.tintColor=NavBarFgColor;
    self.navigationController.navigationBar.titleTextAttributes=NavTextAttribute;
    //设置成导航栏下面开始计算
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bookshop_1_back1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [self setupReviseIcon];
}

//修改图像
- (IBAction)changeIcomImage:(UITapGestureRecognizer *)sender {
    
     self.hudView.hidden = NO;
}
//修改名字
- (IBAction)changeName:(UITapGestureRecognizer *)sender {
    BWPasswordController *passwordController = [[BWPasswordController alloc] initWithNibName:@"BWPasswordController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:passwordController animated:YES];
    
}

//修改密码
- (IBAction)changePassWorld:(UITapGestureRecognizer *)sender {
    NewRegisterViewController *paVC=[[NewRegisterViewController alloc]init];
    paVC.titles=@"修改密码";
    [self.navigationController pushViewController:paVC animated:YES];
    
}
//注销退出
- (IBAction)logout:(UIButton *)sender {
    
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    
    [SVProgressHUD showWithStatus:@"正在注销用户..."];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] = @"user_logout";
    parameters[@"from_system"] = FromSystem;
    //拿到当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    parameters[@"from_client_version"] = version;
    //拿到手机的MAC地址
    parameters[@"from_client_id"] = AppUUID;
    parameters[@"yc_user_role"] = UserRole;
    parameters[@"yc_user_account_uid"] = userMessage.user_account_uid;

    NSString *xmlString = [parameters newXMLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseUrlString]];
    
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak typeof(self) weakself = self;
    NSURLSessionDataTask *csvTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"注销失败"];
            });
            return;
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];
        
        NSMutableURLRequest *dnsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dict[@"dns.url"]]];
        
        [dnsRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        dnsRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
        dnsRequest.HTTPMethod = @"POST";
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:dnsRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:@"注销失败"];
                });
                return;
            }
            
            NSDictionary *dataDict = [NSDictionary dictionaryWithXMLData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!dataDict[@"error_string"]) {
                    [SVProgressHUD showSuccessWithStatus:@"注销成功"];
                
//                    //文件的路径是文件夹的路径+文件名
//                    NSFileManager *fileManager=[NSFileManager defaultManager];
//                    NSString *document1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//                    NSString *filePath1 = [document1 stringByAppendingPathComponent:@"UnitDataBase.db"];
//                    [fileManager removeItemAtPath:filePath1 error:NULL];
//                    
//                    NSString *filePath2 = [document1 stringByAppendingPathComponent:@"ABDataBase.db"];
//                    [fileManager removeItemAtPath:filePath2 error:NULL];
//                    
//                    NSString *filePath3= [document1 stringByAppendingPathComponent:@"VideoDataBase.db"];
//                    [fileManager removeItemAtPath:filePath3 error:NULL];
//                    
//                    NSString *filePath4 = [document1 stringByAppendingPathComponent:@"UserDataBase.db"];
//                    [fileManager removeItemAtPath:filePath4 error:NULL];
//                    
//                    //清空用户信息
//                    NSString *modifyString = [NSString stringWithFormat:@"UPDATE loginUser SET user_account_uid = '',  user_name='', user_msisdn='', photo_icon_url='', photo_raw_url=''"];
//                    [LoginUserManager modifyData:modifyString];
//                    
//                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//                    [user setObject:@"" forKey:@"请填写收货姓名"];
//                    [user setObject:@"" forKey:@"请输入手机号码"];
//                    [user setObject:@"" forKey:@"请填写配送地址"];
//                    
//                    //清楚缓存
//                    [[SDImageCache sharedImageCache] clearDisk];
//                    [[SDImageCache sharedImageCache] clearMemory];
                    
                    //清空所有数据
                    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM csv_path"];
                    NSArray *overModelArray = [BWCSVDatabase queryData:sqlString];
                    NSFileManager *manager = [NSFileManager defaultManager];
                    for (BWCSVModel *csvModel in overModelArray) {
                        
                        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
                        NSString *csvPath = [cachePath stringByAppendingPathComponent:csvModel.csvPath];
                        [manager removeItemAtPath:csvPath error:nil];
                    }
                    
                    NSString *deleteString = [NSString stringWithFormat:@"DELETE FROM csv_path"];
                    [BWCSVDatabase deleteData:deleteString];
                    
                    NewLoginViewController *logVC=[[NewLoginViewController alloc]init];
                    logVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:logVC animated:YES completion:nil];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:@"注销失败"];
                }
            });
        }];
        [dataTask resume];
        self.dataTask=dataTask;
    }];
    [csvTask resume];
    self.csvTask=csvTask;
    
}

#pragma mark - 返回按键的方法
- (void)leftAction{
    
    [self.dnsTask cancel];
    [self.csvTask cancel];
    [self.userTask cancel];
    [self.answerTask cancel];
    [self.postTask cancel];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//修改头像界面布局
- (void)setupReviseIcon
{
    UIView *hudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hudDismiss)];
    [hudView addGestureRecognizer:tap];
    hudView.hidden = YES;
    self.hudView = hudView;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, HBScreenHeight - 130, HBScreenWidth, 130)];
    contentView.backgroundColor = [UIColor whiteColor];
    [hudView addSubview:contentView];
    
    NSArray *titleArray = @[@"拍照", @"选择本地图片", @"取消"];
    CGFloat btnW = contentView.bw_width - 2 * HBMargin;
    CGFloat btnH = 30;
    CGFloat btnX = HBMargin;
    CGFloat btnY = HBMargin;
    
    for (int i = 0; i < titleArray.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setBackgroundColor:HBConstColor];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            [btn addTarget:self action:@selector(photographClick) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 1) {
            [btn addTarget:self action:@selector(choosePhotoClick) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 2) {
            [btn addTarget:self action:@selector(cancelChoose) forControlEvents:UIControlEventTouchUpInside];
        }
        [contentView addSubview:btn];
        
        btnY += (btnH + HBMargin);
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:hudView];
}

- (void)hudDismiss
{
    self.hudView.hidden = YES;
}

//拍照点击事件
- (void)photographClick
{
    self.hudView.hidden = YES;
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

//选择本地图片点击事件
- (void)choosePhotoClick
{
    self.hudView.hidden = YES;
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

//修改头像界面的取消按钮的点击事件
- (void)cancelChoose
{
    self.hudView.hidden = YES;
}

//懒加载imagePickerController
- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        _imagePicker = imagePicker;
    }
    return _imagePicker;
}

//选择图片后调用的方法
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    [SVProgressHUD showWithStatus:@"正在上传图片..."];
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
     loginOrReginModel *userMessage = userArray.lastObject;
    //拿到用户信息
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] = @"user_info_set";
    parameters[@"yc_user_role"] = @"none";
    
    NSString *xmlString = [parameters newXMLString];
    
    NSMutableURLRequest *dnsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseUrlString]];
    
    [dnsRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    dnsRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    dnsRequest.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak typeof(self) weakself = self;
    
    //获取上传地址的请求
    NSURLSessionDataTask *dnsTask = [session dataTaskWithRequest:dnsRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"获取地址失败"];
            });
            return;
        }
        NSDictionary *dnsDict = [NSDictionary dictionaryWithXMLData:data];
        NSMutableString *dnsString = dnsDict[@"dns.url"];
        NSRange range = [dnsString rangeOfString:@".aspx"];
        if (range.length) {
            [dnsString insertString:@"_upload" atIndex:(range.location)];
        }
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dnsString]];
        
        [postRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        postRequest.HTTPBody = imageData;
        postRequest.HTTPMethod = @"POST";
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //上传文件
            NSURLSessionDataTask *postTask = [session dataTaskWithRequest:postRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
                    });
                    
                    return;
                }
                
                NSDictionary *postDict = [NSDictionary dictionaryWithXMLData:data];
                NSString *subString = postDict[@"receipt.receipt"];
                
                NSMutableDictionary *dataPara = [NSMutableDictionary dictionary];
                dataPara[@"trans_code"] = @"user_info_set";
                dataPara[@"from_system"] = FromSystem;
                //拿到当前版本号
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                dataPara[@"from_client_version"] = version;
                //拿到手机的MAC地址
                dataPara[@"from_client_id"] = AppUUID;
                dataPara[@"yc_user_role"] = UserRole;
                dataPara[@"yc_user_account_uid"] = userMessage.user_account_uid;
//                dataPara[@"yc_school_id"] = userMessage.school_id;
//                dataPara[@"yc_dept_id"] = userMessage.dept_id;
                dataPara[@"upload_receipt_photo"] = subString;
                dataPara[@"user_name"] = @"";
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:date];
                NSString *fileName = [NSString stringWithFormat:@"%@.png",dateString];
                dataPara[@"upload_photo_file"] = fileName;
                
                NSString *dataXmlString = [dataPara newXMLString];
                
                NSString *answerString = [dnsString stringByReplacingOccurrencesOfString:@"_upload" withString:@""];
                NSMutableURLRequest *answerRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:answerString]];
                [answerRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                answerRequest.HTTPBody = [dataXmlString dataUsingEncoding:NSUTF8StringEncoding];
                answerRequest.HTTPMethod = @"POST";
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //将上传的头像告诉中控
                    NSURLSessionDataTask *answerTask = [session dataTaskWithRequest:answerRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD showErrorWithStatus:@"中控拉取头像失败"];
                                
                            });
                            
                            return;
                        }
                       
                        NSDictionary *schoolDict = [NSDictionary dictionaryWithXMLData:data];
                        
                        if (schoolDict[@"error_code"]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //[SVProgressHUD dismiss];
                                [SVProgressHUD showErrorWithStatus:schoolDict[@"error_string"]];
                            });
                            return;
                        }
                        
//                        NSMutableURLRequest *schoolRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:schoolDict[@"yc_redirect_request_to"]]];
//                        [schoolRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//                        schoolRequest.HTTPBody = [dataXmlString dataUsingEncoding:NSUTF8StringEncoding];
//                        schoolRequest.HTTPMethod = @"POST";
//                        
//                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                            //将上传的头像告诉学校
//                            NSURLSessionDataTask *schoolTask = [session dataTaskWithRequest:schoolRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                                
//                                if (error) {
//                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                        [SVProgressHUD showErrorWithStatus:@"学校拉取头像失败"];
//                                        
//                                    });
//                                    return;
//                                }
                        
                                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                    NSMutableDictionary *para = [NSMutableDictionary dictionary];
                                    
                                    para[@"trans_code"] = @"user_info_get";
                                    para[@"from_system"] = FromSystem;
                                    //拿到手机的MAC地址
                                    para[@"from_client_id"] = AppUUID;
                                    //拿到当前版本号
                                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                                    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                                    para[@"from_client_version"] = version;
                                    para[@"yc_user_role"] = UserRole;
                                    para[@"yc_user_account_uid"] = userMessage.user_account_uid;
//                                    para[@"yc_school_id"] = userMessage.school_id;
//                                    para[@"yc_dept_id"] = userMessage.dept_id;
                                    //登录成功,请求用户信息
                                    NSString *requestString = [para newXMLString];
                                    
                                    NSMutableURLRequest *userRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:answerString]];
                                    
                                    [userRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                                    userRequest.HTTPBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
                                    userRequest.HTTPMethod = @"POST";
                                    
                                    NSURLSessionDataTask *userTask = [session dataTaskWithRequest:userRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                        
                                        if (error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [SVProgressHUD showErrorWithStatus:@"请求失败..."];
                                            });
                                            return;
                                        }
                                        
                                        NSDictionary *xmlDict = [NSDictionary dictionaryWithXMLData:data];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            NSString *user_accout_uid = xmlDict[@"user_account_uid"];
                                            if (user_accout_uid.length > 0) {
                                                [SVProgressHUD showSuccessWithStatus:@"修改头像成功"];
                                                
                                                for (UINavigationController *navVc in weakself.tabBarController.childViewControllers) {
                                                    
                                                    if (navVc.childViewControllers.count > 1) {
                                                        
                                                        [navVc popViewControllerAnimated:YES];
                                                    }
                                                }
                                                
                                                //将用户数据存到数据库中
                                                 loginOrReginModel *model = [loginOrReginModel mj_objectWithKeyValues:xmlDict];
//                                                model.account =  userMessage.account;
//                                                model.password = userMessage.password;
                                                NSMutableArray *userArray=[NSMutableArray array];
                                                userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
                                                if (userArray.count > 0) {
                                                    NSString *modifyString = [NSString stringWithFormat:@"UPDATE loginUser SET user_account_uid = '%@',  user_name='%@', user_msisdn='%@', photo_icon_url='%@', photo_raw_url='%@'", model.user_account_uid, model.user_name, model.user_msisdn, model.photo_icon_url, model.photo_raw_url];
                                                    [LoginUserManager modifyData:modifyString];
                                                    [weakself.IconImageView sd_setImageWithURL:[NSURL URLWithString:model.photo_icon_url] placeholderImage:[UIImage imageNamed:@"setting_default_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                        weakself.IconImageView.image = image;
                                                    }];
                                                } else {
                                                    [LoginUserManager insertModal:model];
                                                }
                                            } else {
                                                [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                                            }
                                        });
                                    }];
                                    [userTask resume];
                                    self.userTask=userTask;
                                });
                           }];
//                            [schoolTask resume];
                        //});
                    //}];
                    [answerTask resume];
                    self.answerTask=answerTask;
                });
            }];
            [postTask resume];
            self.postTask=postTask;
        });
    }];
    [dnsTask resume];
    self.dnsTask=dnsTask;
}

@end
