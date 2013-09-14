//
//  AddressbookController.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddressbookController.h"
#import "Logger.h"


@interface AddressbookController()<ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic) AddressbookType type;

- (void)showAddressbookPicker;
- (BOOL) isValidEmail:(NSString *)checkString;
- (NSString *) extractEmailAddress:(ABRecordRef)person;
- (NSString *) extractSMSNumber:(ABRecordRef)person;
- (NSString *) extractUserName:(ABRecordRef)person;

-(NSInteger) emailAddressesCount:(ABRecordRef)person;
@end

@implementation AddressbookController

@synthesize type = _type;
@synthesize delegate = _delegate;

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [self getAddresssbookUserSMS];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - Show Addressbook

- (void)showAddressbookPicker
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	picker.peoplePickerDelegate = self;
	[self presentModalViewController:picker animated:YES];
}

-(void) getAddressbookUserEmail
{
    self.type = ADDRESSBOOK_EMAIL;
	[self showAddressbookPicker];
}

-(void) getAddresssbookUserSMS
{
    self.type  = ADDRESSBOOK_PHONE_NUMBER;
    [self showAddressbookPicker];
}

# pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate addressbookCancelled];
}

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; 
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(NSString *) extractEmailAddress:(ABRecordRef)person
{
    ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSString *email;
    NSInteger emailsCount = ABMultiValueGetCount(multi);
    BOOL isValid = NO;
    
    for (int i=0; i<emailsCount; i++) 
    {
        email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, i);
        DLog(@"EMAIL : %@", email);
        if (email)
        {
            isValid = [self isValidEmail:email];
            DLog(@"isValid %@",isValid?@"YES":@"NO");
            if (isValid) 
                break;
        }
    }
    if (!isValid) 
        email = nil;
    return email;
}

-(NSInteger) emailAddressesCount:(ABRecordRef)person
{
    ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSInteger emailsCount = ABMultiValueGetCount(multi);
    return emailsCount;
}


-(NSString *) extractSMSNumber:(ABRecordRef)person
{
    ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *mobileNumber;
    if (ABMultiValueGetCount(multi) > 0) 
    {
        mobileNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
        DLog(@"Mobile number %@", mobileNumber);
    }
    return mobileNumber;
}

-(NSString *) extractUserName:(ABRecordRef)person
{
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSString *userName;
    
    if (firstName) 
        userName = [NSString stringWithString:firstName];
    
    if (lastName) 
    {
        if (userName) 
            userName = [userName stringByAppendingFormat:@" %@",lastName];
        else
            userName = [NSString stringWithString:lastName];
    }
    
    if (!userName) 
    {
        NSString *nickName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonNicknameProperty);
        if (nickName) 
            userName = [NSString stringWithString:nickName];
    }
    
    DLog(@"USER NAME: %@",userName);
    return userName;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self dismissModalViewControllerAnimated:YES];
    
    AddressbookEntity *addressbookentity = [[AddressbookEntity alloc]init];
    
    NSString *userName = [self extractUserName:person];
    addressbookentity.userName = userName;
    DLog(@"Addressbook Entity : %@", addressbookentity);
    
    if (self.type == ADDRESSBOOK_EMAIL)
    {
        NSInteger emailsCount = [self emailAddressesCount:person];
        
        if (emailsCount == 0)
        {
            [self.delegate addressbookFailedWithError:ADDRESSBOOK_EMAIL_NOT_AVAILABLE];
            return NO;
        }
        
        NSString *emailAddress = [self extractEmailAddress:person];
        if (emailAddress)
            addressbookentity.userEmail = emailAddress;
        
        [self.delegate addressbookEmail:addressbookentity];
    }
    else
    {
        NSString *SMSNumber = [self extractSMSNumber:person];
        if (SMSNumber)
            addressbookentity.userSMSNumber = SMSNumber;
        [self.delegate addressbookSMS:addressbookentity];
    }
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

@end
