//
//  BWCSVDatabase.h
//  WidomStudy
//
//  Created by 李明丹 on 16/1/27.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BWCSVModel;

@interface BWCSVDatabase : NSObject

// 插入模型数据
+ (BOOL)insertModal:(BWCSVModel *)modal;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryData:(NSString *)querySql;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql;

/** 将请求下来的csv地址存到本地 */
+ (NSArray <BWCSVModel *>*)writeCsvWithCsvDict:(NSDictionary *)csvDict action:(NSString *)action action_parameter:(NSString *)action_parameter;

@end
