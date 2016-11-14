//
//  InformatioViewController.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/5/20.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "InformatioViewController.h"
#import "AddressViewController.h"
#import "pictureViewController.h"
#import "InforModelAtt.h"
#import "InforModelData.h"
#import "UIImageView+WebCache.h"
#import "ShowImageView.h"
#import "NewLoginViewController.h"
@interface InformatioViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSURLSessionDataTask *dnsTask;
@property (nonatomic, strong) NSURLSessionDataTask *csvTask;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottonHeight;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (nonatomic,strong)InforModelAtt *infromAttModel;
@property (nonatomic,strong)NSMutableArray *infromdataModelArr;
//介绍
@property (nonatomic,strong)UILabel *detailLabel;
//分割线
@property (nonatomic,strong)UIView *thirdView;
//title的image
@property (nonatomic,strong)NSMutableArray *titleImageUrlArr;
//detail的image
@property (nonatomic,strong)NSMutableArray *detaileImageUrlArr;
//上面的图书
@property (nonatomic,strong)UIImageView *titleImageView;
//有多少个图片
@property (nonatomic,strong)UILabel *numberLabel;
//
@property (nonatomic,strong)ShowImageView *titleShowImageView;
//书本上面的视图
@property (nonatomic,strong)UIView *whiteView;
//
@property (nonatomic,assign)NSInteger numberBookImage;
@end

@implementation InformatioViewController

- (NSMutableArray *)infromdataModelArr
{
    if (_infromdataModelArr == nil) {
        
        self.infromdataModelArr = [NSMutableArray array];
    }
    return _infromdataModelArr;
}

- (NSMutableArray *)titleImageUrlArr
{
    if (_titleImageUrlArr == nil) {
        
        self.titleImageUrlArr = [NSMutableArray array];
    }
    return _titleImageUrlArr;
}

- (NSMutableArray *)detaileImageUrlArr
{
    if (_detaileImageUrlArr == nil) {
        
        self.detaileImageUrlArr = [NSMutableArray array];
    }
    return _detaileImageUrlArr;
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
    self.navigationItem.title = @"书本详情";
    //设置成导航栏下面开始计算
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bookshop_1_back1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
  
    //购买的高度
    self.numberBookImage=1;
    self.bottonHeight.constant=[UIScreen mainScreen].bounds.size.height*1.0/10.0;
    [self setScroll];
    [self setupHttpRequestaction:self.dataModel.action action_parameter:self.dataModel.action_parameter trans_code: @"ui_show" loMore:nil];
}

//滑动里面的布局
- (void)setScroll{

    UIView *lightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, HBScreenWidth,HBScreenHeight/2.0)];
    lightView.userInteractionEnabled=YES;
    lightView.backgroundColor=[UIColor lightGrayColor];
    lightView.alpha=0.55;
    [self.ScrollView addSubview:lightView];

    self.whiteView=[[UIView alloc]initWithFrame:CGRectMake(30, 0, HBScreenWidth-60,HBScreenHeight/2.0)];
    self.whiteView.userInteractionEnabled=YES;
    self.whiteView.backgroundColor=[UIColor whiteColor];
    [self.ScrollView addSubview:self.whiteView];
    

    _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(HBScreenWidth-50, HBScreenHeight/2.0-40-20, 40, 40)];
    _numberLabel.backgroundColor=[UIColor blackColor];
    _numberLabel.alpha=0.4;
    _numberLabel.text=@"1/1";
    _numberLabel.textColor=[UIColor whiteColor];
    _numberLabel.textAlignment=NSTextAlignmentCenter;
    _numberLabel.layer.cornerRadius=20;
    _numberLabel.clipsToBounds=YES;
    [self.ScrollView addSubview:_numberLabel];
    
    UIView *firstView=[[UIView alloc]initWithFrame:CGRectMake(0, HBScreenHeight/2.0, HBScreenWidth, 1)];
    firstView.backgroundColor=[UIColor lightGrayColor];
    [self.ScrollView addSubview:firstView];
    
    UILabel *titLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, HBScreenHeight/2.0+7, HBScreenWidth-20, 20)];
    titLabel.textColor=[UIColor blackColor];
    //titLabel.text=@"小王子/小学生国外经典阅读";
    titLabel.text=self.dataModel.book_name;
    titLabel.textAlignment=NSTextAlignmentLeft;
    titLabel.font=[UIFont boldSystemFontOfSize:20];
    [self.ScrollView addSubview:titLabel];
    
