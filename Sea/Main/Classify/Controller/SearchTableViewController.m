//
//  SearchTableViewController.m
//  Petrel
//
//  Created by 李明丹 on 16/1/17.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SearchTableViewCell.h"
#import "postDns.h"
#import "SearchManager.h"
#import "getCsvFromNet.h"
#import "userBookModel.h"
#import "PendulumView.h"
#import "DownManager.h"
#import "downProgaess.h"
#import "DataBase.h"
#import "detailTableViewController.h"
#import "Reachability.h"
#import "StartFormNet.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
//5,6手机的高度减去导航栏的高度20+44
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface SearchTableViewController ()<postDnsDelegate,SearchManagerDelegate,getCsvFromNetDelegate,StartFormNetDelegate>

@property (nonatomic,assign)CGFloat progress;
//用来加载数据的时候
//@property (nonatomic,strong)PendulumView *pendulum;
//记录点击的行数
@property (nonatomic,assign)NSInteger secletPath;

@property (nonatomic,strong)NSMutableArray *csvDataArray;
@property (nonatomic,strong)NSString *urlStr;

//传回去的model
@property (nonatomic,strong)userBookModel *userBookModel;
@property (nonatomic,strong)DataBase *dataBase;
//用来存放已下载
@property (nonatomic,strong)NSMutableArray *findshArray;
//用来存放需要更新
@property (nonatomic,strong)NSMutableArray *upArray;

//下载资源存储容器
@property (atomic,strong) NSMutableArray *downViews;

// 当前加载的下载索引
@property (atomic,strong) NSCondition *condition;
@property (nonatomic,strong)NSMutableArray *finishDownArr;
@property (nonatomic,strong)NSMutableArray *finishUpArr;
//没有下载完成的
@property (nonatomic,strong)NSMutableArray *unFinshArr;
@property (nonatomic,strong)NSMutableArray *unFinshUPArr;
@property (nonatomic,assign)BOOL leave;

@property (nonatomic,strong)StartFormNet *downManager;
@end

@implementation SearchTableViewController

//懒加载
- (NSMutableArray *)unFinshUPArr
{
    if (!_unFinshUPArr) {
        
        self.unFinshUPArr=[NSMutableArray array];
    }
    
    return _unFinshUPArr;
}
- (NSMutableArray *)unFinshArr
{
    if (!_unFinshArr) {
        
        self.unFinshArr=[NSMutableArray array];
    }
    
    return _unFinshArr;
}

- (NSMutableArray *)finishDownArr
{
    if (!_finishDownArr) {
        
        self.finishDownArr=[NSMutableArray array];
    }
    
    return _finishDownArr;
}

- (NSMutableArray *)finishUpArr
{
    if (!_finishUpArr) {
        
        self.finishUpArr=[NSMutableArray array];
    }
    
    return _finishUpArr;
}

- (NSMutableArray *)downViews
{
    if (!_downViews) {
        
        self.downViews=[NSMutableArray array];
    }
    
    return _downViews;
}
//懒加载
- (NSMutableArray *)findshArray
{
    if (!_findshArray) {
        self.findshArray=[NSMutableArray array];
    }
    
    return _findshArray;
}

//懒加载
- (NSMutableArray *)upArray
{
    if (!_upArray) {
        self.upArray=[NSMutableArray array];
    }
    
    return _upArray;
}

//懒加载
- (NSMutableArray *)csvDataArray
{
    if (!_csvDataArray) {
        self.csvDataArray=[NSMutableArray array];
    }
    
    return _csvDataArray;
}


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

- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    //设置导航栏
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"目录下载";
    title.font=[UIFont systemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.113 green:0.588 blue:0.925 alpha:1];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    
    
    //设置成导航栏下面开始计算
    self.navigationController.navigationBar.translucent = NO;
    
     [self.tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@"SearchCell"];
    // 删除多余的cell
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.tableView.backgroundColor=[UIColor colorWithRed:0.784 green:0.910 blue:1 alpha:1];
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    self.leave=NO;
    //先走网络判断
    //判断是否有网络
    BOOL net=[self serachNet];

    if (net) {
        
        [SVProgressHUD showWithStatus:@"加载中..."];
        [[postDns shareManager] searchPostFromDnsDelegateAction:self];
        //[self getPendulum];
    }
    
    //创建下载链接
    _downNames=[NSMutableArray array];
    
    //初始化锁对象
