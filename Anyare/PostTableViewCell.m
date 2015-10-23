//
//  PostTableViewCell.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "PostTableViewCell.h"
#import "Constants.h"
#import "PostDM.h"

#import <QuartzCore/QuartzCore.h>

@interface PostTableViewCell ()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *dateTimeLabel;
@end

#define kPostCellPadding            10
#define kPostCellGap                10
#define kPostCellIconDimension      50

@implementation PostTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.iconImageView];
        [self addSubview:self.locationLabel];
        [self addSubview:self.dateTimeLabel];
    }
    return self;
}

#pragma mark - Accessors
- (UIImageView *)iconImageView {
    if(!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPostCellPadding, kPostCellPadding, kPostCellIconDimension, kPostCellIconDimension)];
        _iconImageView.backgroundColor = [UIColor whiteColor];
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.layer.borderWidth = 2.0;
        _iconImageView.layer.cornerRadius = 8.0;
    }
    return _iconImageView;
}

- (UILabel *)locationLabel {
    if(!_locationLabel) {
        CGFloat originX = _iconImageView.frame.origin.x + _iconImageView.frame.size.width + kPostCellGap;
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX,
                                                                   _iconImageView.frame.origin.y,
                                                                   self.frame.size.width-originX,
                                                                   35.0)];
        _locationLabel.numberOfLines = 2;
        _locationLabel.textColor = [UIColor darkGrayColor];
        _locationLabel.font = [UIFont systemFontOfSize:FONT_SIZE_NORMAL];
        _locationLabel.text = @"2701 Discovery Suites, ADB Avenue, Ortigas Center, Pasig City";
    }
    return _locationLabel;
}

- (UILabel *)dateTimeLabel {
    if(!_dateTimeLabel) {
        _dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_locationLabel.frame.origin.x,
                                                                   _locationLabel.frame.origin.y + _locationLabel.frame.size.height,
                                                                   _locationLabel.frame.size.width,
                                                                   15.0)];
        _dateTimeLabel.textColor = [UIColor darkGrayColor];
        _dateTimeLabel.font = [UIFont systemFontOfSize:FONT_SIZE_NORMAL];
        _dateTimeLabel.text = @"Date and time";
    }
    return _dateTimeLabel;
}

- (void)createCellWithPost:(PostDM *)post
{
    NSString *category = post.category;
    UIImage *image;
    
    if ([category isEqualToString:CATEGORY_FIRE])
        image = [UIImage imageNamed:@"fire-pin"];
    else if ([category isEqualToString:CATEGORY_FLOOD])
        image = [UIImage imageNamed:@"flood-pin"];
    else if ([category isEqualToString:CATEGORY_THEFT])
        image = [UIImage imageNamed:@"theft-pin"];
    else if ([category isEqualToString:CATEGORY_ACCIDENT])
        image = [UIImage imageNamed:@"accident-pin"];
    else if ([category isEqualToString:CATEGORY_ROAD])
        image = [UIImage imageNamed:@"road-pin"];
    else if ([category isEqualToString:CATEGORY_WATERWORKS])
        image = [UIImage imageNamed:@"waterworks-pin"];
    else if ([category isEqualToString:CATEGORY_ASSAULT])
        image = [UIImage imageNamed:@"assault-pin"];
    else if ([category isEqualToString:CATEGORY_VANDALISM])
        image = [UIImage imageNamed:@"vandalism-pin"];
    else if ([category isEqualToString:CATEGORY_DRUGS])
        image = [UIImage imageNamed:@"drugs-pin"];
    
    _iconImageView.image = image;

    _locationLabel.text = post.address;
    NSLog(@"date: %@", post.dateTime);

}
@end
