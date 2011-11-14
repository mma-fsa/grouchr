//
//  FirstViewController.h
//  Grouchr
//
//  Created by Joel Drotos on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataFetcher.h"
#import "DataFetcherResponseHandler.h"
#import "APIResponseDelegate.h"

@interface NearbyComplaintsController : UIViewController <APIResponseDelegate, UITableViewDataSource, UITableViewDelegate> {
    DataFetcherResponseHandler* nearbyComplaintUpdateHandler;
    DataFetcher* nearbyComplaintFetcher;
    NSArray* complaints;
}

- (IBAction) doFetchNearby;

@end