//    _condition=[[NSCondition alloc]init];
//    
//    _currentIndex=0;
    
}


//判断有没有网络的方法,
- (BOOL)serachNet
{
    Reachability *reachAbility = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NSInteger stateNet = [reachAbility currentReachabilityStatus];
    
    if (stateNet == 0) {
        
        UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:@"提示" message:@"网络没有连接,请先连接网络" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alertControll addAction:alertAction];
        
        [self presentViewController:alertControll animated:YES completion:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(time) userInfo:self repeats:NO];
        
        return NO;
    }else{
        
      
     
        return YES;
    }
}




//postDns协议传回来的值
- (void)passDnsUrl:(NSString *)DnsUrl
{
    
    if ([DnsUrl isEqualToString:@"\n"]) {
        return;
    }else{
    self.urlStr=DnsUrl;
    }
    
    NSString *coures=[[NSString alloc]init];
    switch (self.classArray.count) {
        case 0:
            coures=@"course_id=";
            break;
        case 1:
            coures=[NSString stringWithFormat:@"course_id=%@",self.classArray[0]];
            break;
        case 2:
            coures=[NSString stringWithFormat:@"course_id=%@|%@",self.classArray[0],self.classArray[1]];
            break;
        case 3:
            coures=[NSString stringWithFormat:@"course_id=%@|%@|%@",self.classArray[0],self.classArray[1],self.classArray[2]];
            break;
        default:
            break;
    }
    
    
    NSString *grade=[[NSString alloc]init];
    switch (self.classNumberArray.count) {
        case 0:
            grade=@"grade=";
            break;
        case 1:
            grade=[NSString stringWithFormat:@"grade=%@",self.classNumberArray[0]];
            break;
        case 2:
            grade=[NSString stringWithFormat:@"grade=%@|%@",self.classNumberArray[0],self.classNumberArray[1]];
            break;
        case 3:
            grade=[NSString stringWithFormat:@"grade=%@|%@|%@",self.classNumberArray[0],self.classNumberArray[1],self.classNumberArray[2]];
            break;
        case 4:
            grade=[NSString stringWithFormat:@"grade=%@|%@|%@|%@",self.classNumberArray[0],self.classNumberArray[1],self.classNumberArray[2],self.classNumberArray[3]];
            break;
        case 5:
            grade=[NSString stringWithFormat:@"grade=%@|%@|%@|%@|%@",self.classNumberArray[0],self.classNumberArray[1],self.classNumberArray[2],self.classNumberArray[3],self.classNumberArray[4]];
            break;
        case 6:
            grade=[NSString stringWithFormat:@"grade=%@|%@|%@|%@|%@|%@",self.classNumberArray[0],self.classNumberArray[1],self.classNumberArray[2],self.classNumberArray[3],self.classNumberArray[4],self.classNumberArray[5]];
            break;
        default:
            break;
    }
    
    NSString *half_grade=[[NSString alloc]init];
    switch (self.shangxiaArray.count) {
        case 0:
            half_grade=@"half_grade=";
            break;
        case 1:
            half_grade=[NSString stringWithFormat:@"half_grade=%@",self.shangxiaArray[0]];
            break;
        case 2:
            half_grade=[NSString stringWithFormat:@"half_grade=%@|%@",self.shangxiaArray[0],self.shangxiaArray[1]];
            break;

            break;
        default:
            break;
    }
    
     NSString *action_parmeter=[[NSString alloc]init];
    if (self.classArray.count==0&&self.classNumberArray.count==0&&self.shangxiaArray.count==0) {
        
        action_parmeter=@"";
        
    }else if (self.classArray.count==0&&self.classNumberArray.count==0&&self.shangxiaArray.count!=0){
        
        action_parmeter=[NSString stringWithFormat:@"%@",half_grade];
    
    }else if (self.classArray.count==0&&self.classNumberArray.count!=0&&self.shangxiaArray.count==0){
        
        action_parmeter=[NSString stringWithFormat:@"%@",grade];
        
    }else if (self.classArray.count==0&&self.classNumberArray.count!=0&&self.shangxiaArray.count!=0){
        
        action_parmeter=[NSString stringWithFormat:@"%@&amp;%@",grade,half_grade];
        
    }else if (self.classArray.count!=0&&self.classNumberArray.count==0&&self.shangxiaArray.count==0){
        
        action_parmeter=[NSString stringWithFormat:@"%@",coures];
        
    }else if (self.classArray.count!=0&&self.classNumberArray.count==0&&self.shangxiaArray.count!=0){
        
        action_parmeter=[NSString stringWithFormat:@"%@&amp;%@",coures,half_grade];
        
    }else if (self.classArray.count!=0&&self.classNumberArray.count!=0&&self.shangxiaArray.count==0){
        
        action_parmeter=[NSString stringWithFormat:@"%@&amp;%@",coures,grade];
        
    }else if (self.classArray.count!=0&&self.classNumberArray.count!=0&&self.shangxiaArray.count!=0){
        
           action_parmeter=[NSString stringWithFormat:@"%@&amp;%@&amp;%@",coures,grade,half_grade];
        
    }
    
    [[SearchManager shareManager] searchFromNetDelegateAction:self DnsUrl:DnsUrl action_parameter:action_parmeter];


}


