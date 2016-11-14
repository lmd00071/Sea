//
//  NSDate+BWExtension.h
//  WidomStudy
//
//  Created by 李明丹 on 16/1/28.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BWExtension)

//两个时间进行比较
- (NSDateComponents *)intervalToDate:(NSDate *)date;

//和现在的时间进行比较
- (NSDateComponents *)intervalToNow;

//判断是否是比现在的时间晚
+ (BOOL)isLaterTimeThanNowWithDateString:(NSString *)dateString;

//在现在时间的基础上,加一个时间(number的单位是秒)
+ (NSString *)laterDateWithNumber:(NSInteger)number;

@end
