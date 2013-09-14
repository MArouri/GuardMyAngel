//
//  JSONRPC.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONRPCService.h"
#import "Logger.h"

@implementation JSONRPCService
@synthesize delegate = _delegate;
@synthesize url = _url;
@synthesize urlConnection = _urlConnection;
@synthesize username = _username;
@synthesize password = _password;
@synthesize webData = _webData;

-(id) initWithURL:(NSURL*)serviceURL {
	return [self initWithURL:serviceURL user:nil pass:nil];
}

-(id) initWithURL:(NSURL*)serviceURL user:(NSString*)user pass:(NSString*)pass {
	
    if (self = [super init]) {
		self.url = serviceURL;
		self.username = user;
		self.password = pass;
	}
	return self;
}


-(void) execMethod:(NSString*)methodName andParams:(NSArray*)parameters withID:(NSString*)identificator {
    
	//RPC
	NSMutableDictionary* reqDict = [NSMutableDictionary dictionary];
	[reqDict setObject:methodName forKey:@"method"];
	[reqDict setObject:parameters forKey:@"params"];
	[reqDict setObject:identificator forKey:@"id"];
	
	//RPC JSON
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reqDict options:NSJSONWritingPrettyPrinted error:&error];
    
	//Request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.url];
	
	//prepare http body
	[request setHTTPMethod: @"POST"];
	[request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody: jsonData];
    
	if (self.urlConnection != nil) {
		self.urlConnection = nil;
	}
	
	self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
}


-(void) cancelRequest {
	
	if (self.urlConnection) {
		[self.urlConnection cancel];
		self.urlConnection = nil;
		self.webData = nil;
	}
	
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
    DLog(@"Did receive response: %@", response);
	
	self.webData = [[NSMutableData alloc] init];
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	assert(self.webData != nil);
	[self.webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
    self.webData = nil;
	self.urlConnection = nil;
	
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;
	
	//notify
	[self.delegate loadingFailed:[error localizedDescription]];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	self.urlConnection = nil;
	
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;
    
	[self.delegate dataLoaded:self.webData];
	
	self.webData = nil;
}


@end
