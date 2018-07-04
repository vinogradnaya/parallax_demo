//
//  KVHTTPClient.m
//  KVParallaxDemo
//
//  Created by Katerina Vinogradnaya on 1/27/15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import "KVHTTPClient.h"
#import "KVImageCache.h"

static NSString *const kKVErrorDomain = @"com.kv.parallax";

@interface KVHTTPClient ()
@property (strong, nonatomic) NSURLSession *session;
@property (copy, nonatomic) NSString *baseURL;
@end

@implementation KVHTTPClient

#pragma mark - Initialization

- (instancetype)initWithBaseURL:(NSString *)baseURL
{
    self = [super init];
    if (self) {
        self.baseURL = baseURL;
        [self createSession];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithBaseURL:nil];
}

#pragma mark - Instance Methods

- (void)getDataWithParameters:(NSDictionary *)parameters
                   completion:(KVHTTPClientCompletion)completion
{
    NSMutableURLRequest *request = [self requestWithHttpMethod:@"GET"
                                                    parameters:parameters];
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request
                                                    completion:completion];
    [dataTask resume];
}

#pragma mark - NSURLSession Tasks Creation

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                                completion:(KVHTTPClientCompletion)completion
{
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        if (!error) {
                            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *) response;
                            NSError *jsonError = nil;
                            
                            if (httpResp.statusCode == 200) {
                
                                NSDictionary *responseJSON =
                                [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&jsonError];
                                if (completion != nil) {
                                    completion(responseJSON, jsonError);
                                }
                            } else if (httpResp.statusCode > 200 && httpResp.statusCode < 300) {
                                if (completion != nil) {
                                    completion(nil, nil);
                                }
                            } else {
                                NSMutableDictionary* errorDetails = [NSMutableDictionary new];

                                NSString *errorDescription =
                                [NSString stringWithFormat:@"%@ returned status code %d", request.URL, (int)httpResp.statusCode];
                                
                                [errorDetails setValue:errorDescription
                                                forKey:NSLocalizedDescriptionKey];
                
                                NSDictionary* jsonFailureReason =
                                [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions
                                                                  error:&jsonError];
                
                                if (jsonFailureReason != nil) {
                                    NSString *failureReasonCode =
                                    [jsonFailureReason objectForKey:@"ErrorCode"];
                                    if (failureReasonCode != nil) {
                                        [errorDetails setValue:failureReasonCode
                                                        forKey:NSLocalizedFailureReasonErrorKey];
                                    }
                                }
                
                                NSError *responseError =
                                [NSError errorWithDomain:kKVErrorDomain
                                                    code:(int)httpResp.statusCode
                                                userInfo:errorDetails];
                
                                if (completion != nil) {
                                    completion(nil, responseError);
                                }
                            }
                        } else {
                            if (completion != nil) {
                                completion(nil, error);
                            }
                        }
                    }];
    
    return dataTask;
}

- (NSURLSessionDownloadTask *)downloadImageWithURL:(NSString *)urlString
                                        completion:(KVHTTPClientDownloadCompletion)completion
{
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        UIImage *downloadedImage = nil;
        if (!error) {
            NSData *downloadedData = [NSData dataWithContentsOfURL:location];
            downloadedImage = [UIImage imageWithData: downloadedData];
            [[KVImageCache sharedObject] registerImage:downloadedImage forURL:urlString];
        }

        if (completion) {
            completion (downloadedImage, response, error);
        }
    }];
    
    [downloadTask resume];
    
    return downloadTask;
}


#pragma mark - NSURLRequest Creation

- (NSMutableURLRequest *)requestWithHttpMethod:(NSString *)httpMethod
                                    parameters:(NSDictionary *)parameters
{
    NSMutableString *finalURLString =
    [NSMutableString stringWithFormat:@"%@://%@", @"https", self.baseURL];
    
    NSURL *requestURL = nil;
    
    if ([parameters count] > 0) {
        NSString *stringFromParams = [self queryStringFromParameters:parameters];
        finalURLString = [NSMutableString stringWithFormat:@"%@%@", finalURLString, stringFromParams];
    }
    
    requestURL = [NSURL URLWithString:finalURLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    
    [request setHTTPMethod:httpMethod];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return request;
}

#pragma mark - Session Creation

- (void)createSession
{
    NSURLSessionConfiguration *configuration =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configuration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    self.session = [NSURLSession sessionWithConfiguration:configuration
                                             delegate:nil
                                        delegateQueue:nil];
}

#pragma mark - Utils

- (NSString *)queryStringFromParameters:(NSDictionary *)dictionary
{
    NSMutableString *urlWithQuerystring = [NSMutableString new];
    
    for (id key in dictionary) {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        
        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        } else {
            [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
    }
    return urlWithQuerystring;
}

- (NSString *)urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}

@end
