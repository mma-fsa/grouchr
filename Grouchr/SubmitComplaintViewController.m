//
//  SubmitComplaintViewController.m
//  Grouchr
//
//  Created by Mike on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SubmitComplaintViewController.h"


@implementation SubmitComplaintViewController

@synthesize footerView;
@synthesize isReply;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        self.isReply = NO; 
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
    
    //get model instance
     model = [GrouchrModelController getInstance];
    
    //set nav bar title
    if (self.isReply == YES) {
        [self setTitle: @"Reply"];
    }
    else {
        [self setTitle: @"Complain"];
    }
    
    //add bottom padding to the frame
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 45.0, 0.0);    
    
    self.tableView.backgroundColor = [ViewUtility getGrayBackgroundColor];
    
    //setup footer
    self.footerView.backgroundColor = [UIColor clearColor];
    
    //add "Complain" submit button
    submitButton = [[MOGlassButton alloc] initWithFrame:CGRectMake(10, 10, 300, self.footerView.frame.size.height)];
    [submitButton setupAsOrangeButton];
	[submitButton setTitle:@"Submit Complaint" forState:UIControlStateNormal];
    [submitButton addTarget:self action: @selector(hiddenDidClickSubmit) forControlEvents: UIControlEventTouchUpInside];
    [self.footerView addSubview:submitButton];        
    
    if (self.isReply == NO) {
        complaint = model.submitComplaint;
    }
    else {
        complaint = model.replyComplaint;
    }
    
    [model addObserver:self forKeyPath:@"isComplaintSubmitting" options:0 context:nil];
}


- (void) hiddenHandleComplaintInProgress {
    
    if (model.isComplaintSubmitting) {        
        [DSBezelActivityView activityViewForView:self.view withLabel: @"Submitting Complaint"];
        submitButton.hidden = YES;
    }
    else if (model.isComplaintSubmitting == NO) {
        [DSBezelActivityView removeViewAnimated: YES];
        submitButton.hidden = NO;
    }
    
    [self.tableView reloadData];
}

- (void) dealloc {    
    [model removeObserver:self forKeyPath:@"isComplaintSubmitting"];
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
    if (self.isReply == YES) {
        model.activeComplaint = model.replyComplaint;
    }
    else {
        model.activeComplaint = model.submitComplaint;
    }    
    [self.tableView reloadData];
    [self hiddenHandleComplaintInProgress];        
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

- (void) hiddenDidClickSubmit {
    
    [complaintTextView resignFirstResponder];
    
    if (model.isComplaintSubmitting) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Submit aborted" message:@"You are already submitting a complaint/reply, please wait." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];             
        return;
    }
    else if (self.isReply) {
        model.activeComplaint = model.replyComplaint;
    }
    else {
        model.activeComplaint = model.submitComplaint;
    }    
    
    if (twitterSwitch.on) {
        complaint.postToTwitter = YES;
    }
    if (facebookSwitch.on) {
        complaint.postToFacebook = YES;
    }
    
    if ([self hiddenDidValidate] == NO) {
        return;
    }
    else {
        [model startSubmitComplaint: self withSelector: @selector(hiddenDidSubmitComplaint:)];
        [self hiddenHandleComplaintInProgress];
    }    
}

