//
//  AddLocationViewController.m
//  Grouchr
//
//  Created by Mike on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AddLocationViewController.h"

@implementation AddLocationViewController
@synthesize footerView;

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

    [self setTitle: @"Custom Location"];
    
    self.tableView.backgroundColor = [ViewUtility getGrayBackgroundColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    self.footerView.backgroundColor = [UIColor clearColor];
    
    MOGlassButton* glossyButton = [[MOGlassButton alloc] initWithFrame:CGRectMake(10, 10, 300, self.footerView.frame.size.height)];
    [glossyButton setupAsOrangeButton];
	[glossyButton setTitle:@"Add Location" forState:UIControlStateNormal];
    [glossyButton addTarget:self action: @selector(hiddenDidClickAddLocation) forControlEvents: UIControlEventTouchUpInside];
    [self.footerView addSubview:glossyButton];
}

- (void) hiddenDidClickAddLocation {
    if ([self validateVenueName] == YES) {                
        Venue* newVenue = [[Venue alloc] init];
        newVenue.venueid = nil;
        newVenue.isCustom = YES;
        newVenue.name = [locationNameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];        
        GrouchrModelController* model = [GrouchrModelController getInstance];            
        [model.nearbyVenues insertObject:newVenue atIndex:0];        
        [self.navigationController popViewControllerAnimated: YES];
    }
}

- (BOOL) validateVenueName {
    BOOL success = YES;
    
    NSString* trimmedLocationName = [locationNameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* errorMessage = nil;
    if (trimmedLocationName == nil || [@"" isEqualToString: trimmedLocationName]) {
        errorMessage = @"Please enter a non-blank name.";
    }
    
    if (errorMessage != nil) {
        success = NO;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Missing Field" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    return success;
}

- (void) hiddenDidAddLocation {
    //todo: trigger table refresh to reflect added location / close view controller
}

- (void) cancelButtonClicked {
    [self.parentViewController dismissModalViewControllerAnimated: YES];
}

- (void)viewDidUnload
{
    [self setFooterView:nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Location Details";
    }
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        locationNameTextField = [[UITextField alloc] initWithFrame: CGRectMake(15, 10, 290, 30)];
        locationNameTextField.adjustsFontSizeToFitWidth = YES;
        locationNameTextField.textColor = [UIColor blackColor];
        locationNameTextField.placeholder = @"Enter Location Name";
        locationNameTextField.keyboardType = UIKeyboardTypeDefault;
        locationNameTextField.returnKeyType = UIReturnKeyDone;
        locationNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        locationNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        locationNameTextField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview: locationNameTextField];
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
