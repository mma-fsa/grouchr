//
//  LoginViewController.h
//  Grouchr
//
//  Created by Mike on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOGlassButton.h"
#import "CreateUserViewController.h"
#import "ViewUtility.h"
#import "GrouchrModelController.h"

@interface LoginViewController : UITableViewController<UITextFieldDelegate> {
    NSString* password;
    GrouchrModelController* model;
    UITextField* txtUsername;
    UITextField* txtPassword;
}

- (void) createUserClicked;
- (void) loginClicked;
@end
