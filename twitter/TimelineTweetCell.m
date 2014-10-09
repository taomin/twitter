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

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //Mon, 11 Jul 2011 00:00:00 +0200
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"EN"]];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss ZZZZ yyyy"];
    
//    NSLog(@"created at is %@", tweet[@"created_at"]);
//    NSLog(@"date is %@", [dateFormatter dateFromString: tweet[@"created_at"]]);
    NSTimeInterval dateDiff = -1 * [[dateFormatter dateFromString: tweet[@"created_at"]] timeIntervalSinceNow];
//    NSLog(@"relative time ? %@", (now - date));
    NSLog(@"time diff is %f", dateDiff);
    
    if (dateDiff < 60) {
        self.timestamp.text = [NSString stringWithFormat:@"%ds", (int) dateDiff];
    } else if (dateDiff < 120) {
        self.timestamp.text = [NSString stringWithFormat:@"1m"];
    } else if (dateDiff < 3600) {
        self.timestamp.text = [NSString stringWithFormat:@"%dms", (int)(dateDiff/60)];
    } else if (dateDiff < 7200) {
        self.timestamp.text = [NSString stringWithFormat:@"1h"];
    } else if (dateDiff < 86400) {
        self.timestamp.text = [NSString stringWithFormat:@"%dhrs", (int)(dateDiff/3600)];
    } else if (dateDiff < 172800) {
        self.timestamp.text = [NSString stringWithFormat:@"1d"];
    }
    
    
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
