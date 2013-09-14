//
//  GuardMyAngelDataSourceDelegate.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GuardMyAngelDataSourceDelegate <NSObject>

-(void)dataSourceChanged:(id<GuardMyAngelDataSourceDelegate>) delegate data:(NSMutableArray *)data;
-(void)dataFailedWithError:(id<GuardMyAngelDataSourceDelegate>) delegate error:(NSString *)errorDescription;

@end