//    UILabel *autherLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, HBScreenHeight/2.0+7+20+7, HBScreenWidth-20, 20)];
//    autherLabel.textColor=[UIColor lightGrayColor];
//    //autherLabel.text=@"安托万.德.圣.艾克苏陪尼";
//    autherLabel.text=self.dataModel.book_desc;
//    autherLabel.textAlignment=NSTextAlignmentLeft;
//    autherLabel.font=[UIFont systemFontOfSize:16];
//    [self.ScrollView addSubview:autherLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, HBScreenHeight/2.0+27*2+7, (HBScreenWidth-20)/5.0*2, 20)];
    moneyLabel.textColor=[UIColor redColor];
    //moneyLabel.text=@"¥62.67";
    moneyLabel.text=[NSString stringWithFormat:@"¥%@",self.dataModel.book_prices];
    moneyLabel.textAlignment=NSTextAlignmentLeft;
    moneyLabel.font=[UIFont boldSystemFontOfSize:20];
    [self.ScrollView addSubview:moneyLabel];
    
    UILabel *payCoinLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+(HBScreenWidth-20)/5.0*2, HBScreenHeight/2.0+27*2+7, (HBScreenWidth-20)/5.0*3, 20)];
    payCoinLabel.textColor=[UIColor redColor];
    //moneyLabel.text=@"¥62.67";
    payCoinLabel.text=[NSString stringWithFormat:@"%@金币可以抵扣%@元",self.dataModel.discount_yp,self.dataModel.discount_price];
    payCoinLabel.textAlignment=NSTextAlignmentRight;
    payCoinLabel.font=[UIFont systemFontOfSize:16];
    [self.ScrollView addSubview:payCoinLabel];
    
    UIView *secondView=[[UIView alloc]initWithFrame:CGRectMake(0, HBScreenHeight/2.0+27*3+7, HBScreenWidth, 1)];
    secondView.backgroundColor=[UIColor lightGrayColor];
    [self.ScrollView addSubview:secondView];
    
    UILabel *detaiTitlelLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,  HBScreenHeight/2.0+27*3+7+14, HBScreenWidth-20, 20)];
    detaiTitlelLabel.textColor=[UIColor blackColor];
    detaiTitlelLabel.text=@"内容简介";
    detaiTitlelLabel.textAlignment=NSTextAlignmentLeft;
    detaiTitlelLabel.font=[UIFont systemFontOfSize:16];
    [self.ScrollView addSubview:detaiTitlelLabel];
    
    // 获取到本行显示的字符串
    _detailLabel=[[UILabel alloc]init];
    _detailLabel.textColor=[UIColor blackColor];
    _detailLabel.textAlignment=NSTextAlignmentLeft;
    _detailLabel.font=[UIFont systemFontOfSize:16];
    _detailLabel.numberOfLines=0;
    [self.ScrollView addSubview:_detailLabel];
    
    _thirdView=[[UIView alloc]initWithFrame:CGRectMake(0, HBScreenHeight/2.0+27*4+14+10+20+7, HBScreenWidth, 1)];
    _thirdView.backgroundColor=[UIColor lightGrayColor];
    [self.ScrollView addSubview:_thirdView];

    //scrolView的滚动范围(只有滚动范围的宽高大于scrolView自身的宽高,才能实现滚动)
    self.ScrollView.contentSize=CGSizeMake(HBScreenWidth, HBScreenHeight/2.0+27*4+14+10+20+14);
    self.ScrollView.scrollsToTop=NO;
    self.ScrollView.showsVerticalScrollIndicator=NO;
    self.ScrollView.bounces=YES;
    
}

