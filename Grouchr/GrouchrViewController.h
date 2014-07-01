//
//  GrouchrViewController.h
//  Grouchr
//
//  Created by Mike on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginViewController.h"
#import "NearbyComplaintsController.h"
#import "GrouchrModelController.h"
#import "TwitterOAuthUtility.h"
#import "DSActivityView.h"

@interface GrouchrViewController : UIViewController {
    UIActionSheet* loadingOverlay;
    UINavigationController* userManagementNavigation;
    UINavigationController* twitterNav;
    GrouchrModelController* model; 
    
}

+ (void) setInstance: (GrouchrViewController*) theInstance;
+ (GrouchrViewController*) getInstance;

- (void) showTwitterLogin;
- (void) hideTwitterLogin;

- (void) showUsermanagement;
- (void) showLoadingOverlay: (NSString*) message;
- (void) hideLoadingOverlay;

@property (nonatomic, strong) TwitterOAuthUtility* twitterUtility;
@property (nonatomic) BOOL skipLoginOnce;
@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;
@property (strong, nonatomic) UIAlertView* alert;
@property (readwrite) BOOL canShowNetworkError;
@end
