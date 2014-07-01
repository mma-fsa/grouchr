//
//  SecondViewController.m
//  nostoryboard2
//
//  Created by Joel Drotos on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

@synthesize userTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Me", @"Me");
        self.tabBarItem.image = [UIImage imageNamed:@"pirate.png"];
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
    
    userComplaints = [[NSArray alloc] init];
    userInfo = [[NSArray alloc] init];
    
    userComplaintUpdateHandler = [[DataFetcherResponseHandler alloc] initWithDelegate:self];
    userComplaintUpdateHandler.requestType = @"USERCOMPLAINTS";
    userInfoUpdateHandler = [[DataFetcherResponseHandler alloc] initWithDelegate:self];
    userInfoUpdateHandler.requestType = @"USERINFO";
    apiFetcher = [[DataFetcher alloc] init];
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
    [self doFetchUserInfo];
    [self doFetchUserComps];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//custom stuff...

// Table stuff..
-(void) doFetchUserInfo{

    NSLog(@"doFetchUserInfo");
    //[apiFetcher postDataToAPI :[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"USERINFO" :[GrouchrAPI buildUserInfoPayload:@"whiskeyjoe"]]] :userInfoUpdateHandler];
    
}

-(void) doFetchUserComps{
    NSLog(@"doFetchUserComps");
    //[apiFetcher postDataToAPI :[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"USERCOMPLAINTS" :[GrouchrAPI buildUserComplaintsPayload:@"whiskeyjoe":0]]] :userComplaintUpdateHandler];
}

- (void) didAPIRespond:(NSObject*) handler{

    DataFetcherResponseHandler* h = (DataFetcherResponseHandler*)handler;
    NSLog(@"RequestType:%@",h.requestType);
    //NSLog(@"ResponseString:%@",h.responseString);
    
    if(h.requestType == userInfoUpdateHandler.requestType){
        NSDictionary* payload = [userInfoUpdateHandler payload];
        userInfo = [[NSArray alloc] initWithObjects:[APIResponseParser getUserInfo:payload], nil];
        NSLog(@"userInfo populated with %i records",userInfo.count);
    }else if(h.requestType == userComplaintUpdateHandler.requestType){
        NSDictionary* payload = [userComplaintUpdateHandler payload];
        userComplaints = [APIResponseParser getComplaintList:payload];
        NSLog(@"userComplaints populated with %i records",userComplaints.count);
    }else{
        NSLog(@"Bad request type..");
    }
    
    NSLog(@"Refresh on main..");
    [self.userTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"numberOfSectionsInTableView");
    [self setUserTable:tableView];
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"numberOfRowsInSection #%i",section);
    if(section == 0){
        return userInfo.count;
    }else{
        return userComplaints.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 80.0;
    }else{
        return 64.0;
    }
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *UserInfoCellIdentifier = @"UserInfoCell";
    static NSString *ComplaintCellIdentifier = @"ComplaintRowCell";
    
     NSLog(@"section:%i",indexPath.section);
    
    
    if(indexPath.section == 0){
    
        NSLog(@"sec0");
        UIUserInfoTableViewCell *userInfoCell = (UIUserInfoTableViewCell *) [tableView dequeueReusableCellWithIdentifier:UserInfoCellIdentifier];
        if(userInfoCell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:UserInfoCellIdentifier owner:nil options:nil];
            for(id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    userInfoCell = (UIUserInfoTableViewCell *) currentObject;
                    break;
                }
            }
        }
        
        
        if(userInfo != nil){
            NSLog(@"sec0 data");
            UserInfo* tUsr = [userInfo objectAtIndex:indexPath.row];
            if(tUsr != nil){
                userInfoCell.userName.text = [tUsr username];
                userInfoCell.joinDate.text = [tUsr datejoined];
                userInfoCell.totalSubmissions.text = [NSString stringWithFormat:@"%i",[tUsr totalsubmissions]];
                userInfoCell.totalShakePoints.text = [NSString stringWithFormat:@"%i",[tUsr totalshakepoints]];
                userInfoCell.shakePointRank.text = [NSString stringWithFormat:@"%i",[tUsr shakepointrank]];
            }
        }
        
        NSLog(@"sec0 return");
        return userInfoCell;
        
    }else if(indexPath.section == 1){
        UIComplaintTableViewCell *cell = (UIComplaintTableViewCell *) [tableView dequeueReusableCellWithIdentifier:ComplaintCellIdentifier];
        if(cell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:ComplaintCellIdentifier owner:nil options:nil];
            for(id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell = (UIComplaintTableViewCell *) currentObject;
                    break;
                }
            }
        }
        
        if(userComplaints != nil){
            Complaint* tComp = [userComplaints objectAtIndex:indexPath.row];
            if(tComp != nil){
                /*
                cell.venueName.text = [tComp venuename];
                cell.message.text = [tComp message];
                cell.userName.text = [tComp username];
                cell.shakePoints.text = [NSString stringWithFormat:@"%i",[tComp shakepoints]];
                cell.childCount.text = [NSString stringWithFormat:@"%i",[tComp childcount]];
                cell.childShakePoints.text = [NSString stringWithFormat:@"%i",[tComp childshakepoints]];
            */
                }
        }
        return cell;
    }else{
        NSLog(@"section:%i",indexPath.section);
    }
     
    return nil;
    
}

@end