- (void)passCsvData:(searchCsvModel *)scvUrlModel
{

    [[getCsvFromNet shareManager] searchDataFromNetDelegateAction:self csvUrl:scvUrlModel.template_data_csv];


}


- (void)passdataModelArray:(NSMutableArray *)modelArray
{
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
    self.dataBase=[[DataBase alloc]init];
    [self.dataBase creatUserBookDataBaseUserName:name];
    NSArray *bookArray=[self.dataBase allUserBookUserName:name];
    
    [self.findshArray removeAllObjects];
    [self.upArray removeAllObjects];
    [self.csvDataArray removeAllObjects];
    BOOL bookShow=NO;
    for (userBookModel *model in modelArray) {
        
        for (userBookModel *oldModel in bookArray) {
            
            if ([model.text_book_uid isEqualToString:oldModel.text_book_uid]) {
                
                if ([model.modify_time isEqualToString:oldModel.modify_time]) {
                    
                    [self.findshArray addObject:model];
                    
                }else{
                
                    [self.upArray addObject:model];
                
                }
                
                bookShow=YES;
            }
            
        }
        
        if (bookShow==NO) {
            
            [self.csvDataArray addObject:model];
            
        }
            bookShow=NO;
    
    }
    
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
    //[self.pendulum stopAnimating];
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

    return self.csvDataArray.count+self.findshArray.count+self.upArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }

    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor clearColor];
    }else{
        cell.backgroundColor=[UIColor colorWithRed:0.533 green:0.788 blue:0.945 alpha:1];
    }
    if (indexPath.row<self.findshArray.count) {
        
        userBookModel *model=self.findshArray[indexPath.row];
        cell.model=model;
        cell.downButton.hidden=YES;
        cell.finshImageView.text=@"已下载";
        cell.finshImageView.hidden=NO;
        cell.demoView.hidden=YES;
        
    }else if (indexPath.row>=self.findshArray.count&&indexPath.row<(self.findshArray.count+self.upArray.count)) {
        userBookModel *model=[[userBookModel alloc]init];
        model=self.upArray[indexPath.row-self.findshArray.count];
        cell.model=model;
        cell.downButton.hidden=YES;
        cell.finshImageView.text=@"可更新";
        cell.finshImageView.hidden=NO;
        cell.demoView.hidden=YES;
        
        if (self.finishUpArr.count==0) {
            
            cell.finshImageView.tag=9000+indexPath.row-self.findshArray.count;
            cell.finshImageView.userInteractionEnabled=YES;
            //轻拍手势
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFinshAction:)];
            
            [cell.finshImageView addGestureRecognizer:tap];
            
        }else{
            NSString *str=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                if ([self.finishUpArr containsObject:str]) {
                    
                    cell.finshImageView.hidden=NO;
                    cell.finshImageView.text=@"已完成";
                    cell.downButton.hidden=YES;
                    cell.demoView.hidden=YES;
                    
                }else{
                    
                    cell.finshImageView.text=@"可更新";
                    cell.finshImageView.tag=9000+indexPath.row-self.findshArray.count;
                    cell.finshImageView.userInteractionEnabled=YES;
                    cell.downButton.hidden=YES;

                    //轻拍手势
                    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFinshAction:)];
                    
                    [cell.finshImageView addGestureRecognizer:tap];
                
                }
            
        
        }
    
    }else{
        userBookModel *model=[[userBookModel alloc]init];
       model=self.csvDataArray[indexPath.row-self.findshArray.count-self.upArray.count];
          cell.model=model;
        NSString *str=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
 
        if ([self.finishDownArr containsObject:str]) {
            cell.finshImageView.hidden=NO;
            cell.finshImageView.text=@"已完成";
            cell.downButton.hidden=YES;
            cell.demoView.hidden=YES;
            
        }else if([self.unFinshArr containsObject:str]){
            
                cell.finshImageView.hidden=YES;
                cell.downButton.hidden=YES;
                cell.demoView.hidden=NO;
        
        }else{
            cell.finshImageView.hidden=YES;
            cell.downButton.hidden=NO;
            cell.demoView.hidden=YES;
            [cell.downButton addTarget:self action:@selector(downButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.downButton.tag = 2000 + indexPath.row-self.findshArray.count-self.upArray.count;
        }
        
    }
    
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
    
    
    return n/5;
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell.finshImageView.hidden==YES) {
        
             [self DistinguishDown];
       
    }else{
    
        if ([cell.finshImageView.text isEqualToString:@"已完成"]) {
            
            userBookModel *model=self.csvDataArray[indexPath.row-self.findshArray.count-self.upArray.count];
            
            detailTableViewController *detaVC=[[detailTableViewController alloc]init];
            
            detaVC.uid=model.text_book_uid;
            
            [self.navigationController pushViewController:detaVC animated:YES];
            
        }
        if ([cell.finshImageView.text isEqualToString:@"已下载"]) {
            
            userBookModel *model=self.findshArray[indexPath.row];
            
            detailTableViewController *detaVC=[[detailTableViewController alloc]init];
            
            detaVC.uid=model.text_book_uid;
            
            [self.navigationController pushViewController:detaVC animated:YES];
        }
        if ([cell.finshImageView.text isEqualToString:@"可更新"]) {
            
            
            UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:@"提示" message:@"此本书可以更新,请先更新" preferredStyle:UIAlertControllerStyleAlert];
            
//            UIAlertAction *alertAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//            
//            [alertControll addAction:alertAction];
            
            [self presentViewController:alertControll animated:YES completion:nil];
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time) userInfo:self repeats:NO];
            
            
        }
    
    }
    
}


