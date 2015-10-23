//
//  TimelineViewController.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "TimelineViewController.h"
#import "PostTableViewCell.h"
#import "PostController.h"
#import "AppDelegate.h"
#import "UserDM.h"
#import "PostDM.h"
#import "Constants.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, PostControllerDelegate>
@property (strong, nonatomic) UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) AppDelegate *appDelegate;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.view addSubview:self.mainTableView];
    self.navTitle = @"Timeline";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view bringSubviewToFront:self.postButton];
    [_mainTableView reloadData];
    
    if(!self.posts.count) {
        [PostController getPostsInLocationWithDelegate:self
                                              location:_appDelegate.currentLocationCoordinate
                                             authToken:_appDelegate.currentUser.authenticationToken];
    }
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

#pragma mark - Post Controller Delegate
- (void)getPostsDidFinish:(PostController *)controller resultDict:(NSDictionary *)resultDict
{
    _posts = [NSMutableArray arrayWithArray:[PostDM getPostsFromArray:(NSArray *)resultDict]];
    [_mainTableView reloadData];
}
@end
