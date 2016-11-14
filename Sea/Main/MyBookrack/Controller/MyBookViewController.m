//
//  MyBookViewController.m
//  book
//
//  Created by 李明丹 on 16/1/12.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "MyBookViewController.h"
#import "AppDelegate.h"
#import "MyBookTableViewCell.h"
#import "NewLoginViewController.h"
#import "SearchViewController.h"
#import "detailTableViewController.h"
#import "DataBase.h"
#import "userBookModel.h"
#import "Book_PageViewController.h"
#import "BWShakeController.h"
#import "MeViewController.h"
#import "UIImageView+WebCache.m"
#import "MeTableViewController.h"
#import "GoldTableViewController.h"
#import "PHBRank.h"
#import "SDImageCache.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface MyBookViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *bookArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) NSInteger currentTag;
@property (nonatomic) NSInteger deletaTag;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic) BOOL isEdit;
@property (nonatomic) BOOL isPush;
@property (nonatomic,strong)DataBase *dataBase;

//左边的视图
@property(nonatomic,strong)UIView *myView;
@property (nonatomic,strong)UIView *tapView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *photoView;
@property (nonatomic,strong)UIImageView *photoImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@end

@implementation MyBookViewController

- (NSMutableArray *)bookArr
{
    if (!_bookArr) {
        self.bookArr = [NSMutableArray array];
    }
    return _bookArr;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self setBookRack];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.635 green:0.867 blue:0.984 alpha:1];
     [SVProgressHUD setMinimumDismissTimeInterval:20];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //设置导航栏
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"我的书架";
    title.font=[UIFont systemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.113 green:0.588 blue:0.925 alpha:1];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"category.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    
    self.editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = self.editButton;

    self.editButton.tintColor=[UIColor colorWithRed:0.855 green:0.831 blue:0.823 alpha:1];
    //设置成导航栏下面开始计算
    self.navigationController.navigationBar.translucent = NO;
    
    //添加扫手势
    //屏幕边缘拖拽手势
    UIScreenEdgePanGestureRecognizer *screenPan=[[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(rightBarButtonAction:)];
    [self.view addGestureRecognizer:screenPan];
    //从那个方向滑,默认是都不支持
    screenPan.edges=UIRectEdgeLeft;
}

