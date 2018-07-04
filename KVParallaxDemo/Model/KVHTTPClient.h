//
//  KVHTTPClient.h
//  KVParallaxDemo
//
//  Created by Katerina Vinogradnaya on 1/27/15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KVHTTPClientCompletion)(id responseObject, NSError *error);
typedef void(^KVHTTPClientDownloadCompletion)(UIImage *downloadedImage, NSURLResponse *response,  NSError *error);

@interface KVHTTPClient : NSObject
- (instancetype)initWithBaseURL:(NSString *)baseURL;
- (void)getDataWithParameters:(NSDictionary *)parameters
                   completion:(KVHTTPClientCompletion)completion;
- (NSURLSessionDownloadTask *)downloadImageWithURL:(NSString *)url
                                        completion:(KVHTTPClientDownloadCompletion)completion;
@end
