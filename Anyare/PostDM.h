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
@property (strong, nonatomic) NSString *category;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSDate *dateTime;
@end
