//
//  ViewController.m
//  GuardMyAngel
//
//  Created by Mohammad Arouri on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "GuardMyAngelDAO.h"
#import "GuardMyAngelDataSourceDelegate.h"
#import "Logger.h"
#import "LocationController.h"


@interface ViewController()<GuardMyAngelDataSourceDelegate,LocationControllerDelegate>
-(void)loadData;

@property (nonatomic) BOOL finishedLoading;

@property (nonatomic, strong) LocationController *locationController;

@end

@implementation ViewController

@synthesize text = _text;
@synthesize pressButton = _pressButton;
@synthesize imageView = _imageView;
@synthesize finishedLoading = _finishedLoading;

@synthesize locationController = _locationController;

-(void)animateButton
{
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState  animations:^{ self.pressButton.alpha=0.0; } 
                     completion:^(BOOL fin) { if (fin) 
                     {
                         [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{ self.pressButton.alpha=1.0; } 
                                          completion:^(BOOL fin) { if (fin) 
                                          {  
                                              DLog("Finished");
                                              if (!self.finishedLoading) {
                                                  [self animateButton];
                                              }
                                          } 
                                          }];
                     } 
                     }]; 
}

#define IMAGE_COUNT 36
-(void)animateImageView
{
    NSMutableArray * imageArray = [[NSMutableArray alloc] initWithCapacity:IMAGE_COUNT];
    
    // Build array of images, cycling through image names
    for (int i = 0; i < IMAGE_COUNT; i++)
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Frame_%d.jpg", i]]];
    
    
    self.imageView.animationImages = [NSArray arrayWithArray:imageArray];
    
    // One cycle through all the images takes 1.5 seconds
    self.imageView.animationDuration = 1.0;
    
    // Repeat forever
    self.imageView.animationRepeatCount = -1;
    
    // Start it up
    [self.imageView startAnimating];
}

# pragma mark - Setters/Getters

-(LocationController *)locationController
{
    if (!_locationController) {
        _locationController = [LocationController sharedInstance];
    }
    return _locationController;
}

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    self.text.text = NSLocalizedString(@"text", @"");
    
    // Initilize and Delegate Location Controller
    self.locationController.delegate = self;
}

- (void)viewDidUnload
{
    [self setText:nil];
    [self setPressButton:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}

- (IBAction)pressButton:(UIButton *)sender {
    self.text.text = NSLocalizedString(@"fetching", @"");
    self.finishedLoading = NO;
    [self animateButton];
    [self animateImageView];
    
    //[self loadData];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:5.0];
}
#pragma mark - Data Loader
-(void)loadData
{
    GuardMyAngelDAO *dataDAO = [[GuardMyAngelDAO alloc]init];
    [dataDAO getDummyDataForViewController:self];
}

#pragma mark - GuardMyAngelDataSourceDelegate

-(void)dataSourceChanged:(id<GuardMyAngelDataSourceDelegate>)delegate data:(NSMutableArray *)data
{
    self.finishedLoading = YES;
    [self.imageView stopAnimating];
    
    NSString *str = @"";
    NSInteger i=0;
    for (NSString *s in data) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%d %@ \n",++i,s]];
    }
    self.text.text = str;
}

-(void)dataFailedWithError:(id<GuardMyAngelDataSourceDelegate>)delegate error:(NSString *)errorDescription
{
    self.finishedLoading = YES;
    [self.imageView stopAnimating];
    
    self.text.text = errorDescription;
}

# pragma mark - LocationControllerDelegate

-(void)locationUpdate:(CLLocation *)updatedLocation
{
    
    DLog(@"Location Updated to: %f %f", updatedLocation.coordinate.latitude,updatedLocation.coordinate.longitude);
    GuardMyAngelDAO *gaurdMyAngelDao = [[GuardMyAngelDAO alloc]init];
    [gaurdMyAngelDao updateUserLocation:updatedLocation];
}

-(void)locationFailure:(NSString *)errMsg
{
    DLog(@"Error in location updater %@", errMsg);
}

@end
