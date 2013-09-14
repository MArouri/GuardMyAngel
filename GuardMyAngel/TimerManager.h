//
//  TimerManager.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerDelegate.h"

typedef enum {
    TIMER_RUNNING = 0,
    TIMER_DEACTIVATED,
    TIMER_SUSPENDED,
    TIMER_TIMEDOUT_IN_BACKGROUND
} TimerState;

@interface TimerManager : NSObject

@property (nonatomic, strong) id<TimerDelegate> delegate;

-(id) initWithTimeout:(NSInteger) hours minutes:(NSInteger) minutes seconds:(NSInteger)seconds delegate:(id<TimerDelegate>)delegate;
-(void) deactivateTimer; // invalidate timer
-(void) suspendTimer; // Stop timer and save its parameters
-(TimerState) reactivateTimer; // Start the timer again`

@end
