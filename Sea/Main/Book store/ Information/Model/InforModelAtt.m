//
//  InforModelAtt.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/6/2.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "InforModelAtt.h"

@implementation InforModelAtt
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"标题"]) {
        
        [self setValue:value forKey:@"Infortitle"];
    }
    
    if ([key isEqualToString:@"内容简介"]) {
        
        [self setValue:value forKey:@"InforDetail"];
    }
}
@end
