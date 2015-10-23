//
//  PostTableViewCell.h
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostDM;

@interface PostTableViewCell : UITableViewCell
- (void)createCellWithPost:(PostDM *)post;
@end