- (BOOL) hiddenDidValidate {
    
    SubmitComplaint* validateComplaint = (self.isReply == YES)? model.replyComplaint : model.submitComplaint;
    
    NSString* errMsg = nil;
    if (validateComplaint.venue == nil) {
        errMsg = @"Select a location for your complaint.";
    }
    else if (validateComplaint.message == nil || 
             [@"" isEqualToString: [validateComplaint.message stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]]) {
        errMsg = @"Enter a complaint message.";
    }
    
    if (errMsg != nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Required field missing" message:errMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    return (errMsg == nil)? YES : NO;
}

- (void) hiddenSubmitComplaint {
    
    NSLog(@"hiddenSubmitComplaint shouldn't be getting called...");
    
    //[model startSubmitComplaint:self withSelector:@selector(hiddenDidSubmitComplaint:)];
}

- (void) hiddenDidSubmitComplaint: (NSString*) responseCode {    
    
    if (self.isReply) {
        model.replyComplaint = [[SubmitComplaint alloc] init];
        complaint = model.replyComplaint;
        [self.navigationController popViewControllerAnimated: YES];
    }
    else {                             
        model.submitComplaint = [[SubmitComplaint alloc] init];
        complaint = model.submitComplaint;  
        [self hiddenHandleComplaintInProgress];
        [self.tableView reloadData];                        
    }            
    if (twitterSwitch.on) {
        complaint.postToTwitter = YES;
    }
    if (facebookSwitch.on) {
        complaint.postToFacebook = YES;
    }
}

- (void) hiddenDidUploadImage: (NSString*) responseCode {
    if (![@"SUCCESS" isEqualToString: responseCode]) {
        UIAlertView* errorMsg = [[UIAlertView alloc] initWithTitle:@"Error uploading image" message:@"An error occurred while uploading your image, complaint will be submitted without image." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorMsg show];
    }
    [self performSelector: @selector(hiddenSubmitComplaint)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (model.isComplaintSubmitting) 
        return 0;
    
    //first section: required complaint information
    //second section: optional complaint information
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (model.isComplaintSubmitting)
        return 0;
    
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        if (self.isReply == YES) {
            return 3;
        }
        else {
            return 4;
        }
    }
    
    return 0;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString: @"venue"]) {
        Venue* selectedVenue = [object venue];
        locationCell.detailTextLabel.text = selectedVenue.name;
    }
    if ([keyPath isEqualToString: @"isComplaintSubmitting"]) {                        
        [self hiddenHandleComplaintInProgress];
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Required";
    }
    else if (section == 1) {
        return @"Optional";
    }
    
    return @"UNKNOWN";
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LocationCellIdentifier = @"LocationCellIdentifier";
    static NSString *ComplaintCellIdentifier = @"ComplaintCell";
    static NSString *ShakeCellIdentifier = @"ShakeCell";
    static NSString *PictureCellIdentifier = @"PictureCell";
    static NSString *FacebookCellIdentifier = @"FacebookCell";
    static NSString *TwitterCellIdentifier = @"TwitterCell";
    
    UITableViewCell *cell = nil; 
    
    //Required Section
    if (indexPath.section == 0) {
        
        //Location Cell
        if (indexPath.row == 0) {
        
            cell = [tableView dequeueReusableCellWithIdentifier:LocationCellIdentifier];
        
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LocationCellIdentifier];
                cell.imageView.image = [ViewUtility getSmallLocationIcon];
                cell.textLabel.text = @"Location";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.detailTextLabel.font = [UIFont systemFontOfSize: 18.0f];
                cell.detailTextLabel.textColor = [ViewUtility getOrangeLabelColor];
                
                locationCell = cell;
            }
            
            if (complaint != nil && complaint.venue != nil) {
                cell.detailTextLabel.text = complaint.venue.name;
            }
            else {
                cell.detailTextLabel.text = @"<Select>";
            }
        }
    
        //Complaint Cell
        if (indexPath.row == 1) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:ComplaintCellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ComplaintCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                complaintTextView = [[UITextView alloc] initWithFrame: CGRectMake(15.0, 10.0, 290.0, 130.0)];
                complaintTextView.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                complaintTextView.delegate = self;
                complaintTextView.returnKeyType = UIReturnKeyDone;
                [cell.textLabel removeFromSuperview];
                [cell addSubview: complaintTextView];
            }
            
            if (complaint != nil && complaint.message != nil && 
                ![complaint.message isEqualToString:@""]) {
                complaintTextEmpty = NO;
                complaintTextView.textColor = [UIColor blackColor];
                complaintTextView.text = complaint.message;
            }
            else {
                complaintTextEmpty = YES;
                complaintTextView.text = @"enter complaint here";;
                complaintTextView.textColor = [UIColor lightGrayColor];
            }
        }
    }
    
    //Optional Section
    else if (indexPath.section == 1) {
        
        BOOL shakePointsCell = NO;
        BOOL photoCell = NO;
        BOOL facebookCell = NO;
        BOOL twitterCell = NO;        
        
        if (indexPath.row == 0) {
            shakePointsCell = YES;
        }
        else if (self.isReply == YES) {
            if (indexPath.row == 1) {
                facebookCell = YES;
            }
            else if (indexPath.row == 2) {
                twitterCell = YES;
            }
        }
        else if (self.isReply == NO) {
            if (indexPath.row == 1) {
                photoCell = YES;
            }
            else if (indexPath.row == 2) {
                facebookCell = YES;
            }
            else if (indexPath.row == 3) {
                twitterCell = YES;
            }
        }
        
        //Shake points cell
        if (shakePointsCell == YES) {
            cell = [tableView dequeueReusableCellWithIdentifier:ShakeCellIdentifier]; 
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ShakeCellIdentifier];                
                cell.imageView.image = [ViewUtility getSmallFistIcon];
                cell.textLabel.text = @"Shake Points";
                cell.detailTextLabel.textColor = [ViewUtility getOrangeLabelColor];
                cell.detailTextLabel.font = [UIFont systemFontOfSize: 18.0f];
                shakePointsCell = cell;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", complaint.shakepoints];
        }
        
        //Add photo cell
        if (photoCell == YES) {
            cell = [tableView dequeueReusableCellWithIdentifier:PictureCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PictureCellIdentifier];   
                cell.imageView.image = [ViewUtility getSmallCameraIcon];
                photoCell = cell;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            if (complaint.image == nil) {
                cell.textLabel.text = @"Add Photo";
            }
            else {
                cell.textLabel.text = @"Remove Photo";
            }
        }
        
        //Facebook cell
        if (facebookCell == YES) {
            cell = [tableView dequeueReusableCellWithIdentifier: FacebookCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FacebookCellIdentifier]; 
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                facebookSwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
                [facebookSwitch addTarget:self action:@selector(didToggleFacebookSwitch) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = facebookSwitch;                
                cell.textLabel.text = @"Post to Facebook";
            }
            
            if (indexPath.row == 2) {
                //todo: set switch state
            }
        }
        
        //Twitter cell
        if (twitterCell == YES) {
            cell = [tableView dequeueReusableCellWithIdentifier: FacebookCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FacebookCellIdentifier]; 
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                twitterSwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
                [twitterSwitch addTarget:self action:@selector(didToggleTwitterSwitch) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = twitterSwitch;
                cell.textLabel.text = @"Post to Twitter";
            }
            
            if (indexPath.row == 3) {
                //todo: set switch state
            }
        }
    }
    
    return cell;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text == nil || [text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    
    return TRUE;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString: @""]){
        textView.text = @"enter complaint here";;
        textView.textColor = [UIColor lightGrayColor];
        complaintTextEmpty = YES;
    }
    else {
        complaint.message = textView.text;
        complaintTextEmpty = NO;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (complaintTextEmpty) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    return YES;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //complaint text cell
        if (indexPath.row == 1) {
            return 150.0f;
        }
    }
    
    return 50.0;
}

