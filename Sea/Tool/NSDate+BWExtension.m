//
//  NSDate+BWExtension.m
//  WidomStudy
//
//  Created by 李明丹 on 16/1/28.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "NSDate+BWExtension.h"

@implementation NSDate (BWExtension)

- (NSDateComponents *)intervalToDate:(NSDate *)date
{
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 想比较哪些元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 比较
    return [calendar components:unit fromDate:self toDate:date options:0];
}

- (NSDateComponents *)intervalToNow
{
    return [self intervalToDate:[NSDate date]];
}

+ (BOOL)isLaterTimeThanNowWithDateString:(NSString *)dateString
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSDate *date = [fmt dateFromString:dateString];
    
    NSDateComponents *dateComponents = [date intervalToNow];
//    BWLog(@"%@", dateComponents);
    if (dateComponents.year < 0) {
        return YES;
    }
    if (dateComponents.month < 0) {
        return YES;
    }
    if (dateComponents.day < 0) {
        return YES;
    }
    if (dateComponents.hour < 0) {
        return YES;
    }
    if (dateComponents.minute < 0) {
        return YES;
    }
    if (dateComponents.second < 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)laterDateWithNumber:(NSInteger)number
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSString *nowDateString = [fmt stringFromDate:[NSDate date]];
    
    NSString *yearString = [nowDateString substringWithRange:NSMakeRange(0, 4)];
    NSString *monthString = [nowDateString substringWithRange:NSMakeRange(5, 2)];
    NSString *dayString = [nowDateString substringWithRange:NSMakeRange(8, 2)];
    NSString *hourString = [nowDateString substringWithRange:NSMakeRange(11, 2)];
    NSString *minuteString = [nowDateString substringWithRange:NSMakeRange(14, 2)];
    NSString *secondString = [nowDateString substringWithRange:NSMakeRange(17, 2)];
    
    if (number >= 24 * 60 * 60) {
        dayString = [NSString stringWithFormat:@"%zd", dayString.intValue + number / 24 / 60 / 60];
    } else if (number >= 60 * 60) {
        hourString = [NSString stringWithFormat:@"%zd", (hourString.intValue + number / 60 / 60)];
    } else if (number >= 60) {
        minuteString = [NSString stringWithFormat:@"%zd", (minuteString.intValue + number / 60)];
    } else {
        secondString = [NSString stringWithFormat:@"%zd", (secondString.intValue + number)];
    }
    
    //处理不合理时间数据
    if (secondString.integerValue > 59) {
        secondString = [NSString stringWithFormat:@"00"];
        minuteString = [NSString stringWithFormat:@"%02zd", (minuteString.integerValue + 1)];
    }
    if (minuteString.integerValue > 59) {
        minuteString = [NSString stringWithFormat:@"00"];
        hourString = [NSString stringWithFormat:@"%02zd", (hourString.integerValue + 1)];
    }
    if (hourString.integerValue > 23) {
        hourString = [NSString stringWithFormat:@"00"];
        dayString = [NSString stringWithFormat:@"%02zd", (dayString.integerValue + 1)];
    }
    if (dayString.integerValue > 31) {
        dayString = [NSString stringWithFormat:@"01"];
        monthString = [NSString stringWithFormat:@"%02zd", (monthString.integerValue + 1)];
    }
    if (monthString.integerValue > 12) {
        monthString = [NSString stringWithFormat:@"01"];
        yearString = [NSString stringWithFormat:@"%zd", (yearString.integerValue + 1)];
    }
    
    NSMutableString *dateString = [NSMutableString string];
    [dateString appendString:[NSString stringWithFormat:@"%@/", yearString]];
    [dateString appendString:[NSString stringWithFormat:@"%@/", monthString]];
    [dateString appendString:[NSString stringWithFormat:@"%@ ", dayString]];
    [dateString appendString:[NSString stringWithFormat:@"%@:", hourString]];
    [dateString appendString:[NSString stringWithFormat:@"%@:", minuteString]];
    [dateString appendString:[NSString stringWithFormat:@"%@", secondString]];
    
    return dateString;
}

@end
