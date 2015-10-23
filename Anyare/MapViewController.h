//
//  MapViewController.h
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateViewController.h"

@interface MapViewController : TemplateViewController
//- (void)reloadMap;
- (void)reloadMapAt:(CGPoint)point;
@end
