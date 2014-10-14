//
//  MentionsViewController.h
//  twitter
//
//  Created by Taomin Chang on 10/12/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineTweetCell.h"

@interface MentionsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *mentionsTable;

@end
