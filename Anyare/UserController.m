//
//  UserController.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/23/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "UserController.h"
#import "AppDelegate.h"
#import "UserDM.h"
#import "Constants.h"

@implementation UserController

@synthesize delegate;

#pragma mark - Singleton
static UserController *singleton = nil;

+ (UserController *)getInstance
{
    if(singleton == nil) {
        singleton = [[UserController alloc] init];
    }
    return singleton;
}

#pragma mark - Class Methods
+ (void)signInUser:(id <UserControllerDelegate>)delegate
              user:(UserDM *)user
{
    UserController *controller = [UserController getInstance];
    controller.delegate = delegate;
    [controller signInUser:user];
}

#pragma mark - Request Methods
- (void)signInUser:(UserDM *)user
{
    RKObjectManager *objMgr = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).apiObjMgr;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:user.deviceToken ?: @"SIMULATOR" forKey:@"device_id"];
    
    [objMgr setAcceptHeaderWithMIMEType:API_HEADER];
    [objMgr.HTTPClient postPath:API_SIGN_IN
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSError *error;
                           NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:&error];
                           NSLog(@"Response: %@", responseDict);
                           
                           NSDictionary *resultDict = [responseDict objectForKey:@"user"];
                           if ([delegate respondsToSelector:@selector(signInUserDidFinish:resultDict:)])
                               [delegate performSelector:@selector(signInUserDidFinish:resultDict:) withObject:self withObject:resultDict];
                           }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Error: %@", error.localizedDescription);
                       }];

}
@end
