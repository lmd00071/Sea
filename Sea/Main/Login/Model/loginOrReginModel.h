//
//  loginOrReginModel.h
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/1/27.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface loginOrReginModel : NSObject

@property (nonatomic,strong)NSString *error_code;
@property (nonatomic,strong)NSString *error_string;
@property (nonatomic,strong)NSString *register_result_msg;
@property (nonatomic,strong)NSString *login_result_msg;
@property (nonatomic,strong)NSString *user_account_uid;
@property (nonatomic,strong)NSString *user_name;
@property (nonatomic,strong)NSString *user_msisdn;
@property (nonatomic,strong)NSString *photo_icon_url;
@property (nonatomic,strong)NSString *photo_raw_url;
@end
