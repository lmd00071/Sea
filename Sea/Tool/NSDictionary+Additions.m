//
//  NSDictionary+Additions.m
//  demo2
//
//  Created by 李明丹 on 16/1/5.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import "NSDictionary+Additions.h"

#import "NSStack.h"

@implementation NSDictionary (Additions)

- (NSArray*) toArray {
    NSMutableArray *entities = [[NSMutableArray alloc] initWithCapacity:[self count]];
    NSEnumerator *enumerator = [self objectEnumerator];
    id value;
    
    while ((value = [enumerator nextObject])) {
        /* code that acts on the dictionary‚Äôs values */
        [entities addObject:value];
    }
    return entities;
}
- (NSString*) newXMLString {
    NSMutableString *xmlString = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
    [xmlString appendString:@"<infobus>"];
    NSStack *stack = [[NSStack alloc] init];
    NSArray  *keys = nil;
    NSString *key  = nil;
    NSObject *value    = nil;
    NSObject *subvalue = nil;
    NSInteger size = 0;
    [stack push:self];
    while (![stack empty]) {
        value = [stack top];
        [stack pop];
        if (value) {
            if ([value isKindOfClass:[NSString class]]) {
                [xmlString appendFormat:@"</%@>", value];
            }
            else if([value isKindOfClass:[NSDictionary class]])
            {
                keys = [(NSDictionary*)value allKeys];
                size = [(NSDictionary*)value count];
                for (key in keys) {
                    subvalue = [(NSDictionary*)value objectForKey:key];
                    if ([subvalue isKindOfClass:[NSDictionary class]]) {
                        [xmlString appendFormat:@"<%@>", key];
                        [stack push:key];
                        [stack push:subvalue];
                    }
                    else if([subvalue isKindOfClass:[NSString class]])
                    {
                        [xmlString appendFormat:@"<%@>%@</%@>", key, subvalue, key];
                    }
                }
            }            
        }       
    }
    [xmlString appendString:@"</infobus>"];
    return xmlString;
}

- (NSString*) newUpDataXMLString{
    NSMutableString *xmlString = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
    [xmlString appendString:@"<infobus>"];
    NSStack *stack = [[NSStack alloc] init];
    NSArray  *keys = nil;
    NSString *key  = nil;
    NSObject *value    = nil;
    NSObject *subvalue = nil;
    NSInteger size = 0;
    [stack push:self];
    while (![stack empty]) {
        value = [stack top];
        [stack pop];
        if (value) {
            
            if ([value isKindOfClass:[NSString class]]) {
                [xmlString appendFormat:@"</%@>", value];
            }
            else if([value isKindOfClass:[NSDictionary class]])
            {
                keys = [(NSDictionary*)value allKeys];
                size = [(NSDictionary*)value count];
                for (key in keys) {
                    subvalue = [(NSDictionary*)value objectForKey:key];
                    if ([subvalue isKindOfClass:[NSDictionary class]]) {
                        [xmlString appendFormat:@"<%@>", key];
                        [stack push:key];
                        [stack push:subvalue];
                    }
                    else if([subvalue isKindOfClass:[NSString class]])
                    {
                        [xmlString appendFormat:@"<%@>%@</%@>", key, subvalue, key];
                    }
                }
            }
        }
      
    }
    [xmlString appendString:@"</infobus>"];
    return xmlString;

}


@end
