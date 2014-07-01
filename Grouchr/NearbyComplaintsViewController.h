//
//  NearbyComplaintsViewController.h
//  Grouchr
//
//  Created by Mike on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GrouchrModelController.h"
#import "NearbyComplaintsUITableViewCell.h"
#import "NearbyComplaintsContentView.h"
#import "NearbyComplaintsDetailViewController.h"
#import "ViewUtility.h"

@interface NearbyComplaintsViewController : UITableViewController {
    NSMutableArray* contentViews;
    GrouchrModelController* model;
    BOOL delayLoading;
    BOOL isUpdatingTable;
    NSInteger complaintCount;
    NSInteger numberTableRows;
}
- (void) refreshNearbyComplaints;
- (void) hiddenHandleNextPage: (NSNumber*) numAdded;

@end
