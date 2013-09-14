//
//  FacebookManager.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookManager.h"
#import "Logger.h"

@interface FacebookManager() <FBDialogDelegate,FBRequestDelegate>
- (void) updateFacebookUserDefaults; // Save the new facebook accessToken/expiration date in user defaults
- (void) userInfo; // Get user basic info using me graph service
- (void)authorizeFacebookPermissions;

@property (nonatomic) BOOL isInitializing;
@property (nonatomic) BOOL isShareRequested;
@end
    
@implementation FacebookManager
@synthesize facebook = _facebook;
@synthesize delegate = _delegate;
@synthesize isInitializing = _isInitializing;
@synthesize isShareRequested = _isShareRequested;

static FacebookManager* facebookManager = nil;

#define FACEBOOK_APP_ID @"375273169153731"

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.facebook = [[Facebook alloc]initWithAppId:FACEBOOK_APP_ID andDelegate:self];
        
        self.isInitializing  = YES;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) 
        {
            self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
            self.isInitializing = NO;
        }
        
        if (![self.facebook isSessionValid]) 
        {
            [self authorizeFacebookPermissions];
        }
    }
    return self;
}


- (void)updateFacebookUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)userInfo
{
    // Request my info, only id and name from me graph service
    NSMutableDictionary *params = [NSMutableDictionary dictionary]; 
    [params setObject:@"id,name" forKey:@"fields"];
    [self.facebook requestWithGraphPath:@"me" andParams:params andDelegate:self];
}

- (void)authorizeFacebookPermissions
{
    NSArray *permissions = [[NSArray alloc] initWithObjects: @"publish_stream", nil];
    [self.facebook authorize:permissions];
}

# pragma mark - Setters/Getters

-(Facebook *)facebook
{
    if (!_facebook) {
        _facebook = [[Facebook alloc]initWithAppId:FACEBOOK_APP_ID andDelegate:self];
    }
    return _facebook;
}

# pragma mark - Shared Instance

+(FacebookManager *)sharedFacebookManager
{
    if (!facebookManager) {
        facebookManager = [[FacebookManager alloc]init];
    }
    return facebookManager;
}


# pragma mark - FBSessionDelegate

- (void)fbDidLogin 
{
    DLog(@"%@ %@",[self.facebook accessToken],[self.facebook expirationDate]);
   
    self.isInitializing = NO;
    [self updateFacebookUserDefaults];
    
    if (self.isShareRequested) 
    {
        DLog(@"Share requested");
        self.isShareRequested = NO;
        [self shareDialogFeed];
    }
    else
    {
        [self userInfo];
    }
    
}

-(void)fbDidLogout
{
    DLog(@"Logout");
}

-(void)fbDidNotLogin:(BOOL)cancelled
{
    DLog(@"Did not login %@", cancelled?@"Cancelled":@"Not Cancelled");
    self.isInitializing = NO;
    [self.delegate facebookLoginFailedWithError:DID_NOT_LOGIN];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt 
{
    DLog(@"");
    [self updateFacebookUserDefaults];
}

- (void)fbSessionInvalidated
{
    DLog(@"");
    self.isInitializing = NO;
    [self.delegate facebookLoginFailedWithError:SESSION_INVALIDATED];
}

# pragma mark - Share Dialogs

#define LINK @"link"
#define PICTURE @"picture"
#define NAME @"name"
#define CAPTION @"caption"
#define DESCRIPTION @"description"
#define MESSAGE_FEED @"message"
#define DIALOG_FEED @"feed"

-(void) shareDialogFeed
{
    if (self.isInitializing) {
        DLog(@"Initializing");
        self.isShareRequested = YES;
        return;
    }
    
    if (![self.facebook isSessionValid])
    {
        DLog(@" Session is Invalid");
        self.isShareRequested = YES;
        [self authorizeFacebookPermissions];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        @"http://www.facebook.com/mohammad.arouri",LINK,
                        //@"http://photos-f.ak.fbcdn.net/photos-ak-snc1/v85006/135/375273169153731/app_1_375273169153731_7479.gif",PICTURE,
                        @"Dialogs Name",NAME,
                        @"Caption",CAPTION,
                        @"Simple description !!",DESCRIPTION,
                       @"Facebook Dialogs are so easy!",MESSAGE_FEED
                                   ,nil];

    [self.facebook dialog:DIALOG_FEED andParams:params andDelegate:self];
}

# pragma mark - FBDialogDelegate

-(void)dialogDidComplete:(FBDialog *)dialog
{
    DLog(@"Dialog Completed Successfully");
}

-(void)dialog:(FBDialog *)dialog didFailWithError:(NSError *)error
{
    DLog(@"Dialog failed with error %@", error.localizedDescription);
}

-(void)dialogDidNotCompleteWithUrl:(NSURL *)url
{
    DLog(@"");
}

-(void)dialogCompleteWithUrl:(NSURL *)url
{
    DLog(@"%@",url.absoluteString);
}

# pragma mark - RequestDelegate

-(void)requestLoading:(FBRequest *)request
{
    DLog(@"");
}
-(void)request:(FBRequest *)request didLoad:(id)result
{
    NSMutableArray *items = [(NSDictionary*)result objectForKey:@"data"];     
    DLog(@"%@",items);
}
-(void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    DLog(@"");
}
-(void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    DLog(@"");
}
-(void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{

    DLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    
    // Me Graph user name
    if ([[request.url lastPathComponent]isEqualToString:@"me"]) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
        NSString *userId = [json valueForKey:@"id"];
        NSString *name = [json valueForKey:@"name"];
        DLog(@"NAME: %@ ID %@", name,userId);
        
        FacebookUserEntity *userEntity = [[FacebookUserEntity alloc]initWithId:userId andName:name];
        [self.delegate facebookUserEntityUpdated:userEntity];
    }
}

# pragma mark - Methods

-(void)requestUserInfo
{
    if (self.isInitializing) {
        DLog(@"Initializing");
        return;
    }
    
    if (![self.facebook isSessionValid])
    {
        DLog(@" Session is Invalid");
        [self authorizeFacebookPermissions];
    }
    else
    {
        DLog(@"Session is Valid");
        [self userInfo];
    }
}

-(void)logout
{
    [self.facebook logout];
}
@end
