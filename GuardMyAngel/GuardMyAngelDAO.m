//
//  DataModel.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GuardMyAngelDAO.h"
#import "DummyDataModel.h"
#import "UserLocationNotifier.h"

@implementation GuardMyAngelDAO
@synthesize dummyDataModel = _dummyDataModel;

# pragma mark - Setters/Getters

-(DummyDataModel *)dummyDataModel
{
    if (!_dummyDataModel) {
        _dummyDataModel = [[DummyDataModel alloc]init];
    }
    return _dummyDataModel;
}

#define METHOD_NAME @"system.listMethods"
-(void)getDummyDataForViewController:(id<GuardMyAngelDataSourceDelegate>)delegate
{
    [self.dummyDataModel getDummyData:delegate methodName:METHOD_NAME];
}

-(void)updateUserLocation:(CLLocation *)updatedLocation
{
    if (!updatedLocation)
        return;
    
    UserLocationNotifier *userLocationNotifier = [[UserLocationNotifier alloc]init];
    [userLocationNotifier updateUserLocation:updatedLocation];
}

@end
