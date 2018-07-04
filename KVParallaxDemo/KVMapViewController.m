//
//  KVMapViewController.m
//  CWCodingTask
//
//  Created by Katerina Vinogradnaya on 1/27/15.
//  Copyright (c) 2015 KV. All rights reserved.
//

#import "KVMapViewController.h"
#import <MapKit/MapKit.h>

static const CLLocationDistance kKVZoomDistance = 5000;

@interface KVMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation KVMapViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setUpMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mak - Setting Up Map

- (void)setUpMap
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 49.128584;
    coordinate.longitude= 20.221785;

    [self addRegionWithCoordinate:coordinate];
    [self addPinWithCoordinate:coordinate];
}

- (void)addRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, kKVZoomDistance, kKVZoomDistance);
    
    [self.mapView setRegion:viewRegion animated:YES];

}

- (void)addPinWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:@"Title"];
    [self.mapView addAnnotation:annotation];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
