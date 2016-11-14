//
//  SHProgerssView.m
//  
//
//  Created by mac on 16/4/19.
//  Copyright © 2016年 黄. All rights reserved.
// 图片下载进度

#import "SHProgerssView.h"

@implementation SHProgerssView



- (void)drawRect:(CGRect)rect {

    //画圆
    
    // 获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 拼接路径
    /**
     *  @param ctx          上下文
     *  @param x#>          圆心的x值
     *  @param y#>          圆心的y值
     *  @param radius#>     半径
     *  @param startAngle#> 开始角度
     *  @param endAngle#>   结束角度
     *  @param clockwise#>  0：顺时针 1：逆时针
     */
    CGFloat x = rect.size.width * 0.5;
    CGFloat y = rect.size.height * 0.5;
    CGFloat radius = self.frame.size.width *0.4;
    CGFloat startAngle = 0;
    CGFloat endAngle = 2 * M_PI *self.progerss;
    CGContextAddArc(ctx, x, y, radius, startAngle, endAngle, 0);

    
    [self.properssColor set];
    // 设置线宽大小
    CGContextSetLineWidth(ctx, 5);
    
    // 空心渲染
    CGContextStrokePath(ctx);
    // 参数二决定以什么方式绘制
    CGContextDrawPath(ctx, kCGPathFill);
}


@end
