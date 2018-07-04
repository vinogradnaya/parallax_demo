//
//  KVAPoDClient.m
//  KVParallaxDemo
//
//  Created by keksiy on 19.09.15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import "KVAPoDClient.h"
#import "KVHTTPClient.h"

static NSString *const kKVBaseURL = @"api.flickr.com/services/rest/";

@interface KVAPoDClient ()
@end

@implementation KVAPoDClient

#pragma mark - Class Methods

+ (instancetype)sharedClient
{
    static KVAPoDClient *sHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{
                      sHTTPClient = [[KVAPoDClient alloc] initWithBaseURL:kKVBaseURL];
                  });

    return sHTTPClient;
}

- (void)getFlickrDataWithParameters:(NSDictionary *)parameters
                         completion:(KVHTTPClientCompletion)completion {
    [self getDataWithParameters:parameters
                     completion:completion];
}



@end
