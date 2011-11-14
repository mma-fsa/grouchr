//
//  FirstViewController.m
//  Grouchr
//
//  Created by Joel Drotos on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyComplaintsController.h"

#import "GrouchrAPI.h"
#import "DataFetcher.h"
#import "DataFetcherResponseHandler.h"
#import "UIComplaintTableViewCell.h"
#import "Complaint.h"
#import "APIResponseParser.h"

@implementation NearbyComplaintsController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    complaints = [[NSArray alloc] init];
    nearbyComplaintUpdateHandler = [[DataFetcherResponseHandler alloc] initWithDelegate:self];
    nearbyComplaintFetcher = [[DataFetcher alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"applicationDidBecomeActive");
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(IBAction) doFetchNearby{
    
    
    
//    NSLog(@"Login Payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"LOGIN" :[GrouchrAPI buildLoginPayload:@"User" :@"<password>"]]]);
//    NSLog(@"Authenticate Payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"AUTHENTICATE" :[GrouchrAPI buildAuthenticatePayload:@"User" :@"tok123"]]]);
//    NSLog(@"New user payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"NEWUSER" :[GrouchrAPI buildNewUserPayload:@"User" :@"Pass"]]]);
//    NSLog(@"Nearby payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"COMPLAINTS" :[GrouchrAPI buildNearbyComplaintsPayload:[NSNumber numberWithDouble:44.12345] : [NSNumber numberWithDouble:99.12345] :0]]]);
//    NSLog(@"UserComps payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"USERCOMPLAINTS" :[GrouchrAPI buildUserComplaintsPayload:@"whiskeyjoe" :0]]]);
//    NSLog(@"SingleComp payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"SINGLECOMPLAINT" :[GrouchrAPI buildSingleComplaintPayload:1]]]);
//    NSLog(@"GetThread payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"GETTHREAD" :[GrouchrAPI buildGetThreadPayload:1]]]);
    
    
    
    NSLog(@"Make call");
    [nearbyComplaintFetcher postDataToAPI :[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"COMPLAINTS" :[GrouchrAPI buildNearbyComplaintsPayload:[NSNumber numberWithDouble:44.944191] : [NSNumber numberWithDouble:-93.242168] :0]]] :nearbyComplaintUpdateHandler];
    
//    [nearbyComplaintFetcher postData:urlStr :[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"USERCOMPLAINTS" :[GrouchrAPI buildUserComplaintsPayload:@"whiskeyjoe" :0]]] :nearbyComplaintUpdateHandler];
//    
//    [nearbyComplaintFetcher postData:urlStr :[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"SINGLECOMPLAINT" :[GrouchrAPI buildSingleComplaintPayload:1]]] :nearbyComplaintUpdateHandler];
//    
//    [nearbyComplaintFetcher postData:urlStr :[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"GETTHREAD" :[GrouchrAPI buildGetThreadPayload:1]]] :nearbyComplaintUpdateHandler];
}
- (void) didAPIRespond{
    NSLog(@"Callback! hooray!");
    
    NSLog(@"Response: %@",[nearbyComplaintUpdateHandler responseString]);
    
    NSDictionary* payload = [nearbyComplaintUpdateHandler payload];
    complaints = [APIResponseParser getComplaintList:payload];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return complaints.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString* CellIdentifier = @"Cell";
    UIComplaintTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UIComplaintTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Complaint* tComp = [complaints objectAtIndex:indexPath.row];
    
    cell.venueName.text = [tComp venuename];
    cell.message.text = [tComp message];
    cell.userName.text = [tComp username];
    cell.shakePoints.text = [NSString stringWithFormat:@"%i",[tComp shakepoints]];
    cell.childCount.text = [NSString stringWithFormat:@"%i",[tComp childcount]];
    cell.childShakePoints.text = [NSString stringWithFormat:@"%i",[tComp childshakepoints]];
    
    return cell;
    
}

@end
