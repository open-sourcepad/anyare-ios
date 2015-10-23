//
//  MapViewController.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "Mapbox.h"

@interface MapViewController () <MGLMapViewDelegate>
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (nonatomic) MGLMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.navigationItem.title = @"Map";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // initialize the map view
    [self.view addSubview:self.mapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessor
- (MGLMapView *)mapView {
    if(!_mapView) {
        _mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
//    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds
//                                            styleURL:[NSURL URLWithString:@"asset://styles/dark-v8.json"]];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate = self;
    }
    return _mapView;
}

#pragma mark - MGLMapView Delegate
// Always show a callout when an annotation is tapped.
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    return YES;
}

#pragma mark - Public
- (void)reloadMap
{
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(38.894368, -77.036487);
    //CLLocationCoordinate2DMake(_appDelegate.currentLocationCoordinate.x, _appDelegate.currentLocationCoordinate.y);
    // set the map's center coordinate
    [_mapView setCenterCoordinate:locationCoordinate
                            zoomLevel:15
                             animated:NO];
    
    
    // Declare the annotation `point` and set its coordinates, title, and subtitle
    MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
    point.coordinate = locationCoordinate;
    point.title = @"Hello world!";
    point.subtitle = @"Welcome to The Ellipse.";
    [_mapView addAnnotation:point];
}


@end
