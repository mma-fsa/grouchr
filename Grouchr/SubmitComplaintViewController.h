//
//  SubmitComplaintViewController.h
//  Grouchr
//
//  Created by Mike on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakeViewController.h"
#import "NearbyVenuesController.h"
#import "Venue.h"
#import "ViewUtility.h"
#import "MOButton.h"
#import "MOGlassButton.h"
#import "GrouchrModelController.h"
#import "GrouchrViewController.h"
#import "SubmitComplaint.h"
#import "DSActivityView.h"

@interface SubmitComplaintViewController : UITableViewController<UITextViewDelegate, 
    UIImagePickerControllerDelegate> {
    BOOL complaintTextEmpty;
    SubmitComplaint* complaint;
    
    DSBezelActivityView* activityView;
    MOGlassButton* submitButton;
        
    UITableViewCell* locationCell;
    UITextView* complaintTextView;
    UITableViewCell* shakePointsCell;
    UITableViewCell* photoCell;
    UISwitch* facebookSwitch;
    UISwitch* twitterSwitch;
    
    GrouchrModelController* model;
}

- (BOOL) hiddenDidValidate;
- (void) hiddenHandleComplaintInProgress;

@property (readwrite) BOOL isReply;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@end
