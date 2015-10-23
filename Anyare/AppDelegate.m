//
//  AppDelegate.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"

#import "LoginViewController.h"
#import "MapViewController.h"
#import "PostViewController.h"
#import "TimelineViewController.h"

#import "UserDM.h"

#import <CoreLocation/CoreLocation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <RestKit/RestKit.h>
//#import <Mapbox/Mapbox.h>

@interface AppDelegate () <UITabBarControllerDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:COLOR_THEME];
    [[UINavigationBar appearance] setTranslucent:NO];
    NSDictionary * navBarTitleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                                  NSFontAttributeName            : [UIFont boldSystemFontOfSize:18] };
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    // RESTKIT
    _apiObjMgr = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
    
    // LOCATION
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [self requestLocationAccess];
    
    // PUSH NOTIFICATIONS
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |
                                                                                                                      UIUserNotificationTypeAlert |
                                                                                                                      UIUserNotificationTypeBadge)
                                                                                                          categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults boolForKey:DEFAULT_USER_LOGGED_IN]) {
        [self goToHome];
    }
    else {
        // No user is logged in
        [self goToLogin];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Device token: %@", _deviceToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
}

#pragma mark - ACCESSORS
- (UserDM *)currentUser {
    if(!_currentUser) {
        _currentUser = [[UserDM alloc] init];
    }
    return _currentUser;
}

- (LoginViewController *)loginVC {
    if(!_loginVC) {
        _loginVC = [[LoginViewController alloc] init];
    }
    return _loginVC;
}

- (UITabBarController *)tabController {
    if(!_tabController) {
        _tabController = [[UITabBarController alloc] init];
        _tabController.delegate = self;
        _tabController.tabBar.tintColor = COLOR_THEME;
        _tabController.selectedIndex = 0;
        [_tabController setViewControllers:[NSArray arrayWithObjects:
                                            self.mapNavController,
                                            //self.postNavController,
                                            self.timelineNavController,
                                            nil]
                                  animated:YES];
    }
    return _tabController;
}

- (UINavigationController *)mapNavController {
    if(!_mapNavController) {
        _mapNavController = [[UINavigationController alloc] initWithRootViewController:self.mapVC];
        _mapNavController.title = @"Map";
        _mapNavController.tabBarItem.image = [UIImage imageNamed:@"Map.png"];
    }
    return _mapNavController;
}

- (UINavigationController *)postNavController {
    if(!_postNavController) {
        _postNavController = [[UINavigationController alloc] initWithRootViewController:self.postVC];
        _postNavController.title = @"Post";
        //_postNavController.tabBarItem.image = [UIImage imageNamed:@""];
    }
    return _postNavController;
}

- (UINavigationController *)timelineNavController {
    if(!_timelineNavController) {
        _timelineNavController = [[UINavigationController alloc] initWithRootViewController:self.timelineVC];
        _timelineNavController.title = @"Timeline";
        //_timelineNavController.tabBarItem.image = [UIImage imageNamed:@""];
    }
    return _timelineNavController;
}

- (MapViewController *)mapVC {
    if(!_mapVC) {
        _mapVC = [[MapViewController alloc] init];
    }
    return _mapVC;
}

- (PostViewController *)postVC {
    if(!_postVC) {
        _postVC = [[PostViewController alloc] init];
    }
    return _postVC;
}

- (TimelineViewController *)timelineVC {
    if(!_timelineVC) {
        _timelineVC = [[TimelineViewController alloc] init];
    }
    return _timelineVC;
}

#pragma mark - Public
- (void)goToLogin
{
    self.window.rootViewController = self.loginVC;
}

- (void)goToHome
{
    self.window.rootViewController = self.tabController;
}

- (void)logoutUser
{
    
}

#pragma mark - Location
- (void)requestLocationAccess
{
    // Get location
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [_locationManager stopUpdatingLocation];
    
    if(!_isLocationDetected) {
        // Save location
        _currentLocationCoordinate = CGPointMake(location.coordinate.latitude, location.coordinate.longitude);
        NSLog(@"Current location: (%f, %f)", location.coordinate.latitude, location.coordinate.longitude);
        
        _isLocationDetected = YES;
        [_mapVC reloadMap];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Unable to get your current location"
                                          preferredStyle:UIAlertControllerStyleAlert];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    alertController = nil;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status==kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"Authorized always");
    }
    else if(status==kCLAuthorizationStatusDenied) {
        NSLog(@"Denied");
    }
}



@end
