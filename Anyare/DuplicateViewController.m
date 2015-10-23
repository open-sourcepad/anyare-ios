//
//  DuplicateViewController.m
//  Anyare
//
//  Created by Rodel Medina on 10/23/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "DuplicateViewController.h"
#import "PostTableViewCell.h"

@interface DuplicateViewController ()  <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *mainTableView;
@end

@implementation DuplicateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.mainTableView];
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
    return self.posts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostCell";
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell createCellWithPost:[_posts objectAtIndex:indexPath.row]];
    return cell;
}



@end