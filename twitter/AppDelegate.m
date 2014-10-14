//
//  AppDelegate.m
//  twitter
//
//  Created by Taomin Chang on 9/27/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "AppDelegate.h"
#import "TwitterClient.h"
#import "TimelineViewController.h"
#import "LoginViewController.h"
#import "PanelController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(116/255.0) green:(195/255.0) blue:(224/255.0) alpha:0.8]];
    
    LoginViewController *vc = [LoginViewController new];

    //need to determine redirect user to login view or timeline view
    TwitterClient *twitterClient = [TwitterClient getTwitterClient];
    if (twitterClient.requestSerializer.accessToken != nil) {

        [self decideRootViewByVerifingAccessToken:twitterClient.requestSerializer.accessToken rootViewWindow:self.window];

    } else {
        // no access token, redirect to login view
        NSLog(@"try verifying access token");
        self.window.rootViewController = vc;
    }
  
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)decideRootViewByVerifingAccessToken:(BDBOAuthToken *)accessToken rootViewWindow:(UIWindow *)window {
    
    TwitterClient *twitterClient = [TwitterClient getTwitterClient];

    LoginViewController *lvc = [LoginViewController new];

    // a placeholder viewcontroller; let's set timeline view first
    PanelController *pvc = [PanelController new];
    window.rootViewController = pvc;
    
    [twitterClient GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resp = responseObject;
        if (resp[@"id"] != nil) {
            NSLog(@"credential verified %@", responseObject);
//            pvc.timelineVC.userInfo = resp;
            [pvc setUserInfo:resp];
        } else {
            NSLog(@"credential does not include id %@", responseObject);
            window.rootViewController = lvc;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to verify access token");
        window.rootViewController = lvc;
    }
     ];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    NSLog(@"query is %@", url.query);

    TwitterClient *twitterClient = [TwitterClient getTwitterClient];
    [twitterClient fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {

//        NSLog(@"got access token, %@", accessToken.token);
        [twitterClient.requestSerializer saveAccessToken:accessToken];
        [self decideRootViewByVerifingAccessToken:accessToken rootViewWindow:self.window];
        
    } failure:^(NSError *error) {
        NSLog(@"failed to get access token, details: %@", error.description);
    }];
    
    return true;
}

@end
