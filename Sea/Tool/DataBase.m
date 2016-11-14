//
//  DataBase.m
//  StarClothes
//
//  Created by lanou on 15/12/5.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import "DataBase.h"
#import "UIImageView+WebCache.h"
@interface DataBase()

@property(nonatomic ,strong)FMDatabase *userdataBase;
@property(nonatomic ,strong)FMDatabase *detaeldataBase;
@property(nonatomic ,strong)FMDatabase *ABdataBase;
@property(nonatomic ,strong)FMDatabase *videodataBase;
@property(nonatomic ,strong)FMDatabase *videoPlaydataBase;

//下载进度
@property (nonatomic,assign)NSInteger numberProgress;
@property (nonatomic,assign)double progess;
@end


@implementation DataBase

// 创建数据库的UserBook
-(void)creatUserBookDataBaseUserName:(NSString *)UserName
{
    // 创建建立数据库的目标路径
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *dbPath = [document stringByAppendingPathComponent:@"UserDataBase.db"];
    
    NSLog(@"数据库的路径=%@",dbPath);
    
    self.userdataBase = [FMDatabase databaseWithPath:dbPath];
    if ([self.userdataBase open]) {
        
        if ([UserName isEqualToString:@"游客"]) {
            NSString *Update=[NSString stringWithFormat:@"create table User%ld (text_book_uid text permary key, icon text, textbook_name text, grade_order_no text, grade_half_order_no text,course_id text,course_name text,lecture_cnt text,modify_time text, iconImage blob)",[UserName hash]];
            [self.userdataBase executeUpdate:Update];
            
            [self.userdataBase close];
        }else{
            NSString *Update=[NSString stringWithFormat:@"create table User%@ (text_book_uid text permary key, icon text, textbook_name text, grade_order_no text, grade_half_order_no text,course_id text,course_name text,lecture_cnt text,modify_time text, iconImage blob)",UserName];
        
        [self.userdataBase executeUpdate:Update];
        
        [self.userdataBase close];
        }
    }
    
}




-(void)addUserBookFromBrief:(userBookModel *)brief UserName:(NSString *)UserName
{
    NSData *iconImage=UIImagePNGRepresentation(brief.iconImage);
    
    if ([self.userdataBase open]) {
        
        if ([UserName isEqualToString:@"游客"]) {
            NSString *path=[NSString stringWithFormat:@"insert into User%ld (text_book_uid,icon,textbook_name,grade_order_no,grade_half_order_no,course_id,course_name,lecture_cnt,modify_time,iconImage) values(?,?,?,?,?,?,?,?,?,?)",[UserName hash]];
            
            [self.userdataBase executeUpdate:path,brief.text_book_uid,brief.icon,brief.textbook_name,brief.grade_order_no,brief.grade_half_order_no,brief.course_id,brief.course_name,brief.lecture_cnt,brief.modify_time,iconImage];
        }else{
            NSString *path=[NSString stringWithFormat:@"insert into User%@ (text_book_uid,icon,textbook_name,grade_order_no,grade_half_order_no,course_id,course_name,lecture_cnt,modify_time,iconImage) values(?,?,?,?,?,?,?,?,?,?)",UserName];
            
            [self.userdataBase executeUpdate:path,brief.text_book_uid,brief.icon,brief.textbook_name,brief.grade_order_no,brief.grade_half_order_no,brief.course_id,brief.course_name,brief.lecture_cnt,brief.modify_time,iconImage];
        }
        
       
        
        
    }
    [self.userdataBase close];
    
}

-(void)deleteUserFromBriefUid:(NSString *)Uid UserName:(NSString *)UserName
{
  
    if ([UserName isEqualToString:@"游客"]) {
        NSString *deleteUserBook = [NSString stringWithFormat:@"delete from User%ld where text_book_uid = '%@'",[UserName hash],Uid];
        if ([self.userdataBase open]) {
            
            [self.userdataBase executeUpdate:deleteUserBook];
            
        }
        [self.userdataBase close];
    }else{
        
        NSString *deleteUserBook = [NSString stringWithFormat:@"delete from User%@ where text_book_uid = '%@'",UserName,Uid];
        if ([self.userdataBase open]) {
            
            [self.userdataBase executeUpdate:deleteUserBook];
            
        }
        [self.userdataBase close];
    }
    
    
}

