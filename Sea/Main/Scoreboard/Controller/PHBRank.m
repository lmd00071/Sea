//
//  PHBRank.m
//  WidomStudy
//
//  Created by 李明丹 on 16/3/22.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "PHBRank.h"
#import "PHBRankCell.h"
#import "rankModel.h"
#import "rankFormNetManager.h"
#import "RankUserModel.h"
#import "UIImageView+WebCache.h"
#define NavBarFgColor [UIColor whiteColor]
#define NavTextAttribute @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}
@interface PHBRank ()<UITableViewDataSource,UITableViewDelegate,rankFormNetManagerDelegate>

//头像的相框
@property (nonatomic,strong)UIImageView *photoImgaeView;
//个人信息的view
@property (nonatomic,strong)UIView *userView;
//姓名的lable
@property (nonatomic,strong)UILabel *nameLabel;
//学校的label
@property (nonatomic,strong)UILabel *schoolLabel;
//总排行榜
@property (nonatomic,strong)UIView *topView;
//边角
@property (nonatomic,strong)UIView *topViewS;
//总排行榜
@property (nonatomic,strong)UIView *headView;
//总排行榜
@property (nonatomic,strong)UILabel *topLabel;
//隔线
@property (nonatomic,strong)UIView *bottonView;
//显示的tableView
@property (nonatomic,strong)UITableView *tableView;
//用来接收传回来的值
@property (nonatomic,strong)NSMutableArray *cellArr;
@property (nonatomic,strong)RankUserModel *rankUserModel;
@end
@implementation PHBRank
- (NSMutableArray *)cellArr
{
    if (_cellArr == nil) {
        
        self.cellArr = [NSMutableArray array];
    }
    return _cellArr;
}

//测试效果之后删除
- (void)xiaoguo{
    
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
     [self.photoImgaeView sd_setImageWithURL:[NSURL URLWithString:userMessage.photo_icon_url] placeholderImage:[UIImage imageNamed:@"setting_default_head"]];
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
    //self.schoolLabel.text=@"您当前有169分,目前排名在第38位";
   // [self.cellArr removeAllObjects];
    
//    NSArray *name=@[@"徐娇",@"张鹏",@"李娜",@"张伟"];
//    NSArray *rank=@[@"1",@"2",@"3",@"4"];
//    NSArray *titleImage=@[@"head-ima_03",@"head-ima_05",@"head-ima_07",@"head-ima_09"];
//    NSArray *soscr=@[@"总积分:650分",@"总积分:454分",@"总积分:345分",@"总积分:200分"];
//    for (int i=0; i<4; i++) {
//        rankModel *model=[[rankModel alloc]init];
//        model.rank_pos=rank[i];
//        model.title=name[i];
//        model.rank_desc=soscr[i];
//        model.head_icon=titleImage[i];
//       [self.cellArr addObject:model];
//    }
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    self.view.backgroundColor=HBRGBColor(243, 149, 98,1);
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"积分总榜";
    self.navigationController.navigationBar.barTintColor=HBRGBColor(27, 169, 240, 1);
    self.navigationController.navigationBar.tintColor=NavBarFgColor;
    self.navigationController.navigationBar.titleTextAttributes=NavTextAttribute;
    //设置成导航栏下面开始计算
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bookshop_1_back1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(rightAction:)];
   
    [self SetTitleIamgeView];
    [self setBottom];
    [self xiaoguo];
    [[rankFormNetManager shareManager]makeCSVDelegateAction:self];
    
}

//设置图片的位置及点击
- (void)SetTitleIamgeView
{
//个人信息的最下层
self.userView=[[UIView alloc]initWithFrame:CGRectMake(HBScreenWidth/11.0+HBScreenWidth/11.0*3.0/2.0, 25,HBScreenWidth-2.0*HBScreenWidth/11.0-HBScreenWidth/11.0*3.0/2.0,HBScreenWidth/11.0*3.0-10)];
self.userView.backgroundColor=HBRGBColor(174, 207, 248,1);
self.userView.layer.cornerRadius=20;
self.userView.layer.borderWidth=2;
self.userView.layer.borderColor=[[UIColor whiteColor] CGColor];
self.userView.clipsToBounds=YES;
[self.view addSubview:self.userView];


//个人图像的相框
self.photoImgaeView=[[UIImageView alloc]initWithFrame:CGRectMake(HBScreenWidth/11.0, 20,HBScreenWidth/11.0*3.0, HBScreenWidth/11.0*3.0)];
//    if (self.userImage==nil) {
//        self.photoImgaeView.image=[UIImage imageNamed:@"setting_default_head"];
//    }else{
//        self.photoImgaeView.image=self.userImage;
//    }
//self.photoImgaeView.backgroundColor=[UIColor blueColor];
self.photoImgaeView.layer.cornerRadius=(HBScreenWidth/11.0*3.0)/2;
self.photoImgaeView.layer.borderWidth=2;
self.photoImgaeView.layer.borderColor=[HBRGBColor(244, 246, 141,1) CGColor];
self.photoImgaeView.clipsToBounds=YES;
[self.view addSubview:self.photoImgaeView];

//个人的信息
self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(HBScreenWidth/11.0*3.0/2.0+10,16, self.userView.frame.size.width-HBScreenWidth/11.0*3.0/2.0-10, 15)];
//self.nameLabel.text=self.userName;
//self.nameLabel.font=[UIFont boldSystemFontOfSize:17];
self.nameLabel.font=[UIFont systemFontOfSize:17];
self.nameLabel.textColor=[UIColor blackColor];
self.nameLabel.numberOfLines=1;
[self.userView addSubview:self.nameLabel];

