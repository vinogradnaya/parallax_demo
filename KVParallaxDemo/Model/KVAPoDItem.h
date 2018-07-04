//
//  KVAPoDItem.h
//  KVParallaxDemo
//
//  Created by keksiy on 19.09.15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVAPoDItem : NSObject
@property (copy, nonatomic) NSString *photoURL;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *capture;

+ (instancetype)itemFromDictionary:(NSDictionary *)dictionary;

@end