-(NSMutableArray *)allUserBookUserName:(NSString *)UserName
{

    NSMutableArray *stuArr=[NSMutableArray array];
    NSString *findWeather=[[NSString alloc]init];
    if ([UserName isEqualToString:@"游客"]) {
        findWeather = [NSString stringWithFormat:@"select * from User%ld",[UserName hash]];
    }else{
        findWeather = [NSString stringWithFormat:@"select * from User%@",UserName];
    }
    
    if ([self.userdataBase open]) {
        FMResultSet *set = [self.userdataBase executeQuery:findWeather];
        while ([set next]) {
           
            userBookModel *brief = [[userBookModel alloc]init];
            NSString *text_book_uid = [set stringForColumn:@"text_book_uid"];
            NSString *icon = [set stringForColumn:@"icon"];
            NSString *textbook_name = [set stringForColumn:@"textbook_name"];
            NSString *grade_order_no = [set stringForColumn:@"grade_order_no"];
            NSString *grade_half_order_no = [set stringForColumn:@"grade_half_order_no"];
            NSString *course_id = [set stringForColumn:@"course_id"];
            NSString *course_name = [set stringForColumn:@"course_name"];
            NSString *lecture_cnt = [set stringForColumn:@"lecture_cnt"];
            NSString *modify_time = [set stringForColumn:@"modify_time"];
        
            NSData *imageData = [set dataForColumn:@"iconImage"];
            UIImage *iconImage=[[UIImage alloc]init];
            iconImage=[UIImage imageWithData:imageData];
            
            brief.text_book_uid=text_book_uid;
            brief.icon=icon;
            brief.textbook_name=textbook_name;
            brief.grade_order_no=grade_order_no;
            brief.grade_half_order_no=grade_half_order_no;
            brief.course_id=course_id;
            brief.course_name=course_name;
            brief.lecture_cnt=lecture_cnt;
            brief.modify_time=modify_time;
            brief.iconImage=iconImage;
            
            [stuArr addObject:brief];
        }
        
    
       
    }
    return stuArr;
}


//*******************************************************************************************************
// 创建数据库文件的
-(void)creatUnitDataBaseUidName:(NSString *)UidName
{
    // 创建建立数据库的目标路径
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *dbPath = [document stringByAppendingPathComponent:@"UnitDataBase.db"];
    
    NSLog(@"数据库的路径=%@",dbPath);
    
    self.detaeldataBase = [FMDatabase databaseWithPath:dbPath];
    if ([self.detaeldataBase open]) {
        
        NSString *Update=[NSString stringWithFormat:@"create table Uni%ld (lesson_no text, lesson_name text)",[UidName hash]];
        NSString *newUpdata=[Update stringByReplacingOccurrencesOfString:@"-" withString:@"t"];
        
        [self.detaeldataBase executeUpdate:newUpdata];
        
        [self.detaeldataBase close];
    }

}

// 添加
-(void)addUnitFromBriefAarray:(NSMutableArray *)briefArray UidName:(NSString *)UidName
{
    
    for (detaiModel *brief in briefArray) {
        
        
        if ([self.detaeldataBase open]) {
            
            NSString *path=[NSString stringWithFormat:@"insert into Uni%ld (lesson_no,lesson_name) values(?,?)",[UidName hash]];
            NSString *newPath=[path stringByReplacingOccurrencesOfString:@"-" withString:@"t"];
            
            [self.detaeldataBase executeUpdate:newPath,brief.lesson_no,brief.lesson_name];
            
        }
        [self.detaeldataBase close];
    }
    

}

// 删除
-(void)deleteUnitFromBriefUid:(NSString *)Uid
{

    NSString *delete= [NSString stringWithFormat:@"drop table Uni%ld",[Uid hash]];
    NSString *newdelete=[delete stringByReplacingOccurrencesOfString:@"-" withString:@"t"];
    if ([self.detaeldataBase open]) {
        
        [self.detaeldataBase executeUpdate:newdelete];
        
    }
    [self.detaeldataBase close];
    
}

