//
//  UserDM.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "UserDM.h"

#define kUserId                         @"id"
#define kDeviceToken                    @"device_token"
#define kAuthToken                      @"auth_token"
#define kEmail                          @"email"

@implementation UserDM

#pragma mark - UserDM Encoder

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        //decode properties, other class vars
        self.userId = [[decoder decodeObjectForKey:kUserId] intValue];
        self.deviceToken = [decoder decodeObjectForKey:kDeviceToken];
        self.authenticationToken = [decoder decodeObjectForKey:kAuthToken];
        self.email = [decoder decodeObjectForKey:kEmail];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:[NSNumber numberWithInt:self.userId] forKey:kUserId];
    [encoder encodeObject:self.deviceToken forKey:kDeviceToken];
    [encoder encodeObject:self.authenticationToken forKey:kAuthToken];
    [encoder encodeObject:self.email forKey:kEmail];
}

+ (void)saveCustomObject:(UserDM *)user key:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

+ (UserDM *)loadCustomObjectWithKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    UserDM *user = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return user;
}

@end
