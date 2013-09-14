//
//  TwitterViewController.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface TwitterViewController : UIViewController
- (BOOL) canTweet;
- (void) sendTweet;
@end
