//
//  TwitterViewController.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterViewController.h"
#import "Logger.h"

@interface TwitterViewController()

@end

@implementation TwitterViewController

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canTweetStatus) name:ACAccountStoreDidChangeNotification object:nil];

    [super viewDidLoad];
}

-(void)dealloc
{
    //[self removeObserver:self forKeyPath:ACAccountStoreDidChangeNotification];
}
# pragma mark - Methods

- (BOOL)canTweet {
    
    if ([TWTweetComposeViewController canSendTweet]) 
    {
        DLog(@"Can Tweet");
        return YES;
    } else 
    {
        DLog(@"Can't Tweet");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"twitterAccountNotAvailableTitle", @"") message:NSLocalizedString(@"twitterAccountNotAvailableMessage", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"twitterAccountNotAvailableCancelButton", @"") otherButtonTitles:NSLocalizedString(@"twitterAccountNotAvailableDoneTitle", @""), nil];
        [alert show];
        return NO;
    }
}

-(void) sendTweet
{
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    [tweetViewController setInitialText:NSLocalizedString(@"tweetMessage", @"")];
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                DLog(@"Tweet Cancelled");
                break;
            case TWTweetComposeViewControllerResultDone:
                DLog(@"Tweet Done");
                break;
            default:
                break;
        }
        [self dismissModalViewControllerAnimated:YES];
    }];
    [self presentModalViewController:tweetViewController animated:YES];
}

@end
