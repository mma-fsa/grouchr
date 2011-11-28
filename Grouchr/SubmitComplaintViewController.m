//
//  SubmitComplaintViewController.m
//  Grouchr
//
//  Created by Mike on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SubmitComplaintViewController.h"

//the types of cells in our detail view
static NSString* complaintPlaceHolderText = @"enter complaint here";

@implementation SubmitComplaintViewController
@synthesize footerView;
- (id)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}


- (id) init {
    return [super init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle: UITableViewStyleGrouped];
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
    
    //set nav bar title
    [self setTitle: @"Complain"];
    
    //add bottom padding to the frame
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0);    
    
    //setup footer
    self.footerView.backgroundColor = [UIColor clearColor];

    MOGlassButton* glossyButton = [[MOGlassButton alloc] initWithFrame:CGRectMake(10, 10, 300, self.footerView.frame.size.height)];
    [glossyButton setupAsOrangeButton];
	[glossyButton setTitle:@"Submit Complaint" forState:UIControlStateNormal];
    
    [self.footerView addSubview:glossyButton];
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
    //first section: required complaint information
    //second section: optional complaint information
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return 2;
    }
    
    return 0;
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *ComplaintCellIdentifier = @"ComplaintCell";
    
    UITableViewCell *cell = nil; 
    
    //try to retrieve the cell if already created
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:ComplaintCellIdentifier];
    }
    
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    //create the cells if necessary
    if (cell == nil) {
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ComplaintCellIdentifier];
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
    }
    
    // Configure the cell...
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    //required information
    if (indexPath.section == 0) {
        //location select
        if (indexPath.row == 0) {
            cell.imageView.image = [ViewUtility getSmallLocationIcon];
            cell.textLabel.text = @"Location";
            cell.detailTextLabel.text = @"<Select>";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        //complaint text info
        else if (indexPath.row == 1) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextView* complaintTextView = [[UITextView alloc] initWithFrame: CGRectMake(15.0, 10.0, 290.0, 130.0)];
            complaintTextView.textColor = [UIColor lightGrayColor];
            complaintTextView.text = complaintPlaceHolderText;
            complaintTextView.font = [UIFont fontWithName:@"Helvetica" size:15.0];

            complaintTextEmpty = YES;
            complaintTextView.delegate = self;
            complaintTextView.returnKeyType = UIReturnKeyDone;
            [cell.textLabel removeFromSuperview];
            [cell addSubview: complaintTextView];
        }
    }
    
    //optional infomation, photos, shake, etc
    else if (indexPath.section == 1) {
        
        //shake meter
        if (indexPath.row == 0) {            
            cell.imageView.image = [ViewUtility getSmallFistIcon];
            cell.textLabel.text = @"Shake Points";
            cell.detailTextLabel.text = @"0";
        }
        else if (indexPath.row == 1) {
            cell.imageView.image = [ViewUtility getSmallCameraIcon];
            cell.textLabel.text = @"Add Photo";
        }
        
    }
        
    return cell;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString: @""]){
        textView.text = complaintPlaceHolderText;
        textView.textColor = [UIColor lightGrayColor];
        complaintTextEmpty = YES;
    }
    else {
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


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath: indexPath];
    //[cell setHighlighted: NO];
    [cell setSelected: NO];
    
    //handle photo click
    if (indexPath.section == 1 && indexPath.row == 1) {
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
    
}

// Camera/image picking related stuff 
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
