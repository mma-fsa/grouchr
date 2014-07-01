//
//  GrouchrViewController.m
//  Grouchr
//
//  Created by Mike on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GrouchrViewController.h"

static GrouchrViewController* instance = nil;

@implementation GrouchrViewController

@synthesize twitterUtility;
@synthesize tabBarController;
@synthesize skipLoginOnce;
@synthesize alert;
@synthesize canShowNetworkError;

+ (void) setInstance:(GrouchrViewController *)theInstance {
    instance = theInstance;
}

+ (GrouchrViewController*) getInstance {
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self addObserver:self forKeyPath:@"alert" options:0 context:nil];
        model = [GrouchrModelController getInstance];
        [model addObserver:self forKeyPath:@"hasValidToken" options:NSKeyValueChangeSetting context:nil]; 
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
    
    // Do any additional setup after loading the view from its nib.
    [tabBarController.view setFrame: self.view.bounds];
    [self.view addSubview: tabBarController.view];
    
    //setup the navigation controller for the user management views
    userManagementNavigation = [[UINavigationController alloc] initWithRootViewController: [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil]];
    
    self.canShowNetworkError = YES;
}

- (void) dealloc {
    [model removeObserver:self forKeyPath: @"hasValidToken" ];
    [self removeObserver:self forKeyPath:@"alert"];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!model.hasValidToken) {
        [self showUsermanagement];
    }
}

- (void) showTwitterLogin {
    self.twitterUtility = [[TwitterOAuthUtility alloc] init]; 
    twitterNav = [[UINavigationController alloc] initWithRootViewController: self.twitterUtility.loginPopup];    
    [self presentModalViewController: twitterNav animated: YES];
}

- (void) hideTwitterLogin {
    if (self.twitterUtility != nil) {
        [self.twitterUtility.loginPopup.parentViewController dismissModalViewControllerAnimated: YES];
    }
}

- (void) showUsermanagement {
    if (skipLoginOnce == YES) {
        skipLoginOnce = NO;
    }
    else if (self.modalViewController == nil) {
        [self presentModalViewController: userManagementNavigation animated:YES];
    }
    else if (self.modalViewController != userManagementNavigation) {
        [self dismissModalViewControllerAnimated: YES];
        [self presentModalViewController: userManagementNavigation animated:YES];
    }
}

- (void) showLoadingOverlay:(NSString *)message {
    /*    if (loadingOverlay != nil) {
        loadingOverlay.title = message;
    }
    else {
        loadingOverlay = [[UIActionSheet alloc] initWithTitle: message delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        [loadingOverlay showInView: self.view];
    }    */
    [DSBezelActivityView activityViewForView: self.view withLabel: message];
}

- (void) hideLoadingOverlay {
/*    if (loadingOverlay != nil) {
        [loadingOverlay dismissWithClickedButtonIndex:0 animated:YES];
        loadingOverlay = nil;
} */
    [DSBezelActivityView removeViewAnimated: YES];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"hasValidToken" isEqualToString: keyPath]) {
        if (!model.hasValidToken) {
            [self showUsermanagement];
        }
        else if (self.modalViewController == userManagementNavigation)  {
            [self dismissModalViewControllerAnimated: YES];
        }
    }
    else if ([@"alert" isEqualToString: keyPath]) {
        [self hideLoadingOverlay];
    }
}

- (void)viewDidUnload
{
    [self setTabBarController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
