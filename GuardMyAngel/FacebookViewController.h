//
//  FacebookViewController.h
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterViewController.h"

@interface FacebookViewController : TwitterViewController 
{

}
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end