//设置书架框
-(void)setBookRack
{
    [self.scrollView removeFromSuperview];
    //从数据取值
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    NSString *name;
    if (userMessage.user_msisdn.length>0) {
        
        name=userMessage.user_msisdn;
        
    }else{
        name=@"游客";
        
    }
    [self.bookArr removeAllObjects];
    self.dataBase=[[DataBase alloc]init];
    [self.dataBase creatUserBookDataBaseUserName:name];
    self.bookArr=[self.dataBase allUserBookUserName:name];
    
    CGFloat m=700;
    CGFloat n;
    if ([UIScreen mainScreen].bounds.size.height>m) {
        
        n=[UIScreen mainScreen].bounds.size.height-(20+64);
        
    }else
    {
        
        n=[UIScreen mainScreen].bounds.size.height-(20+44);
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, n)];
    [self.view addSubview:self.scrollView];
    self.scrollView.scrollsToTop=YES;
    //边缘弹动效果
    self.scrollView.bounces=NO;
    CGSize size = CGSizeMake(HBScreenWidth/3.0, 170);
    CGFloat jiange = (SCREEN_WIDTH - size.width * 3) / 4;
    //NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"books"]];
    
    //判断当屏幕的高度是6P的时候
    CGFloat number6p=736;
    CGFloat number6=667;
    CGFloat number5=568;
    CGFloat number4=480;
    NSInteger numberPhone=0;
    NSInteger numberBook=0;
    if ([UIScreen mainScreen].bounds.size.height==number6p) {
        numberPhone=2;
        numberBook=3;
    }
    if ([UIScreen mainScreen].bounds.size.height==number6) {
        numberPhone=2;
        numberBook=3;
    }
    if ([UIScreen mainScreen].bounds.size.height==number5) {
        numberPhone=2;
        numberBook=3;
    }
    if ([UIScreen mainScreen].bounds.size.height==number4) {
        numberPhone=1;
        numberBook=2;
    }
 
    NSInteger bgRoew = self.bookArr.count / numberBook;
    if (bgRoew < numberBook) {
        bgRoew = numberPhone;
    }
    for (int j = 0; j < bgRoew + 1; j++) {
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (size.height + jiange+30) * j, SCREEN_WIDTH, size.height + jiange+30)];
        bgImageView.image = [UIImage imageNamed:@"book_box_02.png"];
        [self.scrollView addSubview:bgImageView];
    }

    self.scrollView.contentSize = CGSizeMake(0,(size.height + jiange+30)*(bgRoew+1));
    //点击状态栏回到顶部

    NSInteger count = self.bookArr.count;
    NSInteger addCount = 0;
    NSInteger addTag = count - addCount;
    
    
    if (addCount != 0) {
        count = count - addCount;
    }
    NSInteger number = 0;
    NSInteger row = 0;
    for (int i = 0 ; i < self.bookArr.count+1; i++) {
        
        if (i % 3 != 0) {
            
            number++;
        }
        else{
            if (i > 2) {
                row++;
            }
            number = 0;
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(jiange + (size.width + jiange) * number, jiange / 5 +(size.height + jiange+30) * row, size.width, size.height+jiange)];
        //view.backgroundColor = [UIColor blackColor];
        //view.alpha = 0.5;
        view.tag=i+6000;
        [self.scrollView addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        if (i==self.bookArr.count) {
            
            
            imageView.frame = CGRectMake((HBScreenWidth/3.0-80)/2.0,15,80,size.height-50);
            imageView.image=[UIImage imageNamed:@"book_box_05.png"];
            imageView.tag = 666;
            [view addSubview:imageView];
        }else{
            
            
            userBookModel *model=self.bookArr[i];
            imageView.frame = CGRectMake((HBScreenWidth/3.0-80)/2.0,15,80,size.height-50);
            imageView.image=model.iconImage;
            //添加长按手势
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
            [imageView addGestureRecognizer:longPress];
            
            imageView.tag =500 + 1;
            [view addSubview:imageView];
            
            
            //添加删除按键
            UIImageView *deleteUV=[[UIImageView alloc]initWithFrame:CGRectMake((HBScreenWidth/3.0-80)/2.0+80-5, 0, 23,23)];
            deleteUV.image=[UIImage imageNamed:@"delete.png"];
            deleteUV.userInteractionEnabled=YES;
            deleteUV.tag=30000+i;
            deleteUV.hidden=YES;
            [view addSubview:deleteUV];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((HBScreenWidth/3.0-80)/2.0+80, 0, (HBScreenWidth/3.0-(HBScreenWidth/3.0-80)/2.0+80)*2, 50);
            //button.backgroundColor=[UIColor redColor];
            button.tag=3000+i;
            button.userInteractionEnabled=YES;
            button.hidden=YES;
            [button addTarget:self action:@selector(deleteBook:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            
            
    
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,size.height-35,size.width,20)];
        nameLabel.text = model.textbook_name;
        nameLabel.font=[UIFont fontWithName:@"Marion-Bold" size:10];
        //nameLabel.font = [UIFont systemFontOfSize:10];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor blackColor];
        [view addSubview:nameLabel];
        
        UILabel *classNumberlabel = [[UILabel alloc] initWithFrame:CGRectMake((HBScreenWidth/3.0-80)/2.0+7,size.height-20,size.width/2,20)];
            NSInteger n=[model.grade_order_no integerValue];
            NSString *str=[[NSString alloc]init];
            switch (n) {
                case 1:
                    str=@"一年级";
                    break;
                case 2:
                    str=@"二年级";
                    break;
                case 3:
                    str=@"三年级";
                    break;
                case 4:
                    str=@"四年级";
                    break;
                case 5:
                    str=@"五年级";
                    break;
                case 6:
                    str=@"六年级";
                    break;
                default:
                    break;
            }
        classNumberlabel.text = str;
        classNumberlabel.font = [UIFont systemFontOfSize:10];
        //classNumberlabel.textAlignment = NSTextAlignmentCenter;
        classNumberlabel.textColor = [UIColor colorWithRed:0.118 green:0.118 blue:0.118 alpha:1];
        [view addSubview:classNumberlabel];
        
        UILabel *shangxialabel = [[UILabel alloc] initWithFrame:CGRectMake(size.width/2+4,size.height-20, size.width/2, 20)];
            NSInteger m=[model.grade_half_order_no integerValue];
            NSString *strNumber=[[NSString alloc]init];
            switch (m) {
                case 1:
                    strNumber=@"上册";
                    break;
                case 2:
                    strNumber=@"下册";
                    break;
                default:
                    break;
            }
        shangxialabel.text = strNumber;
        shangxialabel.font = [UIFont systemFontOfSize:10];
        //shangxialabel.textAlignment = NSTextAlignmentCenter;
        shangxialabel.textColor =  [UIColor colorWithRed:0.118 green:0.118 blue:0.118 alpha:1];
        [view addSubview:shangxialabel];
        
        }
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBook:)];
        [imageView addGestureRecognizer:tap];

        
    }
