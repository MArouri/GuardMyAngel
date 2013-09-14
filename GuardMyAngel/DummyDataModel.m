//
//  DummyData.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DummyDataModel.h"
#import "Logger.h"

@interface DummyDataModel()
@end

@implementation DummyDataModel
@synthesize delegate = _delegate;

#pragma mark - JSON Parser
-(NSMutableArray *)parseData:(NSData *)data
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data 
                                                         options:kNilOptions 
                                                           error:&error];
    NSMutableArray *dataArray = [json valueForKey:@"result"];
    return dataArray;
}

#pragma mark - JSONRPC

#define BASE_URL @"http://webservice.mobilesportswasp.com/wcr/service.ashx"
#define METHOD_ID @"1"

-(void) getDummyData:(id<GuardMyAngelDataSourceDelegate>)dataDelegate methodName:(NSString *)methodName
{
    if (dataDelegate) {
        self.delegate = dataDelegate;
    }
    
    JSONRPCService *jsonRPCService = [[JSONRPCService alloc]initWithURL:[NSURL URLWithString:BASE_URL]];
    jsonRPCService.delegate =self;
    [jsonRPCService execMethod:methodName andParams:[NSArray array] withID:METHOD_ID];
}

#pragma mark - JSONRPCServiceDelegatedataDelegate
-(void) dataLoaded:(NSData*)data
{
    if (!data) 
        [self.delegate dataSourceChanged:self.delegate data:nil];
    
    NSMutableArray *dataArray = [self parseData:data];
    [self.delegate dataSourceChanged:self.delegate data:dataArray];
}

-(void) loadingFailed:(NSString*) errMsg
{
    DLog(@"Error %@", errMsg);
}

@end
