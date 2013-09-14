//
//  JSONRPC.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONRPCServiceDelegate
-(void) dataLoaded:(NSData*)data;
-(void) loadingFailed:(NSString*) errMsg;
@end

@interface JSONRPCService : NSObject
{
    NSURL* url;
	NSURLConnection *urlConnection;
    
	id<JSONRPCServiceDelegate> delegate;
	
	NSString* username;
	NSString* password;
	
	NSMutableData* webData;
}

@property (nonatomic, strong) id<JSONRPCServiceDelegate> delegate;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSMutableData *webData;

-(id) initWithURL:(NSURL*)serviceURL;
-(id) initWithURL:(NSURL*)serviceURL user:(NSString*)user pass:(NSString*)pass;
-(void) execMethod:(NSString*)methodName andParams:(NSArray*)parameters withID:(NSString*)identificator;

-(void) cancelRequest;

@end
