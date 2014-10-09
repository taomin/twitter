//
//  TweetViewController.m
//  twitter
//
//  Created by Taomin Chang on 9/28/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface TweetViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userId;
@property (strong, nonatomic) IBOutlet UITextView *tweetContent;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *tweetView;
@property (strong, nonatomic) NSDictionary *tweetData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tweetViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *retweetCount;
@property (strong, nonatomic) IBOutlet UILabel *favoriteCount;
@property (strong, nonatomic) IBOutlet UIButton *retweetButton;
@property (strong, nonatomic) IBOutlet UIButton *replyBtn;
@property (strong, nonatomic) IBOutlet UIButton *retweetBtn;
@property (strong, nonatomic) IBOutlet UIButton *favoriteBtn;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTweetUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTweetUI {

    [self.navigationController.navigationBar setTintColor:[ UIColor whiteColor]];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.tweetData[@"user"][@"profile_image_url_https"]]];
    self.userName.text = self.tweetData[@"user"][@"name"];
    self.userName.font = [UIFont boldSystemFontOfSize:15.0f];
    self.tweetContent.text = self.tweetData[@"text"];
    self.tweetContent.font = [UIFont systemFontOfSize:14.0f];
    self.userId.text = [NSString stringWithFormat:@"@%@",self.tweetData[@"user"][@"screen_name"]];
    self.userId.font = [UIFont systemFontOfSize:14.0f];
    self.retweetCount.text = [NSString stringWithFormat:@"%@", self.tweetData[@"retweet_count"]];
    self.favoriteCount.text = [NSString stringWithFormat:@"%@", self.tweetData[@"favorite_count"]];
    
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    [self.tweetContent sizeToFit];
    
    self.tweetViewHeightConstraint.constant = self.tweetContent.frame.size.height;
    NSLog(@"tweet height: %f", self.tweetViewHeightConstraint.constant);
    
    CGRect contentRect = CGRectZero;
    
    
    for (UIView *subview in self.tweetView.subviews) {
        contentRect = CGRectUnion(contentRect, subview.frame);
    }
    
    self.scrollView.contentSize = contentRect.size;
    
}

-(void)setTweet:(NSDictionary *)tweet {
    
//    NSLog(@"tweet is %@", tweet);
    self.tweetData = tweet;

}
- (IBAction)onReply:(id)sender {
    [self.delegate replyTweet:self.tweetData];
}
- (IBAction)onRetweet:(id)sender {
    
    TwitterClient *twitterClient = [TwitterClient getTwitterClient];
    
    NSDictionary *params = @{@"id": self.tweetData[@"id"]};
    
    NSLog(@"retweet with config: %@", params);
    
    [twitterClient POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", self.tweetData[@"id"]] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // success
        
        NSLog(@"successfully retweeted, response %@", responseObject);
        
        self.retweetCount.text = [NSString stringWithFormat:@"%ld", ([self.tweetData[@"retweet_count"] integerValue] + 1)];
        
        [self.retweetBtn setEnabled:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // fail
    }];
    
}
- (IBAction)onFavorite:(id)sender {
    TwitterClient *twitterClient = [TwitterClient getTwitterClient];
    
    NSDictionary *params = @{@"id": self.tweetData[@"id"]};
    
    NSLog(@"favorite with config: %@", params);
    
    [twitterClient POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // success
        
        NSLog(@"successfully retweeted, response %@", responseObject);
        
        self.favoriteCount.text = [NSString stringWithFormat:@"%ld", ([self.tweetData[@"favorite_count"] integerValue] + 1)];
        
        [self.favoriteBtn setEnabled:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // fail
    }];
}

@end
