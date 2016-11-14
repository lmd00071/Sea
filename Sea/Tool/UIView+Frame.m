//
//  UIView+Frame.m
//  demo2
//
//  Created by 李明丹 on 16/1/7.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setBw_x:(CGFloat)bw_x
{
    CGRect frame = self.frame;
    frame.origin.x = bw_x;
    self.frame = frame;
}
- (CGFloat)bw_x
{
    return self.frame.origin.x;
}

- (void)setBw_y:(CGFloat)bw_y
{
    CGRect frame = self.frame;
    frame.origin.y = bw_y;
    self.frame = frame;
}

- (CGFloat)bw_y
{
    return self.frame.origin.y;
}

- (void)setBw_origin:(CGPoint)bw_origin
{
    CGRect frame = self.frame;
    frame.origin = bw_origin;
    self.frame = frame;
}

- (CGPoint)bw_origin
{
    return self.frame.origin;
}

- (void)setBw_width:(CGFloat)bw_width
{
    CGRect frame = self.frame;
    frame.size.width = bw_width;
    self.frame = frame;
}

- (CGFloat)bw_width
{
    return self.frame.size.width;
}

- (void)setBw_height:(CGFloat)bw_height
{
    CGRect frame = self.frame;
    frame.size.height = bw_height;
    self.frame = frame;
}

- (CGFloat)bw_height
{
    return self.frame.size.height;
}

- (void)setBw_size:(CGSize)bw_size
{
    CGRect frame = self.frame;
    frame.size = bw_size;
    self.frame = frame;
}

- (CGSize)bw_size
{
    return self.frame.size;
}

- (void)setBw_centerX:(CGFloat)bw_centerX
{
    CGPoint center = self.center;
    center.x = bw_centerX;
    self.center = center;
}

- (CGFloat)bw_centerX
{
    return self.center.x;
}

- (void)setBw_centerY:(CGFloat)bw_centerY
{
    CGPoint center = self.center;
    center.y = bw_centerY;
    self.center = center;
}

- (CGFloat)bw_centerY
{
    return self.center.y;
}

@end
