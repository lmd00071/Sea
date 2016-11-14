//
//  Book_PageViewController.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/5/19.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "Book_PageViewController.h"
#import "MJRefresh.h"
#import "BookpageCell.h"
#import "InformatioViewController.h"
#import "attModel.h"
#import "dataModel.h"
#define NavBarFgColor [UIColor whiteColor]
#define NavTextAttribute @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}
@interface Book_PageViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSURLSessionDataTask *dnsTask;
@property (nonatomic, strong) NSURLSessionDataTask *csvTask;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask1;
@property (nonatomic, strong) BWHttpRequestManager *manager;
@property (nonatomic,strong)attModel *pageAttModel;
@property (nonatomic,strong)NSMutableArray *dataModelArr;

@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic,strong)UITableView *tableView;
@property (strong, nonatomic) MJRefreshBackNormalFooter *footerRefresh;

//网络出问题后的imageView
@property (nonatomic,strong)UIImageView *NetImageView;
//是否需要清除数组
@property (nonatomic,assign)BOOL remove;
@end
@implementation Book_PageViewController

- (NSMutableArray *)dataModelArr
{
    if (_dataModelArr == nil) {
        
        self.dataModelArr = [NSMutableArray array];
    }
    return _dataModelArr;
}
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
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title = @"图书商城";
    self.navigationController.navigationBar.barTintColor=HBRGBColor(27, 169, 240, 1);
    self.navigationController.navigationBar.tintColor=NavBarFgColor;
    self.navigationController.navigationBar.titleTextAttributes=NavTextAttribute;
    //设置成导航栏下面开始计算
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bookshop_1_back1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    //去掉导航栏上的黑线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    //设置搜索栏及tableview
    [self setSearch];
    self.remove=NO;
    [self setupHttpRequestaction:@"hyan_emall_book_list" action_parameter:@"type_code=book&amp;search_text=" trans_code: @"ui_show" loMore:nil];
}

- (void)setSearch
{
    UIImageView *topImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HBScreenWidth, 44)];
    topImageView.userInteractionEnabled=YES;
    [self.view addSubview:topImageView];
    topImageView.image=[UIImage imageNamed:@"bookshop_1_bg"];
    
    //画出三角形
//    CAShapeLayer *circleLayer = [CAShapeLayer layer];
//    circleLayer.fillColor = HBRGBColor(27, 169, 240, 1).CGColor;
//    UIBezierPath *patch = [UIBezierPath bezierPath];
//    [patch moveToPoint:CGPointMake(HBScreenWidth/2.0-20, 43)];
//    [patch addLineToPoint:CGPointMake(HBScreenWidth/2.0, 43+22)];
//    [patch addLineToPoint:CGPointMake(HBScreenWidth/2.0+20, 43)];
//    [patch addLineToPoint:CGPointMake(HBScreenWidth/2.0-20, 43)];
//    [patch fill];
//    circleLayer.path = patch.CGPath;
//    [self.view.layer addSublayer:circleLayer];
    
    //设置搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, HBScreenWidth-20, 34)];
    //self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.backgroundColor=[UIColor whiteColor];
    self.searchBar.layer.cornerRadius=5;
    self.searchBar.clipsToBounds=YES;
    self.searchBar.placeholder = @"关键字、商品名称、类别";
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle=UISearchBarStyleProminent;
    self.searchBar.tintColor=[UIColor lightGrayColor];
    self.searchBar.barTintColor=[UIColor whiteColor];
    [topImageView addSubview:self.searchBar];

    self.NetImageView=[[UIImageView alloc]init];
    self.NetImageView.contentMode=UIViewContentModeScaleAspectFit;
    //self.NetImageView.image=[UIImage imageNamed:@"NoNet"];
    self.NetImageView.hidden=YES;
    
    //设置下面的tableView
     self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,0,0) style:UITableViewStylePlain ];
    //判断当屏幕的高度是6P的时候
    CGFloat number6p=736;
    if ([UIScreen mainScreen].bounds.size.height==number6p) {
        self.tableView.frame=CGRectMake(0,44, HBScreenWidth, HBScreenHeight-44-20-64);
        self.NetImageView.frame=CGRectMake(0,44, HBScreenWidth, HBScreenHeight-44-20-64);
        
    }else{
        self.tableView.frame=CGRectMake(0,44, HBScreenWidth, HBScreenHeight-44-20-44);
        self.NetImageView.frame=CGRectMake(0,44, HBScreenWidth, HBScreenHeight-44-20-44);
    }
    //添加到视图上
    [self.view addSubview:self.NetImageView];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"BookpageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    //分割线的颜色
    self.tableView.separatorColor=[UIColor clearColor];
    //分割线的样式
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    // 删除多余的cell
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(RefreshheaderAction)];
    self.footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(RefreshfooterAction)];
    self.tableView.footer=self.footerRefresh;

}
#pragma mark - tableView的协议方法
//每个分区里面有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataModelArr.count;
}

