//
//  KVAPoDClient.h
//  KVParallaxDemo
//
//  Created by keksiy on 19.09.15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import "KVHTTPClient.h"

@interface KVAPoDClient : KVHTTPClient
+ (instancetype)sharedClient;
- (void)getFlickrDataWithParameters:(NSDictionary *)parameters
                         completion:(KVHTTPClientCompletion)completion;
@end
