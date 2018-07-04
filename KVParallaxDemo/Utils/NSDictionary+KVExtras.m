//
//  NSDictionary+KVExtras.m
//  KVParallaxDemo
//
//  Created by keksiy on 19.09.15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import "NSDictionary+KVExtras.h"

@implementation NSDictionary (KVExtras)
- (id)objectNotNullForKey:(id)key
{
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;

    return object;
}
@end
