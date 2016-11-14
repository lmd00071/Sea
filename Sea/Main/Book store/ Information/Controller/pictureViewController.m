//
//  pictureViewController.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/5/30.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "pictureViewController.h"
#import "UIImageView+WebCache.h"
@interface pictureViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat lastScale;

@property (nonatomic, strong) NSArray *imageViewArray;

@property (nonatomic, weak) UILabel *indexLabel;

@property (nonatomic, strong)NSMutableArray *newsPicArray;
@end

@implementation pictureViewController

#pragma mark - 懒加载
- (UILabel *)indexLabel
{
    if (_indexLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        CGFloat labelW = 80;
        CGFloat labelH = 20;
        CGFloat labelX = (HBScreenWidth - labelW) * 0.5;
        CGFloat labelY = HBScreenHeight - labelH - 30;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        //label.backgroundColor=[UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        _indexLabel = label;
    }
    return _indexLabel;
}

- (NSMutableArray *)newsPicArray
{
    if (_newsPicArray == nil) {
        
        self.newsPicArray = [NSMutableArray array];
    }
    return _newsPicArray;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [scrollView addGestureRecognizer:tap];
        scrollView.pagingEnabled = YES;
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.delegate = self;
        [self.view addSubview:scrollView];
        
        _scrollView = scrollView;
    }
    return _scrollView;
}

//scrollView的点击事件
- (void)tapGesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 控制器生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    //    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.lastScale = 1.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
   
}

#pragma mark - 属性的setting方法
//根据传入的模型数组添加图片
- (void)setArray:(NSMutableArray *)newsPicArray
{
  
    _newsPicArray = newsPicArray;
    
    NSMutableArray *imageViewArray = [NSMutableArray array];
    
    CGFloat imageW = self.scrollView.bw_width;
    CGFloat imageH = self.scrollView.bw_height;
    CGFloat imageX = 0;
    CGFloat imageY = (self.scrollView.bw_height - imageH) / 2;
    for (int i = 0; i < newsPicArray.count; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        imageView.userInteractionEnabled = YES;
        imageView.multipleTouchEnabled = YES;
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        [imageViewArray addObject:imageView];
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaGesture:)];
        [pinchRecognizer setDelegate:self];
        [imageView addGestureRecognizer:pinchRecognizer];
        
        UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
        [imageView addGestureRecognizer:rotationGestureRecognizer];
        
        __block UIActivityIndicatorView *activityIndicator;
        [imageView sd_setImageWithURL:[NSURL URLWithString:newsPicArray[i]] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (!activityIndicator)
            {
                activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [imageView addSubview:activityIndicator];
                activityIndicator.center = imageView.center;
                [activityIndicator startAnimating];
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
            
//            //判断是否为横竖屏
//            if (image.size.height/image.size.width*1.0>1.77) {
//                
//                imageView.contentMode=UIViewContentModeScaleToFill;
//                
//            }else{
            
            
                
           // }
//                        if (image) {
//                            if (image.size.width > BWScreenWidth) {
//                                imageView.bw_height = BWScreenWidth / image.size.width * image.size.height;
//                                imageView.bw_y = (BWScreenHeight - imageView.bw_height)/2;
//                            } else {
//                                imageView.bw_height = image.size.height;
//                                imageView.bw_y = (BWScreenHeight - imageView.bw_height)/2;
//                            }
//                            beganTransform = imageView.transform;
//                        }
        }];
        
        //判断是否为横竖屏
//        if (imageView.image.size.height/imageView.image.size.width*1.0>1.77) {
//            
//            imageView.contentMode=UIViewContentModeScaleToFill;
//            
//        }else{
//        
//            imageView.contentMode=UIViewContentModeScaleAspectFit;
//            
//        }
        [self.scrollView addSubview:imageView];
        
        imageX += imageW;
        
        if (i == newsPicArray.count - 1) {
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(imageView.frame), 0);
        }
    }
    
    self.imageViewArray = imageViewArray;
}

