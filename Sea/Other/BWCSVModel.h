//
//  BWCSVModel.h
//  WidomStudy
//
//  Created by 李明丹 on 16/1/27.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWCSVModel : NSObject

//csv文件的类型
@property (nonatomic, copy) NSString *csvType;

//csv文件的地址
@property (nonatomic, copy) NSString *csvPath;

//过期时间
@property (nonatomic, copy) NSString *overdueTime;

@property (nonatomic, copy) NSString *action;

@property (nonatomic, copy) NSString *action_parameter;

@end