//    if (addCount != 0) {
//        for (int i = 0; i < addCount; i++) {
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, 80, 90)];
//            ListModel *model = self.bookArr[addTag];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", model.cover]]];
//            imageView.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBook:)];
//            [imageView addGestureRecognizer:tap];
//            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
//            [imageView addGestureRecognizer:longPress];
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 80, 20)];
//            view.backgroundColor = [UIColor blackColor];
//            view.alpha = 0.5;
//            [imageView addSubview:view];
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 80, 20)];
//            label.font = [UIFont systemFontOfSize:10];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.textColor = [UIColor whiteColor];
//            label.text = model.name;
//            [imageView addSubview:label];
//            addTag++;
//            imageView.tag = addTag;
//            [self.scrollView addSubview:imageView];
//        }
//    }
    UIView *viewScroll = (UIView *)[self.view viewWithTag:self.bookArr.count];
    if (CGRectGetMaxY(viewScroll.frame) > SCREEN_HEIGHT) {
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(viewScroll.frame) + 60);
    }
    
    if (addCount != 0) {
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction) userInfo:nil repeats:NO];
        
    }

    self.isEdit = NO;
    
}
//设置左侧的边栏
- (void)leftView
{
    self.myView=[[UIView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH+40, SCREEN_HEIGHT*0.27, SCREEN_WIDTH-40, SCREEN_HEIGHT-SCREEN_HEIGHT*0.27)];
    self.myView.backgroundColor=[UIColor colorWithRed:0.153 green:0.180 blue:0.192 alpha:0.8];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myView];

    //我的头像View
    self.photoView=[[UIView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH+40, 0, SCREEN_WIDTH-40, SCREEN_HEIGHT*0.27)];
    //self.photoView.backgroundColor=[UIColor colorWithRed:0.839 green:0.302 blue:0.259 alpha:1];
    self.photoView.backgroundColor=HBRGBColor(254, 191, 24, 1);
    self.photoView.alpha=1;
    [[UIApplication sharedApplication].keyWindow addSubview:self.photoView];
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    
    _photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.08, SCREEN_WIDTH*0.125, SCREEN_WIDTH*0.187, SCREEN_WIDTH*0.187)];
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:userMessage.photo_icon_url] placeholderImage:[UIImage imageNamed:@"setting_default_head"]];
    _photoImageView.layer.cornerRadius=SCREEN_WIDTH*0.187/2;
    _photoImageView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _photoImageView.layer.borderWidth=2;
    _photoImageView.clipsToBounds=YES;
    _photoImageView.userInteractionEnabled=YES;
    [self.photoView addSubview:_photoImageView];
    
    UITapGestureRecognizer *photoTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoButtonAction)];
    [_photoImageView addGestureRecognizer:photoTap];
    
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.08, SCREEN_WIDTH*0.327, SCREEN_WIDTH*0.19, SCREEN_WIDTH*0.053)];
    
    if (userMessage.user_msisdn.length>0) {
        
        if (userMessage.user_name.length>0) {
            self.nameLabel.text=userMessage.user_name;
        }else{
            NSString *fourStr=[userMessage.user_msisdn substringFromIndex:7];
            self.nameLabel.text=fourStr;
        }
    }else{
        self.nameLabel.text=@"游客";
    }
    _nameLabel.textColor=[UIColor whiteColor];
    
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    [self.photoView addSubview:_nameLabel];
    
    
    //判断当屏幕的高度是6P的时候
    CGFloat number6p=736;
    CGFloat number6=667;
    CGFloat number5=568;
    CGFloat number4=480;
    if ([UIScreen mainScreen].bounds.size.height==number6p) {
        _nameLabel.font=[UIFont systemFontOfSize:19];
        
    }
    if ([UIScreen mainScreen].bounds.size.height==number6) {
        
       _nameLabel.font=[UIFont systemFontOfSize:17];
        
    }
    if ([UIScreen mainScreen].bounds.size.height==number5) {
        
    _nameLabel.font=[UIFont systemFontOfSize:15];
        
        
    }
    if ([UIScreen mainScreen].bounds.size.height==number4) {
        
        
        _nameLabel.font=[UIFont systemFontOfSize:13];
        
    }
    
    
    
    //添加点击视图删除的view
    self.tapView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0,40, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tapView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDisMissMyView:)];
    [self.tapView addGestureRecognizer:tap];
    
    //添加tableview
    
     self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, SCREEN_HEIGHT-180) style:UITableViewStylePlain ];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    //分割线的颜色
    self.tableView.separatorColor=[UIColor lightGrayColor];
    //分割线的样式
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    //分割线距离上,左,下,右的距离
    self.tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    // 删除多余的cell
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.tableView.scrollEnabled=NO;
    [self.myView addSubview:self.tableView];
    
    
    //添加轻扫手势
    //轻扫手势
    UISwipeGestureRecognizer *swip=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiptapDisMissMyView:)];

    //轻扫的方向,默认是向右滑
    swip.direction=UISwipeGestureRecognizerDirectionLeft;
    //需要几根手指轻扫
    //    swip.numberOfTouchesRequired=2;
    [self.tableView addGestureRecognizer:swip];
    
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        // 设置view弹出来的位置
        self.myView.frame=CGRectMake(0, SCREEN_HEIGHT*0.27, SCREEN_WIDTH-40, SCREEN_HEIGHT-SCREEN_HEIGHT*0.27);
        //view1.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.photoView.frame=CGRectMake(0, 0, SCREEN_WIDTH-40, SCREEN_HEIGHT*0.27);
        
    }];


}


