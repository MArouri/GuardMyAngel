//
//  DataModel.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuardMyAngelDataSourceDelegate.h"
#import "DummyDataModel.h"
#import <CoreLocation/CoreLocation.h>

@interface GuardMyAngelDAO : NSObject
{
    DummyDataModel *dummyDataModel;
}
@property (nonatomic, strong) DummyDataModel *dummyDataModel;

-(void) getDummyDataForViewController:(id<GuardMyAngelDataSourceDelegate>)delegate;

-(void) updateUserLocation:(CLLocation *)updatedLocation;

@end
