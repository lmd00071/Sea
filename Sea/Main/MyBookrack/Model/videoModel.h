//
//  videoModel.h
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/1/19.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface videoModel : NSObject

@property (nonatomic,strong)NSString *lesson_no;
@property (nonatomic,strong)NSString *suit_no;
@property (nonatomic,strong)NSString *lecture_no;
@property (nonatomic,strong)NSString *lecture_name;
@property (nonatomic,strong)NSString *lecture_image;
@property (nonatomic,strong)NSString *video_url;
@property (nonatomic,strong)NSString *lecture_uid;
@property (nonatomic,strong)UIImage *lecture_images;


@end
