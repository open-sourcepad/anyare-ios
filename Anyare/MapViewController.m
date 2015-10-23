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
#import "PostController.h"
#import "UserDM.h"

@interface MapViewController () <MGLMapViewDelegate, PostControllerDelegate>
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) BOOL hasLoadedMap;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.navTitle = @"Map";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessor
- (MGLMapView *)mapView {
    if(!_mapView) {
        //_mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
        _mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds
                                            styleURL:[NSURL URLWithString:@"asset://styles/dark-v8.json"]];
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
//    [PostController getPostsInLocationWithDelegate:self
//                                          location:_appDelegate.currentLocationCoordinate
//                                         authToken:_appDelegate.currentUser.authenticationToken];
    
    _hasLoadedMap = YES;
    [self.view addSubview:self.mapView];
    
    NSLog(@"Load map: %f, %f", _appDelegate.currentLocationCoordinate.x, _appDelegate.currentLocationCoordinate.y);
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(_appDelegate.currentLocationCoordinate.x, _appDelegate.currentLocationCoordinate.y);
    [_mapView setCenterCoordinate:locationCoordinate
                        zoomLevel:15
                         animated:YES];
    
    // Declare the annotation `point` and set its coordinates, title, and subtitle
    MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
    point.coordinate = locationCoordinate;
    point.title = @"Hello world!";
    point.subtitle = @"Welcome to The Ellipse.";

    [_mapView addAnnotation:point];
    
    [self.view bringSubviewToFront:_mapView];
    [self.view bringSubviewToFront:self.postButton];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"pisa"];
    
    if ( ! annotationImage)
    {
        // Leaning Tower of Pisa by Stefan Spieler from the Noun Project
        UIImage *image = [UIImage imageNamed:@"fire-pin"];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"pisa"];
    }
    
    return annotationImage;
}

#pragma mark - Post Controller delegate
- (void)getPostsDidFinish:(PostController *)controller resultDict:(NSDictionary *)resultDict
{
//    // Load all markers
//    
//    _hasLoadedMap = YES;
//    [self.view addSubview:self.mapView];
//    
//    NSLog(@"Load map: %f, %f", _appDelegate.currentLocationCoordinate.x, _appDelegate.currentLocationCoordinate.y);
//    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(_appDelegate.currentLocationCoordinate.x, _appDelegate.currentLocationCoordinate.y);
//    [_mapView setCenterCoordinate:locationCoordinate
//                        zoomLevel:15
//                         animated:YES];
//    
//    // Declare the annotation `point` and set its coordinates, title, and subtitle
//    MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
//    point.coordinate = locationCoordinate;
//    point.title = @"Hello world!";
//    point.subtitle = @"Welcome to The Ellipse.";
//    [_mapView addAnnotation:point];
//    
//    [self.view bringSubviewToFront:_mapView];
//    [self.view bringSubviewToFront:self.postButton];
}

@end
