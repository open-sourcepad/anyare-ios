//
//  PostViewController.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "PostViewController.h"
#import "MapViewController.h"
#import "Constants.h"
#import "PostController.h"
#import "DuplicateViewController.h"
#import "PostDM.h"
#import "AppDelegate.h"
#import "UserDM.h"
#import "Helpers.h"

@interface PostViewController () <PostControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIImageView *categoryView;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UITextField *descriptionTextField;
@property (strong, nonatomic) UIButton *takePhotoButton;
@property (strong, nonatomic) UIButton *chooseButton;
@property (strong, nonatomic) UIButton *postButton;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) PostDM *post;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     _post = [[PostDM alloc] init];
    _post.category = [Helpers intToCategoryName:self.category];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.descriptionLabel];
    [self.view addSubview:self.descriptionTextField];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.takePhotoButton];
    [self.view addSubview:self.chooseButton];
    [self.view addSubview:self.postButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)categoryView {
    if(!_categoryView) {
        CGFloat dimension = 45.0;
        _categoryView = [[UIImageView alloc] initWithFrame:CGRectMake(10,
                                                                      20,
                                                                      dimension, dimension)];
        _categoryView.image = [Helpers intToCategoryImage:self.category];

        _categoryView.clipsToBounds = YES;
    }
    return _categoryView;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.categoryView.frame.size.width + self.categoryView.frame.origin.x + 5, 20, SCREEN_WIDTH-20, 45.0)];
        _descriptionLabel.text = @"Description";
    }
    
    return _descriptionLabel;
}

- (UITextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[UITextField alloc] initWithFrame:CGRectMake(10,
                                                                              ( self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height + 20 ),
                                                                              SCREEN_WIDTH-20, 45.0)];
                _descriptionTextField.delegate = self;
        _descriptionTextField.returnKeyType = UIReturnKeyDone;
        _descriptionTextField.borderStyle = UITextBorderStyleLine;
        _descriptionTextField.placeholder = @"Optional";
    }
    
    return _descriptionTextField;
}

- (UIImageView *)imageView {
    if(!_imageView) {
        CGFloat dimension = 100.0;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2) - (dimension/2),
                                                                       ( self.descriptionTextField.frame.origin.y + self.descriptionTextField.frame.size.height + 20 ),
                                                                       dimension, dimension)];
        _imageView.backgroundColor = [UIColor grayColor];
        _imageView.layer.cornerRadius = _imageView.frame.size.width/2;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)takePhotoButton {
    if(!_takePhotoButton) {
        _takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _takePhotoButton.frame = CGRectMake(self.descriptionTextField.frame.origin.x,
                                       (self.imageView.frame.origin.y + self.imageView.frame.size.height + 20 ),
                                       (self.descriptionTextField.frame.size.width/2)-1,
                                       self.descriptionTextField.frame.size.height);
        
        _takePhotoButton.backgroundColor = COLOR_THEME;
        
        [_takePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_takePhotoButton setTitle:@"Take Photo" forState:UIControlStateNormal];
        [_takePhotoButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoButton;
}

- (UIButton *)chooseButton {
    if(!_chooseButton) {
        _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseButton.frame = CGRectMake(self.takePhotoButton.frame.origin.x + self.takePhotoButton.frame.size.width + 1,
                                       (self.imageView.frame.origin.y + self.imageView.frame.size.height + 20 ),
                                       self.takePhotoButton.frame.size.width,
                                       self.takePhotoButton.frame.size.height);
        
        _chooseButton.backgroundColor = COLOR_THEME;
        
        [_chooseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_chooseButton setTitle:@"Choose Photo" forState:UIControlStateNormal];
        [_chooseButton addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseButton;
}

- (UIButton *)postButton {
    if(!_postButton) {
        _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _postButton.frame = CGRectMake(self.takePhotoButton.frame.origin.x,
                                        (self.takePhotoButton.frame.origin.y + self.takePhotoButton.frame.size.height + 20 ),
                                        self.descriptionTextField.frame.size.width,
                                        self.descriptionTextField.frame.size.height);

        _postButton.backgroundColor = COLOR_THEME;
        
        [_postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_postButton setTitle:@"POST" forState:UIControlStateNormal];
        [_postButton addTarget:self action:@selector(postButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postButton;
}


- (void)postButtonAction:(id)sender
{
    _post.latitude = _appDelegate.currentLocationCoordinate.x;
    _post.longitude = _appDelegate.currentLocationCoordinate.y;
    _post.details   = self.descriptionTextField.text;
    [PostController createPostWithDelegate:self post:_post userToken:_appDelegate.currentUser.authenticationToken];
}

- (void)gotoDuplicateCtrl: (NSMutableArray *)posts
{
    DuplicateViewController *ctrl = [[DuplicateViewController alloc] init];
    ctrl.posts = posts;
    [self.navigationController pushViewController:ctrl animated:YES];
    ctrl = nil;
}

- (void)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self postButtonAction:nil];
    return YES;
}

- (void)createPostDidFinish:(PostController *)controller resultDict:(NSDictionary *)resultDict
{
    BOOL isNewPost = [[resultDict objectForKey:@"new_post"] boolValue];
    
    if (isNewPost) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSDictionary *data = [resultDict objectForKey:@"data"];
        NSArray *arr = [PostDM getPostsFromArray:(NSArray *)data];
        NSMutableArray *posts = [arr mutableCopy];
        [self gotoDuplicateCtrl:posts];
    }
    
    // Force map reload after posting
    [_appDelegate.mapVC reloadMapAt:_appDelegate.currentLocationCoordinate];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    _post.image = chosenImage;
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
