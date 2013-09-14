//
//  LocalNotificationManager.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocalNotificationDelegate <NSObject>
-(void) localNotificationReceived;
@end

@interface LocalNotificationManager : NSObject

+(void) scheduleLocalNotificationWithTimeout:(NSInteger)minutes;
+(void) cancelPreviouslyScheduledLocalNotifications;

@end
