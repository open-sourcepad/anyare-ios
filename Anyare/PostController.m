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
    [params setObject:post.category forKey:@"post[category]"];
    [params setObject:post.details forKey:@"post[description]"];
    [params setObject:[[NSNumber numberWithFloat:post.latitude] stringValue] forKey:@"post[latitude]"];
    [params setObject:[[NSNumber numberWithFloat:post.longitude] stringValue] forKey:@"post[longitude]"];

    if (post.image) {
        NSLog(@"pasok!");
        // Construct filename from user id and date/time + index
        NSString *filename = [NSString stringWithFormat:@"photo.png"];
        
        UIImage *image = post.image;
        NSMutableURLRequest *request = [objMgr.HTTPClient multipartFormRequestWithMethod:@"POST"
                                                                                    path:API_CREATE_POST
                                                                              parameters:params
                                                               constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                   [formData appendPartWithFileData:UIImagePNGRepresentation(image)
                                                                                               name:@"photo[image]"
                                                                                           fileName:filename
                                                                                           mimeType:@"image/png"];
                                                               }
                                        ];
        [objMgr.HTTPClient enqueueBatchOfHTTPRequestOperationsWithRequests:[NSArray arrayWithObject:request]
                                                             progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                                                 NSLog(@"Progress %d of %d", (int)numberOfFinishedOperations, (int)totalNumberOfOperations);
                                                             }
                                                           completionBlock:^(NSArray *operations) {
                                                               AFHTTPRequestOperation *operation = [operations objectAtIndex:0];
                                                               NSError *error;
                                                               NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:&error];

                                                               NSLog(@"Response: %@", responseDict);

                                                               if ([delegate respondsToSelector:@selector(createPostDidFinish:resultDict:)])
                                                                   [delegate performSelector:@selector(createPostDidFinish:resultDict:) withObject:self withObject:responseDict];
                                                           }];
    }else {
    
        [objMgr setAcceptHeaderWithMIMEType:API_HEADER];
        [objMgr.HTTPClient postPath:API_CREATE_POST
                        parameters:params
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSError *error;
                                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:&error];
                                NSLog(@"Response: %@", responseDict);

                                if ([delegate respondsToSelector:@selector(createPostDidFinish:resultDict:)])
                                    [delegate performSelector:@selector(createPostDidFinish:resultDict:) withObject:self withObject:responseDict];

                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                NSLog(@"Error: %@", error.localizedDescription);
                            }];
    }


}

+ (void)getPostsInLocationWithDelegate:(id <PostControllerDelegate>)delegate
                              location:(CGPoint)locationCoordinate
                             authToken:(NSString *)authenticationToken
{
    RKObjectManager *objMgr = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).apiObjMgr;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithFloat:locationCoordinate.x] forKey:@"latitude"];
    [params setObject:[NSNumber numberWithFloat:locationCoordinate.y] forKey:@"longitude"];
    [params setObject:authenticationToken forKey:@"auth_token"];
    
    [objMgr setAcceptHeaderWithMIMEType:API_HEADER];
    [objMgr.HTTPClient getPath:API_GET_POSTS_IN_LOCATION
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSError *error;
                            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:&error];
                            NSLog(@"Response: %@", responseDict);
                            BOOL isSuccess = [[responseDict objectForKey:@"success"] boolValue];
                            
                            if(isSuccess) {
                                NSDictionary *resultDict = [responseDict objectForKey:@"data"];
                                if ([delegate respondsToSelector:@selector(getPostsDidFinish:resultDict:)])
                                    [delegate performSelector:@selector(getPostsDidFinish:resultDict:) withObject:self withObject:resultDict];
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                        }];

}
@end
