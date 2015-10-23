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
#import "Utility.h"

#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface PostTableViewCell ()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *dateTimeLabel;

@property (strong, nonatomic) UIImageView *detailImageView;
@property (strong, nonatomic) UILabel *detailLabel;
@end

#define kPostCellPadding            10
#define kPostCellGap                10
#define kPostCellIconDimension      50
#define kPostCellImageDimension     200

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
        
        [self addSubview:self.detailImageView];
        [self addSubview:self.detailLabel];
    }
    return self;
}

#pragma mark - Accessors
- (UIImageView *)iconImageView {
    if(!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPostCellPadding, kPostCellPadding, kPostCellIconDimension, kPostCellIconDimension)];
        _iconImageView.backgroundColor = [UIColor whiteColor];
    }
    return _iconImageView;
}

- (UILabel *)locationLabel {
    if(!_locationLabel) {
        CGFloat originX = _iconImageView.frame.origin.x + _iconImageView.frame.size.width + kPostCellGap;
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX,
                                                                   _iconImageView.frame.origin.y,
                                                                   self.frame.size.width-originX-kPostCellPadding,
                                                                   35.0)];
        _locationLabel.numberOfLines = 2;
        _locationLabel.textColor = [UIColor darkGrayColor];
        _locationLabel.font = [UIFont systemFontOfSize:FONT_SIZE_NORMAL];
        _locationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _locationLabel;
}

- (UILabel *)dateTimeLabel {
    if(!_dateTimeLabel) {
        _dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_locationLabel.frame.origin.x,
                                                                   _locationLabel.frame.origin.y + _locationLabel.frame.size.height,
                                                                   _locationLabel.frame.size.width,
                                                                   15.0)];
        _dateTimeLabel.textColor = [UIColor grayColor];
        _dateTimeLabel.font = [UIFont systemFontOfSize:(FONT_SIZE_NORMAL-2)];
        _dateTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _dateTimeLabel;
}

- (UIImageView *)detailImageView {
    if(!_detailImageView) {
        _detailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPostCellPadding, kPostCellPadding, kPostCellImageDimension, kPostCellImageDimension)];
        _detailImageView.backgroundColor = [UIColor grayColor];
        _detailImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _detailImageView.center = CGPointMake(self.frame.size.width/2, _detailImageView.center.y);
        _detailImageView.hidden = YES;
    }
    return _detailImageView;
}

- (UILabel *)detailLabel {
    if(!_detailLabel) {
        CGFloat originX = kPostCellPadding;
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX,
                                                                 _detailImageView.frame.origin.y+_detailImageView.frame.size.height,
                                                                 self.frame.size.width-(originX*2),
                                                                 20.0)];
        _detailLabel.textColor = [UIColor darkGrayColor];
        _detailLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_NORMAL];
        _detailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _detailLabel.hidden = YES;
        // Assume text is one line only
    }
    return _detailLabel;
}

