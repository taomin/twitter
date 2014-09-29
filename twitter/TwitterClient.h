//
//  TwitterClient.h
//  twitter
//
//  Created by Taomin Chang on 9/27/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+(TwitterClient*) getTwitterClient;

@end
