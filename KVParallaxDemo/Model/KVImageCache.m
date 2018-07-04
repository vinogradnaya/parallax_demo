//
//  KVImageCache.m
//  KVParallaxDemo
//
//  Created by Katerina Vinogradnaya on 1/27/15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import "KVImageCache.h"

@interface KVImageCache ()
@property (strong, nonatomic) NSCache *defaultImageCache;
@end

@implementation KVImageCache

+ (instancetype)sharedObject
{
    static KVImageCache *sImageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sImageCache = [KVImageCache new];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * __unused notification) {
                                                          [sImageCache clearCache];
                                                      }];
    });
    return sImageCache;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaultImageCache = [NSCache new];
    }
    return self;
}

- (void)dealloc
{
    [self clearCache];
}

- (void)clearCache
{
    [self.defaultImageCache removeAllObjects];
}

- (UIImage *)imageForURL:(NSString *)URLString
{
    if (!URLString) {
        return nil;
    }

    UIImage *image = [self.defaultImageCache objectForKey:URLString];
    return image;
}

-(void)registerImage:(UIImage *)image
              forURL:(NSString *)URLString
{
    
    if (!image || !URLString) {
        return;
    }
    
    [self.defaultImageCache setObject:image forKey:URLString];
}

@end
