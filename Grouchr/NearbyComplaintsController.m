//
//  FirstViewController.m
//  nostoryboard2
//
//  Created by Joel Drotos on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyComplaintsController.h"

@implementation NearbyComplaintsController

@synthesize complaintTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Nearby", @"Nearby");
        self.tabBarItem.image = [UIImage imageNamed:@"wordbubbleicon.png"];
        //self.complaintTable = [complaintTable 
    }
    return self;
}
							
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
    
    NSLog(@"viewDidLoad");
    
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear - calling doFetchNearby");
    [self doFetchNearby];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Table stuff..
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
- (void) didAPIRespond:(NSObject*) handler{
    NSLog(@"Callback! hooray!");
    
    NSLog(@"Response: %@",[nearbyComplaintUpdateHandler responseString]);
    
    NSDictionary* payload = [nearbyComplaintUpdateHandler payload];
    complaints = [APIResponseParser getComplaintList:payload];
    
    NSLog(@"Complaints populated, size:%i",[complaints count]);
    
    NSLog(@"refresh stuff on main thread...");
    //[self performSelectorOnMainThread: withObject:<#(id)#> waitUntilDone:<#(BOOL)#>
    [self.complaintTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    //[tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"numberOfSectionsInTableView");
    NSLog(@"set ComplaintTable");
    [self setComplaintTable:tableView];
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"numberOfRowsInSelection");
    return complaints.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ComplaintRowCell";
    
    UIComplaintTableViewCell *cell = (UIComplaintTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ComplaintRowCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell = (UIComplaintTableViewCell *) currentObject;
                break;
            }
        }
    }
    if(complaints != nil){
    Complaint* tComp = [complaints objectAtIndex:indexPath.row];
    if(tComp != nil){
    cell.venueName.text = [tComp venuename];
    cell.message.text = [tComp message];
    cell.userName.text = [tComp username];
    cell.shakePoints.text = [NSString stringWithFormat:@"%i",[tComp shakepoints]];
    cell.childCount.text = [NSString stringWithFormat:@"%i",[tComp childcount]];
    cell.childShakePoints.text = [NSString stringWithFormat:@"%i",[tComp childshakepoints]];
    }
    }
    NSLog(@"8");        
    return cell;
    
}


@end
