//
//  LocationController.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationController.h"
#import "Logger.h"

@interface LocationController()
    
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;

@end

static LocationController* sharedController = nil;

@implementation LocationController
@synthesize delegate = _delegate;
@synthesize locationManager = _locationManager;
@synthesize location = _location;

-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        //_locationManager.desiredAccuracy =  kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}

# pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.delegate locationUpdate:newLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.delegate locationFailure:error.localizedDescription];
}

# pragma mark - Shared Instance
+ (LocationController*)sharedInstance 
{
    if (!sharedController) {
        
        if ([CLLocationManager locationServicesEnabled])
        {
            sharedController = [[LocationController alloc]init];
            //[sharedController.locationManager startUpdatingLocation];
            [sharedController.locationManager startMonitoringSignificantLocationChanges];
        }else
        {
            sharedController = nil;
        }
        
    }
    return sharedController;
}
@end
