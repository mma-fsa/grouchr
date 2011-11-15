//
//  SecondViewController.h
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
#import "UIUserInfoTableViewCell.h"
#import "APIResponseParser.h"
#import "GrouchrAPI.h"
#import "UserInfo.h"

@interface SecondViewController : UIViewController <APIResponseDelegate, UITableViewDelegate, UITableViewDataSource> {
    __weak UITableView *userTable;
    
    DataFetcherResponseHandler* userComplaintUpdateHandler;
    DataFetcherResponseHandler* userInfoUpdateHandler;
    DataFetcher* apiFetcher;
    
    NSArray* userComplaints;
    NSArray* userInfo;
    
}

- (void) doFetchUserInfo;
- (void) doFetchUserComps;

@property (weak ) UITableView *userTable;

@end
