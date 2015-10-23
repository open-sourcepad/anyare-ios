//
//  DuplicateViewController.m
//  Anyare
//
//  Created by Rodel Medina on 10/23/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "DuplicateViewController.h"
#import "PostTableViewCell.h"
#import "PostController.h"
#import "Constants.h"
#import "PostDM.h"
#import "UserDM.h"
#import "AppDelegate.h"

@interface DuplicateViewController ()  <UITableViewDataSource, UITableViewDelegate, PostControllerDelegate>
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UITableView *mainTableView;
@end

@implementation DuplicateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Same Report?";
    [self.view addSubview:self.mainTableView];

    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mainTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors
- (UITableView *)mainTableView
{
    if(!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_mainTableView registerClass:[PostTableViewCell class] forCellReuseIdentifier:@"PostCell"];
    }
    return _mainTableView;
}

- (NSMutableArray *)posts {
    if(!_posts) {
        _posts = [[NSMutableArray alloc] init];
    }
    return _posts;
}

#pragma mark - Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _posts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check if post has details
    PostDM *post = [_posts objectAtIndex:indexPath.row];
    if(post.detailed)
        return TIMELINE_WITH_IMAGE_TEXT_CELL_ROW_HEIGHT;
    else if(post.details.length)
        return TIMELINE_WITH_TEXT_CELL_ROW_HEIGHT;
    else
        return TIMELINE_CELL_ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostCell";
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell createCellWithPost:[_posts objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostDM *post = [_posts objectAtIndex:indexPath.row];
    [PostController duplicatePostWithDelegate:self post:post userToken:_appDelegate.currentUser.authenticationToken];
}

- (void)duplicatePostDidFinish:(PostController *)controller resultDict:(NSDictionary *)resultDict
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
