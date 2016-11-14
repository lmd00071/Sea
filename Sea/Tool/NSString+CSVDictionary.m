//
//  NSString+CSVDictionary.m
//  demo2
//
//  Created by 李明丹 on 16/1/8.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "NSString+CSVDictionary.h"

#import "parseCSV.h"

@implementation NSString (CSVDictionary)

//将csv格式的文件字符串转化为字典数组
- (NSArray <NSDictionary *>*)csvStringTransformToDictionary
{
    if (self.length > 0) {
        
        NSMutableArray *dictArray = [NSMutableArray array];
        
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data != nil) {
            
            // 第三方框架，給到内容就可以了，实际上第三方框架也可以直接打开文件，不需要经过testFileData
            CSVParser *parser = [[CSVParser alloc] init];
            [parser setEncoding:NSUTF8StringEncoding];
            NSMutableArray *contentsArray = [parser parseData:data];
            
            NSArray *headerArray;
            for (int index = 0; index < contentsArray.count; index++) {
                
                NSArray *dataArray = contentsArray[index];
                
                //存放所有key的数组
                if (index == 0) {
                    headerArray = dataArray;
                }
                
                //存放所有value的数组
                if (index != 0) {
                    
                    //存放数据的字典
                    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
                    
                    //遍历存放value的数组
                    for (int i = 0; i < dataArray.count; i ++) {
                        
                        //拿到对应的key
                        NSString *key = headerArray[i];
                        //key所对应的value
                        NSString *value = dataArray[i];
                        dataDictionary[key] = value;
                    }
                    
                    //将数据字典加到数组中
                    [dictArray addObject:dataDictionary];
                }
            }
        }
        return dictArray;
    }
    return nil;
}

//将16进制字符串转化为UIColor
- (UIColor *) hexadecimalStringToColor
{
    if (!self || [self isEqualToString:@""]) {
        return [UIColor blackColor];
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[self substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[self substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[self substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

@end
