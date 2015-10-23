//
//  LoginViewController.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "LoginViewController.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "UserDM.h"
#import "UserController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController () <FBSDKLoginButtonDelegate, UserControllerDelegate>
@property (strong, nonatomic) FBSDKLoginButton *loginButton;
@property (strong, nonatomic) AppDelegate *appDelegate;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors
- (FBSDKLoginButton *)loginButton {
    if(!_loginButton) {
        _loginButton = [[FBSDKLoginButton alloc] init];
        _loginButton.center = self.view.center;
        _loginButton.readPermissions = @[@"public_profile", @"email"];
        _loginButton.delegate = self;
    }
    return _loginButton;
}

#pragma mark - FB Login Delegate
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    // Login user
    UserDM *user = [[UserDM alloc] init];
    user.deviceToken = _appDelegate.deviceToken;
    [UserController signInUser:self user:user];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}
#pragma mark - User controller delegate
- (void)signInUserDidFinish:(UserController *)controller resultDict:(NSDictionary *)resultDict
{
    // Save current user
    UserDM *user = [[UserDM alloc] init];
    user.userId = [[resultDict objectForKey:@"id"] intValue];
    user.email = [resultDict objectForKey:@"email"];
    user.authenticationToken = [resultDict objectForKey:@"auth_token"];
    _appDelegate.currentUser = user;
    
    [UserDM saveCustomObject:_appDelegate.currentUser key:DEFAULT_USER_LOGGED_IN];
    
    [_appDelegate goToHome];
    [_appDelegate.mapVC reloadMapAt:_appDelegate.currentLocationCoordinate];
}
@end
