//
//  NearbyComplaintsViewController.m
//  Grouchr
//
//  Created by Mike on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyComplaintsViewController.h"

@implementation NearbyComplaintsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle: @"Nearby Complaints"];
    [self.tableView setBackgroundColor: [UIColor clearColor]];
    
    model = [GrouchrModelController getInstance];
    model.fetchNextPageDelegate = self;
    model.fetchNextPageSelector = @selector(hiddenHandleNextPage:);
    
    complaintCount = 0;
    
    delayLoading = NO;
    isUpdatingTable = NO;
    
    [model addObserver:self forKeyPath:@"nearbyComplaints" options:0 context:nil];
    [model addObserver:self forKeyPath:@"isNearbyComplaintsUpdating" options:0 context:nil];
}

- (void)dealloc {
    [model removeObserver:self forKeyPath:@"nearbyComplaints"];
    [model removeObserver:self forKeyPath:@"isNearbyComplaintsUpdating"];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];

    model.fetchNextPageDelegate = nil;
    model.fetchNextPageSelector = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView beginUpdates];
    [self.tableView reloadData];
    [self.tableView endUpdates];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString: @"nearbyComplaints"] && !model.isNearbyComplaintsFetchingNextPage) {
        [self refreshNearbyComplaints];
    }
    else if (!delayLoading && [keyPath isEqualToString: @"isNearbyComplaintsUpdating"] && model.isNearbyComplaintsUpdating == YES) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	[self.tableView beginUpdates];
        [self.tableView reloadData];
	[self.tablwView endUpdates];
        delayLoading = YES;
        [NSTimer scheduledTimerWithTimeInterval: 2.0 target:self selector:@selector(hiddenResetDelayLoading) userInfo:nil repeats:NO];
    }
}