// 根据Uid名查找数据库数据
-(NSMutableArray *)allUnitUidName:(NSString *)UidName
{

    NSMutableArray *stuArr=[NSMutableArray array];
    NSString *find = [NSString stringWithFormat:@"select * from Uni%ld",[UidName hash]];
     NSString *newfind =[find stringByReplacingOccurrencesOfString:@"-" withString:@"t"];
    if ([self.detaeldataBase open]) {
        FMResultSet *set = [self.detaeldataBase executeQuery:newfind];
        while ([set next]) {
            
            detaiModel *brief = [[detaiModel alloc]init];
            NSString *lesson_no = [set stringForColumn:@"lesson_no"];
            NSString *lesson_name = [set stringForColumn:@"lesson_name"];
            
            
            brief.lesson_no=lesson_no;
            brief.lesson_name=lesson_name;

            
            
            [stuArr addObject:brief];
        }
        
    }
    return stuArr;
    
    

}


//*********************************************************************************************************
// 创建数据库文件的
-(void)creatABJuanDataBaseUidName:(NSString *)UidName
{
    // 创建建立数据库的目标路径
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *dbPath = [document stringByAppendingPathComponent:@"ABDataBase.db"];
    
    NSLog(@"数据库的路径=%@",dbPath);
    
    self.ABdataBase = [FMDatabase databaseWithPath:dbPath];
    if ([self.ABdataBase open]) {
        
        NSString *Update=[NSString stringWithFormat:@"create table A%ld (lesson_no text, suit_no text,suit_name text)",[UidName hash]];
        NSString *newUpdata=[Update stringByReplacingOccurrencesOfString:@"-" withString:@"B"];
        
        [self.ABdataBase executeUpdate:newUpdata];
        
        [self.ABdataBase close];
    }

}

// 添加
-(void)addABJuanFromBriefAarray:(NSMutableArray *)briefArray UidName:(NSString *)UidName
{

    for (ABModel *brief in briefArray) {
        

        if ([self.ABdataBase open]) {
            
            NSString *path=[NSString stringWithFormat:@"insert into A%ld (lesson_no,suit_no,suit_name) values(?,?,?)",[UidName hash]];
            NSString *newPath=[path stringByReplacingOccurrencesOfString:@"-" withString:@"B"];
            
            [self.ABdataBase executeUpdate:newPath,brief.lesson_no,brief.suit_no,brief.suit_name];
            
        }
        [self.ABdataBase close];
    }

}

// 删除
-(void)deleteABJuanFromBriefUid:(NSString *)Uid
{
    
    NSString *delete = [NSString stringWithFormat:@"drop table A%ld",[Uid hash]];
     NSString *newdelete=[delete stringByReplacingOccurrencesOfString:@"-" withString:@"B"];
    if ([self.ABdataBase open]) {
        
        [self.ABdataBase executeUpdate:newdelete];
        
    }
    [self.ABdataBase close];

}

// 根据Uid名查找数据库数据
-(NSMutableArray *)allABJuanUidName:(NSString *)UidName
{

    NSMutableArray *stuArr=[NSMutableArray array];
    NSString *find = [NSString stringWithFormat:@"select * from A%ld",[UidName hash]];
     NSString *newfind=[find stringByReplacingOccurrencesOfString:@"-" withString:@"B"];
    if ([self.ABdataBase open]) {
        FMResultSet *set = [self.ABdataBase executeQuery:newfind];
        while ([set next]) {
            
            ABModel *ABbrief = [[ABModel alloc]init];
            NSString *lesson_no = [set stringForColumn:@"lesson_no"];
            NSString *suit_no = [set stringForColumn:@"suit_no"];
            NSString *suit_name = [set stringForColumn:@"suit_name"];
            
            ABbrief.lesson_no=lesson_no;
            ABbrief.suit_no=suit_no;
            ABbrief.suit_name=suit_name;
            
        
            [stuArr addObject:ABbrief];
        }
        
    }
    return stuArr;

}


//************************************************************************************************************
// 创建数据库文件的
-(void)creatVideoDataBaseUidName:(NSString *)UidName;
{
    // 创建建立数据库的目标路径
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *dbPath = [document stringByAppendingPathComponent:@"VideoDataBase.db"];
    
    NSLog(@"数据库的路径=%@",dbPath);
    
    self.videodataBase = [FMDatabase databaseWithPath:dbPath];
    if ([self.videodataBase open]) {
        
        NSString *Update=[NSString stringWithFormat:@"create table vide%ld (lesson_no text, suit_no text,lecture_no text,lecture_name text,lecture_image text,video_url text,lecture_uid text,lecture_images blob)",[UidName hash]];
        NSString *newUpdata=[Update stringByReplacingOccurrencesOfString:@"-" withString:@"o"];

        [self.videodataBase executeUpdate:newUpdata];
        
        [self.videodataBase close];
    }

}

