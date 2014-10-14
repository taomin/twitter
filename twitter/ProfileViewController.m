//
//  ProfileViewController.m
//  twitter
//
//  Created by Taomin Chang on 10/12/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "ProfileViewController.h"
#import "TimelineTweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"


@interface ProfileViewController ()
@property (strong, nonatomic) NSDictionary* userInfo;
@property (strong, nonatomic) NSArray* tweets;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userId;
@property (strong, nonatomic) IBOutlet UILabel *userDescriptions;
@property (strong, nonatomic) IBOutlet UILabel *tweetCnt;
@property (strong, nonatomic) IBOutlet UILabel *followingCnt;
@property (strong, nonatomic) IBOutlet UILabel *followerCnt;
@property (strong, nonatomic) IBOutlet UITableView *userTweetsTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userTweetTableHeight;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.headerImage setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_banners/7250232/1398660752/1500x500"]];
    [self updateProfileView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    [self.userDescriptions sizeToFit];
    CGRect contentRect = CGRectZero;
    
    for (UIView *subview in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, subview.frame);
    }
    
    self.scrollView.contentSize = contentRect.size;
    self.scrollView.bounces = YES;
    
}

- (void)setProfileUserData : (NSDictionary *) userInfo {
    self.userInfo = userInfo;
}

- (void)updateProfileView {
    self.title = @"Profile";
    [self.headerImage setImageWithURL:[NSURL URLWithString:self.userInfo[@"profile_banner_url"]]];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.userInfo[@"profile_image_url_https"]]];
    self.userName.text = self.userInfo[@"name"];
    self.userId.text = self.userInfo[@"screen_name"];
    self.userDescriptions.text = self.userInfo[@"description"];
    self.followerCnt.text = [NSString stringWithFormat:@"%@", self.userInfo[@"followers_count"]];
    self.followingCnt.text = [NSString stringWithFormat:@"%@", self.userInfo[@"friends_count"]];
    self.tweetCnt.text = [NSString stringWithFormat:@"%@", self.userInfo[@"statuses_count"]];
    
    //setup user tweets history
    self.userTweetsTable.delegate = self;
    self.userTweetsTable.dataSource = self;
    self.userTweetsTable.rowHeight = UITableViewAutomaticDimension;
    [self.userTweetsTable registerNib:[UINib nibWithNibName:@"TimelineTweetCell" bundle:nil] forCellReuseIdentifier:@"TimelineTweetCell"];
    [self loadUserTweets];
}

- (void)loadUserTweets {
    
    TwitterClient *twitterClient = [TwitterClient getTwitterClient];
    [twitterClient GET:@"1.1/statuses/user_timeline.json" parameters:@{@"count": @"20"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.tweets = responseObject;
                [self.userTweetsTable reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to get mentions");
    }
     ];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    self.userTweetTableHeight.constant = self.userTweetsTable.contentSize.height;
    [self viewDidLayoutSubviews];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"how mnay twetes ? %lu", (unsigned long)[self.tweets count]);
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimelineTweetCell *cell = [self.userTweetsTable dequeueReusableCellWithIdentifier:@"TimelineTweetCell"];
    NSDictionary *tweet = self.tweets[indexPath.row];
    [cell setTweetData:tweet];
    return cell;
}


@end
