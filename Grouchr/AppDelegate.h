//
//  AppDelegate.h
//  nostoryboard2
//
//  Created by Joel Drotos on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouchrViewController.h"
#import "GrouchrModelController.h"
#import "GrouchrUserData.h"
#import "Facebook.h"
#import "DataFetcherResponseHandler.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate> {
    GrouchrUserData* userData;
    GrouchrModelController* model;
    GrouchrViewController* viewController;
    
    BOOL hasConnection;
    Reachability* internetReach;
}

@property (strong, nonatomic) UIWindow *window;
- (void) initApp;
- (void) restartApp;
- (void) killApp;
- (void) initGrouchrViewController;
- (void) didAuthenticateToken;
- (BOOL) handleFBAuth: (NSURL*) url;
- (BOOL) handleTwitterAuth:(NSURL*)url;
- (void) hiddenDidNetworkError;
- (void) didGetSystemSettings;
- (void) reachabilityChanged: (NSNotification*) note;
- (void) handleReachabilityStatus: (Reachability*) curReach;
@end
