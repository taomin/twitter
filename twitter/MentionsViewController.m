//
//  MentionsViewController.m
//  twitter
//
//  Created by Taomin Chang on 10/12/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "MentionsViewController.h"
#import "TimelineTweetCell.h"
#import "TwitterClient.h"

@interface MentionsViewController ()
@property (strong, nonatomic) NSArray *mentions;
@property (strong, nonatomic) TwitterClient *twitterClient;
@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.mentionsTable.dataSource = self;
    self.mentionsTable.delegate = self;
    [self.mentionsTable registerNib:[UINib nibWithNibName:@"TimelineTweetCell" bundle:nil] forCellReuseIdentifier:@"TimelineTweetCell"];
    self.mentionsTable.rowHeight = UITableViewAutomaticDimension;
    [self setUpNavigationBar];
    [self reloadMentions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)reloadMentions {
    
    self.twitterClient = [TwitterClient getTwitterClient];
    [self.twitterClient GET:@"1.1/statuses/mentions_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.mentions = responseObject;
        [self.mentionsTable reloadData];
//        [self.refreshCtrl endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to get mentions");
    }
     ];
}

- (void)setUpNavigationBar {
    // navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(116/255.0) green:(195/255.0) blue:(224/255.0) alpha:0.8];
    self.navigationItem.title = @"Mentions";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.mentions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimelineTweetCell *cell = [self.mentionsTable dequeueReusableCellWithIdentifier:@"TimelineTweetCell"];
    NSDictionary *tweet = self.mentions[indexPath.row];
    [cell setTweetData:tweet];
//    cell.delegate = self;
    return cell;
    
}


@end
