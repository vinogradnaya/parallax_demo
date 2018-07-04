//
//  ViewController.m
//  KVParallaxDemo
//
//  Created by Katerina Vinogradnaya on 2/9/15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import "KVParallaxViewController.h"
#import "KVAPoDClient.h"
#import "KVFlickrPhoto.h"
#import "KVTableViewCell.h"

static NSString *const kKVFlickPhotoCellIdentifier = @"flickrPhotoCell";

@interface KVParallaxViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (assign, nonatomic) NSInteger currentPage;
@end

@implementation KVParallaxViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photos = [NSMutableArray new];
    self.currentPage = 1;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KVTableViewCell class]) bundle:nil] forCellReuseIdentifier:kKVFlickPhotoCellIdentifier];
    self.tableView.separatorColor = [UIColor clearColor];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.hidden = YES;
    [self.view addSubview:activityIndicator];
    self.activityIndicator = activityIndicator;
    
    [self getPhotosForPage:self.currentPage];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.rowHeight = self.tableView.bounds.size.height;
    self.activityIndicator.center = self.tableView.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (KVTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.photos count] - 1) {
        [self getPhotosForPage:++self.currentPage];
    }
    
    KVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kKVFlickPhotoCellIdentifier forIndexPath:indexPath];
    cell.photo = self.photos[indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray *visibleCells = [self.tableView visibleCells];
    
    for (KVTableViewCell *cell in visibleCells) {
        [cell cellOnTableView:self.tableView didScrollOnView:self.view];
    }
}

#pragma mark - Getting Flickr Data

- (void)getPhotosForPage:(NSInteger)page
{
    [self showActivityIndicator];
    
    [self.parameters setObject:@(page) forKey:@"page"];
    
    [[KVAPoDClient sharedClient] getFlickrDataWithParameters:self.parameters
                                                  completion:^(id responseObject, NSError *error) {
                                                      NSArray *jsonPhotos = responseObject[@"photos"][@"photo"];
                                                      if (jsonPhotos) {
                                                          [self updateTableViewWithPhotos:jsonPhotos];
                                                      }
                                                  }];
}

- (void)updateTableViewWithPhotos:(NSArray *)jsonPhotos
{
    NSInteger previousPhotoCount = [self.photos count];
    [self.photos addObjectsFromArray:[self photosFromJSON:jsonPhotos]];
    NSInteger nextPhotoCount = [self.photos count];
    
    NSMutableArray *indexPathsArray = [NSMutableArray array];
    for (NSInteger i = previousPhotoCount; i < nextPhotoCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathsArray addObject:indexPath];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self downloadPhotosFromIndex:previousPhotoCount toIndex:nextPhotoCount completion:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView beginUpdates];
            [strongSelf.tableView insertRowsAtIndexPaths:indexPathsArray
                                        withRowAnimation:UITableViewRowAnimationFade];
            [strongSelf.tableView endUpdates];
            [strongSelf hideActivityIndicator];
        });
    }];
}

- (void)downloadPhotosFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex completion:(void (^)(void))completion
{
    dispatch_group_t downloadGroup = dispatch_group_create();
    
    for (NSInteger i = fromIndex; i < toIndex; i++) {
        NSString *urlString = ((KVFlickrPhoto *)self.photos[i]).photoURL;
        
        dispatch_group_enter(downloadGroup);
        
        [[KVAPoDClient sharedClient] downloadImageWithURL:urlString completion:^(UIImage *downloadedImage, NSURLResponse *response, NSError *error) {
            dispatch_group_leave(downloadGroup);
        }];
    }
    
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{ // 4
        if (completion) {
            completion ();
        }
    });
}

- (NSMutableArray *)photosFromJSON:(NSArray *)jsonPhotos
{
    NSMutableArray *photos = [NSMutableArray new];
    
    for (NSDictionary *photoDictionary in jsonPhotos) {
        KVFlickrPhoto *photo = [KVFlickrPhoto photoFromDictionary:photoDictionary];
        if (photo) {
            [photos addObject:photo];
        }
    }
    
    return photos;
}

#pragma mark - Activity Indicator

- (void)showActivityIndicator
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.tableView.userInteractionEnabled = NO;
}

- (void)hideActivityIndicator
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.tableView.userInteractionEnabled = YES;
}

#pragma mark - Properties

- (NSMutableDictionary *)parameters
{
    if (_parameters != nil) {
        return _parameters;
    }
    
    NSDictionary *defaultParams = @{@"method" : @"flickr.photos.search",
                                    @"api_key" : @"5a1ff9ce8517fbf486de1acc6efba246",
                                    @"text" : @"nature",
                                    @"format" : @"json",
                                    @"nojsoncallback" : @"1",
                                    @"per_page" : @(10)};
    
    
    _parameters = [[NSMutableDictionary alloc] initWithDictionary:defaultParams];
    return _parameters;
}

@end
