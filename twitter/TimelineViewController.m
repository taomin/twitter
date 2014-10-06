//
//  TimelineViewController.m
//  twitter
//
//  Created by Taomin Chang on 9/27/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "TimelineViewController.h"
#import "TwitterClient.h"
#import "TimelineTweetCell.h"
#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "LoginViewController.h"

NSInteger const SCROLL_BUFFER = 5;

@interface TimelineViewController ()
@property (strong, nonatomic) IBOutlet UITableView *timelineTable;
@property (strong, nonatomic) NSArray *feed;
@property (nonatomic) BOOL isFetching;
@property (strong, nonatomic) TwitterClient* twitterClient;
@property (strong, nonatomic) UIRefreshControl* refreshCtrl;


@end

@implementation TimelineViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self reloadFeed];
    }
    
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.timelineTable.dataSource = self;
    self.timelineTable.delegate = self;
    self.isFetching = NO;
    [self.timelineTable registerNib:[UINib nibWithNibName:@"TimelineTweetCell" bundle:nil] forCellReuseIdentifier:@"TimelineTweetCell"];
    self.timelineTable.rowHeight = UITableViewAutomaticDimension;
    [self setUpNavigationBar];
    
    self.refreshCtrl = [UIRefreshControl new];
    [self.refreshCtrl addTarget:self action:@selector(reloadFeed) forControlEvents:UIControlEventValueChanged];
    [self.timelineTable addSubview:self.refreshCtrl];

}

- (void)reloadFeed {

    self.twitterClient = [TwitterClient getTwitterClient];
    [self.twitterClient GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"fetched twitter timeline %@", responseObject);
        self.feed = responseObject;
        [self.timelineTable reloadData];
        [self.refreshCtrl endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to get timeline");
    }
     ];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.feed count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimelineTweetCell *cell = [self.timelineTable dequeueReusableCellWithIdentifier:@"TimelineTweetCell"];
    NSDictionary *tweet = self.feed[indexPath.row];
    [cell setTweetData:tweet];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetViewController *tvc = [TweetViewController new];
    [tvc setTweet:self.feed[indexPath.row]];
    [self.navigationController pushViewController:tvc animated:YES];
    [self.timelineTable reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.timelineTable reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // load more
    if (indexPath.row + SCROLL_BUFFER >= [self.feed count]) {
        NSLog(@"row %ld, scrollbuffer %ld, count %ld", indexPath.row, SCROLL_BUFFER, [self.feed count]);
        
        // make a call
        [self loadNextBatch];
    }

}


- (void)loadNextBatch {
    if (self.isFetching) { return; }
    self.isFetching = YES;
    
    NSInteger size = [self.feed count];
    NSDictionary *lastItem = self.feed[(size - 1)];
    NSString *lastItemId = lastItem[@"id_str"];

    [self.twitterClient GET:@"1.1/statuses/home_timeline.json" parameters:@{@"max_id": lastItemId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"fetched twitter timeline");
        self.feed = [self.feed arrayByAddingObjectsFromArray:responseObject];
        [self.timelineTable reloadData];
        
        // set isFetching to NO after a sec (after reload finished)
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:[NSBlockOperation blockOperationWithBlock:^{
            self.isFetching = NO;
//            NSLog(@"is fetching : no");
                                        }]
                                       selector:@selector(main)
                                       userInfo:nil
                                        repeats:NO
        ];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to get timeline");
        self.isFetching = NO;
    }
     ];

}

- (void)addNewTweet:(NSDictionary *)tweet {
//    NSLog(@"got a new tweet! %@", tweet);
    NSMutableArray *newFeed = [self.feed mutableCopy];
    [newFeed insertObject:tweet atIndex:0];
    self.feed = newFeed;
    [self.timelineTable reloadData];
}

- (void)onCompose {
    
    ComposeViewController *cvc = [ComposeViewController new];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    
    NSLog(@"do i have user info ? %@", self.userInfo);
    [cvc setTweetUserInfo:self.userInfo];
    cvc.delegate = self;
    [self.navigationController presentViewController:nvc animated:YES completion:nil];

}

- (void)onSignOut {

    NSLog(@"Signed out");
    [self.twitterClient.requestSerializer removeAccessToken];
    LoginViewController *loginVC = [LoginViewController new];
    
    [self presentViewController:loginVC animated:YES completion:nil];
    
}

- (void)setUpNavigationBar {
    // navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(116/255.0) green:(195/255.0) blue:(224/255.0) alpha:0.8];
    self.navigationItem.title = @"Timeline";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // SignOut button
    UIButton *signoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signoutButton setTitle:@"SignOut" forState:UIControlStateNormal];
    [signoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signoutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    signoutButton.frame=CGRectMake(-10.0, 0.0, 75.0, 20.0);
    signoutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [signoutButton addTarget:self action:@selector(onSignOut) forControlEvents:UIControlEventTouchUpInside];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 20.0)];
    [leftView addSubview:signoutButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];

    // NewPost button
    UIButton *newpostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newpostButton setTitle:@"New" forState:UIControlStateNormal];
    [newpostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newpostButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    newpostButton.frame=CGRectMake(5.0, 0.0, 40.0, 20.0);
    [newpostButton addTarget:self action:@selector(onCompose) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 20.0)];
    [rightView addSubview:newpostButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}



@end
