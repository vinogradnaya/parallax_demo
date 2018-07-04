//
//  KVAPoDItem.m
//  KVParallaxDemo
//
//  Created by keksiy on 19.09.15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import "KVAPoDItem.h"

@implementation KVAPoDItem

+ (instancetype)itemFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }

    KVAPoDItem *photo = [KVAPoDItem new];

    NSNumber *farm = dictionary[@"farm"];
    NSNumber *photoId = dictionary[@"id"];
    NSNumber *secret = dictionary[@"secret"];
    NSNumber *server = dictionary[@"server"];

    photo.photoURL = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@.jpg", farm, server, photoId, secret];

    photo.title = dictionary[@"title"];

    return photo;
}
@end
