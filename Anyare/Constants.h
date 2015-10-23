//
//  Constants.h
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

// DIMENSION
#define SCREEN_WIDTH                                [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                               [[UIScreen mainScreen] bounds].size.height
// API
#define API_BASE_URL                                @"http://halloween-penguin.herokuapp.com"
#define API_HEADER                                  @"application/vnd.halloween-penguin+json;version=1"

#define API_SIGN_IN                                 @"/api/sign_in"
#define API_CREATE_POST                             @"/api/posts"
#define API_GET_POSTS_IN_LOCATION                   @"/api/posts"

#define KEY_SUCCESS                                 @"success"


// COLORS
#define RGB(r,g,b)                                  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)                            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(rgbValue)                    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBWithAlpha(rgbValue,a)         [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define COLOR_THEME                                 RGB(34, 213, 158)//RGB(244,155,61)

// DEFAULTS
#define DEFAULT_USER_LOGGED_IN                      @"user is logged in"
#define DEFAULT_USER_AUTH_TOKEN                     @"user auth token"
#define DEFAULT_USER_ID                             @"user id"

// FONT
#define FONT_SIZE_NORMAL                            13

// UI
#define BTN_POST_DIMENSION                          70.0
#define TIMELINE_CELL_ROW_HEIGHT                    70.0
#define TIMELINE_WITH_IMAGE_TEXT_CELL_ROW_HEIGHT    290.0
#define TIMELINE_WITH_TEXT_CELL_ROW_HEIGHT          100.0

// COMMON
#define NUMBER_OF_CATEGORIES                        9

// CATEGORIES
#define CATEGORY_FIRE                               @"fire"
#define CATEGORY_FLOOD                              @"flood"
#define CATEGORY_THEFT                              @"theft"
#define CATEGORY_ACCIDENT                           @"accident"
#define CATEGORY_ROAD                               @"road"
#define CATEGORY_WATERWORKS                         @"waterworks"
#define CATEGORY_ASSAULT                            @"assault"
#define CATEGORY_VANDALISM                          @"vandalism"
#define CATEGORY_DRUGS                              @"drugs"
#define CATEGORY_OTHERS                             @"others"


enum PostCategory {
    kCategoryFire = 0,
    kCategoryFlood,
    kCategoryTheft,
    kCategoryAccident,
    kCategoryRoad,
    kCategoryWaterworks,
    kCategoryAssault,
    kCategoryVandalism,
    kCategoryDrugs,
};