-(void)addVideoFromBriefAarray:(NSMutableArray *)briefArray UidName:(NSString *)UidName
{
      if ([self.videodataBase open]) {
        for (videoModel *brief in briefArray) {
        
    
            NSData *lecture_images=UIImagePNGRepresentation(brief.lecture_images);
        
                
                
                NSString *path=[NSString stringWithFormat:@"insert into vide%ld (lesson_no,suit_no,lecture_no,lecture_name,lecture_image,video_url,lecture_uid,lecture_images) values(?,?,?,?,?,?,?,?)",[UidName hash]];
                NSString *newPath=[path stringByReplacingOccurrencesOfString:@"-" withString:@"o"];
                
                [self.videodataBase executeUpdate:newPath,brief.lesson_no,brief.suit_no,brief.lecture_no,brief.lecture_name,brief.lecture_image,brief.video_url,brief.lecture_uid,lecture_images];
                
            }
          
        }
     [self.videodataBase close];
}

 //添加
-(BOOL)addVideoFromDelegateAction:(id<DataBaseDelegate>)delegate BriefAarray:(NSMutableArray *)briefArray UidName:(NSString *)UidName
{
    self.delegate=delegate;
    self.numberProgress=1;
    self.progess=0;
    
    for (videoModel *brief in briefArray) {
        UIImageView *imageView=[[UIImageView alloc]init];
        
//        [imageView sd_setImageWithURL:[NSURL URLWithString:brief.lecture_image] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//      
//            brief.lecture_images=imageView.image;
//            NSData *lecture_images=UIImagePNGRepresentation(brief.lecture_images);
        //NSData *lecture_images=[NSData dataWithContentsOfURL:[NSURL URLWithString:brief.lecture_image]];
        
            
            if ([self.videodataBase open]) {
                
                
                NSString *path=[NSString stringWithFormat:@"insert into vide%ld (lesson_no,suit_no,lecture_no,lecture_name,lecture_image,video_url,lecture_uid,lecture_images) values(?,?,?,?,?,?,?,?)",[UidName hash]];
                NSString *newPath=[path stringByReplacingOccurrencesOfString:@"-" withString:@"o"];
                
                [self.videodataBase executeUpdate:newPath,brief.lesson_no,brief.suit_no,brief.lecture_no,brief.lecture_name,brief.lecture_image,brief.video_url,brief.lecture_uid,brief.lecture_images];
                
            }
            [self.videodataBase close];
        
//        //通知中心
//        NSNotificationCenter *notiCenter=[NSNotificationCenter defaultCenter];
//         self.progess=1.0*self.numberProgress/briefArray.count*0.9+0.15;
//        //参数1:通知的名字
//        //参数2:发送通知对象
//        //参数3:通知的内容(传值的内容)
//        NSString *progessStr=[NSString stringWithFormat:@"%lf",self.progess];
//        [notiCenter postNotificationName:@"progress" object:self userInfo:@{@"1":progessStr}];
//        self.numberProgress++;
      // }];
        
        //dispatch_async(dispatch_get_main_queue(), ^{
//        self.progess=1.0*self.numberProgress/briefArray.count*0.9+0.15;
//        if (self.delegate && [self.delegate respondsToSelector:@selector(passProgess:)]) {
//            
//            [self.delegate passProgess:self.progess];
//        }
//        
//        self.numberProgress++;
       //});
   }
    return YES;

}

// 删除
-(void)deleteVideoFromBriefUid:(NSString *)Uid
{
    
    NSString *delete = [NSString stringWithFormat:@"drop table vide%ld",[Uid hash]];
    NSString *newdelete=[delete stringByReplacingOccurrencesOfString:@"-" withString:@"o"];
    if ([self.videodataBase open]) {
        
        [self.videodataBase executeUpdate:newdelete];
        
    }
    [self.videodataBase close];
    
}

