//
//  NSStack.m
//  demo2
//
//  Created by 李明丹 on 16/1/5.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "NSStack.h"

@implementation NSStack

- (id) init {
    self = [super init];
    if (self) {
        _stackArray = [[NSMutableArray alloc] init];
    }
    return self;
}
/**
 * @desc judge whether the stack is empty
 *
 * @return TRUE if stack is empty, otherwise FALASE is returned
 */
- (BOOL) empty {
    return ((_stackArray == nil)||([_stackArray count] == 0));
}
/**
 * @desc get top object in the stack
 *
 * @return nil if no object in the stack, otherwise an object
 * is returned, user should judge the return by this method
 */
- (id) top {
    id value = nil;
    if (_stackArray&&[_stackArray count])
    {
        value = [_stackArray lastObject];
    }
    return value;
}
/**
 * @desc pop stack top object
 */
- (void) pop {
    if (_stackArray&&[_stackArray count])
    {
        [_stackArray removeLastObject];
    }
}
/**
 * @desc push an object to the stack
 */
- (void) push:(id)value {
    [_stackArray addObject:value];
}

@end
