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
    [params setObject:userToken forKey:@"device_id"];
    
    [objMgr setAcceptHeaderWithMIMEType:API_HEADER];
    [objMgr.HTTPClient postPath:@""
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSError *error;
                           NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:&error];
                           NSLog(@"Response: %@", responseDict);
                           BOOL isSuccess = [[responseDict objectForKey:KEY_SUCCESS] boolValue];
                           
                           if(isSuccess) {
                               NSDictionary *resultDict = [responseDict objectForKey:KEY_DATA];
                               if ([delegate respondsToSelector:@selector(getChannelDidFinish:resultDict:)])
                                   [delegate performSelector:@selector(getChannelDidFinish:resultDict:) withObject:self withObject:resultDict];
                           }
                           else {
                               if ([delegate respondsToSelector:@selector(getChannel:didFailWithResultDict:)]) {
                                   [delegate performSelector:@selector(getChannel:didFailWithResultDict:)
                                                  withObject:self
                                                  withObject:[NSDictionary dictionaryWithObject:[responseDict objectForKey:KEY_ERROR_MESSAGE] forKey:KEY_ERRORS]];
                               }
                           }
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Error: %@", error.localizedDescription);
                           if ([delegate respondsToSelector:@selector(getChannel:didFailWithResultDict:)]) {
                               [delegate performSelector:@selector(getChannel:didFailWithResultDict:)
                                              withObject:self
                                              withObject:[NSDictionary dictionaryWithObject:error.userInfo forKey:KEY_ERRORS]];
                           }
                       }];

}
@end
