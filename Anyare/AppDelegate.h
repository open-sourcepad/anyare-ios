//
//  AppDelegate.h
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class LoginViewController;
@class MapViewController;
@class PostViewController;
@class TimelineViewController;
@class UserDM;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) RKObjectManager *apiObjMgr;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabController;

@property (strong, nonatomic) LoginViewController *loginVC;
@property (strong, nonatomic) UINavigationController *mapNavController;
@property (strong, nonatomic) UINavigationController *postNavController;
@property (strong, nonatomic) UINavigationController *timelineNavController;
@property (strong, nonatomic) MapViewController *mapVC;
@property (strong, nonatomic) PostViewController *postVC;
@property (strong, nonatomic) TimelineViewController *timelineVC;

@property (strong, nonatomic) UserDM *currentUser;
@property (strong, nonatomic) NSString *deviceToken;
@property (nonatomic) CGPoint currentLocationCoordinate;
@property (nonatomic) BOOL isLocationDetected;

- (void)goToLogin;
- (void)goToHome;
- (void)logoutUser;

@end

