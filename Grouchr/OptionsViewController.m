//
//  OptionsViewController.m
//  Grouchr
//
//  Created by Mike on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OptionsViewController.h"

@implementation OptionsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        model = [GrouchrModelController getInstance];
        [model addObserver:self forKeyPath:@"canPostToFacebook" options:0 context:nil];
        [model addObserver:self forKeyPath:@"canPostToTwitter" options:0 context:nil];
        [model addObserver:self forKeyPath:@"didGetSocialNetworks" options:0 context:nil];
        viewController = [GrouchrViewController getInstance];
    }
    return self;
}

- (void)dealloc {
    [model removeObserver:self forKeyPath:@"canPostToFacebook"];
    [model removeObserver:self forKeyPath:@"canPostToTwitter"];
    [model removeObserver:self forKeyPath:@"didGetSocialNetworks"];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString: @"canPostToFacebook"]) {
        facebookUpdating = NO;
    }
    else if ([keyPath isEqualToString: @"canPostToTwitter"]) {
        twitterUpdating = NO;
    }
    // don't need to handle didGetSocialNetworks, we just want a table reload
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Button Handlers

- (void) hiddenDidFacebookButtonClick {
    if (model.canPostToFacebook) {
        facebookUpdating = YES;
        [self.tableView reloadData];
        [model startFacebookLogout:self withSelector:@selector(hiddenDidFacebookUpdate)];
    }
    else {
        [model startFacebookAuthentication:self withSelector:@selector(hiddenDidFacebookUpdate)];
    }
}

- (void) hiddenDidFacebookUpdate {
    facebookUpdating = NO;
    [self.tableView reloadData];
}

- (void) hiddenDidGrouchrButtonClick {
    if (model.hasValidToken) {
        [model startLogout:nil withSelector: nil];
    }
}

- (void) hiddenDidTwitterButtonClick {
    if (model.canPostToTwitter) {
        twitterUpdating = YES;
        [self.tableView reloadData];
        [model startTwitterLogout:self withSelector:@selector(hiddenDidTwitterUpdate)];
    }
    else {
        [model startTwitterAuthentication:self withSelector:@selector(hiddenDidTwitterUpdate)];
    }
}

- (void) hiddenDidTwitterUpdate {
    twitterUpdating = NO;
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle: @"Options"];
    self.tableView.backgroundColor = [ViewUtility getGrayBackgroundColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor lightGrayColor];
	headerLabel.font = [UIFont boldSystemFontOfSize: 16];
    headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    
	headerLabel.text = [self tableView: tableView titleForHeaderInSection:section];
    
	[customView addSubview:headerLabel];
    
	return customView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Grouchr Login Options";
    }
    else if (section == 1) {
        return @"Facebook Login Options";
    }
    else if (section == 2) {
        return @"Twitter Login Options";
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (0 <= section && section < 3) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *credentialOptionsIdentifier = @"credentialOptionsCell";
    static NSString *facebookOptionsIdentifier = @"facebookOptionsIdentifier";
    static NSString *twitterOptionsIdentifier = @"twitterOptionsIdentifier";
    
    UITableViewCell *cell = nil;
   
    if (indexPath.section == 0 && indexPath.row == 0) {
    
        cell = [tableView dequeueReusableCellWithIdentifier: credentialOptionsIdentifier];
        
        if (cell == nil) {
            
            MOGlassButton* b = [[MOGlassButton alloc] initWithFrame: CGRectMake(0, 0, 100, 35)];
            [b setupAsOrangeButton];
            
            grouchrButton = b;
            [grouchrButton addTarget:self action:@selector(hiddenDidGrouchrButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [grouchrButton setFont: [UIFont boldSystemFontOfSize: 16.0f]];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:credentialOptionsIdentifier];
            
            cell.accessoryView = grouchrButton;
        }
        
        if (model.hasValidToken == YES) {
            cell.textLabel.text = model.userCredentials.username;
            [grouchrButton setTitle:@"Logout" forState:UIControlStateNormal];
        }
        else {
            cell.detailTextLabel.text = @"";
            [grouchrButton setTitle:@"Login" forState:UIControlStateNormal];
        }
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier: facebookOptionsIdentifier];
        
        if (cell == nil) {
            
            MOGlassButton* b = [[MOGlassButton alloc] initWithFrame: CGRectMake(0, 0, 100, 35)];
            [b setupAsOrangeButton];
            
            facebookButton = b;
            [facebookButton addTarget:self action:@selector(hiddenDidFacebookButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [facebookButton.titleLabel setTextAlignment: UITextAlignmentCenter];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:facebookOptionsIdentifier];
            [facebookButton setFont: [UIFont boldSystemFontOfSize: 16.0f]];
            
            facebookActivity = [[UIActivityIndicatorView alloc] init];
            facebookActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            facebookActivity.frame = CGRectMake(0, 0, 100, 35);
        }
        
        if (model.didGetSocialNetworks == NO || twitterUpdating || facebookUpdating) {
            cell.accessoryView = facebookActivity;
            cell.textLabel.text = @"Updating...";
            [facebookActivity startAnimating];
        }
        else if (model.canPostToFacebook) {
            cell.accessoryView = facebookButton;
            [facebookButton setTitle:@"Logout" forState:UIControlStateNormal];
            cell.textLabel.text = @"Logged in";
        }
        else {
            cell.accessoryView = facebookButton;
            [facebookButton setTitle:@"Login" forState:UIControlStateNormal];
            cell.textLabel.text = @"Logged out";
        }
        
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier: twitterOptionsIdentifier];
        
        if (cell == nil) {
            
            MOGlassButton* b = [[MOGlassButton alloc] initWithFrame: CGRectMake(0, 0, 100, 35)];
            [b setupAsOrangeButton];
            
            twitterButton = b;
            [twitterButton addTarget:self action:@selector(hiddenDidTwitterButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [twitterButton.titleLabel setTextAlignment: UITextAlignmentCenter];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:twitterOptionsIdentifier];
            [twitterButton setFont: [UIFont boldSystemFontOfSize: 16.0f]];
            
            twitterActivity = [[UIActivityIndicatorView alloc] init];
            twitterActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            twitterActivity.frame = CGRectMake(0, 0, 100, 35);
        }

        if (model.didGetSocialNetworks == NO || twitterUpdating || facebookUpdating) {
            cell.textLabel.text = @"Updating...";
            cell.accessoryView = twitterActivity;
            [twitterActivity startAnimating];
        }
        else if (model.canPostToTwitter) {
            [twitterButton setTitle:@"Logout" forState:UIControlStateNormal];
            cell.textLabel.text = @"Logged in";
            cell.accessoryView = twitterButton;
        }
        else {
            [twitterButton setTitle:@"Login" forState:UIControlStateNormal];
            cell.textLabel.text = @"Logged out";
            cell.accessoryView = twitterButton;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
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

@end
