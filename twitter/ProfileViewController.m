//
//  ProfileViewController.m
//  twitter
//
//  Created by Taomin Chang on 10/12/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()
@property (strong, nonatomic) NSDictionary* userInfo;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userId;
@property (strong, nonatomic) IBOutlet UILabel *userDescriptions;
@property (strong, nonatomic) IBOutlet UILabel *tweetCnt;
@property (strong, nonatomic) IBOutlet UILabel *followingCnt;
@property (strong, nonatomic) IBOutlet UILabel *followerCnt;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.headerImage setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_banners/7250232/1398660752/1500x500"]];
    
    [self updateProfileView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    [self.userDescriptions sizeToFit];
    CGRect contentRect = CGRectZero;
    
    for (UIView *subview in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, subview.frame);
    }
    
    self.scrollView.contentSize = contentRect.size;
    self.scrollView.bounces = YES;
    
}

- (void)setProfileUserData : (NSDictionary *) userInfo {
    self.userInfo = userInfo;
}

- (void)updateProfileView {
    [self.headerImage setImageWithURL:[NSURL URLWithString:self.userInfo[@"profile_banner_url"]]];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.userInfo[@"profile_image_url_https"]]];
    self.userName.text = self.userInfo[@"name"];
    self.userId.text = self.userInfo[@"screen_name"];
    self.userDescriptions.text = self.userInfo[@"description"];
    self.followerCnt.text = [NSString stringWithFormat:@"%@", self.userInfo[@"followers_count"]];
    self.followingCnt.text = [NSString stringWithFormat:@"%@", self.userInfo[@"friends_count"]];
    self.tweetCnt.text = [NSString stringWithFormat:@"%@", self.userInfo[@"statuses_count"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
