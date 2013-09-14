//
//  FacebookUserEntity.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookUserEntity.h"

@implementation FacebookUserEntity

@synthesize userId = _userId;
@synthesize name = _name;


- (id)initWithId:(NSString *)passedUserId andName:(NSString *)userName {
    self = [super init];
    if (self) {
        
        if (passedUserId)
            self.userId = passedUserId;
        if (userName) 
            self.name = userName;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"FacebookUserEntity: ID: %@ NAME: %@",self.userId,self.name];
}

@end