//提示框没有下载
- (void)DistinguishDown
{
    
    UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:@"提示" message:@"此本书还没有下载,请先下载" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertControll animated:YES completion:nil];
    
     [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time) userInfo:self repeats:NO];
    
}

//一秒后自己消失
- (void)time{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma --mark  方法
- (void)downBarButtonAction:(UIButton *)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];


}

//点击可跟新手势
- (void)tapFinshAction:(UITapGestureRecognizer *)tap
{
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    NSString *name;
    if (userMessage.user_msisdn.length>0) {
        name=userMessage.user_msisdn;
    }else{
        name=@"游客";
        
    }

    //tap.view 获取手势所在的视图
    UILabel *upLabel=(UILabel *)tap.view;
    [self.unFinshArr addObject:@(upLabel.tag-9000+self.findshArray.count)];
    userBookModel *model=[[userBookModel alloc]init];
    model=self.upArray[upLabel.tag-9000];
    
//    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(globalQueue, ^{
//        
//        self.dataBase=[[DataBase alloc]init];
//        [self.dataBase creatUserBookDataBaseUserName:name];
//        [self.dataBase deleteUserFromBriefUid:model.text_book_uid UserName:name];
//        
//        self.dataBase=[[DataBase alloc]init];
//        [self.dataBase creatUnitDataBaseUidName:model.text_book_uid];
//        [self.dataBase deleteUnitFromBriefUid:model.text_book_uid];
//        
//        self.dataBase=[[DataBase alloc]init];
//        [self.dataBase creatABJuanDataBaseUidName:model.text_book_uid];
//        [self.dataBase deleteABJuanFromBriefUid:model.text_book_uid];
//        
//        StartFormNet *downManager=[[StartFormNet alloc]init];
//        [downManager searchFromNetDelegateAction:self DnsUrl:nil action_parameter:model.text_book_uid cellNumber:upLabel.tag];
//        [_condition lock];
//        [_condition broadcast];
//        
//    });
    
    
    dispatch_queue_t queueSerial=dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queueSerial, ^{
        
        self.dataBase=[[DataBase alloc]init];
        [self.dataBase creatUserBookDataBaseUserName:name];
        [self.dataBase deleteUserFromBriefUid:model.text_book_uid UserName:name];
        
        self.dataBase=[[DataBase alloc]init];
        [self.dataBase creatUnitDataBaseUidName:model.text_book_uid];
        [self.dataBase deleteUnitFromBriefUid:model.text_book_uid];
        
        self.dataBase=[[DataBase alloc]init];
        [self.dataBase creatABJuanDataBaseUidName:model.text_book_uid];
        [self.dataBase deleteABJuanFromBriefUid:model.text_book_uid];
        
        StartFormNet *downManager=[[StartFormNet alloc]init];
        [downManager searchFromNetDelegateAction:self DnsUrl:nil action_parameter:model.text_book_uid cellNumber:upLabel.tag];
        self.downManager=downManager;
    });
    
    
    self.secletPath=upLabel.tag;
    NSArray *array = [self.tableView indexPathsForVisibleRows];
    SearchTableViewCell *cell=[self.tableView cellForRowAtIndexPath:array[upLabel.tag-9000+self.findshArray.count]];
    cell.demoView.progressView.progress=0;
    cell.demoView.hidden=NO;
    upLabel.text=@"已完成";
    upLabel.userInteractionEnabled=NO;
    upLabel.hidden=YES;
    
    
}

