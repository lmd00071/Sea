//
//  SearchViewController.m
//  Petrel
//
//  Created by 李明丹 on 16/1/13.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "MyBookTableViewCell.h"
#import "NewLoginViewController.h"
#import "SearchTableViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>


//左边的视图
@property(nonatomic,strong)UIView *myView;
@property (nonatomic,strong)UIView *tapView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *photoView;

//记录数学语文英文
@property (nonatomic,strong)NSMutableArray *classArray;
//记录年级
@property (nonatomic,strong)NSMutableArray *classNumberArray;
//记录上下册
@property (nonatomic,strong)NSMutableArray *shangxiaArray;
//记录上下册
@property (nonatomic,strong)NSMutableArray *versionsArray;

@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UILabel *errorStringLabel;
@end

@implementation SearchViewController

//懒加载
- (NSMutableArray *)classArray
{
    if (!_classArray) {
        self.classArray=[NSMutableArray array];
    }
    
    return _classArray;
}

//懒加载
- (NSMutableArray *)classNumberArray
{
    if (!_classNumberArray) {
        self.classNumberArray=[NSMutableArray array];
    }
    
    return _classNumberArray;
}

//懒加载
- (NSMutableArray *)versionsArray
{
    if (!_versionsArray) {
        self.versionsArray=[NSMutableArray array];
    }
    
    return _versionsArray;
}

//懒加载
- (NSMutableArray *)shangxiaArray
{
    if (!_shangxiaArray) {
        self.shangxiaArray=[NSMutableArray array];
    }
    
    return _shangxiaArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    //设置导航栏
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"搜索";
    title.font=[UIFont systemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.113 green:0.588 blue:0.925 alpha:1];
//  self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"category.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftbackButtonAction:)];
    
    [self setClass];
    [self setupCancelSuccess];
}

