//
//  UserController.h
//  Anyare
//
//  Created by Nikki Fernandez on 10/23/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class UserDM;

@protocol UserControllerDelegate;

@interface UserController : NSObject
{
@private
    id <UserControllerDelegate> delegate;
}
@property (nonatomic) id <UserControllerDelegate> delegate;

+ (void)signInUser:(id <UserControllerDelegate>)delegate
              user:(UserDM *)user;
@end

@protocol UserControllerDelegate <NSObject>
@optional
- (void)signInUserDidFinish:(UserController *)controller resultDict:(NSDictionary *)resultDict;
@end