// 根据点击的Cell上的下载的方法
- (void)downButtonAction:(UIButton *)sender{

   
    NSInteger n=sender.tag-2000;
    NSString *str=[NSString stringWithFormat:@"%lu",(sender.tag-2000+self.findshArray.count+self.upArray.count)];
    [self.unFinshArr addObject:str];
    userBookModel *model=[[userBookModel alloc]init];
    model=self.csvDataArray[n];

    
    dispatch_queue_t queueSerial=dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queueSerial, ^{
        
        StartFormNet *downManager=[[StartFormNet alloc]init];
        [downManager searchFromNetDelegateAction:self DnsUrl:nil action_parameter:model.text_book_uid cellNumber:sender.tag];
        self.downManager=downManager;
        
    });
    
//    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(globalQueue, ^{
//
//        StartFormNet *downManager=[[StartFormNet alloc]init];
//        [downManager searchFromNetDelegateAction:self DnsUrl:nil action_parameter:model.text_book_uid cellNumber:sender.tag];
//        self.downManager=downManager;
//        [_condition lock];
//        [_condition broadcast];
//        
//    });

    self.secletPath=sender.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(sender.tag-2000+self.findshArray.count+self.upArray.count) inSection:0];
    SearchTableViewCell *cell  = (SearchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.demoView.progressView.progress=0;
    cell.demoView.hidden=NO;
    sender.hidden=YES;


   
    
}

