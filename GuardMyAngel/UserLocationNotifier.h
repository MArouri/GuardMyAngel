//
//  UserLocationNotifier.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONRPCService.h"

@interface UserLocationNotifier : NSObject<JSONRPCServiceDelegate>

-(void) updateUserLocation:(CLLocation *)updatedLocation;

@end
