//
//  SubmitComplaintViewController.h
//  Grouchr
//
//  Created by Mike on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewUtility.h"
#import "MOButton.h"
#import "MOGlassButton.h"

@interface SubmitComplaintViewController : UITableViewController<UITextViewDelegate, UIImagePickerControllerDelegate> {
    BOOL complaintTextEmpty;
}
@property (weak, nonatomic) IBOutlet UIView *footerView;

@end
