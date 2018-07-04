//
//  KVFlickrPhoto.h
//  KVParallaxDemo
//
//  Created by Katerina Vinogradnaya on 1/27/15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVFlickrPhoto : NSObject
@property (copy, nonatomic) NSString *photoURL;
@property (copy, nonatomic) NSString *title;

+ (instancetype)photoFromDictionary:(NSDictionary *)dictionary;
@end
