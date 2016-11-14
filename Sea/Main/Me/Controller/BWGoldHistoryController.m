//
//  BWGoldHistoryController.m
//  WidomStudy
//
//  Created by 李明丹 on 16/4/15.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "BWGoldHistoryController.h"

#import "BWGoldHistoryCell.h"
#import "BWGoldHistory.h"

@interface BWGoldHistoryController ()

@property (nonatomic, strong) NSURLSessionDataTask *dnsTask;
@property (nonatomic, strong) NSURLSessionDataTask *csvTask;

@property (nonatomic, strong) NSArray *goldHistoryArray;

@end

@implementation BWGoldHistoryController

static NSString *goldHistoryCell = @"goldHistoryCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消费记录";
    self.tableView.rowHeight = 67;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"BWGoldHistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:goldHistoryCell];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_refresh"] forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(setupHttpRequest) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HBScreenWidth, 1)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    [self setupData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.dnsTask cancel];
    [self.csvTask cancel];
    [SVProgressHUD dismiss];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goldHistoryArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BWGoldHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:goldHistoryCell];
    BWGoldHistory *model = self.goldHistoryArray[indexPath.row];
    cell.goldHistory = model;
    
    return cell;
}


- (void)setupHttpRequest
{
    [SVProgressHUD showWithStatus:@"正在请求数据中..."];
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"trans_code"] = @"ui_show";
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

    parameters[@"action"] = @"show_yp_history";
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
                
                NSDictionary *dataDict = [NSDictionary dictionaryWithXMLData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakself setupDatabaseWithCsvDict:dataDict];
                    [weakself.tableView reloadData];
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

//根据请求到的csv地址进行数据处理
- (void)setupDatabaseWithCsvDict:(NSDictionary *)csvDict
{
    NSString *action = @"show_yp_history";
    NSString *action_parameter = @"show_yp_history";
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM csv_path WHERE action='%@' AND action_parameter='%@'", action, action_parameter];
    NSArray *overModelArray = [BWCSVDatabase queryData:selectString];
    NSFileManager *manager = [NSFileManager defaultManager];
    for (BWCSVModel *csvModel in overModelArray) {
        
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *csvPath = [cachePath stringByAppendingPathComponent:csvModel.csvPath];
        [manager removeItemAtPath:csvPath error:nil];
    }
    
    NSString *deleteData = [NSString stringWithFormat:@"DELETE FROM csv_path WHERE action='%@' AND action_parameter='%@'", action, action_parameter];
    [BWCSVDatabase deleteData:deleteData];
    
    NSArray *csvModelArray = [BWCSVDatabase writeCsvWithCsvDict:csvDict action:action action_parameter:action_parameter];
    for (BWCSVModel *csvModel in csvModelArray) {
        
        //插入数据
        [BWCSVDatabase insertModal:csvModel];
        
        if ([csvModel.csvType isEqualToString:DataCsvKey]) {
            
            NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            NSString *csvPath = [cachePath stringByAppendingPathComponent:csvModel.csvPath];
            NSString *dataString = [NSString stringWithContentsOfFile:csvPath encoding:NSUTF8StringEncoding error:nil];
            NSArray *dataArray = [dataString csvStringTransformToDictionary];
            NSMutableArray *modelArray = [NSMutableArray array];
            for (NSDictionary *dataDict in dataArray) {
                BWGoldHistory *model = [BWGoldHistory mj_objectWithKeyValues:dataDict];
                [modelArray addObject:model];
            }
            self.goldHistoryArray = modelArray;
        }
    }
}

//进行数据获取
- (void)setupData
{
    NSString *action = @"show_yp_history";
    NSString *action_parameter = @"show_yp_history";
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM csv_path WHERE action='%@' AND action_parameter='%@'", action, action_parameter];
    NSArray *csvModelArray = [BWCSVDatabase queryData:selectString];
    if (csvModelArray.count > 0) {
        
        //先将数据显示出来,然后进行判断
        for (BWCSVModel *csvModel in csvModelArray) {
            
            if ([csvModel.csvType isEqualToString:DataCsvKey]) {    //数据csv对应的模型
                NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
                NSString *csvPath = [cachePath stringByAppendingPathComponent:csvModel.csvPath];
                NSString *dataString = [NSString stringWithContentsOfFile:csvPath encoding:NSUTF8StringEncoding error:nil];
                NSArray *dataArray = [dataString csvStringTransformToDictionary];
                NSMutableArray *modelArray = [NSMutableArray array];
                for (NSDictionary *dataDict in dataArray) {
                    BWGoldHistory *model = [BWGoldHistory mj_objectWithKeyValues:dataDict];
                    [modelArray addObject:model];
                }
                self.goldHistoryArray = modelArray;
            }
        }
        BWCSVModel *model = csvModelArray.firstObject;
        if ([NSDate isLaterTimeThanNowWithDateString:model.overdueTime]) {    //未超时,直接赋值
            
        } else {    //超过存储时间,进行请求
            [self setupHttpRequest];
        }
        
    } else {
        [self setupHttpRequest];
    }
}

@end
