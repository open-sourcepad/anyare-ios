//
//  Utility.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/23/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSDate *)convertUnixToDate:(long)unix
{
    return [NSDate dateWithTimeIntervalSince1970:unix];;
}

@end