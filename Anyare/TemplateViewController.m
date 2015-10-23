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
#import "PostViewController.h"

@interface TemplateViewController ()
@property (strong, nonatomic) UIView *categoryPopupView;
@property (strong, nonatomic) UIButton *closeButton;

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
                                                                      110.0,
                                                                      self.view.frame.size.width-originX-60.0,
                                                                      370.0)];
        _categoryPopupView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _categoryPopupView.backgroundColor = COLOR_THEME;
        _categoryPopupView.layer.borderColor = [UIColor whiteColor].CGColor;
        _categoryPopupView.layer.borderWidth = 3.0;
        _categoryPopupView.layer.cornerRadius = 10.0;
        _categoryPopupView.alpha = 0;
        _categoryPopupView.center = CGPointMake(self.view.frame.size.width/2, _categoryPopupView.center.y);
        _categoryPopupView.userInteractionEnabled = YES;
        
        // Add category buttons
        CGFloat x = 15.0;
        CGFloat y = 35.0;
        CGFloat dimension = 75.0;
        CGFloat gap = 15.0;
        UIView *subPopupView = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                                        0.0,
                                                                        (gap*4)+(dimension*3),
                                                                        _categoryPopupView.frame.size.height)];
        subPopupView.backgroundColor = [UIColor clearColor];
        [_categoryPopupView addSubview:subPopupView];
        [_categoryPopupView addSubview:self.closeButton];
        
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
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"accident.png"] title:@"Accident"];
                }
                    break;
                case kCategoryRoad: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"broken_road.png"] title:@"Road"];
                }
                    break;
                case kCategoryWaterworks: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"pipe.png"] title:@"Water Work"];
                }
                    break;
                case kCategoryAssault: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"assault.png"] title:@"Assault"];
                }
                    break;
                case kCategoryVandalism: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"vandalism.png"] title:@"Vandalism"];
                }
                    break;
                case kCategoryDrugs: {
                    [categoryBtn setCategoryButtonImage:[UIImage imageNamed:@"drugs.png"] title:@"Drugs"];
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

- (UIButton *)closeButton {
    if(!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(_categoryPopupView.frame.size.width-30.0, 10.0, 20.0, 20.0);
        [_closeButton setTitle:@"X" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark - Button Actions
- (void)postButtonAction:(id)sender
{
    // Show category popup
    _categoryPopupView.alpha = 1;
    [self.view bringSubviewToFront:_categoryPopupView];
    // To do: animate
}

- (void)categoryButtonAction:(CategoryButton *)sender
{
    
    PostViewController *ctrl = [[PostViewController alloc] init];
    ctrl.category = (int)sender.tag;
    [self.navigationController pushViewController:ctrl animated:YES];
    ctrl = nil;
}

- (void)closeButtonAction:(id)sender
{
    _categoryPopupView.alpha = 0;
    // To do: animate
}

#pragma mark - Private
@end
