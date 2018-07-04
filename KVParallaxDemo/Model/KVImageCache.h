//
//  KVImageCache.h
//  KVParallaxDemo
//
//  Created by Katerina Vinogradnaya on 1/27/15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KVImageCache : NSObject

+ (instancetype)sharedObject;
- (UIImage *)imageForURL:(NSString *)URLString;
- (void)registerImage:(UIImage *)image forURL:(NSString *)URLString;
@end
