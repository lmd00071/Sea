//
//  AddressViewController.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/5/26.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "AddressViewController.h"
#import "UIImageView+WebCache.h"
#import "WXApi.h"
#import "payTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
@interface AddressViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSessionDataTask *csvTask;
@property (nonatomic, strong) NSURLSessionDataTask *dnsTask;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottonHegin;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) IBOutlet UILabel *payLable;
//底下的view
@property (nonatomic,strong)UIView *bottonView;
//收货的姓名
@property (nonatomic,strong)UITextField *nameTextField;
//收货的电话
@property (nonatomic,strong)UITextField *phoneTextField;
//收货的地址
@property (nonatomic,strong)UITextField *addressTextField;
//书本的数量
@property (nonatomic,strong)UILabel *goodsNumberLabel;
@property (nonatomic,strong)UILabel *goodsNumber;
//记录书本的数量
@property (nonatomic,assign)NSInteger bookNumber;
//付款的钱
@property (nonatomic,assign)float payMoney;
//抵扣的金币
@property (nonatomic,strong)UILabel *goldNumberLabel;

//开关
@property (nonatomic,strong)UISwitch *swith;

@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UILabel *errorStringLabel;

//总积分
@property (nonatomic,strong)UILabel *UserGoldLabel;
@property (nonatomic,assign)NSInteger goldNumber;


//支付
@property(nonatomic,strong)UIView *myView;
@property (nonatomic,strong)UIView *mybottonView;
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title = @"订单";
    //设置成导航栏下面开始计算
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bookshop_1_back1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    [self setupCancelSuccess];
    [self payView];
    //购买的高度
    self.bottonHegin.constant=[UIScreen mainScreen].bounds.size.height*1.0/10.0;
    self.payMoney=[self.dataModel.book_prices floatValue];
    self.payLable.text=[NSString stringWithFormat:@"¥%@",self.dataModel.book_prices];
    [self setScroll];
    [self recoverKey];
    self.bookNumber=1;
    self.goldNumber=0;
    [self setupHttpRequest];
    
}

//滑动里面的布局
- (void)setScroll{
    
    UIImageView *goodsImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 140,150)];
    goodsImageView.contentMode=UIViewContentModeScaleAspectFit;
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.dataModel.icon] placeholderImage:[UIImage imageNamed:@""]];
    [self.ScrollView addSubview:goodsImageView];

    // 获取到本行显示的字符串
//    NSString *str=self.dataModel.book_name;
//    CGRect rect=[str boundingRectWithSize:CGSizeMake(HBScreenWidth-150, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil];
//    CGFloat height=rect.size.height;
    
    UILabel *titLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 35, HBScreenWidth-150, 20)];
    titLabel.textColor=[UIColor blackColor];
    titLabel.text=self.dataModel.book_name;
    titLabel.textAlignment=NSTextAlignmentLeft;
    titLabel.font=[UIFont boldSystemFontOfSize:20];
    titLabel.numberOfLines=1;
    [self.ScrollView addSubview:titLabel];
    
