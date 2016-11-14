//
//  BWCSVDatabase.m
//  WidomStudy
//
//  Created by 李明丹 on 16/1/27.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "BWCSVDatabase.h"
#import "BWCSVModel.h"

@implementation BWCSVDatabase

static FMDatabase *_fmdb;

+ (void)initialize {
    // 执行打开数据库和创建表操作
    _fmdb = [FMDatabase databaseWithPath:DBPath];
    
    [_fmdb open];
    
    //必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS csv_path(id INTEGER PRIMARY KEY, csvType TEXT, csvPath TEXT, overdueTime TEXT, action TEXT, action_parameter TEXT);"];
}

//插入数据
+ (BOOL)insertModal:(BWCSVModel *)model {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM csv_path WHERE csvPath = '%@';", model.csvPath];
    
    BWCSVModel *selectModel = [self queryData:sql].firstObject;
    
    if (selectModel.csvPath) {
        return NO;
    }
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO csv_path(csvType, csvPath, overdueTime, action, action_parameter) VALUES ('%@', '%@', '%@', '%@', '%@');", model.csvType, model.csvPath, model.overdueTime, model.action, model.action_parameter];
    return [_fmdb executeUpdate:insertSql];
}

//查询数据
+ (NSArray <BWCSVModel *>*)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM csv_path;";
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"csvType"] = [set stringForColumn:@"csvType"];
        dict[@"csvPath"] = [set stringForColumn:@"csvPath"];
        dict[@"overdueTime"] = [set stringForColumn:@"overdueTime"];
        dict[@"action"] = [set stringForColumn:@"action"];
        dict[@"action_parameter"] = [set stringForColumn:@"action_parameter"];
        
        BWCSVModel *model = [BWCSVModel mj_objectWithKeyValues:dict];
        [arrM addObject:model];
    }
    return arrM;
}

//删除数据
+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM csv_path";
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

+ (NSArray <BWCSVModel *>*)writeCsvWithCsvDict:(NSDictionary *)csvDict action:(NSString *)action action_parameter:(NSString *)action_parameter
{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    //非UTF-8编码
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    //cache路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    //缓存时间
    NSString *generalName = [csvDict[GeneralCsvKey] componentsSeparatedByString:@"/"].lastObject;
    NSString *generalCsv = [NSString stringWithContentsOfURL:[NSURL URLWithString:csvDict[GeneralCsvKey]] encoding:encode error:nil];
    NSString *generalPath = [cachePath stringByAppendingPathComponent:generalName];
    [generalCsv writeToFile:generalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *generalArray = [generalCsv csvStringTransformToDictionary];
    NSString *laterDateString = nil;
    for (NSDictionary *generalDict in generalArray) {
        if ([generalDict[@"key"] isEqualToString:@"缓存时长"]) {
            NSString *cacheTime = generalDict[@"value"];
            laterDateString = [NSDate laterDateWithNumber:cacheTime.intValue];
        }
    }
    
    NSMutableDictionary *generalDict = [NSMutableDictionary dictionary];
    generalDict[@"csvType"] = GeneralCsvKey;
    generalDict[@"csvPath"] = generalName;
    generalDict[@"overdueTime"] = laterDateString;
    generalDict[@"action"] = action;
    generalDict[@"action_parameter"] = action_parameter;
    
    BWCSVModel *generalModel = [BWCSVModel mj_objectWithKeyValues:generalDict];
    [modelArray addObject:generalModel];
    
    //标题
    NSString *attrName = [csvDict[AttrCsvKey] componentsSeparatedByString:@"/"].lastObject;
    NSString *attrPath = [cachePath stringByAppendingPathComponent:attrName];
    NSString *attrCsv = [NSString stringWithContentsOfURL:[NSURL URLWithString:csvDict[AttrCsvKey]] encoding:encode error:nil];
    [attrCsv writeToFile:attrPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[@"csvType"] = AttrCsvKey;
    attrDict[@"csvPath"] = attrName;
    attrDict[@"overdueTime"] = laterDateString;
    attrDict[@"action"] = action;
    attrDict[@"action_parameter"] = action_parameter;
    
    BWCSVModel *attrModel = [BWCSVModel mj_objectWithKeyValues:attrDict];
    [modelArray addObject:attrModel];
    
    //数据
    NSString *dataName = [csvDict[DataCsvKey] componentsSeparatedByString:@"/"].lastObject;
    NSString *dataCsv = [NSString stringWithContentsOfURL:[NSURL URLWithString:csvDict[DataCsvKey]] encoding:encode error:nil];
    NSString *dataPath = [cachePath stringByAppendingPathComponent:dataName];
    [dataCsv writeToFile:dataPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    dataDict[@"csvType"] = DataCsvKey;
    dataDict[@"csvPath"] = dataName;
    dataDict[@"overdueTime"] = laterDateString;
    dataDict[@"action"] = action;
    dataDict[@"action_parameter"] = action_parameter;
    
    BWCSVModel *dataModel = [BWCSVModel mj_objectWithKeyValues:dataDict];
    [modelArray addObject:dataModel];
    
//    BWLog(@"%@, %@, %@", generalPath, attrPath, dataPath);
    
    return modelArray;
}

@end
