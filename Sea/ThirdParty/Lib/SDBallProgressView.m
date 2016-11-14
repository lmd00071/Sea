//
//  SDBallProgressView.m
//  SDProgressView
//
//  Created by aier on 15-2-19.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDBallProgressView.h"

@implementation SDBallProgressView

- (void)drawRect:(CGRect)rect
{
    
    //self.backgroundColor=[UIColor colorWithRed:0.714 green:0.733 blue:0.733 alpha:1];
    //self.backgroundColor=[UIColor yellowColor];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    [[UIColor whiteColor] set];
    
    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - SDProgressViewItemMargin;
    
    
    CGFloat w = radius * 2 + SDProgressViewItemMargin;
    CGFloat h = w;
    CGFloat x = (rect.size.width - w) * 0.5;
    CGFloat y = (rect.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextFillPath(ctx);
    
    //[[UIColor grayColor] set];
    [[UIColor colorWithRed:0.86 green:0.172 blue:0.251 alpha:1] set];
    
    CGFloat startAngle = M_PI * 0.5 - self.progress * M_PI;
    CGFloat endAngle = M_PI * 0.5 + self.progress * M_PI;
    CGContextAddArc(ctx, xCenter, yCenter, radius, startAngle, endAngle, 0);
    CGContextFillPath(ctx);
    
    // 进度数字
    NSString *progressStr = [NSString stringWithFormat:@"%.0f%s", self.progress * 100, "\%"];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:18 * SDProgressViewFontScale];
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [self setCenterProgressText:progressStr withAttributes:attributes];
}

@end