- (void)setimageView:(NSMutableArray *)imageUrlArr
{
//    _titleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, HBScreenWidth-80,HBScreenHeight/2.0)];
//    _titleImageView.userInteractionEnabled=YES;
//    _titleImageView.contentMode=UIViewContentModeScaleAspectFit;
//    //_titleImageView.image=[UIImage imageNamed:@"12_03"];
//    [self.whiteView addSubview:_titleImageView];
    
    UIScrollView *scrolView=[[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, HBScreenWidth-80,HBScreenHeight/2.0)];
    [self.whiteView addSubview:scrolView];
    scrolView.contentSize=CGSizeMake((HBScreenWidth-80)*imageUrlArr.count, HBScreenHeight/2.0);
    scrolView.pagingEnabled=YES;
    for (int i=0; i<imageUrlArr.count; i++) {
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake((HBScreenWidth-80)*i, 0, HBScreenWidth-80, HBScreenHeight/2.0)];
        InforModelData *datamodel=[[InforModelData alloc]init];
        datamodel=self.titleImageUrlArr[i];
        [imageview sd_setImageWithURL:[NSURL URLWithString:datamodel.image_file]];
        imageview.userInteractionEnabled=YES;
        [scrolView addSubview:imageview];
        //需要添加手势
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapACtion:)];
        [imageview addGestureRecognizer:tap];
    }
    scrolView.scrollEnabled=YES;
    scrolView.showsHorizontalScrollIndicator=NO;
    scrolView.bounces=NO;
    scrolView.delegate=self;

}
//scrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.numberBookImage=1+(scrollView.contentOffset.x+(HBScreenWidth-80)/2.0)/(HBScreenWidth-80);
    self.numberLabel.text=[NSString stringWithFormat:@"%lu/%lu",(unsigned long)self.numberBookImage,(unsigned long)self.titleImageUrlArr.count];
    
}
//网络请求回来后的下面展示的图
- (void)setDetailImgaeViewArr:(NSMutableArray *)detailArr height:(NSInteger)height
{
   
    CGFloat beHieght=HBScreenHeight/2.0+27*4+14+10+height+7+7;
    
    NSMutableArray *hieghtArr=[NSMutableArray array];
    for (int i = 0; i < detailArr.count; i ++) {
        InforModelData *model=[[InforModelData alloc]init];
        model=detailArr[i];
        NSInteger HBimageW=[model.image_width integerValue];
        NSInteger HBimageH=[model.image_height integerValue];
        
        CGFloat imageW = HBScreenWidth;
        CGFloat imageY =0;
        if (hieghtArr.count<1) {
            
            
        }else{
            for (NSString * hieght in hieghtArr) {
                
                imageY += [hieght integerValue];
            }
        }
        CGFloat imageH = HBScreenWidth*1.0/HBimageW*1.0*HBimageH;
        [hieghtArr addObject:@(imageH)];
        CGFloat imageX = 0;
     
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX,beHieght+imageY, imageW, imageH)];
        imageView.contentMode=UIViewContentModeScaleToFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.image_file] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
           
        
        }];
        [self.ScrollView addSubview:imageView];
        NSInteger hegintzong=0;
        for (NSString * hieght in hieghtArr) {
            
            hegintzong += [hieght integerValue];
        }
        self.ScrollView.contentSize=CGSizeMake(HBScreenWidth, HBScreenHeight/2.0+27*4+14+10+height+14+hegintzong);
        
    }

}

