//
//  KVTableViewCell.m
//  KVParallaxDemo
//
//  Created by Katerina Vinogradnaya on 2/8/15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import "KVTableViewCell.h"
#import "KVImageView.h"

static const CGFloat kKVGradientSize = 60.f;
static const CGFloat kKVGradientOpacity = .7f;

@interface KVTableViewCell ()
@property (weak, nonatomic) IBOutlet KVImageView *photoView;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeightConstraint;
@end

@implementation KVTableViewCell

- (void)awakeFromNib
{
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.photoView.clipsToBounds = YES;
    
    CAGradientLayer *topGradient = [CAGradientLayer layer];
    topGradient.frame = CGRectMake(0, 0, screenSize.width, kKVGradientSize);
    topGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    topGradient.opacity = kKVGradientOpacity;
    [self.contentView.layer insertSublayer:topGradient above:self.photoView.layer];
    
    CAGradientLayer *bottomGradient = [CAGradientLayer layer];
    bottomGradient.frame = CGRectMake(0, -kKVGradientSize, screenSize.width, kKVGradientSize);
    bottomGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    bottomGradient.opacity = kKVGradientOpacity;
    [self.textView.layer insertSublayer:bottomGradient atIndex:0];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.photo = nil;
    self.photoView.image = nil;
    self.titleLabel.text = nil;
}

- (void)setPhoto:(KVFlickrPhoto *)photo
{
    if (_photo != photo) {
        _photo = photo;
        
        [self.photoView setImageWithURL:_photo.photoURL];
        self.titleLabel.text = _photo.title;
    }
}

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view
{
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    self.photoViewTopConstraint.constant = -rectInSuperview.origin.y/1.5;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.photoViewHeightConstraint.constant = self.contentView.bounds.size.height;
    self.photoViewWidthConstraint.constant = self.contentView.bounds.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