//table的协议方法
//每个分区里面有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //    return self.stuArr.count;
    
    return 7;
    
}

//每行显示什么样的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //从重用池(重用队列)里面取出一个cell
    MyBookTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"reuse"];
    
    //判断取到的cell是否为空
    if (cell==nil) {
        //如果取到的cell为空,创建一个cell
        cell=[[MyBookTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuse"];
    }
    NSArray *nameArray=@[@"搜索",@"我的书架",@"图书商城",@"摇一摇",@"积分",@"金币",@"设置"];
    
    cell.photoImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"海燕平台_0%ld.png",(indexPath.row+1)]];
    cell.backImageView.image=[UIImage imageNamed:@"海燕平台_09.png"];
    cell.nameLabel.text=nameArray[indexPath.row];
    
    
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
    return SCREEN_HEIGHT*0.09;
    
}


//cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //搜索
    if (indexPath.row==0) {
        
        [self tapDisMissMyView:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(SearchView) userInfo:nil repeats:NO];
    }
    //我的书架
    if (indexPath.row==1) {
        [self tapDisMissMyView:nil];
    }
    //读书商城
    if (indexPath.row==2) {
        [self tapDisMissMyView:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(Bookpage) userInfo:nil repeats:NO];
    
    }
    //摇一摇
    if (indexPath.row==3) {
        
        NSMutableArray *userArray=[NSMutableArray array];
        userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
        loginOrReginModel *userMessage = userArray.lastObject;
        if (userMessage.user_msisdn.length>0) {
            
            [self tapDisMissMyView:nil];
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(shake) userInfo:nil repeats:NO];
            
        }else{
            
            [self tapDisMissMyView:nil];
            
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pushView) userInfo:nil repeats:NO];
            
        }
        
    }
    //积分
    if (indexPath.row==4) {
        
        [self tapDisMissMyView:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(bank) userInfo:nil repeats:NO];
        
    }

    //金币
    if (indexPath.row==5) {
        
        NSMutableArray *userArray=[NSMutableArray array];
        userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
        loginOrReginModel *userMessage = userArray.lastObject;
        if (userMessage.user_msisdn.length>0) {
            
            [self tapDisMissMyView:nil];
            
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(goldAction) userInfo:nil repeats:NO];
            
        }else{
            
            [self tapDisMissMyView:nil];
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pushView) userInfo:nil repeats:NO];
        }
        
    }
    //设置
    if (indexPath.row==6) {
        [self tapDisMissMyView:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(set) userInfo:nil repeats:NO];
        
    }
    
}