#pragma mark - 点击图片的方法
- (void)tapACtion:(UITapGestureRecognizer *)tap{

    pictureViewController  *showBigPicVc = [[pictureViewController alloc] init];
    NSMutableArray *imageArr=[NSMutableArray array];
    for (InforModelData *model in self.titleImageUrlArr) {
        
        [imageArr addObject:model.image_file];
    }
    [showBigPicVc setArray:imageArr];
    showBigPicVc.index=self.numberBookImage-1;
    showBigPicVc.modalTransitionStyle=UIModalTransitionStylePartialCurl;
    [self presentViewController:showBigPicVc animated:YES completion:nil];

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
#pragma mark - 购买按键的方法
- (IBAction)buyButtonAction:(UIButton *)sender {
    NSMutableArray *userArray=[NSMutableArray array];
    userArray = [LoginUserManager queryData:@"SELECT * FROM loginUser"];
    loginOrReginModel *userMessage = userArray.lastObject;
    if (userMessage.user_msisdn.length>0) {
        
        AddressViewController *addVC=[[AddressViewController alloc]init];
        addVC.dataModel=self.dataModel;
        [self.navigationController pushViewController:addVC animated:YES];
        
    }else{
        
        [self pushView];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

//进行http请求
- (void)setupHttpRequestaction:(NSString *)action action_parameter:(NSString *)action_parameter trans_code:(NSString *)trans_code loMore:(NSString *)loMore
{
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
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
               // NSString *urlstr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *csvDict = [NSDictionary dictionaryWithXMLData:data];
                
//                if (csvDict[@"error_code"]) {
//                    
//                    [SVProgressHUD showErrorWithStatus:csvDict[@"error_string"]];
//                    return;
//                }
//                if (csvDict[@"pop_message"]) {
//                    
//                    [SVProgressHUD showSuccessWithStatus:csvDict[@"pop_message"]];
//                    return;
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
                            self.infromAttModel=nil;
                            NSMutableDictionary *newsDict = [NSMutableDictionary dictionary];
                            for (NSDictionary *dict in newsArray) {
                                
                                if ([dict[@"key"] isEqualToString:@"标题"]) {
                                    newsDict[@"Infortitle"] = dict[@"value"];
                                    
                                }else if ([dict[@"key"] isEqualToString:@"内容简介"]){
                                    
                                    newsDict[@"InforDetail"] = dict[@"value"];
                                }
                                
                            }
                            self.infromAttModel=[[InforModelAtt alloc]init];
                            [self.infromAttModel setValuesForKeysWithDictionary:newsDict];
                            
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
    
                            if (picArray != nil && picArray.count > 0) {
                                for (NSMutableDictionary *picDict in picArray) {
                                    
                                    InforModelData *datamodel=[[InforModelData alloc]init];
                                    [datamodel setValuesForKeysWithDictionary:picDict];
                                    if ([datamodel.image_usage isEqualToString:@"title_image"]) {
                                        
                                        [self.titleImageUrlArr addObject:datamodel];
                                        
                                    }else if ([datamodel.image_usage isEqualToString:@"detail_image"]) {
                                        
                                        [self.detaileImageUrlArr addObject:datamodel];
                                    }
                        
                                    [self.infromdataModelArr addObject:datamodel];
                                }
                                //需要换图片
                                //加载
                            }
                            if (self.titleImageUrlArr.count>=1) {
                                [self setimageView:self.titleImageUrlArr];
//                                InforModelData *datamodel=[[InforModelData alloc]init];
//                                datamodel=self.titleImageUrlArr[0];
//                                [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:datamodel.image_file] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                                    
//                                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                    
//                                }];
                                
                                self.numberLabel.text=[NSString stringWithFormat:@"1/%lu",(unsigned long)self.titleImageUrlArr.count];
                                
                            }
                            
                                CGRect rect=[self.infromAttModel.InforDetail boundingRectWithSize:CGSizeMake(HBScreenWidth-20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
                                CGFloat height=rect.size.height;
                            _detailLabel.frame=CGRectMake(10,  HBScreenHeight/2.0+27*4+14+10, HBScreenWidth-20, height);
                            _detailLabel.text=self.infromAttModel.InforDetail;
                            _thirdView.frame=CGRectMake(0, HBScreenHeight/2.0+27*4+14+10+height+7, HBScreenWidth, 1);
                            self.ScrollView.contentSize=CGSizeMake(HBScreenWidth, HBScreenHeight/2.0+27*4+14+10+height+14);
                            
                            [self setDetailImgaeViewArr:self.detaileImageUrlArr height:height];
                            
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
