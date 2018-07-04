//
//  KVTableViewCell.h
//  KVParallaxDemo
//
//  Created by Katerina Vinogradnaya on 2/8/15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KVFlickrPhoto.h"

@interface KVTableViewCell : UITableViewCell
@property (strong, nonatomic) KVFlickrPhoto *photo;
- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;
@end
