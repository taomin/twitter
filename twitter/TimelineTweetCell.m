//
//  TimelineTweetCell.m
//  twitter
//
//  Created by Taomin Chang on 9/27/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "TimelineTweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@implementation TimelineTweetCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweetData:(NSDictionary *)tweet {
    self.tweet = tweet;
    [self.profileImage setImageWithURL:[NSURL URLWithString:tweet[@"user"][@"profile_image_url_https"]]];
    self.userName.text = tweet[@"user"][@"name"];
    self.userName.font = [UIFont boldSystemFontOfSize:15.0f];
    self.tweetContent.text = tweet[@"text"];
    self.tweetContent.font = [UIFont systemFontOfSize:14.0f];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%@", tweet[@"retweet_count"]];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%@", tweet[@"favorite_count"]];

    [self.tweetContent sizeToFit];
    self.tweetContentHeightConstraint.constant = self.tweetContent.frame.size.height;
    NSLog(@"tweet user: %@, content height: %f", self.tweet[@"user"][@"name"], self.tweetContentHeightConstraint.constant);

}
- (IBAction)onReply:(id)sender {
    [self.delegate replyTweet:self.tweet];
}

- (IBAction)onRetweet:(id)sender {
    
    TwitterClient *twitterClient = [TwitterClient getTwitterClient];
    
    NSDictionary *params = @{@"id": self.tweet[@"id"]};
    
    NSLog(@"retweet with config: %@", params);
    
    [twitterClient POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", self.tweet[@"id"]] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // success
        
        NSLog(@"successfully retweeted, response %@", responseObject);
        
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", ([self.tweet[@"retweet_count"] integerValue] + 1)];

        [self.retweetButton setEnabled:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // fail
    }];
    
}
- (IBAction)onFavorite:(id)sender {
    TwitterClient *twitterClient = [TwitterClient getTwitterClient];
    
    NSDictionary *params = @{@"id": self.tweet[@"id"]};
    
    NSLog(@"favorite with config: %@", params);
    
    [twitterClient POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // success
        
        NSLog(@"successfully retweeted, response %@", responseObject);
        
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", ([self.tweet[@"favorite_count"] integerValue] + 1)];
        
        [self.favoriteButton setEnabled:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // fail
    }];

}

@end
