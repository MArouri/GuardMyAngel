//
//  TimerDelegate.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TimerDelegate <NSObject>
-(void) timerUpdatedWithValue:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger) seconds timeout:(BOOL)timeout;
@end
