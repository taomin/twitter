//
//  PanelController.h
//  twitter
//
//  Created by Taomin Chang on 10/12/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineViewController.h"
#import "MenuController.h"
#import "ProfileViewController.h"
#import "MentionsViewController.h"

@interface PanelController : UIViewController <MenuControllerDelegate>
@property (strong, nonatomic) TimelineViewController *timelineVC;
@property (strong, nonatomic) MenuController *menuVC;
@property (strong, nonatomic) ProfileViewController* profileVC;
@property (strong, nonatomic) MentionsViewController* mentionsVC;
-(void) setUserInfo: (NSDictionary *) userInfo;
@end
