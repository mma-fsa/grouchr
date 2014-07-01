//
//  NearbyVenuesController.h
//  Grouchr
//
//  Created by Mike on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouchrModelController.h"
#import "AddLocationViewController.h"
#import "Venue.h"

@interface NearbyVenuesController : UITableViewController {
    GrouchrModelController* model;
}

@property (readwrite) BOOL isReply;

@end