#pragma --mark 调用的方法
//点击设置转到登录页面
- (void)set
{
    //创建Storyboard
    UIStoryboard *meST=[UIStoryboard storyboardWithName:@"MeViewController" bundle:[NSBundle mainBundle]];
    //我的
    //第一个参数是上面创建的,第二个是storyboard ID
    MeTableViewController  *MEAndSchoolController = [meST instantiateViewControllerWithIdentifier:@"meST"];
    //MEAndSchoolController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:MEAndSchoolController animated:YES];
}

//点击金币转到登录页面
- (void)goldAction
{
    //创建Storyboard
    UIStoryboard *goldST=[UIStoryboard storyboardWithName:@"Gold" bundle:[NSBundle mainBundle]];
    //我的
    //第一个参数是上面创建的,第二个是storyboard ID
    GoldTableViewController  *goldVC = [goldST instantiateViewControllerWithIdentifier:@"goldST"];
    [self.navigationController pushViewController:goldVC animated:YES];
}

//点击书城转到书城页面
- (void)Bookpage
{
    Book_PageViewController *bookVC=[[Book_PageViewController alloc]init];
    [self.navigationController pushViewController:bookVC animated:YES];
    
}
//点击摇一摇
- (void)shake
{
    
    BWShakeController *shakeVc = [[BWShakeController alloc] init];
    [self.navigationController pushViewController:shakeVc animated:YES];
    
}
//点击积分
- (void)bank{
    
    PHBRank *bankVC=[[PHBRank alloc]init];
    [self.navigationController pushViewController:bankVC animated:YES];
    
}
//点击搜索的页面
-(void)SearchView
{
    SearchViewController *searchVC=[[SearchViewController alloc]init];
    
    NSNotificationCenter *notiCenter=[NSNotificationCenter defaultCenter];
    
    //参数1:观察者
    //参数2:收到消息的时候执行方法,带一个NSNotification类型的参数,就是别的对象发送通知
    //参数3:想接收的消息的名字
    //参数4:想接收谁发的消息
    [notiCenter addObserver:self selector:@selector(recieveNotification:) name:@"美女" object:nil];

    
    [self.navigationController pushViewController:searchVC animated:YES];

}

//通知回来的方法
- (void)recieveNotification:(NSNotification *)noti
{
    [self.bookArr removeAllObjects];
    NSArray *array=[self.view subviews];
    for (int i=0; i<array.count; i++) {
        
        [array[i] removeFromSuperview];
        
    }
    
    [self setBookRack];
    
    
}


//左边点击的方法
- (void)leftBarButtonAction:(UIBarButtonItem *)sender
{
    [self leftView];
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:userMessage.photo_icon_url] placeholderImage:[UIImage imageNamed:@"setting_default_head"]];
    if (userMessage.user_msisdn.length>0) {
        
        if (userMessage.user_name.length>0) {
            self.nameLabel.text=userMessage.user_name;
        }else{
            NSString *fourStr=[userMessage.user_msisdn substringFromIndex:7];
            self.nameLabel.text=fourStr;
        }
    }else{
        self.nameLabel.text=@"游客";
    }
}

//右边点击的方法
- (void)rightBarButtonAction:(UIBarButtonItem *)sender
{
    
    if (self.isEdit) {
        [self.editButton setTitle:@"编辑"];
       
        for (int i=0; i<self.bookArr.count; i++) {
            
            UIView *viewarray=[self.view viewWithTag:i+6000];
            NSArray *arrayView=[viewarray subviews];
            
            UIImageView *imageVive=arrayView[0];
            imageVive.userInteractionEnabled=YES;
            
            UIImageView *delete=arrayView[1];
            //delete.userInteractionEnabled=NO;
            delete.hidden=YES;
        
            UIButton *button=arrayView[2];
            ///button.userInteractionEnabled=NO;
            button.hidden=YES;
        }
        
        UIImageView *iamgeView1=[self.view viewWithTag:666];
        iamgeView1.userInteractionEnabled=YES;
        
        self.isEdit = NO;
    }
    else{
        [self longAction:nil];
        
    }
    
}

