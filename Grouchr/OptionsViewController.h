//
//  OptionsViewController.h
//  Grouchr
//
//  Created by Mike on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GrouchrModelController.h"
#import "GrouchrViewController.h"
#import "ViewUtility.h"

#import "MOButton.h"
#import "MOGlassButton.h"

@interface OptionsViewController : UITableViewController {
    GrouchrModelController* model;
    GrouchrViewController* viewController;
    UIButton* grouchrButton;
    
    UIActivityIndicatorView* facebookActivity;
    UIButton* facebookButton;
    BOOL facebookUpdating;
    
    UIActivityIndicatorView* twitterActivity;
    UIButton* twitterButton;
    BOOL twitterUpdating;
    
    BOOL loadingControllerActive;
    NSTimer* loadingControllerTimer;
}

- (void) hiddenDidGrouchrButtonClick;
- (void) hiddenDidFacebookButtonClick;
- (void) hiddenDidTwitterButtonClick;

- (void) hiddenDidFacebookUpdate;
- (void) hiddenDidTwitterUpdate;

@end