//每行显示什么样的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

      BookpageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
      dataModel *model=[[dataModel alloc]init];
      model=self.dataModelArr[indexPath.row];
      [cell setMicoCellDataModel:model];

    
    return cell;
    
}


//几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
////每一行的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 140;
    
}

//cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    InformatioViewController *inVC=[[InformatioViewController alloc]init];
    dataModel *model=[[dataModel alloc]init];
    model=self.dataModelArr[indexPath.row];
    inVC.dataModel=model;
    [self.navigationController pushViewController:inVC animated:YES];
    
}

#pragma --mark 调用的方法
//上拉加载更多
- (void)RefreshfooterAction{
    NSString *action_parameter=[self.pageAttModel.drag_before_action_parameter stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    self.remove=NO;
    [self setupHttpRequestaction:self.pageAttModel.drag_before_action action_parameter:action_parameter trans_code:@"ui_show" loMore:self.pageAttModel.drag_before_cmd];
    [self.tableView.footer endRefreshing];
}
//下拉刷新
- (void)RefreshheaderAction{
    
    self.remove=YES;
    [self setupHttpRequestaction:@"hyan_emall_book_list" action_parameter:@"type_code=book&amp;search_text=" trans_code: @"ui_show" loMore:nil];
    [self.tableView.header endRefreshing];
    
}

#pragma mark - 返回按键的方法
- (void)leftAction{
    
    [self.dnsTask cancel];
    [self.csvTask cancel];
    [self.dataTask cancel];
    [self. dataTask1 cancel];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
    //[self.searchBar setShowsCancelButton:NO animated:YES];
    
}

#pragma mark - UISearchBarDelegate 协议

// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
    
}
// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];// 放弃第一响应者
    [self.searchBar setShowsCancelButton:NO animated:YES];
    self.remove=YES;
    [self setupHttpRequestaction:@"hyan_emall_book_list" action_parameter:[NSString stringWithFormat:@"type_code=book&amp;search_text=%@",self.searchBar.text]  trans_code: @"ui_show" loMore:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//进行http请求
- (void)setupHttpRequestaction:(NSString *)action action_parameter:(NSString *)action_parameter trans_code:(NSString *)trans_code loMore:(NSString *)loMore
{

    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    
    [SVProgressHUD showWithStatus:@"正在请求数据中..."];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] =trans_code;
    parameters[@"from_system"] = FromSystem;
    //拿到当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    parameters[@"from_client_version"] = version;
    //拿到手机的MAC地址
    parameters[@"from_client_id"] = AppUUID;
    parameters[@"from_client_desc"] = FromSystem;
    parameters[@"yc_user_role"] = UserRole;
   if (userArray.count > 0) {
       loginOrReginModel *userMessage = userArray.lastObject;
       parameters[@"yc_user_account_uid"] = userMessage.user_account_uid;

    }
    if (loMore) {
        parameters[@"cmd"] = loMore;
    }
    parameters[@"action"] = action;
    parameters[@"action_parameter"] = action_parameter;
    NSString *xmlString = [parameters newXMLString];
    
    NSMutableURLRequest *dnsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseUrlString]];
    [dnsRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    dnsRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    dnsRequest.HTTPMethod = @"POST";
    dnsRequest.timeoutInterval = 10;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dnsTask = [session dataTaskWithRequest:dnsRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"请求超时"];
            self.NetImageView.hidden=NO;
            self.NetImageView.image=[UIImage imageNamed:@"NoNet"];
            self.tableView.hidden=YES;
            return;
        }
        
        NSDictionary *dnsDict = [NSDictionary dictionaryWithXMLData:data];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSMutableURLRequest *csvRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dnsDict[@"dns.url"]]];
            [csvRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            csvRequest.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
            csvRequest.HTTPMethod = @"POST";
            csvRequest.timeoutInterval = 10;
            
            NSURLSessionDataTask *csvTask = [session dataTaskWithRequest:csvRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    
                    return;
                }
                //NSString *urlstr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *csvDict = [NSDictionary dictionaryWithXMLData:data];
                
//                if (csvDict[@"error_code"]) {
//                    
//                    [SVProgressHUD showErrorWithStatus:csvDict[@"error_string"]];
//                    return;
//                }
//                if (csvDict[@"pop_message"]) {
//                    
//                    [SVProgressHUD showSuccessWithStatus:csvDict[@"pop_message"]];
//                    //return;
//                }
                //非UTF-8编码
                NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                //*****************************************
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_group_t group = dispatch_group_create();
                
                
                dispatch_group_async(group, queue, ^{
                    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:csvDict[@"template_attr_csv"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        
                        if (error) {
                            [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                            self.NetImageView.hidden=NO;
                            self.NetImageView.image=[UIImage imageNamed:@"NoDown"];
                            self.tableView.hidden=YES;
                            return;
                        }
                        //回到主线程刷新数据
                        //dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *contents = [[NSString alloc] initWithData:data encoding:encode];
                        if (contents == nil || contents.length <= 0) {
                            return;
                        }
                        NSArray *newsArray = [contents csvStringTransformToDictionary];
                        if (newsArray != nil && newsArray.count > 0) {
                            self.pageAttModel=nil;
                            NSMutableDictionary *newsDict = [NSMutableDictionary dictionary];
                            for (NSDictionary *dict in newsArray) {
                                
                                if ([dict[@"key"] isEqualToString:@"result_cnt"]) {
                                    newsDict[@"result_cnt"] = dict[@"value"];
                                    
                                }else if ([dict[@"key"] isEqualToString:@"refresh_all"]){
                                    
                                    newsDict[@"refresh_all"] = dict[@"value"];
                                }else if ([dict[@"key"] isEqualToString:@"drag_before_cmd"]){
                                    
                                    newsDict[@"drag_before_cmd"] = dict[@"value"];
                                }else if ([dict[@"key"] isEqualToString:@"drag_before_action"]){
                                    
                                    newsDict[@"drag_before_action"] = dict[@"value"];
                                }else if ([dict[@"key"] isEqualToString:@"drag_before_action_parameter"]){
                                    
                                    newsDict[@"drag_before_action_parameter"] = dict[@"value"];
                                }
                                
                            }
                            self.pageAttModel=[[attModel alloc]init];
                            [self.pageAttModel setValuesForKeysWithDictionary:newsDict];
                            
                        }
                        
                    }];
                    [dataTask resume];
                    self.dataTask=dataTask;
                    
                    
                });
                //********************************************************
                dispatch_group_async(group, queue, ^{
                    
                    NSURLSessionDataTask *dataTask1 = [session dataTaskWithURL:[NSURL URLWithString:csvDict[@"template_data_csv"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        
                        if (error) {
                            [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
                            return;
                        }
                        //清楚上次的数组
                        
                        NSString *contents = [[NSString alloc] initWithData:data encoding:encode];
                        NSArray *picArray = [contents csvStringTransformToDictionary];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                            if (self.remove) {
                                [self.dataModelArr removeAllObjects];
                            }
                            if (picArray != nil && picArray.count > 0) {
                                for (NSMutableDictionary *picDict in picArray) {
                                    
                                    dataModel *datamodel=[[dataModel alloc]init];
                                    [datamodel setValuesForKeysWithDictionary:picDict];
                                    [self.dataModelArr addObject:datamodel];
                                }
                                //需要换图片
                            
                                self.NetImageView.hidden=YES;
                                self.tableView.hidden=NO;
                                [self.tableView reloadData];
                            }
                            
                        });
                    }];
                    
                    [dataTask1 resume];
                    self.dataTask1=dataTask1;
                });
                
            }];
            [csvTask resume];
            self.csvTask=csvTask;
            
        });
    }];
    [dnsTask resume];
    self.dnsTask=dnsTask;
}


@end