//动画消失的动画
- (void)tapDisMissMyView:(UITapGestureRecognizer *)tap;
{
    //动画完成后消失视图
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeAll) userInfo:nil repeats:NO];
    
    [self.tapView removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        
        // 设置view弹出来的位置
        self.myView.frame=CGRectMake(-SCREEN_WIDTH+40, SCREEN_HEIGHT*0.27, SCREEN_WIDTH-40, SCREEN_HEIGHT-SCREEN_HEIGHT*0.27);
        //view1.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.photoView.frame=CGRectMake(-SCREEN_WIDTH+40, 0, SCREEN_WIDTH-40, SCREEN_HEIGHT*0.27);
        
    }];
    
}

//轻扫动画消失
- (void)swiptapDisMissMyView:(UISwipeGestureRecognizer *)swip
{
    //动画完成后消失视图
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeAll) userInfo:nil repeats:NO];
    
    [self.tapView removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        
        // 设置view弹出来的位置
        self.myView.frame=CGRectMake(-SCREEN_WIDTH+40, SCREEN_HEIGHT*0.27, SCREEN_WIDTH-40, SCREEN_HEIGHT-SCREEN_HEIGHT*0.27);
        //view1.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.photoView.frame=CGRectMake(-SCREEN_WIDTH+40, 0, SCREEN_WIDTH-40, SCREEN_HEIGHT*0.27);
        
    }];
    
    
    
    
}



//动画消失后视图消失
- (void)removeAll
{

    [self.myView removeFromSuperview];
    [self.photoView removeFromSuperview];

}


//点击头像的方法
- (void)photoButtonAction
{
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    if (userMessage.user_msisdn.length>0) {
        [self tapDisMissMyView:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(photoButton) userInfo:nil repeats:NO];
    }else{
        
        [self tapDisMissMyView:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pushView) userInfo:nil repeats:NO];
        
    }
    
}

//
- (void)pushView
{
    UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:@"提示" message:@"您还没登录，请先登录" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NewLoginViewController *logVC=[[NewLoginViewController alloc]init];
        logVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:logVC animated:YES completion:nil];
        
    }];
    
    UIAlertAction *alertAction1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alertControll addAction:alertAction];
    [alertControll addAction:alertAction1];
    [self presentViewController:alertControll animated:YES completion:nil];
    
    //[SVProgressHUD showErrorWithStatus:@"请先登录"];

}

- (void)photoButton{

    MeViewController *meVC=[[MeViewController alloc]init];
    [self.navigationController pushViewController:meVC animated:YES];

}


//书架上面的点击的方法*******************************************
//点击方法
- (void)tapBook:(UITapGestureRecognizer *)sender
{
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UIView *view=(UIView *)[imageView superview];
    self.isPush = YES;
    if (view.tag-6000<self.bookArr.count) {
        
        userBookModel *model=self.bookArr[view.tag-6000];
        
        detailTableViewController *detaVC=[[detailTableViewController alloc]init];
        detaVC.uid=model.text_book_uid;        
        [self.navigationController pushViewController:detaVC animated:YES];

        
    }else{
    
        [self SearchView];
    
    }

}


#pragma mark--长按方法
- (void)longAction:(UILongPressGestureRecognizer *)sender
{
    
    
    for (int i=0; i<self.bookArr.count; i++) {
        
        UIView *viewarray=[self.view viewWithTag:i+6000];
         NSArray *arrayView=[viewarray subviews];
        
        if (arrayView.count!=0) {
            UIImageView *imageVive=arrayView[0];
            imageVive.userInteractionEnabled=NO;
            
            UIImageView *delete=arrayView[1];
            delete.userInteractionEnabled=YES;
            delete.hidden=NO;
            
            UIButton *button=arrayView[2];
            button.userInteractionEnabled=YES;
            button.hidden=NO;
        }
        
    }
    
    UIImageView *iamgeView1=[self.view viewWithTag:666];
    iamgeView1.userInteractionEnabled=NO;
    
    self.isEdit = YES;
    [self.editButton setTitle:@"完成"];
}


