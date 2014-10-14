//
//  PanelController.m
//  twitter
//
//  Created by Taomin Chang on 10/12/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "PanelController.h"
#import "TimelineViewController.h"
#import "MenuController.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileViewController.h"
#import "MentionsViewController.h"

@interface PanelController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainViewoffsetX;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *tabView;
@property (strong, nonatomic) IBOutlet UIView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuWidthConstraint;

@property (strong, nonatomic) UINavigationController *timelineNVC;
@property (strong, nonatomic) UINavigationController *profileNVC;
@property (strong, nonatomic) UINavigationController *mentionsNVC;

@property (strong, nonatomic) UIViewController* currentVC;
@property BOOL menuOpen;
@property CGPoint touchStart;
@end

@implementation PanelController

- (id) init {
    self = [super init];
    if (self) {
        self.timelineVC = [TimelineViewController new];
        self.menuVC = [MenuController new];
        self.menuVC.delegate = self;
        self.mentionsVC = [MentionsViewController new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainViewoffsetX.constant = 0;
    self.menuOpen = NO;
    
    // set main view to timeline view
    [self loadTimelineView:NO];
    
    // add menu controller
    self.menuVC.view.frame = self.menuView.bounds;
    [self addChildViewController:self.menuVC];
    [self.menuView addSubview:self.menuVC.view];
    [self.menuVC didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUserInfo: (NSDictionary *) userInfo {
    self.timelineVC.userInfo = userInfo;
    [self.menuVC setupMenu:userInfo];
}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.tableView];
    
    if (sender.state == UIGestureRecognizerStateBegan) {

        self.touchStart = translation;

    } else if (sender.state == UIGestureRecognizerStateChanged) {

        CGFloat delta = translation.x - self.touchStart.x;

        if (!self.menuOpen && delta > 0 && delta < self.menuWidthConstraint.constant) {
            self.mainViewoffsetX.constant = delta;
        } else if (self.menuOpen && delta < 0 && delta > -1*self.menuWidthConstraint.constant) {
            self.mainViewoffsetX.constant = self.menuWidthConstraint.constant + delta;
        }
    
    } else if (sender.state == UIGestureRecognizerStateEnded) {

        CGFloat delta = translation.x - self.touchStart.x;
        
        if (!self.menuOpen && delta > 0) {
            [self openMenu];
        } else if (self.menuOpen && delta < 0) {
            [self closeMenu:YES];
        }
    }
    
}

- (void)openMenu {
    
    [UIView animateWithDuration:0.35 animations:^{
        self.mainViewoffsetX.constant = self.menuWidthConstraint.constant;
        [self.view layoutIfNeeded];
    }];
    
    self.menuOpen = YES;

}

- (void)closeMenu:(BOOL)isAnimated {

    if (isAnimated) {
        [UIView animateWithDuration:0.35 animations:^{
            self.mainViewoffsetX.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
    self.menuOpen = NO;
}


- (void)loadViewInMainTable:(UIViewController *)vc {
    [self loadViewInMainTable:vc animated:YES];
}

- (void)loadViewInMainTable:(UIViewController *)vc animated:(BOOL)isAnimated {
    if (self.currentVC != nil) {
        [self.currentVC willMoveToParentViewController:nil];
        [self.currentVC didMoveToParentViewController:nil];
    }

    vc.view.frame = self.tableView.bounds;
    [self addChildViewController:vc];
    [self.tableView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    self.currentVC = vc;
    [self closeMenu:isAnimated];
}

- (void)loadProfileView: (NSDictionary *)userInfo {
    
    self.profileVC = [ProfileViewController new];
    [self.profileVC setProfileUserData:userInfo];
    self.profileNVC = [[UINavigationController alloc] initWithRootViewController:self.profileVC];
    [self loadViewInMainTable: self.profileNVC];
}

- (void)loadTimelineView {
    [self loadTimelineView:YES];
}

- (void)loadTimelineView:(BOOL)isAnimated{
    if (self.timelineNVC == nil) {
        self.timelineNVC = [[UINavigationController alloc] initWithRootViewController:self.timelineVC];
    }
    [self loadViewInMainTable:self.timelineNVC animated:isAnimated];
}


- (void)loadMentionsView {
    if (self.mentionsNVC == nil) {
        self.mentionsNVC = [[UINavigationController alloc] initWithRootViewController:self.mentionsVC];
    }

    [self loadViewInMainTable: self.mentionsNVC];
}

@end
