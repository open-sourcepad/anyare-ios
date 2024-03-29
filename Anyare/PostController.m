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

+ (void)duplicatePostWithDelegate:(id <PostControllerDelegate>)delegate
                          post:(PostDM *)post
                     userToken:(NSString *)userToken
{
    PostController *controller = [PostController getInstance];
    controller.delegate = delegate;
    [controller duplicatePost:post userToken:userToken];
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
        
        UIImage *image = [self compressForUpload:post.image scale:0.1];
        NSMutableURLRequest *request = [objMgr.HTTPClient multipartFormRequestWithMethod:@"POST"
                                                                                    path:API_CREATE_POST
                                                                              parameters:params
                                                               constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                   [formData appendPartWithFileData:UIImagePNGRepresentation(image)
                                                                                               name:@"post[image]"
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

- (void)duplicatePost:(PostDM *)post userToken:(NSString *)userToken
{
    RKObjectManager *objMgr = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).apiObjMgr;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userToken forKey:@"auth_token"];
    [params setObject:[[NSNumber numberWithInt:post.postId] stringValue] forKey:@"post_id"];
    [params setObject:@"repost" forKey:@"action_type"];
    
    
                            NSLog(@"Response: %d", post.postId);
    [objMgr setAcceptHeaderWithMIMEType:API_HEADER];
    [objMgr.HTTPClient postPath:API_CREATE_POST
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSError *error;
                            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:&error];
                            NSLog(@"Response: %@", responseDict);
                            
                            if ([delegate respondsToSelector:@selector(duplicatePostDidFinish:resultDict:)])
                                [delegate performSelector:@selector(duplicatePostDidFinish:resultDict:) withObject:self withObject:responseDict];
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                        }];
    
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
                            NSDictionary *resultDict = [responseDict objectForKey:@"data"];
                            if ([delegate respondsToSelector:@selector(getPostsDidFinish:resultDict:)])
                                [delegate performSelector:@selector(getPostsDidFinish:resultDict:) withObject:self withObject:resultDict];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                        }];

}

- (UIImage *)compressForUpload:(UIImage *)original scale:(CGFloat)scale
{
    NSData *imgData = UIImageJPEGRepresentation(original, 1); //1 it represents the quality of the image.
    NSLog(@"Size of Image(bytes):%lu",(unsigned long)[imgData length]);

    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *compressedImageData = UIImageJPEGRepresentation(compressedImage, 1); //1 it represents the quality of the image.
    NSLog(@"Size of Image(bytes):%lu",(unsigned long)[compressedImageData length]);

    return compressedImage;
}
@end
