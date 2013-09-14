//
//  LocationController.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol LocationControllerDelegate <NSObject>
- (void) locationUpdate:(CLLocation*)updatedLocation;
- (void) locationFailure:(NSString *)errMsg;
@end

@interface LocationController : NSObject<CLLocationManagerDelegate>
{
    id<LocationControllerDelegate> delegate;
}
@property (nonatomic, strong) id<LocationControllerDelegate> delegate;

+ (LocationController *) sharedInstance;

@end
