//
//  detailTableViewController.m
//  Petrel
//
//  Created by 李明丹 on 16/1/18.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "detailTableViewController.h"
#import "detailTableViewCell.h"
#import "AvPalyTableViewController.h"
#import "DataBase.h"
#import "detaiModel.h"
#import "DataBase.h"
#import "NewLoginViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface detailTableViewController ()

@property (nonatomic,strong)UIView *myView;
@property (nonatomic,strong)DataBase *dataBase;
@property (nonatomic,strong)NSMutableArray *detalArray;
//AB卷
@property (nonatomic,strong)DataBase *dataBase1;
@property (nonatomic,strong)NSMutableArray *ABArray;
@property (nonatomic,strong)NSMutableArray *abArray;
@property (nonatomic,assign)NSInteger ABNumber;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation detailTableViewController

//懒加载
- (NSMutableArray *)detalArray
{
    if (!_detalArray) {
        self.detalArray=[NSMutableArray array];
    }
    
    return _detalArray;
}

//懒加载
- (NSMutableArray *)ABArray
{
    if (!_ABArray) {
        
        self.ABArray=[NSMutableArray array];
    }
    
    return _ABArray;
}


//懒加载
- (NSMutableArray *)abArray
{
    if (!_abArray) {
        
        self.abArray=[NSMutableArray array];
    }
    
    return _abArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //取数据
    
    self.dataBase=[[DataBase alloc]init];
    [self.dataBase creatUnitDataBaseUidName:self.uid];
    self.detalArray=[self.dataBase allUnitUidName:self.uid];
    
    //设置导航栏
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"单元目录";
    title.font=[UIFont systemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.113 green:0.588 blue:0.925 alpha:1];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    
    
    //设置成导航栏下面开始计算
    self.navigationController.navigationBar.translucent = NO;
    
    // 删除多余的cell
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.tableView.backgroundColor=[UIColor colorWithRed:0.784 green:0.910 blue:1 alpha:1];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.detalArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //从重用池(重用队列)里面取出一个cell
    detailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cells"];
    
    //判断取到的cell是否为空
    if (cell==nil) {
        //如果取到的cell为空,创建一个cell
        cell=[[detailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cells"];
    }
    
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor clearColor];
    }else{
        
        cell.backgroundColor=[UIColor colorWithRed:0.533 green:0.788 blue:0.945 alpha:1];
    }
    detaiModel *model=self.detalArray[indexPath.row];
    
   cell.titleLabel.text=model.lesson_name;
    
    return cell;
}



//每一行的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat m=700;
    CGFloat n;
    if ([UIScreen mainScreen].bounds.size.height>m) {
        
        n=[UIScreen mainScreen].bounds.size.height-(20+64);
        
    }else
    {
        
        n=[UIScreen mainScreen].bounds.size.height-(20+44);
    }
    
    
    return n/12+10;
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        detailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.ABNumber=indexPath.row;
        
        [self donghauView];
        
}