//    NSString *str1=self.dataModel.book_desc;
//    CGRect rect1=[str1 boundingRectWithSize:CGSizeMake(HBScreenWidth-150, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
//    CGFloat height1=rect1.size.height;
    
    UILabel *autherLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 35+25,HBScreenWidth-150, 60)];
    autherLabel.textColor=[UIColor lightGrayColor];
    autherLabel.text=self.dataModel.book_desc;
    autherLabel.textAlignment=NSTextAlignmentLeft;
    autherLabel.font=[UIFont systemFontOfSize:16];
    autherLabel.numberOfLines=3;
    [self.ScrollView addSubview:autherLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 128, (HBScreenWidth-150)/2.0, 20)];
    moneyLabel.textColor=[UIColor redColor];
    moneyLabel.text=[NSString stringWithFormat:@"¥%@",self.dataModel.book_prices];
    moneyLabel.textAlignment=NSTextAlignmentLeft;
    moneyLabel.font=[UIFont boldSystemFontOfSize:20];
    [self.ScrollView addSubview:moneyLabel];
    
    
    self.UserGoldLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 155, HBScreenWidth-150, 20)];
    self.UserGoldLabel.textColor=[UIColor redColor];
    self.UserGoldLabel.textAlignment=NSTextAlignmentLeft;
    self.UserGoldLabel.font=[UIFont systemFontOfSize:17];
    [self.ScrollView addSubview:self.UserGoldLabel];
    
    _goodsNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(140+(HBScreenWidth-150)/2.0-10, 128, (HBScreenWidth-150)/2.0, 20)];
    _goodsNumberLabel.textColor=[UIColor blackColor];
    _goodsNumberLabel.text=@"X1";
    _goodsNumberLabel.textAlignment=NSTextAlignmentRight;
    _goodsNumberLabel.font=[UIFont boldSystemFontOfSize:20];
    [self.ScrollView addSubview:_goodsNumberLabel];
    
    UIView *firstView=[[UIView alloc]initWithFrame:CGRectMake(10, 180, HBScreenWidth-20, 1)];
    firstView.backgroundColor=[UIColor lightGrayColor];
    [self.ScrollView addSubview:firstView];
    
    UILabel *detaiTitlelLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 181, 120, 70)];
    detaiTitlelLabel.textColor=[UIColor blackColor];
    detaiTitlelLabel.text=@"购买数量";
    detaiTitlelLabel.textAlignment=NSTextAlignmentLeft;
    detaiTitlelLabel.font=[UIFont systemFontOfSize:20];
    [self.ScrollView addSubview:detaiTitlelLabel];
    
    UIButton *SumLeftButotn=[UIButton buttonWithType:UIButtonTypeCustom];
    SumLeftButotn.frame=CGRectMake(HBScreenWidth-10-20*2-40, 181+25,20, 20);
    [SumLeftButotn setImage:[UIImage imageNamed:@"order_icon_jian"] forState:UIControlStateNormal];
    [SumLeftButotn addTarget:self action:@selector(SumLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.ScrollView addSubview:SumLeftButotn];
    
    _goodsNumber=[[UILabel alloc]initWithFrame:CGRectMake(HBScreenWidth-10-20-40, 181, 40, 70)];
    _goodsNumber.textColor=[UIColor blackColor];
    _goodsNumber.text=@"1";
    _goodsNumber.textAlignment=NSTextAlignmentCenter;
    _goodsNumber.font=[UIFont systemFontOfSize:20];
    [self.ScrollView addSubview:_goodsNumber];
    
    UIButton *AddRightButotn=[UIButton buttonWithType:UIButtonTypeCustom];
    AddRightButotn.frame=CGRectMake(HBScreenWidth-10-20, 181+25, 20, 20);
    [AddRightButotn setImage:[UIImage imageNamed:@"order_icon_jia"] forState:UIControlStateNormal];
    [AddRightButotn addTarget:self action:@selector(AddRightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.ScrollView addSubview:AddRightButotn];
    
    UIView *secondView=[[UIView alloc]initWithFrame:CGRectMake(10, 251, HBScreenWidth-20, 1)];
    secondView.backgroundColor=[UIColor lightGrayColor];
    [self.ScrollView addSubview:secondView];
    
    UILabel *goldLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 252,90, 70)];
    detaiTitlelLabel.textColor=[UIColor blackColor];
    goldLabel.text=@"抵扣金币";
    goldLabel.textAlignment=NSTextAlignmentLeft;
    goldLabel.font=[UIFont systemFontOfSize:21];
    [self.ScrollView addSubview:goldLabel];
    
    self.goldNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(110,252,HBScreenWidth-190, 70)];
    self.goldNumberLabel.textColor=[UIColor redColor];
    self.goldNumberLabel.text=[NSString stringWithFormat:@"%@金币可用,可抵扣%@元",self.dataModel.discount_yp,self.dataModel.discount_price];
    self.goldNumberLabel.textAlignment=NSTextAlignmentLeft;
    self.goldNumberLabel.font=[UIFont systemFontOfSize:16];
    self.goldNumberLabel.numberOfLines=0;
