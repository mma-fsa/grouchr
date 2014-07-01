//
//  CreateUserViewController.m
//  Grouchr
//
//  Created by Mike on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateUserViewController.h"

@implementation CreateUserViewController

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
    
    [self setTitle: @"Create User"];
    
    self.tableView.backgroundColor = [ViewUtility getGrayBackgroundColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    model = [GrouchrModelController getInstance];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Create a new Grouchr user.";
    }
    return @"";
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView* buttonsContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
        
        MOGlassButton *create = [[MOGlassButton alloc] initWithFrame: CGRectMake(10, 10, 300, 50)];
        [create setTitle: @"Create Account" forState:UIControlStateNormal];
        [create setupAsOrangeButton];
        
        [create addTarget: self action:@selector(createUserClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsContainer addSubview: create] ;
        return buttonsContainer;
    }
    return nil;
}

- (void) createUserClicked {

    UIAlertView* errorMsg = nil;
    
    txtUsername.text = [txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([txtUsername.text length] < 4 || [txtUsername.text length] > 32) {
        errorMsg = [[UIAlertView alloc] initWithTitle:@"Error creating user" message:@"Username must be between 4 and 32 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else if ([txtPassword1.text length] < 6) {
        errorMsg = [[UIAlertView alloc] initWithTitle:@"Error creating user" message:@"Passwords must be at least 6 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else if (![txtPassword1.text isEqualToString: txtPassword2.text]) {
        errorMsg = [[UIAlertView alloc] initWithTitle:@"Error creating user" message:@"Both passwords must match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else {
        model.userCredentials.username = txtUsername.text;
        model.userCredentials.password = txtPassword1.text;
        [model startNewUser:self withSelector:@selector(hiddenDidCreateUser:)];
    }
    
    if (errorMsg != nil) {
        [errorMsg show];
    }
}

- (void) hiddenDidCreateUser: (NSString*) responseCode { 
    
    UIAlertView* errorMsg = nil;
    if ([@"EXISTS" isEqualToString: responseCode]) {
        errorMsg = [[UIAlertView alloc] initWithTitle:@"Error creating user" message:@"The specified username is taken, please choose another." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else if ([@"INVALID_USERNAME" isEqualToString: responseCode]) {
        errorMsg = [[UIAlertView alloc] initWithTitle:@"Error creating user" message:@"Please enter an alphanumeric username between 4 and 32 characters in length." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else if ([@"WEAK_PASSWORD" isEqualToString: responseCode]) {
        errorMsg = [[UIAlertView alloc] initWithTitle:@"Error creating user" message:@"Please choose a password with 6 characters or more." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else if ([@"BAD_LOGIN" isEqualToString: responseCode]) {
        errorMsg = [[UIAlertView alloc] initWithTitle:@"Error creating user" message:@"Unspecified error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else if ([@"BAD_REQUEST" isEqualToString: responseCode]) {
        errorMsg = [[UIAlertView alloc] initWithTitle:@"Error creating user" message:@"Unspecified error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
    if (errorMsg != nil) {
        [errorMsg show];
    }
    else {
        [model startLogin:self withSelector: @selector(hiddenDidLogin:)];
    }
}

- (void) hiddenDidLogin: (NSString*) responseCode {
    if ([@"BAD_LOGIN" isEqualToString: responseCode]) {
        UIAlertView* msg = [[UIAlertView alloc] initWithTitle: @"Login Failed" message:@"Please check your username, re-enter your password and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [msg show];
    }
    if ([@"BAD_REQUEST" isEqualToString: responseCode]) {
        UIAlertView* msg = [[UIAlertView alloc] initWithTitle: @"Login Failed" message:@"Unspecified error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [msg show];
    }  
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 70.0f;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserNameCellIdentifier = @"UsernameCell";
    static NSString *PasswordCellIdentifier = @"PasswordCell";
    static NSString *ConfirmPasswordCellIdentifier = @"ConfirmPasswordCell";
    
    BOOL needsInit = NO;
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:UserNameCellIdentifier];  
        }
        else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:PasswordCellIdentifier];
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier: ConfirmPasswordCellIdentifier];
        }
    }
    
    if (cell == nil) {
        needsInit = YES;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserNameCellIdentifier];
            }
            else if (indexPath.row == 1) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PasswordCellIdentifier];
            }
            else if (indexPath.row == 2) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ConfirmPasswordCellIdentifier];
            }
        }
    }
    
    if (needsInit && indexPath.section == 0) {
        if (indexPath.row == 0) {
            txtUsername = [[UITextField alloc] initWithFrame: CGRectOffset(cell.contentView.frame, 5, 10)];
            txtUsername.delegate = self;
            txtUsername.keyboardType = UIKeyboardTypeURL;
            txtUsername.placeholder = @"Username";
            txtUsername.autocapitalizationType = UITextAutocapitalizationTypeNone;
            txtUsername.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.textLabel removeFromSuperview];
            [cell.contentView addSubview: txtUsername];
        }
        else if(indexPath.row == 1 || indexPath.row == 2) {
            UITextField* txtPassword = [[UITextField alloc] initWithFrame: CGRectOffset(cell.contentView.frame, 5, 10)];
            
            if (indexPath.row == 1) {
                txtPassword1 = txtPassword;
                txtPassword1.placeholder = @"Password";
            }
            else if (indexPath.row == 2) {
                txtPassword2 = txtPassword;
                txtPassword2.placeholder = @"Confirm Password";
            }
            txtPassword.delegate = self;
            txtPassword.keyboardType = UIKeyboardTypeURL;
            txtPassword.keyboardAppearance = UIKeyboardAppearanceAlert;
            txtPassword.secureTextEntry = YES;
            txtPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
            txtPassword.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.textLabel removeFromSuperview];
            [cell.contentView addSubview: txtPassword];
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
