//
//  PostController.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/23/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "PostController.h"
#import "AppDelegate.h"
#import "PostDM.h"
#import "Constants.h"

@implementation PostController

@synthesize delegate;

#pragma mark - Singleton
static PostController *singleton = nil;

+ (PostController *)getInstance
{
    if(singleton == nil) {
        singleton = [[PostController alloc] init];
    }
    return singleton;
}

#pragma mark - Class Methods
+ (void)createPostWithDelegate:(id <PostControllerDelegate>)delegate
                          post:(PostDM *)post
                     userToken:(NSString *)userToken
{
    PostController *controller = [PostController getInstance];
    controller.delegate = delegate;
    [controller createPost:post userToken:userToken];
}

#pragma mark - Request Methods
- (void)createPost:(PostDM *)post userToken:(NSString *)userToken
{
    RKObjectManager *objMgr = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).apiObjMgr;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setObject:userToken forKey:@"auth_token"];
    [params setObject:@"fire" forKey:@"post[category]"];
    [params setObject:post.details forKey:@"post[description]"];
    [params setObject:[[NSNumber numberWithFloat:post.latitude] stringValue] forKey:@"post[latitude]"];
    [params setObject:[[NSNumber numberWithFloat:post.longitude] stringValue] forKey:@"post[longitude]"];

    
    [objMgr setAcceptHeaderWithMIMEType:API_HEADER];
    [objMgr.HTTPClient postPath:API_CREATE_POST
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Error: %@", error.localizedDescription);
                       }];

}
@end