- (void)createCellWithPost:(PostDM *)post
{
    if(post.detailed) {
        // Post has details
        dispatch_async(dispatch_get_main_queue(), ^{
            _detailImageView.image = nil;
            [_detailImageView sd_setImageWithURL:[NSURL URLWithString:post.largeImageUrl]
                                placeholderImage:nil
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           _detailImageView.image = image;
                                       }];
        });
        
        _detailImageView.hidden = NO;
        _detailLabel.text = post.details;
        _detailLabel.hidden = NO;
        
        CGRect detailFrame = _detailLabel.frame;
        detailFrame.origin.x = kPostCellPadding;
        _detailLabel.frame = detailFrame;
        
        CGRect iconFrame = _iconImageView.frame;
        iconFrame.origin.y = _detailLabel.frame.origin.y + _detailLabel.frame.size.height;
        _iconImageView.frame = iconFrame;
        
        CGRect addressFrame = _locationLabel.frame;
        addressFrame.origin.y = _iconImageView.frame.origin.y;
        _locationLabel.frame = addressFrame;
        
        CGRect dateTimeFrame = _dateTimeLabel.frame;
        dateTimeFrame.origin.y = _locationLabel.frame.origin.y + _locationLabel.frame.size.height;
        _dateTimeLabel.frame = dateTimeFrame;
    }
    else if(post.details.length) {
        _detailImageView.image = nil;
        _detailLabel.text = post.details;
        _detailLabel.hidden = NO;
        
        CGRect detailFrame = _detailLabel.frame;
        detailFrame.origin.x = _locationLabel.frame.origin.x;
        detailFrame.origin.y = kPostCellPadding;
        detailFrame.size.width = self.frame.size.width-detailFrame.origin.x-kPostCellPadding;
        _detailLabel.frame = detailFrame;
        
        CGRect iconFrame = _iconImageView.frame;
        iconFrame.origin.y = _detailLabel.frame.origin.y + _detailLabel.frame.size.height;
        _iconImageView.frame = iconFrame;
        
        CGRect addressFrame = _locationLabel.frame;
        addressFrame.origin.y = _iconImageView.frame.origin.y;
        _locationLabel.frame = addressFrame;
        
        CGRect dateTimeFrame = _dateTimeLabel.frame;
        dateTimeFrame.origin.y = _locationLabel.frame.origin.y + _locationLabel.frame.size.height;
        _dateTimeLabel.frame = dateTimeFrame;
    }
    else {
        _detailImageView.image = nil;
        _detailLabel.text = post.details;
        
        // Reset frames
        CGRect iconFrame = _iconImageView.frame;
        iconFrame.origin.y = kPostCellPadding;
        _iconImageView.frame = iconFrame;
        
        CGRect addressFrame = _locationLabel.frame;
        addressFrame.origin.y = _iconImageView.frame.origin.y;
        _locationLabel.frame = addressFrame;
        
        CGRect dateTimeFrame = _dateTimeLabel.frame;
        dateTimeFrame.origin.y = _locationLabel.frame.origin.y + _locationLabel.frame.size.height;
        _dateTimeLabel.frame = dateTimeFrame;
    }
    
    NSString *category = post.category;
    UIImage *image;
    
//    if ([category isEqualToString:CATEGORY_FIRE])
//        image = [UIImage imageNamed:@"fire-pin"];
//    else if ([category isEqualToString:CATEGORY_FLOOD])
//        image = [UIImage imageNamed:@"flood-pin"];
//    else if ([category isEqualToString:CATEGORY_THEFT])
//        image = [UIImage imageNamed:@"theft-pin"];
//    else if ([category isEqualToString:CATEGORY_ACCIDENT])
//        image = [UIImage imageNamed:@"accident-pin"];
//    else if ([category isEqualToString:CATEGORY_ROAD])
//        image = [UIImage imageNamed:@"road-pin"];
//    else if ([category isEqualToString:CATEGORY_WATERWORKS])
//        image = [UIImage imageNamed:@"waterworks-pin"];
//    else if ([category isEqualToString:CATEGORY_ASSAULT])
//        image = [UIImage imageNamed:@"assault-pin"];
//    else if ([category isEqualToString:CATEGORY_VANDALISM])
//        image = [UIImage imageNamed:@"vandalism-pin"];
//    else if ([category isEqualToString:CATEGORY_DRUGS])
//        image = [UIImage imageNamed:@"drugs-pin"];
    
    if ([category isEqualToString:CATEGORY_FIRE])
        image = [UIImage imageNamed:@"fire-cat"];
    else if ([category isEqualToString:CATEGORY_FLOOD])
        image = [UIImage imageNamed:@"flood"];
    else if ([category isEqualToString:CATEGORY_THEFT])
        image = [UIImage imageNamed:@"theft"];
    else if ([category isEqualToString:CATEGORY_ACCIDENT])
        image = [UIImage imageNamed:@"accident"];
    else if ([category isEqualToString:CATEGORY_ROAD])
        image = [UIImage imageNamed:@"broken_road"];
    else if ([category isEqualToString:CATEGORY_WATERWORKS])
        image = [UIImage imageNamed:@"pipe"];
    else if ([category isEqualToString:CATEGORY_ASSAULT])
        image = [UIImage imageNamed:@"assault"];
    else if ([category isEqualToString:CATEGORY_VANDALISM])
        image = [UIImage imageNamed:@"vandalism"];
    else if ([category isEqualToString:CATEGORY_DRUGS])
        image = [UIImage imageNamed:@"drugs"];
    
    _iconImageView.image = image;
    _locationLabel.text = post.address;
    
    // Date and time
    NSString *dateTimeString = post.dateTime;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *date = [dateFormat dateFromString:dateTimeString];

    NSDateFormatter *displayDateFormat = [[NSDateFormatter alloc] init];
    [displayDateFormat setDateFormat:@"MMMM d, yyyy hh:mm aa"];
    _dateTimeLabel.text = [displayDateFormat stringFromDate:date];
}
@end
