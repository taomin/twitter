//
//  TimelineTweetCell.h
//  twitter
//
//  Created by Taomin Chang on 9/27/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimelineTweetViewController;

@protocol TimelineTweetDelegate <NSObject>
- (void)replyTweet:(NSDictionary *)tweet;
- (void)loadUserProfile: (NSInteger)userId userScreenName: (NSString *)screenName;
@end

@interface TimelineTweetCell : UITableViewCell
@property (strong, nonatomic) NSDictionary* tweet;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UITextView *tweetContent;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tweetContentHeightConstraint;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (strong, nonatomic) IBOutlet UIButton *retweetButton;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *timestamp;
@property (nonatomic, weak) id < TimelineTweetDelegate> delegate;
- (void)setTweetData:(NSDictionary *)tweet;
@end
