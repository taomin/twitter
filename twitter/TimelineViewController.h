//
//  TimelineViewController.h
//  twitter
//
//  Created by Taomin Chang on 9/27/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "TimelineTweetCell.h"

@interface TimelineViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ComposeViewControllerDelegate,TimelineTweetDelegate>
@property (strong, nonatomic) NSDictionary *userInfo;
@end
