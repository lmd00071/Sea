//
//  LoginUserManager.h
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/6/7.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "loginOrReginModel.h"
@interface LoginUserManager : NSObject
+ (void)insertModal:(loginOrReginModel *)model;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (NSMutableArray *)queryData:(NSString *)querySql;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql;
@end
