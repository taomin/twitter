//
//  MenuController.m
//  twitter
//
//  Created by Taomin Chang on 10/12/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "MenuController.h"
#import "UIImageView+AFNetworking.h"

@interface MenuController ()

@property (strong, nonatomic) NSDictionary *userInfo;
@end

@implementation MenuController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupMenu:(NSDictionary *)userInfo {
    
    self.userInfo = userInfo;
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.userInfo[@"profile_image_url_https"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchToProfile:(id)sender {
    [self.delegate loadProfileView:self.userInfo];
}
- (IBAction)switchToTimeline:(id)sender {
    [self.delegate loadTimelineView];
}
- (IBAction)switchToMentions:(id)sender {
    [self.delegate loadMentionsView];
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
