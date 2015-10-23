//
//  PostController.h
//  Anyare
//
//  Created by Nikki Fernandez on 10/23/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class PostDM;

@protocol PostControllerDelegate;

@interface PostController : NSObject
{
    @private
    id <PostControllerDelegate> delegate;
}
@property (nonatomic) id <PostControllerDelegate> delegate;

+ (void)createPostWithDelegate:(id <PostControllerDelegate>)delegate
                          post:(PostDM *)post
                     userToken:(NSString *)userToken;
+ (void)getPostsInLocationWithDelegate:(id <PostControllerDelegate>)delegate
                              location:(CGPoint)locationCoordinate
                             authToken:(NSString *)authenticationToken;
@end

@protocol PostControllerDelegate <NSObject>
@optional
- (void)createPostDidFinish:(PostController *)controller resultDict:(NSDictionary *)resultDict;
- (void)getPostsDidFinish:(PostController *)controller resultDict:(NSDictionary *)resultDict;
@end
