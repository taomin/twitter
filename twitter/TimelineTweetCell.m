//
//  TimelineTweetCell.m
//  twitter
//
//  Created by Taomin Chang on 9/27/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "TimelineTweetCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TimelineTweetCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweetData:(NSDictionary *)tweet {
    [self.profileImage setImageWithURL:[NSURL URLWithString:tweet[@"user"][@"profile_image_url_https"]]];
    self.userName.text = tweet[@"user"][@"name"];
    self.userName.font = [UIFont boldSystemFontOfSize:15.0f];
    self.tweetContent.text = tweet[@"text"];
    self.tweetContent.font = [UIFont systemFontOfSize:14.0f];
}

@end
