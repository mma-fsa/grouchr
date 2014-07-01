//
//  LoginViewController.m
//  Grouchr
//
//  Created by Mike on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

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

    [self setTitle: @"Login"];
    
    UIBarButtonItem* createUser = [[UIBarButtonItem alloc] initWithTitle:@"Create User" style:UIBarButtonItemStyleBordered target:self action:@selector(createUserClicked)];
    self.navigationItem.rightBarButtonItem = createUser;

    self.tableView.backgroundColor = [ViewUtility getGrayBackgroundColor];
 
    model = [GrouchrModelController getInstance];
}

- (void)createUserClicked {
    CreateUserViewController* createUserViewController = [[CreateUserViewController alloc] initWithNibName: @"CreateUserViewController" bundle:nil];
    [createUserViewController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    [createUserViewController setProvidesPresentationContextTransitionStyle: YES];
    [self.navigationController pushViewController: createUserViewController animated:YES];
}

- (void)loginClicked {
    model.userCredentials.username = txtUsername.text;
    model.userCredentials.password = txtPassword.text;
    [model startLogin:self withSelector: @selector(hiddenDidLogin:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

- (void) hiddenDidLogin: (NSString*) responseCode {
    if ([@"BAD_LOGIN" isEqualToString: responseCode]) {
        UIAlertView* msg = [[UIAlertView alloc] initWithTitle: @"Login Failed" message:@"Please check your username, re-enter your password and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [msg show];
        txtPassword.text = @"";
    }
    if ([@"BAD_REQUEST" isEqualToString: responseCode]) {
        UIAlertView* msg = [[UIAlertView alloc] initWithTitle: @"Login Failed" message:@"Unspecified error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [msg show];
        txtPassword.text = @"";
    }    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Enter your Grouchr login details, or click \"Create User\" to sign up.";
    }
    
    return @"Not implemented";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0){
        return 2;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserNameCellIdentifier = @"UsernameCell";
    static NSString *PasswordCellIdentifier = @"PasswordCell";
    
    BOOL needsInit = NO;
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:UserNameCellIdentifier];  
        }
        else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:PasswordCellIdentifier];
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
        }
    }
    
    if (needsInit && indexPath.section == 0) {
        if (indexPath.row == 0) {
            txtUsername = [[UITextField alloc] initWithFrame: CGRectOffset(cell.contentView.frame, 5, 10)];
            txtUsername.delegate = self;
            txtUsername.keyboardType = UIKeyboardTypeURL;
            txtUsername.placeholder = @"Username";
            txtUsername.autocorrectionType = UITextAutocorrectionTypeNo;
            txtUsername.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [cell.textLabel removeFromSuperview];
            [cell.contentView addSubview: txtUsername];
        }
        else if(indexPath.row == 1) {
            txtPassword = [[UITextField alloc] initWithFrame: CGRectOffset(cell.contentView.frame, 5, 10)];
            txtPassword.delegate = self;
            txtPassword.keyboardType = UIKeyboardTypeURL;
            txtPassword.keyboardAppearance = UIKeyboardAppearanceAlert;
            txtPassword.secureTextEntry = YES;
            txtPassword.placeholder = @"Password";
            txtPassword.autocorrectionType = UITextAutocorrectionTypeNo;
            txtPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [cell.textLabel removeFromSuperview];
            [cell.contentView addSubview: txtPassword];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 70.0f;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView* buttonsContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
        
        MOGlassButton *login = [[MOGlassButton alloc] initWithFrame: CGRectMake(10, 10, 300, 50)];
        [login setTitle: @"Login" forState:UIControlStateNormal];
        [login setupAsOrangeButton];
    
        [login addTarget:self action:@selector(loginClicked) forControlEvents: UIControlEventTouchUpInside];
        
        [buttonsContainer addSubview: login] ;
        return buttonsContainer;
    }
    
    return nil;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength > 25) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