self.schoolLabel=[[UILabel alloc]initWithFrame:CGRectMake(HBScreenWidth/11.0*3.0/2.0+10,31, self.userView.frame.size.width-HBScreenWidth/11.0*3.0/2.0-20, self.userView.frame.size.height-23-20)];
//self.schoolLabel.text=[NSString stringWithFormat:@"共获得8积分.目前的积分排名是第82828名."];
self.schoolLabel.font=[UIFont systemFontOfSize:13];
self.schoolLabel.textColor=[UIColor blackColor];
self.schoolLabel.numberOfLines=0;
[self.userView addSubview:self.schoolLabel];
    
    //排行榜View
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(10,40+HBScreenWidth/11.0*3.0,HBScreenWidth-20,30)];
    self.topView.backgroundColor=HBRGBColor(253, 251, 219,1);
    self.topView.layer.cornerRadius=5;
    self.topView.clipsToBounds=YES;
    [self.view addSubview:self.topView];
    
    self.topViewS=[[UIView alloc]initWithFrame:CGRectMake(10,40+HBScreenWidth/11.0*3.0+25,HBScreenWidth-20,5)];
    self.topViewS.backgroundColor=HBRGBColor(253, 251, 219,1);
    [self.view addSubview:self.topViewS];
    
    self.headView=[[UIView alloc]initWithFrame:CGRectMake(3,7,3,15)];
    self.headView.backgroundColor=[UIColor redColor];
    self.headView.layer.cornerRadius=2;
    self.headView.clipsToBounds=YES;
    [self.topView addSubview:self.headView];
    
    self.topLabel=[[UILabel alloc]initWithFrame:CGRectMake(12,5,100,20)];
    self.topLabel.text=@"总排名";
    self.topLabel.textColor=HBRGBColor(56, 86, 244,1);
    self.topLabel.font=[UIFont boldSystemFontOfSize:17];
    [self.topView addSubview:self.topLabel];
    
    self.bottonView=[[UIView alloc]initWithFrame:CGRectMake(10,40+HBScreenWidth/11.0*3.0+30,HBScreenWidth-20,1)];
    self.bottonView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:self.bottonView];

}

//下半的布局
- (void)setBottom
{
    CGFloat number6p=736;
    if ([UIScreen mainScreen].bounds.size.height>=number6p) {
        
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(10,40+HBScreenWidth/11.0*3.0+31,HBScreenWidth-20,HBScreenHeight-20-66-40-HBScreenWidth/11.0*3.0-31) style:UITableViewStylePlain ];
    }else{
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(10,40+HBScreenWidth/11.0*3.0+31,HBScreenWidth-20,HBScreenHeight-20-44-40-HBScreenWidth/11.0*3.0-31) style:UITableViewStylePlain ];
    }
    [self.view addSubview:self.tableView];
    //分割线的颜色
   // self.tableView.separatorColor=[UIColor clearColor];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    //禁止拖深
    [self.tableView setBounces:NO];

}

#pragma mark - tableView的协议方法
//每个分区里面有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cellArr.count;
}

//每行显示什么样的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //从重用池(重用队列)里面取出一个cell
    PHBRankCell *cell=[tableView dequeueReusableCellWithIdentifier:@"rank"];
    //判断取到的cell是否为空
    if (cell==nil) {
        //如果取到的cell为空,创建一个cell
        cell=[[[PHBRankCell class]alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rank"];
        NSLog(@"这是新创建的cell");
    }else{
        
        NSLog(@"这是从重用池中取出来的cell");
    }
    cell.backgroundColor=[UIColor clearColor];
    rankModel *model=self.cellArr[indexPath.row];
    [cell setRankModel:model];
    //取消点击效果
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
   
      return 90;
    
  
}

#pragma mark - rankFormNetManagerDelegate 协议方法
- (void)passPostResultTopModelArray:(NSMutableArray *)ModelArray attModel:(RankUserModel *)attModel
{
    self.schoolLabel.text=attModel.userMessager;
    [self.cellArr removeAllObjects];
    for (rankModel *model in ModelArray) {
        [self.cellArr addObject:model];
    }
    
    [self.tableView reloadData];
}

#pragma mark - BarButtonItem 设置导航栏的左右点击方法

- (void)rightAction:(UIBarButtonItem *)sender
{
     [[rankFormNetManager shareManager]makeCSVDelegateAction:self ];
    
}

- (void)leftAction:(UIBarButtonItem *)sender
{
    [[rankFormNetManager shareManager] viewDisMiss];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end
