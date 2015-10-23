//
//  UserDM.h
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDM : NSObject
@property (nonatomic) int userId;
@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *authenticationToken;
@property (strong, nonatomic) NSString *email;
@end
