//
//  ComposeViewController.h
//  twitter
//
//  Created by Taomin Chang on 9/29/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComposeViewController;
@protocol ComposeViewControllerDelegate <NSObject>
- (void)addNewTweet:(NSDictionary *)tweet;
@end

@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id <ComposeViewControllerDelegate> delegate;
- (void)setTweetUserInfo:(NSDictionary *)userInfo;
@end
