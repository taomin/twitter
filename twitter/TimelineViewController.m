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

@interface TimelineViewController ()
@property (strong, nonatomic) IBOutlet UITableView *timelineTable;
@property (strong, nonatomic) NSArray *feed;

@end

@implementation TimelineViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        TwitterClient *twitterClient = [TwitterClient getTwitterClient];
        [twitterClient GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"fetched twitter timeline %@", responseObject);
            self.feed = responseObject;
            [self.timelineTable reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to get timeline");
        }
         ];
    }
    
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.timelineTable.dataSource = self;
    self.timelineTable.delegate = self;
    [self.timelineTable registerNib:[UINib nibWithNibName:@"TimelineTweetCell" bundle:nil] forCellReuseIdentifier:@"TimelineTweetCell"];
    self.timelineTable.rowHeight = UITableViewAutomaticDimension;

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

@end
