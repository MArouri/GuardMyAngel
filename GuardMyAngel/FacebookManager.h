//
//  FacebookManager.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "FacebookUserEntity.h"

typedef enum {
    DID_NOT_LOGIN = 0,
    SESSION_INVALIDATED
} FacebookErrorDescription;


@protocol FacebookManagerDelegate <NSObject>

// Fire an event when the user entity is ready after successfull login
-(void) facebookUserEntityUpdated:(FacebookUserEntity *)user;
-(void) facebookLoginFailedWithError:(FacebookErrorDescription)errorDescription;
@end

@interface FacebookManager : NSObject<FBSessionDelegate>
{
    Facebook *facebook;
    id<FacebookManagerDelegate> delegate;
}

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) id<FacebookManagerDelegate> delegate;

+(FacebookManager *)sharedFacebookManager;

-(void) shareDialogFeed;
-(void)logout;
-(void)requestUserInfo; // Get user id,name

@end
