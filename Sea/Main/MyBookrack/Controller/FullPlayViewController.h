//
//  FullPlayViewController.h
//  WidomStudy
//
//  Created by 李明丹 on 16/4/25.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPlayer.h"

@protocol FullPlayViewControllerDelegate<NSObject>

- (void)fullPlayViewControllerSendWatchSecond:(NSInteger )watchSecond;
@end

@interface FullPlayViewController : UIViewController
@property (nonatomic,strong)NSString *URLString;
@property (nonatomic,strong)UIImage *mp3image;

@property (nonatomic,strong)NSString *lesson_uid;

@property (nonatomic,copy)void(^watchBlock)(NSInteger,NSString *);

@end
