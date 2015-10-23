//
//  TemplateViewController.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/23/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "TemplateViewController.h"
#import <Quartzcore/QuartzCore.h>
#import "Constants.h"

#import "CategoryButton.h"

@interface TemplateViewController ()
@property (strong, nonatomic) UIView *categoryPopupView;

@end

#define kCategoryTag 100

@implementation TemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.postButton];
    [self.view addSubview:self.categoryPopupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = _navTitle;

}

#pragma mark - Accessors
- (UIButton *)postButton {
    if(!_postButton) {
        _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _postButton.frame = CGRectMake(10.0, self.view.frame.size.height-230.0, BTN_POST_DIMENSION, BTN_POST_DIMENSION);
        [_postButton addTarget:self action:@selector(postButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _postButton.backgroundColor = [UIColor whiteColor];
        _postButton.layer.cornerRadius = BTN_POST_DIMENSION/2;
        _postButton.layer.borderColor = COLOR_THEME.CGColor;
        _postButton.layer.borderWidth = 5.0;
    }
    return _postButton;
}

- (UIView *)categoryPopupView {
    if(!_categoryPopupView) {
        CGFloat originX = _postButton.frame.origin.x+30.0;
        _categoryPopupView = [[UIView alloc] initWithFrame:CGRectMake(originX,
                                                                      130.0,
                                                                      self.view.frame.size.width-originX-60.0,
                                                                      350.0)];
        _categoryPopupView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _categoryPopupView.backgroundColor = COLOR_THEME;
        _categoryPopupView.layer.borderColor = [UIColor whiteColor].CGColor;
        _categoryPopupView.layer.borderWidth = 3.0;
        _categoryPopupView.layer.cornerRadius = 10.0;
        _categoryPopupView.alpha = 0;
        
        // Add category buttons
        CGFloat x = 15.0;
        CGFloat y = 15.0;
        CGFloat dimension = 75.0;
        CGFloat gap = 15.0;
        UIView *subPopupView = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                                        0.0,
                                                                        (gap*4)+(dimension*3),
                                                                        _categoryPopupView.frame.size.height)];
        subPopupView.backgroundColor = [UIColor clearColor];
        [_categoryPopupView addSubview:subPopupView];
        
        for (int i=0; i<NUMBER_OF_CATEGORIES; i++) {
            CategoryButton *categoryBtn = [[CategoryButton alloc] initWithFrame:CGRectMake(x, y, dimension, dimension)];
            categoryBtn.tag = kCategoryTag+i+1;
            [categoryBtn addTarget:self action:@selector(categoryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            switch (i) {
                case kCategoryFire: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"fire-cat.png"] title:@"Fire"];
                }
                    break;
                case kCategoryFlood: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"flood.png"] title:@"Flood"];
                }
                    break;
                case kCategoryTheft: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"theft.png"] title:@"Theft"];
                }
                    break;
                case kCategoryTraffic: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"theft.png"] title:@"Traffic"];
                }
                    break;
                case kCategoryRoad: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"broken_road.png"] title:@"Road"];
                }
                    break;
                case kCategoryWaterworks: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"theft.png"] title:@"Water Works"];
                }
                    break;
                case kCategoryAssault: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"theft.png"] title:@"Assault"];
                }
                    break;
                case kCategoryVandalism: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"theft.png"] title:@"Vandalism"];
                }
                    break;
                case kCategoryDrugs: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"theft.png"] title:@"Drugs"];
                }
                    break;
                default:
                    break;
            }
            
            [subPopupView addSubview:categoryBtn];
            categoryBtn = nil;
            
            x += (gap + dimension);
            
            if((i+1)%3 == 0) {
                x = 15.0;
                y += (gap + dimension);
            }
        }
        subPopupView.center = CGPointMake(_categoryPopupView.frame.size.width/2, subPopupView.center.y);
        subPopupView = nil;
    }
    return _categoryPopupView;
}

#pragma mark - Button Actions
- (void)postButtonAction:(id)sender
{
    // Show category popup
    _categoryPopupView.alpha = 1;
    [self.view bringSubviewToFront:_categoryPopupView];
    // To do: animate
}

- (void)categoryButtonAction:(id)sender
{
    
}

#pragma mark - Private
@end
