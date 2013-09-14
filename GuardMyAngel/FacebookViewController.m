//
//  FacebookViewController.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookViewController.h"
#import "FacebookManager.h"
#import "Logger.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

#import "AddressbookController.h"
#import "LocalNotificationManager.h"
#import "TimerManager.h"

@interface FacebookViewController()<FacebookManagerDelegate,AddressbookDelegate,TimerDelegate>

@property (nonatomic, strong) TimerManager *timerManager;

@end

@implementation FacebookViewController

@synthesize infoTextField = _infoTextField;
@synthesize timerLabel = _timerLabel;
@synthesize timerManager = _timerManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [self setInfoTextField:nil];
    [self setTimerLabel:nil];
    [super viewDidUnload];
}

-(void)setTimerLabelValue
{
    DLog(@"");
}

-(void)viewWillAppear:(BOOL)animated
{
}

-(void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

# pragma mark - TimerDelegate
-(void)timerUpdatedWithValue:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds timeout:(BOOL)timeout
{
    
    if (timeout) {
        DLog(@"TIME OUT");
    }
    DLog(@" -TIMER- %@", [NSString stringWithFormat:@"%d : %d : %d",hours,minutes,seconds]);
    self.timerLabel.text = [NSString stringWithFormat:@"%d : %d : %d",hours,minutes,seconds];
}

# pragma mark - Action Functions

- (IBAction)printFacebookInfo:(id)sender 
{
    FacebookManager *facebookManager = [FacebookManager sharedFacebookManager];
    facebookManager.delegate = self;
    [facebookManager requestUserInfo];
}

- (IBAction)postToFacebook:(id)sender 
{
    FacebookManager *facebookManager = [FacebookManager sharedFacebookManager];
    facebookManager.delegate = self;
    [facebookManager shareDialogFeed];
}
- (IBAction)facebookLogout:(id)sender
{
    FacebookManager *facebookManager = [FacebookManager sharedFacebookManager];
    facebookManager.delegate = self;
    [facebookManager logout];
}
- (IBAction)addressbookPressed:(id)sender 
{
    
}
- (IBAction)scheduleLocalNotificaion:(id)sender 
{
    [LocalNotificationManager scheduleLocalNotificationWithTimeout:10];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Addressbook"]) {
        AddressbookController *addressbookController = (AddressbookController *)segue.destinationViewController;
        addressbookController.delegate = self;
    }
}
- (IBAction)suspendTimer:(id)sender
{
    [self.timerManager suspendTimer];
}
- (void)reactivateTimerManager
{
    TimerState state = [self.timerManager reactivateTimer];
    switch (state) {
        case TIMER_RUNNING:
            DLog(@"TIMER_RUNNING");
            break;
        case TIMER_DEACTIVATED:
            DLog(@"TIMER_DEACTIVATED");
            break;
        case TIMER_TIMEDOUT_IN_BACKGROUND:
            DLog(@"TIMER_TIMEDOUT_IN_BACKGROUND");
            break;
        default:
            break;
    }
}

- (IBAction)reactivateTimer:(id)sender
{
    [self reactivateTimerManager];
}
- (IBAction)newTimer:(id)sender
{
    self.timerManager = [[TimerManager alloc]initWithTimeout:0 minutes:0 seconds:30 delegate:self];
}


# pragma mark - FacebookManagerDelegate

-(void)facebookUserEntityUpdated:(FacebookUserEntity *)user
{
    DLog(@"Returned User: %@", user);
}
-(void)facebookLoginFailedWithError:(FacebookErrorDescription)errorDescription
{
    DLog(@"Failed with Error: %i", errorDescription);
}

# pragma mark - Twitter

- (IBAction)tweet:(id)sender {
    if ([self canTweet]) {
        [self sendTweet];
    }
}

# pragma mark - AddressbookDelegate
-(void)addressbookCancelled
{
    DLog(@"");
}
-(void)addressbookEmail:(AddressbookEntity *)entity
{
    DLog(@"%@", entity);
}
-(void)addressbookSMS:(AddressbookEntity *)entity
{
    DLog(@"%@", entity);
}
-(void)addressbookFailedWithError:(AddressbookErrorType)error
{
    DLog(@"%d", error);
}

# pragma mark -
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog(@"applicationDidEnterBackground");
    [self.timerManager suspendTimer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLog(@"applicationWillEnterForeground");
    [self reactivateTimerManager];
}
@end
