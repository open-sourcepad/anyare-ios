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
#import "Constants.h"
#import "UserDM.h"
#import "PostDM.h"

@interface MapViewController () <MGLMapViewDelegate, PostControllerDelegate>
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (nonatomic) MGLMapView *mapView;
@property (strong, nonatomic) NSMutableArray *pins;
@property (nonatomic) CGPoint currentPoint;
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
//- (void)reloadMap
//{
//    [PostController getPostsInLocationWithDelegate:self
//                                          location:_appDelegate.currentLocationCoordinate
//                                         authToken:_appDelegate.currentUser.authenticationToken];
//}

- (void)reloadMapAt:(CGPoint)point
{
    _currentPoint = point;
    [PostController getPostsInLocationWithDelegate:self
                                          location:point
                                         authToken:_appDelegate.currentUser.authenticationToken];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    NSString *category = annotation.subtitle;
    MGLAnnotationImage *annotationImage;
    UIImage *image;
    
    if ([category isEqualToString:CATEGORY_FIRE]) {
        image = [UIImage imageNamed:@"fire-pin"];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:CATEGORY_FIRE];
    }
    else if ([category isEqualToString:CATEGORY_FLOOD]) {
        image = [UIImage imageNamed:@"flood-pin"];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:CATEGORY_FLOOD];
    }
    else if ([category isEqualToString:CATEGORY_THEFT]) {
        image = [UIImage imageNamed:@"theft-pin"];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:CATEGORY_THEFT];
    }
    else if ([category isEqualToString:CATEGORY_ACCIDENT]) {
        image = [UIImage imageNamed:@"accident-pin"];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:CATEGORY_ACCIDENT];
    }
    else if ([category isEqualToString:CATEGORY_ROAD]) {
        image = [UIImage imageNamed:@"road-pin"];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:CATEGORY_ROAD];
    }
    else if ([category isEqualToString:CATEGORY_WATERWORKS]) {
        image = [UIImage imageNamed:@"waterworks-pin"];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:CATEGORY_WATERWORKS];
    }
    else if ([category isEqualToString:CATEGORY_ASSAULT]) {
        image = [UIImage imageNamed:@"assault-pin"];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:CATEGORY_ASSAULT];
    }
    else if ([category isEqualToString:CATEGORY_VANDALISM]) {
        image = [UIImage imageNamed:@"vandalism-pin"];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:CATEGORY_VANDALISM];
    }
    else if ([category isEqualToString:CATEGORY_DRUGS]) {
        image = [UIImage imageNamed:@"drugs-pin"];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:CATEGORY_DRUGS];
    }
    
    return annotationImage;
}

- (void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    // Remove all annotations
    //[mapView removeAnnotations:mapView.annotations];
    
    NSLog(@"Current point (%f,%f)", _currentPoint.x, _currentPoint.y);
    NSLog(@"Region did change (%f,%f)", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
    CGPoint newPoint = CGPointMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);

    //if(_currentPoint.x != newPoint.x || _currentPoint.y != newPoint.y)
    if(![[NSString stringWithFormat:@"%.3f", _currentPoint.x] isEqualToString:[NSString stringWithFormat:@"%.3f", newPoint.x]] ||
       ![[NSString stringWithFormat:@"%.3f", _currentPoint.y] isEqualToString:[NSString stringWithFormat:@"%.3f", newPoint.y]])
        [self reloadMapAt:newPoint];
}


#pragma mark - Post Controller delegate
- (void)getPostsDidFinish:(PostController *)controller resultDict:(NSDictionary *)resultDict
{
    [self.view addSubview:self.mapView];
    
    
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(_currentPoint.x, _currentPoint.y);
    [_mapView setCenterCoordinate:locationCoordinate
                        zoomLevel:15
                         animated:NO];
    
    NSArray *postsInLocation = [PostDM getPostsFromArray:(NSArray *)resultDict];
    
    // Load all markers
    for (PostDM *post in postsInLocation) {
        MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(post.latitude, post.longitude);
        point.title = post.address;
        point.subtitle = post.category;
        [_mapView addAnnotation:point];
        
        NSLog(@"Post %f, %f", post.latitude, post.longitude);
    }
    
    [self.view bringSubviewToFront:_mapView];
    [self.view bringSubviewToFront:self.postButton];
}

@end
