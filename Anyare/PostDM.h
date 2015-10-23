//
//  PostDM.h
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PostDM : NSObject
@property (nonatomic) int postId;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *address;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (strong, nonatomic) NSString *details;    // Description
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDate *dateTime;
@property (nonatomic) BOOL resolved;

@property (strong, nonatomic) NSString *smallImageUrl;
@property (strong, nonatomic) NSString *mediumImageUrl;
@property (strong, nonatomic) NSString *largeImageUrl;

+ (NSArray *)getPostsFromArray:(NSArray *)array;
+ (PostDM *)getPostFromDictionary:(NSDictionary *)dict;
@end
