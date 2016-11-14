//
//  DataBase.h
//  StarClothes
//
//  Created by lanou on 15/12/5.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "userBookModel.h"
#import "detaiModel.h"
#import "ABModel.h"
#import "videoModel.h"
#import "playVideoModel.h"

//协议方法
@protocol  DataBaseDelegate <NSObject>

//可以选择的
@optional
-(void)passProgess:(float )progress;

@end

@interface DataBase : NSObject

// 创建数据库文件的
-(void)creatUserBookDataBaseUserName:(NSString *)UserName;

// 添加
-(void)addUserBookFromBrief:(userBookModel *)brief UserName:(NSString *)UserName;

// 删除
-(void)deleteUserFromBriefUid:(NSString *)Uid UserName:(NSString *)UserName;

// 根据Uid名查找数据库数据
-(NSMutableArray *)allUserBookUserName:(NSString *)UserName;



// 创建数据库文件的
-(void)creatUnitDataBaseUidName:(NSString *)UidName;

// 添加
-(void)addUnitFromBriefAarray:(NSMutableArray *)briefArray UidName:(NSString *)UidName;

// 删除
-(void)deleteUnitFromBriefUid:(NSString *)Uid;

// 根据Uid名查找数据库数据
-(NSMutableArray *)allUnitUidName:(NSString *)UidName;



// 创建数据库文件的
-(void)creatABJuanDataBaseUidName:(NSString *)UidName;

// 添加
-(void)addABJuanFromBriefAarray:(NSMutableArray *)briefArray UidName:(NSString *)UidName;

// 删除
-(void)deleteABJuanFromBriefUid:(NSString *)Uid;

// 根据Uid名查找数据库数据
-(NSMutableArray *)allABJuanUidName:(NSString *)UidName;



// 创建数据库文件的
-(void)creatVideoDataBaseUidName:(NSString *)UidName;

// 添加
-(BOOL)addVideoFromDelegateAction:(id<DataBaseDelegate>)delegate BriefAarray:(NSMutableArray *)briefArray UidName:(NSString *)UidName;

-(void)addVideoFromBriefAarray:(NSMutableArray *)briefArray UidName:(NSString *)UidName;
// 删除
-(void)deleteVideoFromBriefUid:(NSString *)Uid;

// 根据Uid名查找数据库数据
-(NSMutableArray *)allVideoUidName:(NSString *)UidName;


//协议传值
@property(nonatomic ,retain)id <DataBaseDelegate>delegate;


// 创建数据库文件的
-(void)creatVideoPlayDataBaseUidName:(NSString *)UidName;

// 添加
-(void)addVideoPlayFromBrief:(playVideoModel *)brief UidName:(NSString *)UidName;

// 删除
-(void)deleteVideoPlayFromBriefUid:(NSString *)Uid;

// 根据Uid名查找数据库数据
-(playVideoModel *)allVideoPlayUidName:(NSString *)UidName url:(NSString *)url;




@end
