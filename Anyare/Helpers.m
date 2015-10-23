//
//  Helpers.m
//  Anyare
//
//  Created by Rodel Medina on 10/23/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "Helpers.h"
#import "Constants.h"

@implementation Helpers
+(NSString *)intToCategoryName:(int)index
{
    switch (index) {
        case kCategoryFire: {
            return CATEGORY_FIRE;
        }
            break;
        case kCategoryFlood: {
            return CATEGORY_FLOOD;
        }
            break;
        case kCategoryTheft: {
            return CATEGORY_THEFT;
        }
            break;
        case kCategoryAccident: {
            return CATEGORY_ACCIDENT;
        }
            break;
        case kCategoryRoad: {
            return CATEGORY_ROAD;
        }
            break;
        case kCategoryWaterworks: {
            return CATEGORY_WATERWORKS;
        }
            break;
        case kCategoryAssault: {
            return CATEGORY_ASSAULT;
        }
            break;
        case kCategoryVandalism: {
            return CATEGORY_VANDALISM;
        }
            break;
        case kCategoryDrugs: {
            return CATEGORY_DRUGS;
        }
            break;
        default:
            return CATEGORY_OTHERS;
            break;
    }
}

+(UIImage *)intToCategoryImage:(int)index
{
    UIImage *image = [[UIImage alloc] init];

    switch (index) {
        case kCategoryFire: {
            image = [UIImage imageNamed:@"fire-cat.png"];
        }
            break;
        case kCategoryFlood: {
//            [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"flood.png"] title:@"Flood"];
            image = [UIImage imageNamed:@"flood.png"];
        }
            break;
        case kCategoryTheft: {
//            [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"theft.png"] title:@"Theft"];
            image = [UIImage imageNamed:@"theft.png"];
        }
            break;
        case kCategoryAccident: {
//            [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"accident.png"] title:@"Accident"];
            image = [UIImage imageNamed:@"accident.png"];
        }
            break;
        case kCategoryRoad: {
//            [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"broken_road.png"] title:@"Road"];
            image = [UIImage imageNamed:@"broken_road.png"];
        }
            break;
        case kCategoryWaterworks: {
//            [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"pipe.png"] title:@"Water Work"];
            image = [UIImage imageNamed:@"pipe.png"];
        }
            break;
        case kCategoryAssault: {
//            [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"assault.png"] title:@"Assault"];
            image = [UIImage imageNamed:@"assault.png"];
        }
            break;
        case kCategoryVandalism: {
//            [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"vandalism.png"] title:@"Vandalism"];
            image = [UIImage imageNamed:@"vandalism.png"];
        }
            break;
        case kCategoryDrugs: {
//            [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"drugs.png"] title:@"Drugs"];
            image = [UIImage imageNamed:@"drugs.png"];
        }
            break;
        default:
            break;
    }
    
    return image;
}
@end
