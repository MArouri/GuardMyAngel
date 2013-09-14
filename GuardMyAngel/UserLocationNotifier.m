//
//  UserLocationNotifier.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserLocationNotifier.h"
#import "Logger.h"

@implementation UserLocationNotifier

#pragma mark - JSONRPC

#define BASE_URL @"http://webservice.mobilesportswasp.com/wcr/service.ashx"
#define METHOD_ID @"1"
#define METHOD_NAME @"HelloWorld"

static int count = 0;

-(void)updateUserLocation:(CLLocation *)updatedLocation
{
    if (count++%10!=0)return;
        
    JSONRPCService *jsonRPCService = [[JSONRPCService alloc]initWithURL:[NSURL URLWithString:BASE_URL]];
    jsonRPCService.delegate =self;
    [jsonRPCService execMethod:METHOD_NAME andParams:[NSArray array] withID:METHOD_ID];
}

#pragma mark - JSONRPCServiceDelegatedataDelegate
-(void) dataLoaded:(NSData*)data
{
    NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    DLog(@"Location Updated %@",dataString);
}

-(void) loadingFailed:(NSString*) errMsg
{
    DLog(@"Error %@", errMsg);
}
@end
