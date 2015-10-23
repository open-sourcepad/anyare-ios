//
//  Constants.h
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

// COLORS
#define RGB(r,g,b)                                  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)                            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(rgbValue)                    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBWithAlpha(rgbValue,a)         [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define COLOR_THEME                                 RGB(244,155,61)

// DEFAULTS
#define DEFAULT_USER_LOGGED_IN                      @"user is logged in"

// FONT
#define FONT_SIZE_NORMAL                            13