//
//  userBookModel.h
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/1/19.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface userBookModel : NSObject

@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *textbook_name;
@property (nonatomic,strong)NSString *grade_order_no;
@property (nonatomic,strong)NSString *grade_half_order_no;
@property (nonatomic,strong)NSString *text_book_uid;
@property (nonatomic,strong)NSString *course_id;
@property (nonatomic,strong)NSString *course_name;
@property (nonatomic,strong)NSString *lecture_cnt;
@property (nonatomic,strong)NSString *modify_time;
@property (nonatomic,strong)UIImage *iconImage;



@end
