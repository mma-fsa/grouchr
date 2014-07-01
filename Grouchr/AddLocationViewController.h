//
//  AddLocationViewController.h
//  Grouchr
//
//  Created by Mike on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewUtility.h"
#import "MOGlassButton.h"
#import "GrouchrModelController.h"

@interface AddLocationViewController : UITableViewController <UITextFieldDelegate> {
    UITextField* locationNameTextField;
}

- (BOOL) validateVenueName;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@end
