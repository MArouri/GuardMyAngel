//
//  AddressbookController.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddressbookEntity.h"
#import "FacebookViewController.h"

typedef enum {
    ADDRESSBOOK_EMAIL = 0,
    ADDRESSBOOK_PHONE_NUMBER
} AddressbookType;

typedef enum {
    ADDRESSBOOK_EMAIL_NOT_AVAILABLE = 0,
    ADDRESSBOOK_PHONE_NUMBER_NOT_AVAILABLE
} AddressbookErrorType;

@protocol AddressbookDelegate <NSObject>
@optional
-(void) addressbookEmail:(AddressbookEntity *)entity;
-(void) addressbookSMS:(AddressbookEntity *)entity;
-(void) addressbookFailedWithError:(AddressbookErrorType)error;
-(void) addressbookCancelled;

@end


@interface AddressbookController : UIViewController

@property (nonatomic, strong) id<AddressbookDelegate> delegate;

-(void) getAddressbookUserEmail;
-(void) getAddresssbookUserSMS;

@end
