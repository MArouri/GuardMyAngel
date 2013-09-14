//
//  NotAnimatedSegue.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotAnimatedSegue.h"

@implementation NotAnimatedSegue

-(void)perform
{
    UIViewController *src = (UIViewController *) self.sourceViewController;
    
    [src.navigationController pushViewController:self.destinationViewController animated:NO];
}

@end
