//
//  KVFlickrPhoto.m
//  KVParallaxDemo
//
//  Created by Katerina Vinogradnaya on 1/27/15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import "KVFlickrPhoto.h"

@implementation KVFlickrPhoto

+ (instancetype)photoFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }
    
    KVFlickrPhoto *photo = [KVFlickrPhoto new];
    
    NSNumber *farm = dictionary[@"farm"];
    NSNumber *photoId = dictionary[@"id"];
    NSNumber *secret = dictionary[@"secret"];
    NSNumber *server = dictionary[@"server"];

    photo.photoURL = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@.jpg", farm, server, photoId, secret];
    
    photo.title = dictionary[@"title"];
    
    return photo;
}

@end
