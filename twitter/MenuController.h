//
//  MenuController.h
//  twitter
//
//  Created by Taomin Chang on 10/12/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuController;
@protocol MenuControllerDelegate <NSObject>
- (void)loadProfileView:(NSDictionary *)userInfo;
- (void)loadTimelineView;
- (void)loadMentionsView;
@end

@interface MenuController : UIViewController
- (void)setupMenu:(NSDictionary *)userInfo;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (nonatomic, weak) id <MenuControllerDelegate> delegate;
@end
