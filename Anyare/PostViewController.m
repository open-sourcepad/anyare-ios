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

@interface PostViewController ()
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UITextField *descriptionTextField;
@property (strong, nonatomic) UIButton *postButton;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.descriptionTextField];
    [self.view addSubview:self.postButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 45.0)];
//        _descriptionTextField.delegate = self;
        _descriptionTextField.returnKeyType = UIReturnKeyDone;
        _descriptionTextField.placeholder = @"Description";
    }
    
    return _descriptionTextField;
}


- (UIButton *)postButton {
    if(!_postButton) {
        _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _postButton.frame = CGRectMake(self.descriptionTextField.frame.origin.x,
                                        ( self.descriptionTextField.frame.size.height + 20 ),
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
//    PostDM *post = [[PostDM alloc] init];
//    post.category = self.category;
//    post.location = @"";
//    [PostController createPostWithDelegate:self post:post userToken:_appDelegate.currentUser];
}

@end