//    [self.goldNumberLabel sizeToFit];
    [self.ScrollView addSubview:self.goldNumberLabel];
    
    self.swith=[[UISwitch alloc]initWithFrame:CGRectMake(HBScreenWidth-70, 252+35/2.0, 70, 35)];
    self.swith.onTintColor=HBRGBColor(53, 153, 224, 1);
    [self.swith setOn:NO];
    [self.swith addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.ScrollView addSubview:self.swith];
    
    UIView *thirdView=[[UIView alloc]initWithFrame:CGRectMake(10, 322, HBScreenWidth-20, 1)];
    thirdView.backgroundColor=[UIColor lightGrayColor];
    [self.ScrollView addSubview:thirdView];
    
    
    _bottonView=[[UIView alloc]initWithFrame:CGRectMake(0, 323, HBScreenWidth, 153)];
    [self.ScrollView addSubview:_bottonView];
    
    
    UIImageView *nameImageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 25/2.0, 25, 25)];
    nameImageView.image=[UIImage imageNamed:@"order_address_01"];
    [_bottonView addSubview:nameImageView];
    
    //缓存
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *nameStr = nil;
    nameStr=[user objectForKey:@"请填写收货姓名"];
    NSString *phoneStr = nil;
    phoneStr=[user objectForKey:@"请输入手机号码"];
    NSString *addressStr = nil;
    addressStr=[user objectForKey:@"请填写配送地址"];
    
    _nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(65, 10, HBScreenWidth-65-20, 30)];
    _nameTextField.placeholder=@"请填写收货姓名";
    _nameTextField.text=nameStr;
    _nameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _nameTextField.adjustsFontSizeToFitWidth = YES;
    _nameTextField.enabled=YES;
    _nameTextField.delegate=self;
    [_bottonView addSubview:_nameTextField];
    
    UIView *fourView=[[UIView alloc]initWithFrame:CGRectMake(20, 50, HBScreenWidth-40, 1)];
    fourView.backgroundColor=[UIColor lightGrayColor];
    [_bottonView addSubview:fourView];
    
    UIImageView *phoneImageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 51+25/2.0, 25, 25)];
    phoneImageView.image=[UIImage imageNamed:@"order_address_02"];
    [_bottonView addSubview:phoneImageView];
    
    _phoneTextField=[[UITextField alloc]initWithFrame:CGRectMake(65, 51, HBScreenWidth-65-20, 50)];
    _phoneTextField.placeholder=@"请输入手机号码";
    _phoneTextField.text=phoneStr;
    _phoneTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _phoneTextField.adjustsFontSizeToFitWidth = YES;
    _phoneTextField.enabled=YES;
    _phoneTextField.delegate=self;
    [_bottonView addSubview:_phoneTextField];
    
    UIView *fiveView=[[UIView alloc]initWithFrame:CGRectMake(20, 101, HBScreenWidth-40, 1)];
    fiveView.backgroundColor=[UIColor lightGrayColor];
    [_bottonView addSubview:fiveView];
    
    
    UIImageView *addressImageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 102+25/2.0, 25, 25)];
    addressImageView.image=[UIImage imageNamed:@"order_address_04"];
    [_bottonView addSubview:addressImageView];
    
    _addressTextField=[[UITextField alloc]initWithFrame:CGRectMake(65, 102+10, HBScreenWidth-65-20, 30)];
    _addressTextField.placeholder=@"请填写配送地址";
    _addressTextField.text=addressStr;
    _addressTextField.delegate=self;
    [_bottonView addSubview:_addressTextField];
    
//    UITextView *addressText=[[UITextView alloc]initWithFrame:CGRectMake(65, 102, HBScreenWidth-65-20, 50)];
//    addressText.textAlignment=NSTextAlignmentNatural;
//    addressText.editable = YES;
//    addressText.scrollEnabled = YES;
//    addressText.font = [UIFont systemFontOfSize:16];
//    [bottonView addSubview:addressText];
//    
//    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 102, HBScreenWidth-65-20, 50)];
//    //addLabel.text = @"请输配送地址";
//    addLabel.textColor=[UIColor lightGrayColor];
//    addLabel.alpha=1;
//    addLabel.font = [UIFont systemFontOfSize:17];
//    [bottonView addSubview:addLabel];
    
    UIView *sixView=[[UIView alloc]initWithFrame:CGRectMake(20, 152, HBScreenWidth-40, 1)];
    sixView.backgroundColor=[UIColor lightGrayColor];
    [_bottonView addSubview:sixView];
    
    //scrolView的滚动范围(只有滚动范围的宽高大于scrolView自身的宽高,才能实现滚动)
    self.ScrollView.contentSize=CGSizeMake(HBScreenWidth, 476+14);
    self.ScrollView.scrollsToTop=NO;
    self.ScrollView.showsVerticalScrollIndicator=NO;
    self.ScrollView.bounces=YES;
    
}

