//
//  LoginUserManager.m
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/6/7.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "LoginUserManager.h"
#define LPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"loginUser.db"]
@implementation LoginUserManager

static FMDatabase *_fmdb;

+ (void)initialize {
    // 执行打开数据库和创建表操作
    _fmdb = [FMDatabase databaseWithPath:LPATH];
    
    [_fmdb open];
    
    //必须先打开数据库才能创建表。。。否则提示数据库没有打开
     [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS loginUser(error_code TEXT PRIMARY KEY, error_string TEXT, register_result_msg TEXT, login_result_msg TEXT, user_account_uid TEXT, user_name TEXT, user_msisdn TEXT, photo_icon_url TEXT, photo_raw_url TEXT);"];
    
    
}

//插入数据
+ (void)insertModal:(loginOrReginModel *)model{
    
    NSLog(@"%@",LPATH);
   
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO loginUser(error_code, error_string, register_result_msg, login_result_msg, user_account_uid, user_name, user_msisdn, photo_icon_url,photo_raw_url) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", model.error_code, model.error_string, model.register_result_msg, model.login_result_msg, model.user_account_uid, model.user_name, model.user_msisdn, model.photo_icon_url,model.photo_raw_url];
        [_fmdb executeUpdate:insertSql];
   
}

//查询数据
+ (NSMutableArray <loginOrReginModel *>*)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM loginUser;";
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"error_code"] = [set stringForColumn:@"error_code"];
        dict[@"error_string"] = [set stringForColumn:@"error_string"];
        dict[@"register_result_msg"] = [set stringForColumn:@"register_result_msg"];
        dict[@"login_result_msg"] = [set stringForColumn:@"login_result_msg"];
        dict[@"user_account_uid"] = [set stringForColumn:@"user_account_uid"];
        dict[@"user_name"] = [set stringForColumn:@"user_name"];
        dict[@"user_msisdn"] = [set stringForColumn:@"user_msisdn"];
        dict[@"photo_icon_url"] = [set stringForColumn:@"photo_icon_url"];
        dict[@"photo_raw_url"] = [set stringForColumn:@"photo_raw_url"];
        
        loginOrReginModel *model = [loginOrReginModel mj_objectWithKeyValues:dict];
        [arrM addObject:model];
    }
    return arrM;
}

//删除数据
+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM loginUser";
    }
    
    return [_fmdb executeUpdate:deleteSql];
    
}

//修改数据
+ (BOOL)modifyData:(NSString *)modifySql {
    
    if (modifySql == nil) {
        
        return NO;
    }
    return [_fmdb executeUpdate:modifySql];
}


@end
