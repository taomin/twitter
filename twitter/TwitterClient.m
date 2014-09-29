//
//  TwitterClient.m
//  twitter
//
//  Created by Taomin Chang on 9/27/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

+(TwitterClient*) getTwitterClient {
    static TwitterClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"uW3fDcvZnoKd2rFRWSIkFDkVl" consumerSecret:@"qaFyUdzxqcS5QU4cG0ylYVoNE1cRixHALNFKmQ4lfy0UXLwMjJ"];
        
    });
    return client;
}

@end
