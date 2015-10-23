//
//  PostViewController.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "PostViewController.h"
#import "Constants.h"
#import "PostController.h"
#import "PostDM.h"
#import "AppDelegate.h"
#import "UserDM.h"

@interface PostViewController () <PostControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UITextField *descriptionTextField;
@property (strong, nonatomic) UIButton *postButton;


@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.descriptionLabel];
    [self.view addSubview:self.descriptionTextField];
    [self.view addSubview:self.postButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 45.0)];
        _descriptionLabel.text = @"Description";
    }
    
    return _descriptionLabel;
}

- (UITextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[UITextField alloc] initWithFrame:CGRectMake(10,
                                                                              ( self.descriptionLabel.frame.size.height + 20 ),
                                                                              SCREEN_WIDTH-20, 45.0)];
                _descriptionTextField.delegate = self;
        _descriptionTextField.returnKeyType = UIReturnKeyDone;
        _descriptionTextField.borderStyle = UITextBorderStyleLine;
        _descriptionTextField.placeholder = @"Optional";
    }
    
    return _descriptionTextField;
}


- (UIButton *)postButton {
    if(!_postButton) {
        _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _postButton.frame = CGRectMake(self.descriptionTextField.frame.origin.x,
                                        (self.descriptionTextField.frame.origin.y + self.descriptionTextField.frame.size.height + 20 ),
                                        self.descriptionTextField.frame.size.width,
                                        self.descriptionTextField.frame.size.height);

        _postButton.backgroundColor = RGB(34, 123, 129);
        
        [_postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_postButton setTitle:@"POST" forState:UIControlStateNormal];
        [_postButton addTarget:self action:@selector(postButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postButton;
}


- (void)postButtonAction:(id)sender
{
    NSLog(@"TOKEN : %@", _appDelegate.currentUser.authenticationToken);
    PostDM *post = [[PostDM alloc] init];
    post.category = [self categoryName:self.category];
    post.latitude = _appDelegate.currentLocationCoordinate.x;
    post.longitude = _appDelegate.currentLocationCoordinate.y;
    post.details   = self.descriptionTextField.text;
    [PostController createPostWithDelegate:self post:post userToken:@"zgGZwkG72YjJYoTv4xQK"];
}

- (NSString *)categoryName: (int)i {
    switch (i) {
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self postButtonAction:nil];
    return YES;
}
@end