#pragma mark--删除小说方法
- (void)deleteBook:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"删除中..."];
    
    NSInteger number=sender.tag;
    UIImageView *delete=[self.view viewWithTag:(number*10)];
    [delete superview];
    
    UIView *view=[sender superview];
    self.deletaTag = view.tag-6000;
    userBookModel *model=self.bookArr[self.deletaTag];

    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    NSString *name;
    if (userMessage.user_msisdn.length>0) {
        name=userMessage.user_msisdn;
    }else{
        name=@"游客";
        
    }
    
    self.dataBase=[[DataBase alloc]init];
    [self.dataBase creatUserBookDataBaseUserName:name];
    [self.dataBase deleteUserFromBriefUid:model.text_book_uid UserName:name];
    
    self.dataBase=[[DataBase alloc]init];
    [self.dataBase creatUnitDataBaseUidName:model.text_book_uid];
    [self.dataBase deleteUnitFromBriefUid:model.text_book_uid];
    
    self.dataBase=[[DataBase alloc]init];
    [self.dataBase creatABJuanDataBaseUidName:model.text_book_uid];
    [self.dataBase deleteABJuanFromBriefUid:model.text_book_uid];
    
    self.dataBase=[[DataBase alloc]init];
    [self.dataBase creatVideoDataBaseUidName:model.text_book_uid];
    [self.dataBase deleteVideoFromBriefUid:model.text_book_uid];
    [self.bookArr removeObjectAtIndex:self.deletaTag];
    
    //清楚缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [sender.superview removeFromSuperview];
    
    
    NSInteger tag = 6000;
    for (UIView *View1 in self.scrollView.subviews) {
        
        if (View1.subviews.count != 0) {
            View1.tag = tag;
            tag++;
        }
    }
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(deleteBookAnimation) userInfo:nil repeats:NO];
    
}

#pragma mark--删除小说动画
- (void)deleteBookAnimation
{

    NSInteger number = (self.deletaTag) % 3;
    NSInteger row = (self.deletaTag) / 3;
    CGSize size = CGSizeMake(HBScreenWidth/3.0, 170);
    CGFloat jiange = (SCREEN_WIDTH - size.width * 3) / 4;
    UIView *viewNew= [self.view viewWithTag:self.deletaTag+6000];
    __block MyBookViewController *bookVC = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        viewNew.frame = CGRectMake(jiange + (size.width + jiange) * number, jiange / 5 + (size.height + jiange) * row, size.width, size.height);
        
    } completion:^(BOOL finished) {
        if (bookVC.deletaTag == self.bookArr.count+1) {
            
            [SVProgressHUD showSuccessWithStatus:@"删除完成"];
            return;
        }
        bookVC.deletaTag++;
        [bookVC deleteBookAnimation];
    }];
}


#pragma mark--添加小说动画效果
- (void)timeAction
{
    
    NSInteger tag = self.bookArr.count ;
    self.currentTag = tag + 1;
    CGSize size = CGSizeMake(80, 90);
    CGFloat jiange = (SCREEN_WIDTH - size.width * 3) / 4;
    NSInteger number = (tag) % 3;
    NSInteger row = (tag) / 3;
    if (tag == 0) {
        number = 0;
        row = 0;
    }
    __block MyBookViewController *bookVC = self;
    UIImageView *addImageView = [self.scrollView viewWithTag:self.currentTag];
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        addImageView.frame = CGRectMake(jiange + (size.width + jiange) * number, jiange / 5 + (size.height + jiange) * row, size.width, size.height);
    } completion:^(BOOL finished) {
        
//        if ([ListManager shareListManager].addBook == 0) {
//            bookVC.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(addImageView.frame));
//            //            [BookChapterManager shareBookChapterManager].addBook = 0;
//            return;
//        }
        [bookVC timeAction];
    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    if (!self.isPush) {
        
        [self.bookArr removeAllObjects];
    }
}

- (void)dismis
{
    self.isPush = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"美女" object:nil];
    
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
