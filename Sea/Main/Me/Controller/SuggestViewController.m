//
//  SuggestViewController.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/6/21.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "SuggestViewController.h"
#define NavBarFgColor [UIColor whiteColor]
#define NavTextAttribute @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}
@interface SuggestViewController ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *suggsetLabel;
@property (strong, nonatomic) IBOutlet UITextView *InputText;

@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UILabel *errorStringLabel;
@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"意见反馈";
    self.navigationController.navigationBar.barTintColor=HBRGBColor(27, 169, 240, 1);
    self.navigationController.navigationBar.tintColor=NavBarFgColor;
    self.navigationController.navigationBar.titleTextAttributes=NavTextAttribute;
    //设置成导航栏下面开始计算
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bookshop_1_back1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huishou:)];
    [self.view addGestureRecognizer:tap];
    _InputText.delegate=self;
    [self setupCancelSuccess];

}
//提交的方法
- (IBAction)SendbuttonAction:(UIButton *)sender {
    
    [SVProgressHUD showWithStatus:@"正在提交..."];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(send) userInfo:nil repeats:NO];
    
}

//清除缓存
- (void)send
{
    [SVProgressHUD dismiss];
    self.errorStringLabel.text=@"提交成功";
    self.backgroundView.hidden=NO;
  
}

//点击输入的文字的地方
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _suggsetLabel.hidden=YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_InputText.text isEqualToString:@""]) {
        
        _suggsetLabel.hidden=NO;
    }else{
        
        _suggsetLabel.hidden=YES;
    }
    
}
//键盘回收
- (void)huishou:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
#pragma --mark 方法
//点击左侧的按键的方法
- (void)leftBarButtonAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
