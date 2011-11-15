//
//  FirstViewController.h
//  nostoryboard2
//
//  Created by Joel Drotos on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Complaint.h"
#import "DataFetcher.h"
#import "DataFetcherResponseHandler.h"
#import "APIResponseDelegate.h"
#import "UIComplaintTableViewCell.h"
#import "APIResponseParser.h"
#import "GrouchrAPI.h"

@interface NearbyComplaintsController : UIViewController <APIResponseDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    __weak UITableView *complaintTable;

    
    DataFetcherResponseHandler* nearbyComplaintUpdateHandler;
    DataFetcher* nearbyComplaintFetcher;
    NSArray* complaints;
}

- (IBAction) doFetchNearby;

@property (weak ) UITableView *complaintTable;

@end