// 根据Uid名查找数据库数据
-(NSMutableArray *)allVideoUidName:(NSString *)UidName
{
    
    NSMutableArray *stuArr=[NSMutableArray array];
    NSString *find= [NSString stringWithFormat:@"select * from vide%ld",[UidName hash]];
     NSString *newfind=[find stringByReplacingOccurrencesOfString:@"-" withString:@"o"];
    if ([self.videodataBase open]) {
        FMResultSet *set = [self.videodataBase executeQuery:newfind];
        while ([set next]) {
            
            videoModel *brief = [[videoModel alloc]init];
            NSString *lesson_no = [set stringForColumn:@"lesson_no"];
            NSString *suit_no = [set stringForColumn:@"suit_no"];
            NSString *lecture_no = [set stringForColumn:@"lecture_no"];
            NSString *lecture_name = [set stringForColumn:@"lecture_name"];
            NSString *lecture_image = [set stringForColumn:@"lecture_image"];
            NSString *video_url = [set stringForColumn:@"video_url"];
            NSString *lecture_uid = [set stringForColumn:@"lecture_uid"];
            
            NSData *imageData = [set dataForColumn:@"lecture_images"];
            UIImage *lecture_images=[[UIImage alloc]init];
            lecture_images=[UIImage imageWithData:imageData];
            
            brief.lesson_no=lesson_no;
            brief.suit_no=suit_no;
            brief.lecture_no=lecture_no;
            brief.lecture_name=lecture_name;
            brief.lecture_image=lecture_image;
            brief.video_url=video_url;
            brief.lecture_images=lecture_images;
            brief.lecture_uid=lecture_uid;
            
            [stuArr addObject:brief];
        }
        
    }
    return stuArr;

}



//***************************************************************************************************
// 创建数据库文件的
-(void)creatVideoPlayDataBaseUidName:(NSString *)UidName
{
    // 创建建立数据库的目标路径
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *dbPath = [document stringByAppendingPathComponent:@"VideoPlayDataBase.db"];
    
    NSLog(@"数据库的路径=%@",dbPath);
    
    self.videoPlaydataBase = [FMDatabase databaseWithPath:dbPath];
    if ([self.videoPlaydataBase open]) {
        
        NSString *Update=[NSString stringWithFormat:@"create table videoPla%ld (video_url text,video_url_play blob)",[UidName hash]];
        NSString *newUpdata=[Update stringByReplacingOccurrencesOfString:@"-" withString:@"y"];
        
        [self.videoPlaydataBase executeUpdate:newUpdata];
        
        [self.videoPlaydataBase close];
    }

}

// 添加
-(void)addVideoPlayFromBrief:(playVideoModel *)brief UidName:(NSString *)UidName
{
    
        if ([self.videoPlaydataBase open]) {

            
            NSString *path=[NSString stringWithFormat:@"insert into videoPla%ld (video_url,video_url_play) values(?,?)",[UidName hash]];
            NSString *newPath=[path stringByReplacingOccurrencesOfString:@"-" withString:@"y"];
            
            [self.videoPlaydataBase executeUpdate:newPath,brief.video_url,brief.video_url_play];
            
        }
        [self.videoPlaydataBase close];
    
    
}

// 删除
-(void)deleteVideoPlayFromBriefUid:(NSString *)Uid
{
    
    NSString *delete= [NSString stringWithFormat:@"drop table videoPla%ld",[Uid hash]];
     NSString *newdelete=[delete stringByReplacingOccurrencesOfString:@"-" withString:@"y"];
    
    if ([self.videoPlaydataBase open]) {
        
        [self.videoPlaydataBase executeUpdate:newdelete];
        
    }
    [self.videoPlaydataBase close];

}

// 根据Uid名查找数据库数据
-(playVideoModel *)allVideoPlayUidName:(NSString *)UidName url:(NSString *)url
{

    
    playVideoModel *brief = [[playVideoModel alloc]init];
    NSString *find= [NSString stringWithFormat:@"select * from videoPla%ld where video_url like '%@'",[UidName hash],url];
    
    NSString *newfind=[find stringByReplacingOccurrencesOfString:@"-" withString:@"y"];
    
    if ([self.videoPlaydataBase open]) {
        
        
        FMResultSet *set = [self.videoPlaydataBase executeQuery:newfind];
        while ([set next]) {
            
           
            NSString *video_url = [set stringForColumn:@"video_url"];
            NSData *video_url_play = [set dataForColumn:@"video_url_play"];
            
            
            brief.video_url=video_url;
            brief.video_url_play=video_url_play;
            
        }
        
    }

    return brief;
}



@end