//左侧点击返回
- (void)leftbackButtonAction:(UIBarButtonItem *)sender
{
    NSNotificationCenter *notiCenter=[NSNotificationCenter defaultCenter];
    [notiCenter postNotificationName:@"美女" object:self userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)setClass
{
    CGFloat m=700;
    CGFloat n;
    if ([UIScreen mainScreen].bounds.size.height>m) {
        
        n=[UIScreen mainScreen].bounds.size.height-(20+64);
        
    }else
    {
        
        n=[UIScreen mainScreen].bounds.size.height-(20+44);
    }
    
    //科目的布局******************************
    UILabel *classLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.05, n/7/4, n/7/2+SCREEN_WIDTH*0.03, n/7/2)];
    //classLabel.backgroundColor=[UIColor blueColor];
    classLabel.text=@"科目";
    classLabel.textColor=[UIColor blackColor];
    
    [self.view addSubview:classLabel];
    
    NSArray *classArray=@[@"语文",@"数学",@"英语"];
    for (int i=0; i<3; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(20+n/7/2+10+(SCREEN_WIDTH-(20+n/7/2+20))/13+(SCREEN_WIDTH-(20+n/7/2+20))/13*4*i, n/7/4, (SCREEN_WIDTH-(20+n/7/2+20))/13*3, n/7/2);
        button.backgroundColor=[UIColor colorWithRed:0.945 green:0.463 blue:0.329 alpha:1];
        button.tag=101+i;
        [button setTitle:classArray[i] forState:UIControlStateNormal];
        button.tintColor=[UIColor whiteColor];
        if ([UIScreen mainScreen].bounds.size.height==480) {
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            
        }else if ([UIScreen mainScreen].bounds.size.height==568) {
            button.titleLabel.font=[UIFont systemFontOfSize:17];
            
        }else{
            
            button.titleLabel.font=[UIFont systemFontOfSize:18];
        }
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius=15;
        button.layer.borderColor=[[UIColor colorWithRed:0.804 green:0.341 blue:0.078 alpha:1] CGColor];
        button.layer.borderWidth=2;
        button.clipsToBounds=YES;
        [self.view addSubview:button];
        
    }
    
    UIView *classView=[[UIView alloc]initWithFrame:CGRectMake(10, n/7, SCREEN_WIDTH-10, 1)];
    classView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:classView];

    //年纪布局*********************************
    UILabel *gradeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,n/7+n/7/4, n/7/2+SCREEN_WIDTH*0.03, n/7/2)];
    //classLabel.backgroundColor=[UIColor blueColor];
    gradeLabel.text=@"年级";
    gradeLabel.textColor=[UIColor blackColor];
    
    [self.view addSubview:gradeLabel];
    
    NSArray *gradeArray=@[@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级"];
    for (int i=0; i<6; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(20+n/7/2+10+(SCREEN_WIDTH-(20+n/7/2+20))/13+(SCREEN_WIDTH-(20+n/7/2+20))/13*4*(i%3), n/7+n/7/4+(n/7/2+n/7/4)*(i/3), (SCREEN_WIDTH-(20+n/7/2+20))/13*3, n/7/2);
        button.backgroundColor=[UIColor colorWithRed:0.945 green:0.463 blue:0.329 alpha:1];
        button.tag=201+i;
        [button setTitle:gradeArray[i] forState:UIControlStateNormal];
        button.tintColor=[UIColor whiteColor];
        
        if ([UIScreen mainScreen].bounds.size.height==480) {
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            
        }else if ([UIScreen mainScreen].bounds.size.height==568) {
            button.titleLabel.font=[UIFont systemFontOfSize:17];
            
        }else{
            
            button.titleLabel.font=[UIFont systemFontOfSize:18];
        }
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius=15;
        button.layer.borderColor=[[UIColor colorWithRed:0.804 green:0.341 blue:0.078 alpha:1] CGColor];
        button.layer.borderWidth=2;
        button.clipsToBounds=YES;
        [self.view addSubview:button];
        
    }
    
    UIView *gradeView=[[UIView alloc]initWithFrame:CGRectMake(10, n/7*3-n/7/4, SCREEN_WIDTH-10, 1)];
    gradeView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:gradeView];
    
    
    
    //册次************************************
    
    UILabel *bookNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, n/7*3, n/7/2+SCREEN_WIDTH*0.03, n/7/2)];
    //classLabel.backgroundColor=[UIColor blueColor];
    bookNumberLabel.text=@"册次";
    bookNumberLabel.textColor=[UIColor blackColor];
    
    [self.view addSubview:bookNumberLabel];
    
    NSArray *bookNumberArray=@[@"上册",@"下册"];
    for (int i=0; i<2; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(20+n/7/2+10+(SCREEN_WIDTH-(20+n/7/2+20))/13+(SCREEN_WIDTH-(20+n/7/2+20))/13*4*i, n/7*3, (SCREEN_WIDTH-(20+n/7/2+20))/13*3, n/7/2);
        button.backgroundColor=[UIColor colorWithRed:0.945 green:0.463 blue:0.329 alpha:1];
        button.tag=301+i;
        [button setTitle:bookNumberArray[i] forState:UIControlStateNormal];
        button.tintColor=[UIColor whiteColor];
        
        if ([UIScreen mainScreen].bounds.size.height==480) {
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            
        }else if ([UIScreen mainScreen].bounds.size.height==568) {
            button.titleLabel.font=[UIFont systemFontOfSize:17];
            
        }else{
            
            button.titleLabel.font=[UIFont systemFontOfSize:18];
        }
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius=15;
        button.layer.borderColor=[[UIColor colorWithRed:0.804 green:0.341 blue:0.078 alpha:1] CGColor];
        button.layer.borderWidth=2;
        button.clipsToBounds=YES;
        [self.view addSubview:button];
        
    }
    
    UIView *bookNumberView=[[UIView alloc]initWithFrame:CGRectMake(10, n/7*4-n/7/4, SCREEN_WIDTH-10, 1)];
    bookNumberView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:bookNumberView];
    
   //教材************************************
    UILabel *taetherLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, n/7*4, n/7/2+SCREEN_WIDTH*0.03, n/7/2)];
    //classLabel.backgroundColor=[UIColor blueColor];
    taetherLabel.text=@"教材";
    taetherLabel.textColor=[UIColor blackColor];
   
    [self.view addSubview:taetherLabel];
    
    NSArray *taetherArray=@[@"人教版",@"北师大版",@"语文S版",@"西师大版"];
    for (int i=0; i<taetherArray.count; i++) {
        
        UIButton *teatherbutton=[UIButton buttonWithType:UIButtonTypeCustom];
        teatherbutton.frame=CGRectMake(20+n/7/2+10+(SCREEN_WIDTH-(20+n/7/2+20))/13+(SCREEN_WIDTH-(20+n/7/2+20))/13*4*(i%3),n/7*4+(n/7/2+n/7/4)*(i/3), (SCREEN_WIDTH-(20+n/7/2+20))/13*3, n/7/2);
        teatherbutton.backgroundColor=[UIColor colorWithRed:0.945 green:0.463 blue:0.329 alpha:1];
        teatherbutton.tag=40001+i;
        [teatherbutton setTitle:taetherArray[i] forState:UIControlStateNormal];
        teatherbutton.tintColor=[UIColor whiteColor];
        
        if ([UIScreen mainScreen].bounds.size.height==480) {
            teatherbutton.titleLabel.font=[UIFont systemFontOfSize:14];
            
        }else if ([UIScreen mainScreen].bounds.size.height==568) {
            
            teatherbutton.titleLabel.font=[UIFont systemFontOfSize:14];
            
        }else{
        
            teatherbutton.titleLabel.font=[UIFont systemFontOfSize:16];
        }

        [teatherbutton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        teatherbutton.layer.cornerRadius=15;
        teatherbutton.layer.borderColor=[[UIColor colorWithRed:0.804 green:0.341 blue:0.078 alpha:1] CGColor];
        teatherbutton.layer.borderWidth=2;
        teatherbutton.clipsToBounds=YES;
        //teatherbutton.userInteractionEnabled=NO;
        [self.view addSubview:teatherbutton];

    }
    UIView *taetherView=[[UIView alloc]initWithFrame:CGRectMake(10, n/7*5+n/7/2, SCREEN_WIDTH-10, 1)];
    taetherView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:taetherView];
    
    //查找的button**************************************
    
    
    UIButton *searchbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    searchbutton.frame=CGRectMake(70,n/7*5+n/7/4+n/7/2, SCREEN_WIDTH-140, n/7-n/7/4*4/3);
    searchbutton.backgroundColor=[UIColor colorWithRed:0.875 green:0.427 blue:0.231 alpha:1];
    searchbutton.tag=1000;
    [searchbutton setTitle:@"查找" forState:UIControlStateNormal];
    searchbutton.tintColor=[UIColor whiteColor];
    searchbutton.titleLabel.font=[UIFont systemFontOfSize:25];
    
    [searchbutton addTarget:self action:@selector(searchbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    searchbutton.layer.cornerRadius=9;
    searchbutton.layer.borderColor=[[UIColor colorWithRed:0.875 green:0.427 blue:0.231 alpha:1] CGColor];
    searchbutton.layer.borderWidth=2;
    searchbutton.clipsToBounds=YES;
    [self.view addSubview:searchbutton];
    
    
    
    //判断当屏幕的高度是6P的时候
    CGFloat number6p=736;
    CGFloat number6=667;
    CGFloat number5=568;
    CGFloat number4=480;
    if ([UIScreen mainScreen].bounds.size.height==number6p) {
        
        classLabel.font=[UIFont systemFontOfSize:23];
        gradeLabel.font=[UIFont systemFontOfSize:23];
        bookNumberLabel.font=[UIFont systemFontOfSize:23];
        taetherLabel.font=[UIFont systemFontOfSize:23];
        
        
    }
    if ([UIScreen mainScreen].bounds.size.height==number6) {
        
       classLabel.font=[UIFont systemFontOfSize:22];
       gradeLabel.font=[UIFont systemFontOfSize:22];
       bookNumberLabel.font=[UIFont systemFontOfSize:22];
       taetherLabel.font=[UIFont systemFontOfSize:22];
        
    }
    if ([UIScreen mainScreen].bounds.size.height==number5) {
        
        classLabel.font=[UIFont systemFontOfSize:21];
        gradeLabel.font=[UIFont systemFontOfSize:21];
        bookNumberLabel.font=[UIFont systemFontOfSize:21];
        taetherLabel.font=[UIFont systemFontOfSize:21];
        
        
    }
    if ([UIScreen mainScreen].bounds.size.height==number4) {
        
        classLabel.font=[UIFont systemFontOfSize:19];
        gradeLabel.font=[UIFont systemFontOfSize:19];
        bookNumberLabel.font=[UIFont systemFontOfSize:19];
        taetherLabel.font=[UIFont systemFontOfSize:19];
        
        
    }
    
    
    
}

#pragma --mark 调用的方法

//点击查找的方法
- (void)searchbuttonAction:(UIButton *)sender
{
    
    
    SearchTableViewController *searVC=[[SearchTableViewController alloc]init];
    
    searVC.classArray=self.classArray;
    searVC.classNumberArray=self.classNumberArray;
    searVC.shangxiaArray=self.shangxiaArray;
    
    [self.navigationController pushViewController:searVC animated:YES];

}



//点击每个button的方法
- (void)buttonAction:(UIButton *)sender
{
    
    if (sender.selected) {
        [sender setSelected:NO];
        sender.backgroundColor=[UIColor colorWithRed:0.945 green:0.463 blue:0.329 alpha:1];
        
        if (100<sender.tag&&sender.tag<104) {
            
            switch (sender.tag) {
                case 101:
                    [self.classArray removeObject:@"chinese"];
                    break;
                case 102:
                  [self.classArray removeObject:@"maths"];
                    break;
                case 103:
                    [self.classArray removeObject:@"english"];
                    break;
                default:
                    break;
             }
        }else if (200<sender.tag&&sender.tag<207)
        {
            switch (sender.tag) {
                case 201:
                    [self.classNumberArray removeObject:@"1"];
                    break;
                case 202:
                    [self.classNumberArray removeObject:@"2"];
                    break;
                case 203:
                    [self.classNumberArray removeObject:@"3"];
                    break;
                case 204:
                    [self.classNumberArray removeObject:@"4"];
                    break;
                case 205:
                    [self.classNumberArray removeObject:@"5"];
                    break;
                case 206:
                    [self.classNumberArray removeObject:@"6"];
                    break;
                default:
                    break;
            }
        
        
        }else if (300<sender.tag&&sender.tag<303)
        {
            switch (sender.tag) {
                case 301:
                    [self.shangxiaArray removeObject:@"1"];
                    break;
                case 302:
                    [self.shangxiaArray removeObject:@"2"];
                    break;
                default:
                    break;
            }
            
            
        }

        
    }else{
        
        [sender setSelected:YES];
        sender.backgroundColor=[UIColor colorWithRed:0.882 green:0.219 blue:0.4 alpha:1];
        
        if (100<sender.tag&&sender.tag<104) {
            
            switch (sender.tag) {
                case 101:
                    [self.classArray addObject:@"chinese"];
                    break;
                case 102:
                    [self.classArray addObject:@"maths"];
                    break;
                case 103:
                    [self.classArray addObject:@"english"];
                    break;
                default:
                    break;
            }
            
        }else if (200<sender.tag&&sender.tag<207)
        {
            switch (sender.tag) {
                case 201:
                    [self.classNumberArray addObject:@"1"];
                    break;
                case 202:
                    [self.classNumberArray addObject:@"2"];
                    break;
                case 203:
                    [self.classNumberArray addObject:@"3"];
                    break;
                case 204:
                    [self.classNumberArray addObject:@"4"];
                    break;
                case 205:
                    [self.classNumberArray addObject:@"5"];
                    break;
                case 206:
                    [self.classNumberArray addObject:@"6"];
                    break;
                default:
                    break;
            }
            
            
        }else if (300<sender.tag&&sender.tag<303)
        {
            switch (sender.tag) {
                case 301:
                    [self.shangxiaArray addObject:@"1"];
                    break;
                case 302:
                    [self.shangxiaArray addObject:@"2"];
                    break;
                default:
                    break;
            }
            
            
        }

        
    }
    
    
    if (40001<sender.tag&&sender.tag<40005)
    {
        [sender setSelected:NO];
        sender.backgroundColor=[UIColor colorWithRed:0.945 green:0.463 blue:0.329 alpha:1];
        //[SVProgressHUD showImage:nil status:@"敬请期待新课程!"];
        self.errorStringLabel.text=@"敬请期待新课程!";
        self.backgroundView.hidden=NO;
        
    }
    

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

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