#pragma --mark  方法
- (void)leftButtonAction:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (void)donghauView
{
    self.dataBase1=[[DataBase alloc]init];
    [self.dataBase1 creatABJuanDataBaseUidName:self.uid];
    self.ABArray=[self.dataBase1 allABJuanUidName:self.uid];
    
    
    detaiModel *deModel=[[detaiModel alloc]init];
    deModel=self.detalArray[self.ABNumber];
    
    for (ABModel *ABmodel in self.ABArray) {
        
        if ([ABmodel.lesson_no isEqualToString:deModel.lesson_no]) {
            
            [self.abArray addObject:ABmodel];
            
        }
        
    }
    

    if (self.abArray.count<=1) {
        
        
        [self pushPlayButton:nil];
        
    }else{
    
    self.myView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.myView.backgroundColor=[UIColor colorWithRed:0.153 green:0.180 blue:0.192 alpha:0.6];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myView];
    //添加取消点击
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDisMissMyView:)];
    [self.myView addGestureRecognizer:tap];
    
   
    
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
    if (self.abArray.count<13) {
        button.frame=CGRectMake(25, 110, SCREEN_WIDTH-50, SCREEN_HEIGHT/4+SCREEN_HEIGHT/4/3*(self.abArray.count-1));
        
    }else{
            
        button.frame=CGRectMake(25, 110, SCREEN_WIDTH-50, SCREEN_HEIGHT/4+SCREEN_HEIGHT/4/3*11);
            
    }
    button.backgroundColor=[UIColor colorWithRed:0.784 green:0.910 blue:1 alpha:1];
    button.layer.borderWidth=1;
    button.layer.borderColor=[[UIColor colorWithRed:0.569 green:0.596 blue:0.941 alpha:1] CGColor];
    button.layer.cornerRadius=3;
    button.clipsToBounds=YES;
    
    [self.myView addSubview:button];
        
    if (self.abArray.count<13) {
           
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-50, SCREEN_HEIGHT/4+SCREEN_HEIGHT/4/3*(self.abArray.count-1))];
    }else{
            
           
            
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-50, SCREEN_HEIGHT/4+SCREEN_HEIGHT/4/3*11)];
            
    }
    //scrolView的滚动范围(只有滚动范围的宽高大于scrolView自身的宽高,才能实现滚动)
    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH-50, SCREEN_HEIGHT/4+SCREEN_HEIGHT/4/3*(self.abArray.count+2));
    self.scrollView.scrollsToTop=YES;
    //边缘弹动效果
    //self.scrollView.bounces=NO;
    //按页(scrolView自身的大小)滚动
    self.scrollView.pagingEnabled=NO;
    [button addSubview:self.scrollView];

       

    UILabel *titleNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH-50, SCREEN_HEIGHT/4/3)];
    titleNameLabel.text=deModel.lesson_name;
    titleNameLabel.textAlignment=NSTextAlignmentCenter;

    titleNameLabel.textColor=[UIColor blackColor];
    [self.scrollView addSubview:titleNameLabel];
    
        //判断当屏幕的高度是6P的时候
        CGFloat number6p=736;
        CGFloat number6=667;
        CGFloat number5=568;
        CGFloat number4=480;
        if ([UIScreen mainScreen].bounds.size.height==number6p) {
            
            titleNameLabel.font=[UIFont systemFontOfSize:23];
            
        }
        if ([UIScreen mainScreen].bounds.size.height==number6) {
            
            titleNameLabel.font=[UIFont systemFontOfSize:21];
            
        }
        if ([UIScreen mainScreen].bounds.size.height==number5) {
            
            titleNameLabel.font=[UIFont systemFontOfSize:19];
            
        }
        if ([UIScreen mainScreen].bounds.size.height==number4) {
        
            titleNameLabel.font=[UIFont systemFontOfSize:18];
            
        }
        
        
        for (int i=0; i<self.abArray.count; i++) {
            
            ABModel *abmodel=self.abArray[i];
            
            UIButton *AButton=[UIButton buttonWithType:UIButtonTypeCustom];
            AButton.frame=CGRectMake(0, SCREEN_HEIGHT/4/3*(1+i), SCREEN_WIDTH-50, SCREEN_HEIGHT/4/3);
            if (i%2==0) {
                AButton.backgroundColor=[UIColor colorWithRed:0.996 green:0.945 blue:0.957 alpha:1];
            }else{
            
                 AButton.backgroundColor=[UIColor colorWithRed:0.980 green:0.812 blue:0.827 alpha:1];
            }
            
            AButton.tag=7000+i;
            [AButton setTitle:[NSString stringWithFormat:@"  %@",abmodel.suit_name] forState:UIControlStateNormal];
            AButton.titleLabel.font=[UIFont systemFontOfSize:18];
            AButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [AButton addTarget:self action:@selector(pushPlayButton:) forControlEvents:UIControlEventTouchUpInside];
            [AButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [AButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [self.scrollView addSubview:AButton];
            
            
        }
    
    }

}


#pragma --mark 方法
//动画消失的动画
- (void)tapDisMissMyView:(UITapGestureRecognizer *)tap;
{
    [self.myView removeFromSuperview];
    [self.abArray removeAllObjects];
    [self.ABArray removeAllObjects];
    
}

//轻扫动画消失
- (void)swiptapDisMissMyView:(UISwipeGestureRecognizer *)swip
{
    [self.myView removeFromSuperview];
    [self.abArray removeAllObjects];
    [self.ABArray removeAllObjects];
    
}


//点击A卷B卷的方法
- (void)pushPlayButton:(UIButton *)sender
{
    
    if (self.abArray.count==0) {
        
        
        [self myBookNil];
        
    }else{
    
    
    AvPalyTableViewController *avVc=[[AvPalyTableViewController alloc]init];
    [self.myView removeFromSuperview];
    
    if (self.abArray.count>1) {
        
        ABModel *model=[[ABModel alloc]init];
        model=self.abArray[sender.tag-7000];
        avVc.lectutNumber=model.lesson_no;
        avVc.suitNumber=model.suit_no;
        avVc.uid=self.uid;
        avVc.titleLesson=model.suit_name;
        
        
    }else{
        
        ABModel *model=[[ABModel alloc]init];
        model=self.abArray[0];
        avVc.lectutNumber=model.lesson_no;
        avVc.suitNumber=model.suit_no;
        avVc.uid=self.uid;
        avVc.titleLesson=model.suit_name;
    }

    [self.ABArray removeAllObjects];
    [self.abArray removeAllObjects];
    
    [self.navigationController pushViewController:avVc animated:YES];
    
   }
}

- (void)myBookNil
{
    UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:@"提示" message:@"此章节还在存入中,请耐心等待一下" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertControll addAction:alertAction];
    
    [self presentViewController:alertControll animated:YES completion:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:self repeats:NO];

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

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