//使用金币的方法
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
 
    if (self.goldNumber>=([self.dataModel.discount_yp integerValue]*self.bookNumber)) {
        BOOL isButtonOn = [switchButton isOn];
        if (isButtonOn) {
            
            float pay=self.bookNumber*self.payMoney-[self.dataModel.discount_price floatValue]*self.bookNumber;
            _payLable.text=[NSString stringWithFormat:@"¥%.2lf",pay];
            
        }else {
            
            float pay=self.bookNumber*self.payMoney;
            _payLable.text=[NSString stringWithFormat:@"¥%.2lf",pay];
            
        }

    }else{
    
        [switchButton setOn:NO];
        [SVProgressHUD showErrorWithStatus:@"对不起,您的金币数不够用来抵扣!"];
//        self.errorStringLabel.text=@"对不起,您的金币数不够用来抵扣!";
//        self.backgroundView.hidden=NO;
    
    }
    
}

#pragma mark - 左减少的方法
- (void)SumLeftAction:(UIButton *)sender{
    if (self.bookNumber==1) {
        
    }else{
        
        self.bookNumber=self.bookNumber-1;
        _goodsNumberLabel.text=[NSString stringWithFormat:@"X%ld",(long)self.bookNumber];
        _goodsNumber.text=[NSString stringWithFormat:@"%ld",(long)self.bookNumber];
        if (self.swith.isOn) {
            
            float pay=self.bookNumber*self.payMoney-[self.dataModel.discount_price floatValue]*self.bookNumber;
            _payLable.text=[NSString stringWithFormat:@"¥%.2lf",pay];
        }else{
            float pay=self.bookNumber*self.payMoney;
            _payLable.text=[NSString stringWithFormat:@"¥%.2lf",pay];
           }
        self.goldNumberLabel.text=[NSString stringWithFormat:@"%ld金币可用,可抵扣%.2f元",[self.dataModel.discount_yp integerValue]*self.bookNumber,[self.dataModel.discount_price floatValue]*self.bookNumber];
    }
   
}

