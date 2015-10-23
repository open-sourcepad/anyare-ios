//
//  CategoryButton.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/23/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "CategoryButton.h"
#import <QuartzCore/QuartzCore.h>

@interface CategoryButton ()
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@end
@implementation CategoryButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8.0;
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.textLabel];
    }
    return self;
}

#pragma mark - Accessors
- (UILabel *)textLabel {
    if(!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                               _iconImageView.frame.origin.y+_iconImageView.frame.size.height+5.0,
                                                               self.frame.size.width,
                                                               12.0)];
        _textLabel.font = [UIFont systemFontOfSize:11.0];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIImageView *)iconImageView {
    if(!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 50.0, 50.0)];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.center = CGPointMake(self.frame.size.width/2, _iconImageView.center.y);
    }
    return _iconImageView;
}

- (void)setCategoryButtonImage:(UIImage *)image title:(NSString *)title
{
    _iconImageView.image = image;
    _textLabel.text = title;
}
@end
