//
//  TimerManager.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimerManager.h"
#import "TimerDelegate.h"
#import "Logger.h"

@interface TimerManager()

@property (nonatomic) NSInteger seconds;
@property (nonatomic) NSInteger minutes;
@property (nonatomic) NSInteger hours;
@property (nonatomic, strong) NSTimer *timer;

-(void) initializeTimerWithTimeout:(NSInteger) initialHours minutes:(NSInteger) initialMinutes seconds:(NSInteger)initialSeconds;
-(void) startTimer;
-(void) timerSingleUntiTimeOut;
-(TimerState) setTimerByComponents:(NSDateComponents *)components;
-(void) resetTimerComponents;
-(void) resetTimerDefaults;

@end

@implementation TimerManager

@synthesize seconds = _seconds;
@synthesize minutes = _minutes;
@synthesize hours = _hours;
@synthesize timer = _timer;
@synthesize delegate = _delegate;

-(id) initWithTimeout:(NSInteger) hours minutes:(NSInteger) minutes seconds:(NSInteger)seconds delegate:(id<TimerDelegate>)delegate
{
    self = [super init];
    if (self) 
    {
        self.delegate = delegate;
        [self initializeTimerWithTimeout:hours minutes:minutes seconds:seconds];
    }
    return self;
}

-(void)initializeTimerWithTimeout:(NSInteger)initialHours minutes:(NSInteger)initialMinutes seconds:(NSInteger)initialSeconds
{
    if (initialSeconds >= 0 && initialSeconds < 60) {
        self.seconds = initialSeconds;
    }
    
    if (initialMinutes >= 0 && initialMinutes < 60) {
        self.minutes = initialMinutes;
    }
    
    if (initialHours >= 0 && initialHours < 24) {
        self.hours = initialHours;
    }
    
    DLog(@" %d : %d : %d", self.hours,self.minutes,self.seconds);
    
    [self startTimer];
}

# define TIMER_TIMEOUT_PERIOD 1.0
-(void) startTimer
{
    // Reset local timer and defaults values
    [self resetTimerDefaults];
    // Deactivate timer if it is running
    [self deactivateTimer];
    // Update delegate
    [self.delegate timerUpdatedWithValue:self.hours minutes:self.minutes seconds:self.seconds timeout:NO];
    // Initialize new Timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_TIMEOUT_PERIOD target:self selector:@selector(timerSingleUntiTimeOut) userInfo:nil repeats:YES];
}

-(void) timerSingleUntiTimeOut
{
    // Check if seconds can be subtracted
    if (self.seconds >= TIMER_TIMEOUT_PERIOD) 
    {
        self.seconds -=TIMER_TIMEOUT_PERIOD;
    }
    else
    {
        // Try subtract from minutes
        if (self.minutes >= 1) 
        {
            self.minutes -= 1;
            self.seconds += (60-TIMER_TIMEOUT_PERIOD);
        }
        else
        {
            // Try subtract from hours
            if (self.hours >= 1) {
                
                self.hours -=1;
                self.minutes += 59;
                self.seconds += (60 - TIMER_TIMEOUT_PERIOD);
            }
        }
    }
    
    BOOL isTimeout = NO;
    if ((self.hours*60+self.minutes*60+self.seconds) < TIMER_TIMEOUT_PERIOD) {
        isTimeout = YES;
        [self resetTimerComponents]; // Reset to defaults
        [self deactivateTimer]; // Deactivate
    }
    
    [self.delegate timerUpdatedWithValue:self.hours minutes:self.minutes seconds:self.seconds timeout:isTimeout];
}

-(void) deactivateTimer
{
    [self.timer invalidate];
}

# define SAVED_AT_DATE_KEY @"savedAtDate"
# define TIMER_SAVED_KEY @"timerSavedAtDate"

-(void) suspendTimer
{
    // Define timer components
    NSDateComponents *timerDateComponents = [[NSDateComponents alloc]init];
    [timerDateComponents setHour:self.hours];
    [timerDateComponents setMinute:self.minutes];
    [timerDateComponents setSecond:self.seconds];
    
    // Get Current Date
    NSDate *currentDate = [NSDate date];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Save Current Date
    NSData *currentDateComponentsEncoded = [NSKeyedArchiver archivedDataWithRootObject:currentDate];
    [defaults setObject:currentDateComponentsEncoded forKey:SAVED_AT_DATE_KEY];
    
    // Save timer components
    NSData *timerDateComponentsEncoded = [NSKeyedArchiver archivedDataWithRootObject:timerDateComponents];
    [defaults setObject:timerDateComponentsEncoded forKey:TIMER_SAVED_KEY];
    
    [self deactivateTimer];
}


-(TimerState)reactivateTimer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Get Saved Previous Date
    NSData *savedDateEncoded = [defaults objectForKey:SAVED_AT_DATE_KEY];
    NSDate *savedDate = (NSDate *)[NSKeyedUnarchiver unarchiveObjectWithData: savedDateEncoded];
    
    // Get Saved Timer Components
    NSData *savedTimerDateComponentsEncoded = [defaults objectForKey:TIMER_SAVED_KEY];
    NSDateComponents *savedTimerDateComponents = (NSDateComponents *)[NSKeyedUnarchiver unarchiveObjectWithData: savedTimerDateComponentsEncoded];
    
    // Check if the timer was saved
    if (savedTimerDateComponents.hour == 0 && savedTimerDateComponents.minute == 0 && savedTimerDateComponents.second == 0)
        return TIMER_DEACTIVATED;
    
    // Get Current Date
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Calculate difference between Saved and Current dates
    NSDateComponents *difference = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:savedDate toDate:currentDate options:0];
    NSDate *differenceDate = [calendar dateByAddingComponents:difference toDate:[NSDate date] options:0];
    
    // Get Saved Timer time offset from current time
    NSDate *savedTimerDate = [calendar dateByAddingComponents:savedTimerDateComponents toDate:[NSDate date] options:0];
    
    // Calculate difference between the difference date and the saved timer date
    NSDateComponents *result = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:differenceDate toDate:savedTimerDate options:0];
    
    // Set Timer New Components
    TimerState state =  [self setTimerByComponents:result];
    
    // Return State
    return state;
}

-(TimerState)setTimerByComponents:(NSDateComponents *)components
{
    // Timer in invalid state
    if (!components) 
        return TIMER_DEACTIVATED;
    
    // Timer timed out while in background
    if (components.second < 0 || components.minute < 0 || components.hour < 0)
        return TIMER_TIMEDOUT_IN_BACKGROUND;
    
    
    [self initializeTimerWithTimeout:components.hour minutes:components.minute seconds:components.second];
    
    return TIMER_RUNNING;
    
}

-(void) resetTimerDefaults
{
    // Define timer components
    NSDateComponents *timerDateComponents = [[NSDateComponents alloc]init];
    [timerDateComponents setHour:0];
    [timerDateComponents setMinute:0];
    [timerDateComponents setSecond:0];
    
    // Save timer components
    NSData *timerDateComponentsEncoded = [NSKeyedArchiver archivedDataWithRootObject:timerDateComponents];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:timerDateComponentsEncoded forKey:TIMER_SAVED_KEY];
}

-(void) resetTimerComponents
{
    self.hours = 0;
    self.minutes = 0;
    self.seconds = 0;
    
    [self resetTimerDefaults];
}

# pragma mark - lifecycle

-(void)dealloc
{
    [self.timer invalidate];
}
@end