#pragma mark - 右增加的方法
- (void)AddRightAction:(UIButton *)sender{
    
    self.bookNumber=self.bookNumber+1;
    _goodsNumberLabel.text=[NSString stringWithFormat:@"X%ld",(long)self.bookNumber];
    _goodsNumber.text=[NSString stringWithFormat:@"%ld",(long)self.bookNumber];
    if (self.swith.isOn) {
        
        float pay=self.bookNumber*self.payMoney-[self.dataModel.discount_price floatValue]*self.bookNumber;
        _payLable.text=[NSString stringWithFormat:@"¥%.2lf",pay];
    }else{
        float pay=self.bookNumber*self.payMoney;
        _payLable.text=[NSString stringWithFormat:@"¥%.2lf",pay];
    }
    self.goldNumberLabel.text=[NSString stringWithFormat:@"%ld金币可用,可抵扣%.2f元",[self.dataModel.discount_yp integerValue]*self.bookNumber,[self.dataModel.discount_price floatValue]*self.bookNumber];
}
#pragma mark - 返回按键的方法
- (void)leftAction{
    
    [self.csvTask cancel];
    [self.dnsTask cancel];
    [self.dataTask cancel];
    [SVProgressHUD dismiss];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//立即付款的方法
- (IBAction)payMoneyAction:(UIButton *)sender {
    
    
    if ([_nameTextField.text isEqualToString:@""]||[ _phoneTextField.text isEqualToString:@""]||[_addressTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写完收货信息!"];
        
    }else{
    
        self.myView.hidden=NO;
        [UIView animateWithDuration:0.5 animations:^{
            
            self.mybottonView.frame=CGRectMake(0, self.myView.frame.size.height-240, HBScreenWidth, 240);
            
        }];
    }
    
}

//订单
//- (void)order
//{
//    [SVProgressHUD dismiss];
////    self.errorStringLabel.text=@"创建成功";
////    self.backgroundView.hidden=NO;
////    NSString *res = [self jumpToBizPay];
////    if( ![res isEqualToString:@""] ){
////        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////        [alter show];
////        NSLog(@"微信支付返回的信息 %@",res);
////        
////    }
//    
//}

//微信支付功能
- (void)jumpToBizPaydict:(NSDictionary *)dict {
    
    if (![WXApi isWXAppInstalled]) {
       // NSLog(@"没有安装微信");
        [SVProgressHUD showErrorWithStatus:@"没有安装微信"];
        return ;
    }else if (![WXApi isWXAppSupportApi]){
        
       // NSLog(@"不支持微信支付");
         [SVProgressHUD showErrorWithStatus:@"不支持微信支付"];
        return ;
    }
    [SVProgressHUD dismiss];
    
    NSString *timerStr = dict[@"wx_time_stamp"];
    double timer = timerStr.doubleValue;
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc]init];
                    req.partnerId           = dict[@"wx_partner_id"];
                    req.prepayId            = dict[@"wx_perpay_id"];
                    req.nonceStr            = dict[@"wx_nonce_str"];
                    req.timeStamp           = timer;
                    req.package             = dict[@"wx_package_value"];
                    req.sign                = dict[@"wx_sign"];
                    
            [WXApi sendReq:req];
           NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",dict[@"wx_app_id"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );

}

//支付宝支付功能
- (void)jumpToAipayPaydict:(NSDictionary *)dict {
    
    [SVProgressHUD dismiss];
    
    NSString *appScheme = @"aipay";
    NSString *orderSpec=dict[@"aipay_order_info"];
    NSString *oldsignedString = dict[@"aipay_sign"];
    NSString *rsa=dict[@"aipay_sign_type"];
    
    NSString *signedString1 =[oldsignedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString *signedString2 =[signedString1 stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    
    NSString *orderString = nil;
    if (signedString2 != nil) {
        
    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                   orderSpec, signedString2, rsa];
  
    NSLog(@"orderString = %@",orderString);
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
    }

}



//点击回来键盘
- (void)recoverKey
{
    UITapGestureRecognizer *huitap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huishou:)];
    [self.view addGestureRecognizer:huitap];
    
}

//点击回收的方法
- (void)huishou:(UITapGestureRecognizer *)tap
{
    
    [self.view endEditing:YES];
}

#pragma mark - textfield协议方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField

{

        [UIView animateWithDuration:0.2 animations:^{
            
            // 设置view弹出来的位置
            //_bottonView.frame=CGRectMake(0, 0, HBScreenWidth, 153);
            //_ScrollView.frame=CGRectMake(0, 0, HBScreenWidth, 153);
            _ScrollView.contentInset = UIEdgeInsetsMake(-300, 0, 300, 0);
        }];
  
}
//输入框编辑完成以后，将视图恢复到原始状态

-(void)textFieldDidEndEditing:(UITextField *)textField
{   NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    
    if ([textField.placeholder isEqualToString:@"请填写收货姓名"]) {
        [user setObject:textField.text forKey:@"请填写收货姓名"];
        
    }else if ([textField.placeholder isEqualToString:@"请输入手机号码"]) {
        [user setObject:textField.text forKey:@"请输入手机号码"];
        
    }else if ([textField.placeholder isEqualToString:@"请填写配送地址"]) {
        [user setObject:textField.text forKey:@"请填写配送地址"];
        
    }
        [UIView animateWithDuration:0.2 animations:^{
            
            _ScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }];
        
 
}

