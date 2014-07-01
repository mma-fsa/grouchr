//
//  CreateUserViewController.h
//  Grouchr
//
//  Created by Mike on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOGlassButton.h"
#import "ViewUtility.h"
#import "GrouchrModelController.h"
@interface CreateUserViewController : UITableViewController <UITextFieldDelegate> {
    UITextField* txtUsername;
    UITextField* txtPassword1;
    UITextField* txtPassword2;
    GrouchrModelController* model;
}

- (void) createUserClicked;
- (void) hiddenDidCreateUser: (NSString*) responseCode;

@end