//协议传回来的进度
- (void)passProgaessDataMore:(float)progaess cellNumber:(NSInteger)cellNumber
{
    
    if (progaess>=0.97) {
        
        [SVProgressHUD showWithStatus:@"书本存入中..."];
        
    }
    
    
    if (cellNumber>8999) {
//        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(globalQueue, ^{
//            
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(cellNumber-9000+self.findshArray.count) inSection:0];
//        SearchTableViewCell *cell  = (SearchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//
//
//                cell.demoView.hidden=NO;
//                cell.downButton.hidden=YES;
//                cell.finshImageView.hidden=YES;
//                cell.demoView.progressView.progress = progaess;
//                
//            });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(cellNumber-9000+self.findshArray.count) inSection:0];
            SearchTableViewCell *cell  = (SearchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            
            cell.demoView.hidden=NO;
            cell.downButton.hidden=YES;
            cell.finshImageView.hidden=YES;
            cell.demoView.progressView.progress = progaess;

             });
    }else{
//        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(globalQueue, ^{
//            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(cellNumber-2000+self.findshArray.count+self.upArray.count) inSection:0];
//            SearchTableViewCell *cell  = (SearchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//            
//            cell.demoView.hidden=NO;
//            cell.downButton.hidden=YES;
//            cell.finshImageView.hidden=YES;;
//            cell.demoView.progressView.progress = progaess;
//            
//        });
       dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(cellNumber-2000+self.findshArray.count+self.upArray.count) inSection:0];
        SearchTableViewCell *cell  = (SearchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
           
           cell.demoView.hidden=NO;
           cell.downButton.hidden=YES;
           cell.finshImageView.hidden=YES;;
           cell.demoView.progressView.progress = progaess;

      });
    }

}

//完成后
- (void)passFinshCelllNumber:(NSInteger)cellNumber
{
    if (self.leave==YES) {
        return;
    }
    
    [SVProgressHUD dismiss];
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    NSString *name;
    if (userMessage.user_msisdn.length>0) {
        name=userMessage.user_msisdn;
    }else{
        name=@"游客";
        
    }
    
    if (cellNumber>8999) {
        
        [self.unFinshUPArr removeObject:@(cellNumber-9000+self.findshArray.count)];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(cellNumber-9000+self.findshArray.count) inSection:0];
        SearchTableViewCell *cell  = (SearchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
         dispatch_async(dispatch_get_main_queue(), ^{
                //[_condition unlock];
                cell.demoView.progressView.progress=1.0;
                //[cell.demoView removeFromSuperview];
                cell.demoView.hidden=YES;
                cell.finshImageView.text=@"已完成";
                cell.finshImageView.hidden=NO;
                cell.downButton.hidden=YES;
                NSString *str=[NSString stringWithFormat:@"%lu",(cellNumber-9000+self.findshArray.count)];
                [self.finishUpArr addObject:str];
 
        
         });
        
    }else{
        NSInteger n=cellNumber-2000;
        userBookModel *model=[[userBookModel alloc]init];
        model=self.csvDataArray[n];
        
   
            self.dataBase=[[DataBase alloc]init];
           [self.dataBase creatUserBookDataBaseUserName:name];
           [self.dataBase deleteUserFromBriefUid:model.text_book_uid UserName:name];
           [self.dataBase creatUserBookDataBaseUserName:name];
            [self.dataBase addUserBookFromBrief:model UserName:name];
 
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(cellNumber-2000+self.findshArray.count+self.upArray.count) inSection:0];
            SearchTableViewCell *cell  = (SearchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
           NSString *str=[NSString stringWithFormat:@"%lu",(cellNumber-2000+self.findshArray.count+self.upArray.count)];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                    //[_condition unlock];
                
                    cell.demoView.progressView.progress=1.0;
                    //[cell.demoView removeFromSuperview];
                    cell.demoView.hidden=YES;
                    cell.finshImageView.text=@"已完成";
                    cell.finshImageView.hidden=NO;
                    cell.downButton.hidden=YES;
                    [self.unFinshArr removeObject:str];
                    [self.finishDownArr addObject:str];
                
        });
    }
}

- (void)leftAction:(UIBarButtonItem *)sender
{
    [self.downManager viewDisMiss];
    [[SDWebImageManager sharedManager]cancelAll];
    [[NSThread currentThread] cancel];
   
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    NSString *name;
    if (userMessage.user_msisdn.length>0) {
        name=userMessage.user_msisdn;
    }else{
        name=@"游客";
        
    }
    
    for (NSString *numStr in self.unFinshArr) {
        
 
        NSInteger n=[numStr integerValue]-self.findshArray.count-self.upArray.count;
        userBookModel *model=[[userBookModel alloc]init];
        model=self.csvDataArray[n];
        
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
    
    }
    
    //清楚缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    self.leave=YES;
    
    [self.navigationController popViewControllerAnimated:YES];

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