//注销成功界面布局
- (void)setupCancelSuccess
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:backgroundView];
    backgroundView.hidden = YES;
    self.backgroundView = backgroundView;
    
    UIView *remindView = [[UIView alloc] init];
    remindView.bw_width = HBScreenWidth - 60;
    remindView.bw_height = 120;
    remindView.center = CGPointMake(HBScreenWidth * 0.5, HBScreenHeight * 0.5);
    remindView.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:remindView];
    
    UILabel *warmLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, remindView.bw_width, 40)];
    warmLabel.text = @"温馨提示";
    warmLabel.font = [UIFont systemFontOfSize:20];
    warmLabel.textColor = [UIColor whiteColor];
    warmLabel.backgroundColor = HBConstColor;
    warmLabel.textAlignment = NSTextAlignmentCenter;
    [remindView addSubview:warmLabel];
    
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, remindView.bw_width - 2 * 10, 40)];
    remindLabel.textColor = [UIColor blackColor];
    remindLabel.font = [UIFont systemFontOfSize:15];
    remindLabel.textAlignment=NSTextAlignmentCenter;
    [remindView addSubview:remindLabel];
    self.errorStringLabel = remindLabel;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 80, remindView.bw_width - 2 * 10, 30);
    sureBtn.backgroundColor = HBConstColor;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [remindView addSubview:sureBtn];
}
//温馨提示框上的确定按钮的点击事件
- (void)sureClick
{
    self.backgroundView.hidden = YES;
    
}

- (void)orderbuild:(NSString *)pay_type
{
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    
    [SVProgressHUD showWithStatus:@"正在创建订单中..."];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] = @"hyan_emall_create_order";
    parameters[@"from_system"] = FromSystem;
    //拿到当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    parameters[@"from_client_version"] = version;
    //拿到手机的MAC地址
    parameters[@"from_client_id"] = AppUUID;
    parameters[@"yc_user_role"] = UserRole;
    if (userMessage.user_account_uid.length>0) {
        
         parameters[@"yc_user_account_uid"] = userMessage.user_account_uid;
    }
   
    parameters[@"book_uid"] = self.dataModel.book_uid;
    parameters[@"pay_type"]=pay_type;
    NSString *number=[NSString stringWithFormat:@"%ld",self.bookNumber];
    parameters[@"order_quantity"] =number;;
    NSString *discount_yp;
    NSString *discount_price;
    if (self.swith.isOn) {
        discount_yp=[NSString stringWithFormat:@"%ld",[self.dataModel.discount_yp integerValue]*self.bookNumber];
        discount_price=[NSString stringWithFormat:@"%.2f",[self.dataModel.discount_price floatValue]*self.bookNumber];
    }else {
        discount_yp=@"";
        discount_price=@"";
    }
    parameters[@"discount_yp"] = discount_yp;
    parameters[@"discount_price"] = discount_price;

    NSString *payStr=[_payLable.text substringFromIndex:1];
    parameters[@"order_final_price"] =payStr;
    parameters[@"order_user_name"] = _nameTextField.text;
    parameters[@"order_contact_phone"] = _phoneTextField.text;
    parameters[@"order_address"] = _addressTextField.text;
    
    
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
                [SVProgressHUD showErrorWithStatus:@"创建失败"];
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
                    [SVProgressHUD showErrorWithStatus:@"创建失败"];
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *dataDict = [NSDictionary dictionaryWithXMLData:data];
                
                 if (!dataDict[@"error_code"]) {
  
                     if ([pay_type isEqualToString:@"wxpay"]) {
                         
                         [self jumpToBizPaydict:dataDict];
                     }
                    
                     if ([pay_type isEqualToString:@"aipay"]) {
                         
                         [self jumpToAipayPaydict:dataDict];
                     }
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:dataDict[@"error_string"]];
                }
            });
        }];
        [dataTask resume];
        self.dataTask=dataTask;
    }];
    [csvTask resume];
    self.csvTask=csvTask;
    
    
}


