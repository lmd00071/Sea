//
//  ShowImageController.h
// 
//
//  Created by mac on 16/5/7.
//  Copyright © 2016年 黄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageView : UIScrollView


//是否显示圆形下载进度
@property (nonatomic, assign) BOOL isProgerss;

//圆形进度 颜色
@property (nonatomic, strong) UIColor *properssColor;



//是否显示页码标签
@property (nonatomic, assign) BOOL isTally;
//页码标签字体颜色（默认白色）
@property (nonatomic, strong) UIColor *TallyColor;
//标签字体
@property (nonatomic, strong) UIFont *tallyFont;



/**
 *  图片url数组 (放到计算完frame和添加到父控件之后)
 */
@property (nonatomic, strong) NSArray *imageUrlArr;

//创建几张图片（默认显示三张）最大为图片数组-1
@property (nonatomic, assign) int showImageCount;

@end
