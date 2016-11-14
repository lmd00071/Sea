//
//  RankUserModel.m
//  WidomStudy
//
//  Created by 李明丹 on 16/3/23.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "RankUserModel.h"

@implementation RankUserModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"标题"]) {
        
        [self setValue:value forKey:@"title"];
    }
    
    if ([key isEqualToString:@"我的头像"]) {
        
        [self setValue:value forKey:@"icon"];
    }
    
    if ([key isEqualToString:@"我的昵称"]) {
        
        [self setValue:value forKey:@"name"];
    }
    
    if ([key isEqualToString:@"我的得分情况"]) {
        
        [self setValue:value forKey:@"userMessager"];
        
    }
    
}

@end
