//
//  pictureViewController.h
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/5/30.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pictureViewController : UIViewController

@property (nonatomic, strong) NSArray *picUrlArray;
@property (nonatomic, assign) NSInteger index;
- (void)setArray:(NSMutableArray *)newsPicArray;

@end