- (void)setupHttpRequest
{
    [SVProgressHUD showWithStatus:@"正在请求数据中..."];
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] = @"user_account_info_get";
    parameters[@"from_system"] = FromSystem;
    //拿到当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    parameters[@"from_client_version"] = version;
    //拿到手机的MAC地址
    parameters[@"from_client_id"] = AppUUID;
    if (userArray.count > 0) {
        loginOrReginModel *userMessage = userArray.lastObject;
        parameters[@"yc_user_role"] = UserRole;
        parameters[@"yc_user_account_uid"] = userMessage.user_account_uid;
        
    }
    NSString *xmlString = [parameters newXMLString];
    
    NSMutableURLRequest *dnsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseUrlString]];
    
    [dnsRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    dnsRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    dnsRequest.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak typeof(self) weakself = self;
    
    //拿到dns服务器的请求
    NSURLSessionDataTask *dnsTask = [session dataTaskWithRequest:dnsRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
            });
            return;
        }
        NSDictionary *dnsDict = [NSDictionary dictionaryWithXMLData:data];
        
        NSMutableURLRequest *csvRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dnsDict[@"dns.url"]]];
        [csvRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        csvRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
        csvRequest.HTTPMethod = @"POST";
        csvRequest.timeoutInterval = 10;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSURLSessionDataTask *csvTask = [session dataTaskWithRequest:csvRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                    });
                    return;
                }
                
                NSDictionary *csvDict = [NSDictionary dictionaryWithXMLData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakself.UserGoldLabel.text = [NSString stringWithFormat:@"您的金币为:%@",csvDict[@"current_yp"]];
                    weakself.goldNumber=[csvDict[@"current_yp"] integerValue];
                    [SVProgressHUD dismiss];
                });
            }];
            [csvTask resume];
            weakself.csvTask = csvTask;
        });
    }];
    [dnsTask resume];
    self.dnsTask = dnsTask;
}

//支付方式
- (void)payView
{
    self.myView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.myView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myView];
    self.myView.hidden = YES;
    
    
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,HBScreenWidth,self.myView.frame.size.height-240)];
    topView.backgroundColor=[UIColor clearColor];
    [self.myView addSubview:topView];

    UITapGestureRecognizer *dissMyView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissMyVieAction:)];
    [topView addGestureRecognizer:dissMyView];
    
    self.mybottonView=[[UIView alloc]initWithFrame:CGRectMake(0, self.myView.frame.size.height,HBScreenWidth,240)];
    self.mybottonView.backgroundColor=[UIColor whiteColor];
    [self.myView addSubview:self.mybottonView];
    
   UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,HBScreenWidth,240) style:UITableViewStylePlain ];
    [tableView registerNib:[UINib nibWithNibName:@"payTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"paycell"];
    tableView.delegate=self;
    tableView.dataSource=self;
    //tableView.backgroundColor=[UIColor clearColor];
    //分割线的颜色
    tableView.separatorColor=[UIColor lightGrayColor];
    //分割线的样式
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    //分割线距离上,左,下,右的距离
    tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    // 删除多余的cell
    [tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    tableView.scrollEnabled=NO;
    [self.mybottonView addSubview:tableView];
    

}


//table的协议方法
//每个分区里面有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}

//每行显示什么样的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    payTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paycell"];
    if (indexPath.row==0) {
        cell.touImageView.image=[UIImage imageNamed:@"wxpay"];
        cell.nameLabel.text=@"微信支付";
    }else{
       
       cell.touImageView.image=[UIImage imageNamed:@"aipay"];
       cell.nameLabel.text=@"支付宝支付";
       
    }
    return cell;
}


//几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}



//每一行的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}


//cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //微信支付
    if (indexPath.row==0) {
        
        [self  orderbuild:@"wxpay"];
    }
    //支付宝支付
    if (indexPath.row==1) {
        
        [self  orderbuild:@"aipay"];
    }
    
}


//自定义分区头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *namelabel=[[UILabel alloc]init];
    namelabel.backgroundColor=HBRGBColor(27, 169, 240, 1);
    namelabel.text=@"请选择支付方式";
    namelabel.textColor=[UIColor whiteColor];
    namelabel.textAlignment=NSTextAlignmentCenter;
    namelabel.font=[UIFont systemFontOfSize:22];
    return namelabel;
    
}
//分区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 60;
}


- (void)dissMyVieAction:(UITapGestureRecognizer *)tap
{
    //动画完成后消失视图
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(myViewDis) userInfo:nil repeats:NO];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.mybottonView.frame=CGRectMake(0, self.myView.frame.size.height, HBScreenWidth, 240);
      
    }];


}


- (void)myViewDis
{
    self.myView.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
