//
//  PostDM.h
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostDM : NSObject
@property (nonatomic) int postId;
@property (nonatomic) int category;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSDate *dateTime;
@end
