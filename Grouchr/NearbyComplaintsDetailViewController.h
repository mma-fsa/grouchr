//
//  NearbyComplaintsDetailViewController.h
//  Grouchr
//
//  Created by Mike on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Complaint.h"
#import "GrouchrModelController.h"
#import "NearbyComplaintsDetailUITableViewCell.h"
#import "NearbyComplaintsDetailContentView.h"
#import "ImageViewerViewController.h"
#import "SubmitComplaintViewController.h"

@interface NearbyComplaintsDetailViewController : UITableViewController {
    GrouchrModelController* model;
    NSArray* complaintThread;
    NSDateFormatter* shortDateFormatter;
    NSString* imageURL;
    UIBarButtonItem *replyButton;
}

- (void) hiddenDidClickReply;

@property (nonatomic) NSInteger threadSubmissionId;

@end
