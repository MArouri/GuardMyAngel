//
//  AddressbookEntity.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GaurdMyAngelDataEntity.h"

@interface AddressbookEntity : GaurdMyAngelDataEntity
{
    NSString *userName;
    NSString *userEmail;
    NSString *userSMSNumber;
}

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userSMSNumber;


- (id)initWithUserName:(NSString *)name email:(NSString *)email SMSNumber:(NSString *)SMSNumber;
@end
