//
//  dataModel.h
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/6/1.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataModel : NSObject
@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *book_name;
@property (nonatomic,strong)NSString *book_desc;
@property (nonatomic,strong)NSString *book_prices;
@property (nonatomic,strong)NSString *book_uid;
@property (nonatomic,strong)NSString *is_hot;
@property (nonatomic,strong)NSString *discount_yp;
@property (nonatomic,strong)NSString *discount_price;
@property (nonatomic,strong)NSString *cmd;
@property (nonatomic,strong)NSString *action;
@property (nonatomic,strong)NSString *action_parameter;

@end