- (void) hiddenResetDelayLoading {
    delayLoading = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (model == nil) {
        numberTableRows = 0;
    }
    else if (model.isNearbyComplaintsUpdating && isUpdatingTable == NO) {
        [tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        tableView.scrollEnabled = NO;  
        numberTableRows = 4;
    }
    else {
        tableView.scrollEnabled = YES;
        contentViews = [[NSMutableArray alloc] init];    
        complaintCount = [[model nearbyComplaints] count];
                                      
        numberTableRows = MAX([[model nearbyComplaints] count] + 1, 4);               
    }
    return numberTableRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ThisIsACell";
    static NSString *LoadingCellIdentifier = @"LoadingCell";
    static NSString *BlankCellIdentifier = @"BlankCell";
    static NSString *FetchingMoreCellIdentifier = @"FetchingMoreCell";
    static NSString *NoMoreNearbyCellIdentifier = @"NoMoreNearbyCell";
    
    UITableViewCell *cell = nil;
    
    if ((model.isNearbyComplaintsUpdating && !isUpdatingTable) || indexPath.row >= complaintCount) {
        
        NSString* cellText = nil;
        BOOL isLoadingCell = NO;
        BOOL isFetchingMoreCell = NO;
        BOOL isNoMoreNearbyCell = NO;

        
        //Figure out which cell / text to display
        if (model.isNearbyComplaintsUpdating && indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
            cellText = @"Loading...";
            isLoadingCell = YES;
        }
        else if (!model.isNearbyComplaintsUpdating && !model.hasFetchedAllNearbyComplaints && indexPath.row == numberTableRows - 1) {      
            cell = [tableView dequeueReusableCellWithIdentifier:FetchingMoreCellIdentifier];
            cellText = @"Tap to fetch more.";
            isFetchingMoreCell = YES;
        }
        else if (model.hasFetchedAllNearbyComplaints && indexPath.row == numberTableRows - 1) {
            cell = [tableView dequeueReusableCellWithIdentifier: NoMoreNearbyCellIdentifier];
            cellText = @"No more nearby.";                
            isNoMoreNearbyCell = YES;
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:BlankCellIdentifier];
        }        
        
        // Init cells
        if (cell == nil) {
            
            CGRect cellSize = CGRectMake(0, 0, 320, 120);
            
            if (isLoadingCell || isFetchingMoreCell) {
                NSString* cellID = (isLoadingCell)? LoadingCellIdentifier : FetchingMoreCellIdentifier;
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];                                
//                UIActivityIndicatorView* loadingActivity = 
//                    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];                                
//                [cell setAccessoryView:loadingActivity];
//                [loadingActivity startAnimating];
            }
            else if (isNoMoreNearbyCell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NoMoreNearbyCellIdentifier];
            }
            else {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BlankCellIdentifier];
            }
            
            [cell.textLabel setTextAlignment: UITextAlignmentCenter];
            [cell.textLabel setTextColor: [UIColor lightGrayColor]];
            [cell.textLabel setFont: [UIFont boldSystemFontOfSize: 24.0f]];
                
            cell.backgroundView = [[UIImageView alloc] initWithFrame: cellSize];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor: [UIColor clearColor]];
            ((UIImageView*)cell.backgroundView).image = [ViewUtility getEmptyNearbyCellBackground];
            ((UIImageView*)cell.selectedBackgroundView).image = [ViewUtility getEmptyNearbyCellBackground];
             
        }
    
        if (cellText != nil){
            cell.textLabel.text = cellText;
        }            
    }
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NearbyComplaintsContentView* content = nil;
        
        if (cell == nil) {
            CGRect cellSize = CGRectMake(0, 0, 320, 120);
            cell = [[NearbyComplaintsUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundView = [[UIImageView alloc] initWithFrame: cellSize];
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;        
            [cell setBackgroundColor: [UIColor clearColor]];
            
            ((UIImageView *)cell.backgroundView).image = [ViewUtility getNearbyCellBackground];    
            //((UIImageView *)cell.selectedBackgroundView).image = [ViewUtility getNearbyCellBackground];
            
            content = [[NearbyComplaintsContentView alloc] initWithFrame: cellSize];
            ((NearbyComplaintsUITableViewCell*)cell).nearbyContent = content;
            [cell addSubview: content];
        }
        else {
            content = ((NearbyComplaintsUITableViewCell*)cell).nearbyContent;
        }
        
        if (content != nil) {
            Complaint* c = [model.nearbyComplaints objectAtIndex: indexPath.row];        
            
            content.venueLabel.text = [NSString stringWithFormat:@"@%@", c.venuename];
            content.submitterLabel.text = c.username;
            content.repliesLabel.text = [NSString stringWithFormat: @"%d replies", c.childcount];
            content.pointsLabel.text = [NSString stringWithFormat: @"%d points", c.shakepoints];
            
            
            if (c.hasImage) {
                content.picturesLabel.text = @"image";
                content.noPicturesLabel.text = @"";
            }
            else {
                content.picturesLabel.text = @"";
                content.noPicturesLabel.text = @"none";
            }
            
            NSString* complaintText = c.message;
            
            if ([complaintText length] > 65) {
                complaintText = [NSString stringWithFormat: @"%@...", [complaintText substringToIndex: 62]];
            }
            
            content.complaintTextView.text = complaintText;  
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (model.nearbyComplaints != nil && [model.nearbyComplaints count] > 0 && !model.isNearbyComplaintsUpdating && !model.isNearbyComplaintsFetchingNextPage && indexPath.row == model.nearbyComplaints.count) {
//        [model fetchNextPage];
//    }
}

- (void) refreshNearbyComplaints {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void) hiddenHandleNextPage: (NSNumber*) numAdded {
    
    //20 is the number of records per page
    if (model != nil && model.nearbyComplaints != nil) {
        
        NSUInteger addStart = model.nearbyComplaints.count - [numAdded intValue] + 1;
        
        NSMutableArray* newRows = [[NSMutableArray alloc] init];
        for (int i = 0; i < [numAdded intValue]; i++) {
            [newRows addObject: [NSIndexPath indexPathForRow: addStart + i inSection:0]];
        }
        
        if ([newRows count] > 0) {
            
            isUpdatingTable = YES;
            NSIndexPath* updateRows = [NSIndexPath indexPathForRow: addStart - 1 inSection: 0];   
            complaintCount = [[model nearbyComplaints] count];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:newRows withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: updateRows] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            isUpdatingTable = NO;
            
            model.numberFetchedComplaints = 0;
            
        }
    }
    
    [[GrouchrViewController getInstance] hideLoadingOverlay];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (indexPath.row > [[model nearbyComplaints] count] - 1) {
        if (model.hasFetchedAllNearbyComplaints == YES)
            return;
        
        GrouchrViewController* viewController = [GrouchrViewController getInstance];
        [viewController showLoadingOverlay: @"Fetching more..."];
        [model fetchNextPage];
    }
    else {    
        NearbyComplaintsDetailViewController* detailView = [[NearbyComplaintsDetailViewController alloc] init];
        detailView.threadSubmissionId = [[model.nearbyComplaints objectAtIndex: indexPath.row] submissionid];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Nearby" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [[self navigationItem] setBackBarButtonItem:backButton];
        
        [self.navigationController pushViewController:(UIViewController*)detailView animated: YES];
    }
}

@end
