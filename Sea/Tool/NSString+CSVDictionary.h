//
//  NSString+CSVDictionary.h
//  demo2
//
//  Created by 李明丹 on 16/1/8.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CSVDictionary)

- (NSArray <NSDictionary *>*)csvStringTransformToDictionary;

- (UIColor *)hexadecimalStringToColor;

@end
