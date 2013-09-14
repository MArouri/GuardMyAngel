//
//  LocalNotificationManager.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalNotificationManager.h"

@implementation LocalNotificationManager

# define LOCAL_NOTIFICATION_SHOW_BEFORE_EXIPRATION 5
+(void) scheduleLocalNotificationWithTimeout:(NSInteger)minutes
{
    // Remove all past notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Local notification will appear before the application timer expires by the value of LOCAL_NOTIFICATION_SHOW_BEFORE_EXIPRATION
    minutes-=LOCAL_NOTIFICATION_SHOW_BEFORE_EXIPRATION;
    
    if (minutes <= LOCAL_NOTIFICATION_SHOW_BEFORE_EXIPRATION)
        minutes = LOCAL_NOTIFICATION_SHOW_BEFORE_EXIPRATION;
    
    NSDate *date = [NSDate date];
    
    date = [date dateByAddingTimeInterval:(minutes)];
    
     UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    if (!localNotification)
        return;
    
    localNotification.fireDate = date;
    localNotification.alertBody = [NSString stringWithFormat:@"The timer will finish in %d minutes",LOCAL_NOTIFICATION_SHOW_BEFORE_EXIPRATION];
    localNotification.alertAction = NSLocalizedString(@"localNotificationActionKey", @"");
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    NSDictionary *infoDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:minutes] forKey:@"TimeInterval"];
    localNotification.userInfo = infoDictionary;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

+(void) cancelPreviouslyScheduledLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