//根据传入的图片url,加载图片控件
- (void)setPicUrlArray:(NSArray *)picUrlArray
{
    _picUrlArray = picUrlArray;
    
    NSMutableArray *imageViewArray = [NSMutableArray array];
    
    //根据图片url加载图片控件
    CGFloat imageW = self.scrollView.bw_width;
    CGFloat imageH = imageW * 0.75;
    CGFloat imageX = 0;
    CGFloat imageY = (self.scrollView.bw_height - imageH) / 2;
    for (int i = 0; i < picUrlArray.count; i ++) {
        
        NSString *picUrl = picUrlArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        imageView.userInteractionEnabled = YES;
        imageView.multipleTouchEnabled = YES;
        [imageViewArray addObject:imageView];
        
        //旋转手势
        UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
        [imageView addGestureRecognizer:rotationGestureRecognizer];
        
        //缩放手势
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaGesture:)];
        [pinchRecognizer setDelegate:self];
        [imageView addGestureRecognizer:pinchRecognizer];
        
        __block UIActivityIndicatorView *activityIndicator;
        [imageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (!activityIndicator)
            {
                activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [imageView addSubview:activityIndicator];
                activityIndicator.center = imageView.center;
                [activityIndicator startAnimating];
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //下载图片完毕后,显示图片
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
            //判断是否为横竖屏
            if (image.size.height/image.size.width*1.0>1.77) {
                
                imageView.contentMode=UIViewContentModeScaleToFill;
                
            }else{
                
                imageView.contentMode=UIViewContentModeScaleAspectFit;
                
            }
            
            //            if (image) {
            //                if (image.size.width > BWScreenWidth) {
            //                    imageView.bw_height = BWScreenWidth / image.size.width * image.size.height;
            //                    imageView.bw_y = (BWScreenHeight - imageView.bw_height)/2;
            //                } else {
            //                    imageView.bw_height = image.size.height;
            //                    imageView.bw_y = (BWScreenHeight - imageView.bw_height)/2;
            //                }
            //                beganTransform = imageView.transform;
            //            }
        }];
        
        [self.scrollView addSubview:imageView];
        
        imageX += imageW;
        
        if (i == picUrlArray.count - 1) {
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(imageView.frame), 0);
        }
    }
    
    self.imageViewArray = imageViewArray;
}

//一进来选中第几张图片
- (void)setIndex:(NSInteger)index
{
    self.scrollView.contentOffset = CGPointMake(HBScreenWidth * index, 0);
    if (self.picUrlArray.count > 0) {
        self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd", (index + 1), self.picUrlArray.count];
    } else {
        self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd", (index + 1), self.newsPicArray.count];
    }
    
}

#pragma mark - UIScrollViewDelegate
//开始滚动的时候要将之前的放大还原
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bw_width;
    
    if (beganTransform.a) {
        UIImageView *imageView = self.imageViewArray[index];
        imageView.transform = beganTransform;
    }
}

//减速完成(即滚动结束),改变下方标签的值
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bw_width;
    if (self.picUrlArray.count > 0) {
        self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd", (index + 1), self.picUrlArray.count];
    } else {
        self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd", (index + 1), self.newsPicArray.count];
    }
}

#pragma mark - 手势方法
//图片最开始的位置
CGAffineTransform beganTransform;
//用于保证初始位置只被赋值一次
CGAffineTransform moreTransform;
//缩放手势
- (void)scaGesture:(UIPinchGestureRecognizer *)sender
{
    //    if (sender.state == UIGestureRecognizerStateBegan) {
    //        if (!moreTransform.a) {
    //            beganTransform = sender.view.transform;
    //        }
    //    }
    
    CGFloat scale = 1.0 - (self.lastScale - sender.scale);
    if (scale < 0.9) {
        scale = 0.9;
    }
    
    CGAffineTransform currentTransform = sender.view.transform;
    __block CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    sender.view.transform = newTransform;
    self.lastScale = sender.scale;
    
    //当手指离开屏幕时,将lastscale设置为1.0
    if(sender.state == UIGestureRecognizerStateEnded) {
        //        if (newTransform.a < 1) {
        //            sender.view.transform = CGAffineTransformScale(beganTransform, 1, 1);
        //        }
        moreTransform = sender.view.transform;
        self.lastScale = 1.0;
    }
}

//旋转手势
- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    //    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan) {
    //        if (!moreTransform.a) {
    //            beganTransform = rotationGestureRecognizer.view.transform;
    //        }
    //    }
    
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
    
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        moreTransform = rotationGestureRecognizer.view.transform;
        //        if (rotationGestureRecognizer.velocity > M_PI_4 && rotationGestureRecognizer.velocity < M_PI_2) {
        //            view.transform = CGAffineTransformRotate(beganTransform, M_PI_2);
        //            beganTransform = view.transform;
        //        } else if (rotationGestureRecognizer.velocity > M_PI_2 && rotationGestureRecognizer.velocity < M_PI) {
        //            view.transform = CGAffineTransformRotate(beganTransform, 0);
        //            beganTransform = view.transform;
        //        }
    }
}

//支持多手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
