//
//  NearbyComplaintsDetailViewController.m
//  Grouchr
//
//  Created by Mike on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyComplaintsDetailViewController.h"


@implementation NearbyComplaintsDetailViewController
@synthesize threadSubmissionId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc {
    [model removeObserver: self forKeyPath:@"complaintThreads"];
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

    model = [GrouchrModelController getInstance];
    complaintThread = [model complaintThread: self.threadSubmissionId];
    
    [self setTitle: @"Complaint"];
    if (complaintThread != nil && [complaintThread count] > 1) {
        [self setTitle: [NSString stringWithFormat: @"%d Complaints", [complaintThread count]]];
    }
    
    shortDateFormatter = [[NSDateFormatter alloc] init];
    [shortDateFormatter setDateFormat: @"MM-dd-yy"];
    
    replyButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStyleBordered target:self action:@selector(hiddenDidClickReply)];
    replyButton.tintColor = [ViewUtility getOrangeLabelColor];
    
    if (complaintThread != nil) {
        [[self navigationItem] setRightBarButtonItem: replyButton];
    }
    
    [model addObserver:self forKeyPath:@"complaintThreads" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString: @"complaintThreads"]) {
        NSArray* updatedComplaintThread = [model complaintThread: self.threadSubmissionId];
        if (complaintThread != updatedComplaintThread){
            complaintThread = updatedComplaintThread;
            
            if ([complaintThread count] > 1) {
                [self setTitle: [NSString stringWithFormat: @"%d Complaints", [complaintThread count]]];
            }
            [[self navigationItem] setRightBarButtonItem: replyButton];            
        }        
        if (complaintThread != nil && [complaintThread count] > 1) {
            [self setTitle: [NSString stringWithFormat: @"%d Complaints", [complaintThread count]]];
        }
        [self.tableView reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (complaintThread == nil) {
        return 1;
    }
    else {
        return [complaintThread count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *LoadingCellIdentifier = @"DetailLoadingCell";
    
    CGRect cellSize = CGRectMake(0, 0, 320, 380);
    
    if (complaintThread == nil) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadingCellIdentifier];
            
            UIActivityIndicatorView *activityView = 
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [activityView startAnimating];
            [cell setAccessoryView:activityView];
            
            [cell.textLabel setTextColor: [UIColor lightGrayColor]];
            [cell.textLabel setFont: [UIFont boldSystemFontOfSize: 24.0f]];
            [cell.textLabel setBackgroundColor: [UIColor clearColor]];
            
            cell.backgroundView = [[UIImageView alloc] initWithFrame: cellSize];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ((UIImageView*)cell.backgroundView).image = [ViewUtility getEmptyNearbyCellBackground];
            ((UIImageView*)cell.selectedBackgroundView).image = [ViewUtility getEmptyNearbyCellBackground];
                        
            cell.textLabel.text = @"Loading...";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
        }
        
        return cell;
    }
    else {
        
        NearbyComplaintsDetailUITableViewCell* detailCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (detailCell == nil) {
            
            detailCell = [[NearbyComplaintsDetailUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            detailCell.selectionStyle = UITableViewCellSelectionStyleNone;            
            
            detailCell.backgroundView = [[UIImageView alloc] initWithFrame: cellSize];
            ((UIImageView*)detailCell.backgroundView).image = [ViewUtility getDetailViewBackground];
            
            detailCell.contentView = [[NearbyComplaintsDetailContentView alloc] initWithFrame: cellSize];
            [detailCell addSubview: detailCell.contentView];
            
            [detailCell.contentView.viewPictureButton addTarget:self action:@selector(hiddenDidClickViewPicture:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        Complaint* c = [complaintThread objectAtIndex: indexPath.row];
        
        if ( c != nil) {
            NearbyComplaintsDetailContentView* content = detailCell.contentView;    
                        
            NSString* trimmedVenueName = [NSString stringWithFormat: @"@%@", c.venuename];
            if ([trimmedVenueName length] > 23) {
                trimmedVenueName = [NSString stringWithFormat: @"%@...", [trimmedVenueName substringToIndex: 20]];
            }
            
            content.detailTitle.text = trimmedVenueName;
            content.detailSubTitle.text = [NSString stringWithFormat: @"by %@", c.username]; 
            content.pointsLabel.text = [NSString stringWithFormat: @"%d points", c.shakepoints];
            content.complaintText.text = c.message;
            
            if (c.hasImage) {
                content.viewPictureButton.hidden = NO;
                imageURL = c.imageurl_orig;
            }
            else {
                content.viewPictureButton.hidden = YES;
                imageURL = nil;
            }
        }
        
        return detailCell;
    }
    
    return nil;
}

#pragma mark - table view styling 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 380.0f;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Button Handlers

- (void) hiddenDidClickViewPicture: (id)sender {
    if (imageURL != nil) {
        ImageViewerViewController* imgViewerController = [[ImageViewerViewController alloc] init];
        imgViewerController.imageURL = [NSURL URLWithString: imageURL];
        [self.navigationController pushViewController:imgViewerController animated:YES];
    }
}

- (void) hiddenDidClickReply {

    SubmitComplaintViewController* replyController = [[SubmitComplaintViewController alloc] initWithNibName:@"SubmitComplaintViewController" bundle:nil];
    replyController.isReply = YES;
    model.replyComplaint = [[SubmitComplaint alloc] init];
    model.replyComplaint.parentThreadId = [NSNumber numberWithInt: self.threadSubmissionId];
    if (complaintThread != nil && [complaintThread count] > 0) {
        Complaint* c = [complaintThread objectAtIndex: 0];
        Venue* v = [[Venue alloc] init];
        v.venueid = [NSString stringWithFormat: @"%d", c.venueid];
        v.name = c.venuename;
        v.isCustom = NO;
        v.provider = @"GROUCHR";
        model.replyComplaint.venue = v;
    }
    
    [self.navigationController pushViewController:replyController animated:YES];
}

@end
