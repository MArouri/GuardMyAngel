//
//  DummyData.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONRPCService.h"
#import "GuardMyAngelDataSourceDelegate.h"

@interface DummyDataModel : NSObject<JSONRPCServiceDelegate>
{
    id<GuardMyAngelDataSourceDelegate> delegate;
}

@property (nonatomic, weak) id<GuardMyAngelDataSourceDelegate> delegate;

-(void) getDummyData:(id<GuardMyAngelDataSourceDelegate>)delegate methodName:(NSString *)methodName;
@end
