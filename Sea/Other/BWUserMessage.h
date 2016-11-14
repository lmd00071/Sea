//
//  BWUserMessage.h
//  WidomStudy
//
//  Created by 李明丹 on 16/1/21.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWUserMessage : NSObject

@property (nonatomic, copy) NSString *user_account_uid;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *photo_icon_url;

@property (nonatomic, copy) NSString *photo_raw_url;

@property (nonatomic, copy) NSString *school_id;

@property (nonatomic, copy) NSString *school_name;

@property (nonatomic, copy) NSString *dept_id;

@property (nonatomic, copy) NSString *dept_name;

@property (nonatomic, copy) NSString *user_contact_phone;

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *teach_course_id;

@property (nonatomic, copy) NSString *teach_course_name;

@property (nonatomic, copy) NSString *asaf_token;

@end
