//
//  FacebookUserEntity.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GaurdMyAngelDataEntity.h"

@interface FacebookUserEntity : GaurdMyAngelDataEntity
{
    NSString *userId;
    NSString *name;
}
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *name;

- (id)initWithId:(NSString *)passedUserId andName:(NSString *)userName;

@end
