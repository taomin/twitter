//
//  TweetViewController.h
//  twitter
//
//  Created by Taomin Chang on 9/28/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TweetViewController;

@protocol TweetDelegate <NSObject>
- (void)replyTweet:(NSDictionary *)tweet;
@end


@interface TweetViewController : UIViewController

@property (nonatomic, weak) id <TweetDelegate> delegate;
-(void)setTweet:(NSDictionary *)tweet;

@end
