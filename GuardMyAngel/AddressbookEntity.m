//
//  AddressbookEntity.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddressbookEntity.h"

@implementation AddressbookEntity

@synthesize userName;
@synthesize userEmail;
@synthesize userSMSNumber;

- (id)initWithUserName:(NSString *)name email:(NSString *)email SMSNumber:(NSString *)SMSNumber
{
    self = [super init];
    if (self) {
        if (name) 
            self.userName = name;
        if (email)
            self.userEmail = email;
        if (SMSNumber)
            self.userSMSNumber = SMSNumber;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"AddressbookEntity: userName %@ , userEmail %@ , userSMSNumber %@",self.userName,self.userEmail,self.userSMSNumber];
}

@end
