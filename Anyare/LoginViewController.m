//
//  LoginViewController.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController () <FBSDKLoginButtonDelegate>
@property (strong, nonatomic) FBSDKLoginButton *loginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DEFAULT_USER_LOGGED_IN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate goToHome];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}
@end