- (void) didToggleFacebookSwitch {    
    if (!model.canPostToFacebook) {
        [facebookSwitch setOn: NO animated: NO];
        [model startFacebookAuthentication: self withSelector: @selector(didFacebookAuthentication:)];
    }
    else if (model.canPostToFacebook && facebookSwitch.on == YES) {
        model.activeComplaint.postToFacebook = YES;
    }
    else {
        model.activeComplaint.postToFacebook = NO;
    }
}

- (void) didFacebookAuthentication: (NSNumber*) success {
    if (model.canPostToFacebook) {
        [facebookSwitch setOn: YES];
        model.activeComplaint.postToFacebook = YES;
    }
}

- (void) didToggleTwitterSwitch {
    if (!model.canPostToTwitter) {
        [twitterSwitch setOn: NO animated: NO];
        [model startTwitterAuthentication: self withSelector: @selector(didTwitterAuthentication)];
    }
    else if (model.canPostToTwitter == YES && twitterSwitch.on == YES) {
        model.activeComplaint.postToTwitter = YES;
    }
    else {
        model.activeComplaint.postToTwitter = NO;
    }
}

- (void) didTwitterAuthentication {    
    if (model.canPostToTwitter) {
        [twitterSwitch setOn: YES];
        model.activeComplaint.postToTwitter = YES;
    }
}

#pragma mark - Table view delegate


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath: indexPath];
    //[cell setHighlighted: NO];
    [cell setSelected: NO];
    
    BOOL shakePointsCell = NO;
    BOOL photoCell = NO;
    BOOL facebookCell = NO;
    BOOL twitterCell = NO;        
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            shakePointsCell = YES;
        }
        else if (self.isReply == YES) {
            if (indexPath.row == 1) {
                facebookCell = YES;
            }
            else if (indexPath.row == 2) {
                twitterCell = YES;
            }
        }
        else if (self.isReply == NO) {
            if (indexPath.row == 1) {
                photoCell = YES;
            }
            else if (indexPath.row == 2) {
                facebookCell = YES;
            }
            else if (indexPath.row == 3) {
                twitterCell = YES;
            }
        }
    }
    
    //handle location select
    if (indexPath.section == 0 && indexPath.row == 0) {
        NearbyVenuesController* nearbyVenuesController = [[NearbyVenuesController alloc] initWithNibName:@"NearbyVenuesController" bundle:nil];
        nearbyVenuesController.isReply = self.isReply;
        [self.navigationController pushViewController: nearbyVenuesController animated:YES];
        
    }
    
    //handle photo click
    else if (photoCell == YES) {
        //add the photo
        if ([model.submitComplaint image] == nil) {
            UIImagePickerController* pickerControl = [[UIImagePickerController alloc] init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                pickerControl.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            else {
                [[UIAlertView alloc] initWithTitle: @"Camera Error" message:@"Could not open camera or photo library." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return;
            }
            pickerControl.allowsEditing = YES;
            pickerControl.delegate = self;
            [self presentModalViewController:pickerControl animated:YES];
        }
        //remove the photo
        else {
            [model.submitComplaint setImage: nil];
            [self.tableView reloadData];
        }                
    }
    
    //handle shake points click
    else if (shakePointsCell == YES) {
        ShakeViewController* shakeViewController = [[ShakeViewController alloc] initWithNibName:@"ShakeViewController" bundle:nil];
        shakeViewController.isReply = self.isReply;
        [self.navigationController pushViewController: shakeViewController animated:YES];
    }
}

// Camera/image picking related stuff 
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissModalViewControllerAnimated: YES];
        
    UIImage* selectedImage = nil;
    if ([info objectForKey:UIImagePickerControllerEditedImage] != nil) {
        selectedImage = [info objectForKey: UIImagePickerControllerEditedImage];
    }
    else if ([info objectForKey: UIImagePickerControllerOriginalImage] != nil) {
        selectedImage = [info objectForKey: UIImagePickerControllerOriginalImage];
    }
    
    if (selectedImage != nil) {
        [complaint setImage: selectedImage];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    if (image != nil) {
        //TODO: setup remove image handler
        [complaint setImage: image];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated: YES];
}


@end
