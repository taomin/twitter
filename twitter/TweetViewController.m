//
//  TweetViewController.m
//  twitter
//
//  Created by Taomin Chang on 9/28/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userId;
@property (strong, nonatomic) IBOutlet UITextView *tweetContent;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *tweetView;
@property (strong, nonatomic) NSDictionary *tweetData;

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
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    [self.tweetContent sizeToFit];
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

@end
