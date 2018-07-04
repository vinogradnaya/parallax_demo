//
//  KVImageView.m
//  KVParallaxDemo
//
//  Created by Katerina Vinogradnaya on 1/27/15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import "KVImageView.h"
#import "KVAPoDClient.h"
#import "KVImageCache.h"

@interface KVImageView ()
@property (strong, nonatomic) NSURLSessionDownloadTask *task;
@property (copy, nonatomic) NSString *urlString;
@end

@implementation KVImageView

- (void)setImageWithURL:(NSString *)urlString
{
    UIImage *cachedImage = [[KVImageCache sharedObject] imageForURL:urlString];
    if (cachedImage) {
        self.image = cachedImage;
        return;
    }

    if (self.task.state == NSURLSessionTaskStateRunning) {
        [self.task cancel];
    }
    
    self.urlString = urlString;
    
    if (urlString) {
        __weak typeof(self) weakSelf = self;
        
        self.task = [[KVAPoDClient sharedClient] downloadImageWithURL:urlString completion:^(id responseObject, NSURLResponse *response, NSError *error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([strongSelf.urlString isEqualToString:[response.URL absoluteString]]) {
                        strongSelf.image = responseObject;
                        
                        CATransition *transition = [CATransition animation];
                        transition.duration = .6f;
                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                        transition.type = kCATransitionFade;
                        [strongSelf.layer addAnimation:transition forKey:nil];
                        
                    }
                });
            }

        }];
    }
}

@end
