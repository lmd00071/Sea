//
//  BWUserMessageManager.m
//  WidomStudy
//
//  Created by 李明丹 on 16/1/21.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "BWUserMessageManager.h"

@implementation BWUserMessageManager

static FMDatabase *_fmdb;

+ (void)initialize {
    // 执行打开数据库和创建表操作
    _fmdb = [FMDatabase databaseWithPath:DBPath];
    
    [_fmdb open];
    
    //必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS user_message(id INTEGER PRIMARY KEY, user_account_uid TEXT, user_name TEXT, photo_icon_url TEXT, photo_raw_url TEXT, school_id TEXT, school_name TEXT, dept_id TEXT, dept_name TEXT, user_contact_phone TEXT, account TEXT, password TEXT, teach_course_id TEXT, teach_course_name TEXT, asaf_token TEXT);"];
}

//插入数据
+ (BOOL)insertModal:(BWUserMessage *)model {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM user_message WHERE user_account_uid = '%@';", model.user_account_uid];
    BWUserMessage *selectModel = [self queryData:sql].firstObject;
    if (selectModel.user_account_uid) {
        return NO;
    }
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO user_message(user_account_uid, user_name, photo_icon_url, photo_raw_url, school_id, school_name, dept_id, dept_name, user_contact_phone, account, password, teach_course_id, teach_course_name, asaf_token) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", model.user_account_uid, model.user_name, model.photo_icon_url, model.photo_raw_url, model.school_id, model.school_name, model.dept_id, model.dept_name, model.user_contact_phone, model.account, model.password, model.teach_course_id, model.teach_course_name, model.asaf_token];
    return [_fmdb executeUpdate:insertSql];
}

//查询数据
+ (NSArray <BWUserMessage *>*)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM user_message;";
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"user_account_uid"] = [set stringForColumn:@"user_account_uid"];
        dict[@"user_name"] = [set stringForColumn:@"user_name"];
        dict[@"photo_icon_url"] = [set stringForColumn:@"photo_icon_url"];
        dict[@"photo_raw_url"] = [set stringForColumn:@"photo_raw_url"];
        dict[@"school_id"] = [set stringForColumn:@"school_id"];
        dict[@"school_name"] = [set stringForColumn:@"school_name"];
        dict[@"dept_id"] = [set stringForColumn:@"dept_id"];
        dict[@"dept_name"] = [set stringForColumn:@"dept_name"];
        dict[@"user_contact_phone"] = [set stringForColumn:@"user_contact_phone"];
        dict[@"account"] = [set stringForColumn:@"account"];
        dict[@"password"] = [set stringForColumn:@"password"];
        dict[@"teach_course_id"] = [set stringForColumn:@"teach_course_id"];
        dict[@"teach_course_name"] = [set stringForColumn:@"teach_course_name"];
        dict[@"asaf_token"] = [set stringForColumn:@"asaf_token"];
        
        BWUserMessage *model = [BWUserMessage mj_objectWithKeyValues:dict];
        [arrM addObject:model];
    }
    return arrM;
}

//删除数据
+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM user_message";
    }
    
    return [_fmdb executeUpdate:deleteSql];
    
}

//修改数据
+ (BOOL)modifyData:(NSString *)modifySql {
    
    if (modifySql == nil) {
        //        modifySql = @"UPDATE news_home SET ID_No = '789789' WHERE name = 'lisi'";
        return NO;
    }
    return [_fmdb executeUpdate:modifySql];
}

@end
