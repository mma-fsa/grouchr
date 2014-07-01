//
//  ShakeViewController.m
//  Grouchr
//
//  Created by Mike on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ShakeViewController.h"

@implementation ShakeViewController
@synthesize isReply;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle: @"Shake it!"];
    [self.view setBackgroundColor: [ViewUtility getOrangeLabelColor]];
    
    UIImageView* animation = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 280, 280)];
    [self.view addSubview:animation];
    animation.animationImages = [ViewUtility getShakeAnimationImages];
    animation.animationDuration = 0.5f;
   
    [animation startAnimating];
    
    GrouchrModelController* model = [GrouchrModelController getInstance];
    didCancelShake = NO;
    
    if (self.isReply == YES) {
        [model startShakeGesture:self withSelector: @selector(shakeGestureDone) forObject: model.replyComplaint];        
    }
    else {
        [model startShakeGesture:self withSelector: @selector(shakeGestureDone) forObject: model.submitComplaint];        
    }
    
    self.navigationItem.backBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle:@"Complain" style:UIBarButtonItemStyleDone target:self action:@selector(handleBack:)];
    
    UILabel* shakeLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 290, 320, 60)];
    
    shakeLabel.textAlignment = UITextAlignmentCenter;
    shakeLabel.font = [UIFont boldSystemFontOfSize: 18.0f];
    shakeLabel.backgroundColor = [UIColor clearColor];
    shakeLabel.text = @"Shake your phone back and forth!";
    
    [self.view addSubview: shakeLabel];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];

    GrouchrModelController* model = [GrouchrModelController getInstance];
    if (isReply == YES) {
        model.activeComplaint = model.replyComplaint;
    }
    else if (isReply == NO) {
        model.activeComplaint = model.submitComplaint;
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    didCancelShake = YES;
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) handleBack:(id) sender {
    didCancelShake = YES;
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) shakeGestureDone {
    if (!didCancelShake) {
        [self.navigationController popViewControllerAnimated: YES];
    }
}

@end
