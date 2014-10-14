//
//  ComposeViewController.m
//  twitter
//
//  Created by Taomin Chang on 9/29/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UITextView *composeText;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userId;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) NSString *replyUserId;
@property (nonatomic) NSInteger replyTweetId;
@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.replyTweetId = -1;
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.userInfo[@"profile_image_url_https"]]];

    [self setUpNavigationBar];

    self.userName.text = self.userInfo[@"name"];
    self.userId.text = self.userInfo[@"screen_name"];
    
    if (self.replyUserId != nil) {
        self.composeText.text = [NSString stringWithFormat:@"@%@ ", self.replyUserId];
    }
    
    NSLog(@"image url %@", self.userInfo[@"profile_image_url"]);
    [self.composeText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTweetUserInfo:(NSDictionary *)userInfo {
    self.userInfo = userInfo;
}

- (void)setReplyTweet:(NSString *)userId replyTo:(NSInteger )tweetId {
    if (userId != nil) {
        self.replyTweetId = tweetId;
        self.replyUserId = userId;
    }
}

- (void)postTweet {
//    NSLog(@"ready to post tweet: %@", self.composeText.text);
    
    TwitterClient *twitterClient = [TwitterClient getTwitterClient];
    
    NSMutableDictionary *params = [@{@"status": self.composeText.text} mutableCopy];
    if (self.replyTweetId != -1) {
        [params setObject:@(self.replyTweetId) forKey:@"in_reply_to_status_id"];
    }
    
    NSLog(@"post tweet with config: %@", params);
    
    [twitterClient POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // success
        
//        NSLog(@"successfully post a tweet, response %@", responseObject);
        NSDictionary *tweet = responseObject;
        
        [self dismissViewControllerAnimated:YES completion:^{
            // NSLog(@"dismissed view, inserting tweet into timeline");
            [self.delegate addNewTweet:tweet];
        }];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // fail
    }];

}

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:^{
        // NSLog(@"dismissed");
    }];
}


- (void)setUpNavigationBar {
    // navigation bar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(237/255.0) green:(237/255.0) blue:(237/255.0) alpha:1];
    
    // Cancel button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:(109/255.0) green:(177/255.0) blue:(232/255.0) alpha:1] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    cancelButton.frame=CGRectMake(-20.0, 0.0, 75.0, 20.0);
    [cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    [leftView addSubview:cancelButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    // Tweet button
    UIButton *newpostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newpostButton setTitle:@"Tweet" forState:UIControlStateNormal];
    [newpostButton setTitleColor:[UIColor colorWithRed:(109/255.0) green:(177/255.0) blue:(232/255.0) alpha:1] forState:UIControlStateNormal];
    [newpostButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    newpostButton.frame=CGRectMake(0.0, 0.0, 40.0, 20.0);
    [newpostButton addTarget:self action:@selector(postTweet) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 20.0)];
    [rightView addSubview:newpostButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}




@end
