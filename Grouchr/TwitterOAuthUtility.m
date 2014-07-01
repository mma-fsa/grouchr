//
//  TwitterOAuthUtility.m
//  Grouchr
//
//  Created by Mike on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterOAuthUtility.h"
#import "GrouchrViewController.h"

static TwitterOAuthUtility* instance = nil; 

@implementation TwitterOAuthUtility

@synthesize oAuthTwitter = _oAuthTwitter;
@synthesize loginPopup = _loginPopup;

- (id) init {
    if (self = [super init]) {
        
        _oAuthTwitter = [[OAuthTwitter alloc] 
                         initWithConsumerKey: @"0MQqoqc3k7jx5LX8EO8sQ" 
                         andConsumerSecret: @"vDv38wIM6Q5v5wwYtQf4SLpi85MEjcoMpWZQyx9MQ"];
        
        viewController = [GrouchrViewController getInstance];
        model = [GrouchrModelController getInstance];
        
        _loginPopup = [[TwitterLoginPopup alloc] initWithNibName: @"TwitterLoginCallbackFlow" bundle:nil];
        _loginPopup.oAuthCallbackUrl = @"x-oauthflow-grouchr-twitter://done";
        _loginPopup.flowType = TwitterLoginCallbackFlow;
        _loginPopup.oAuth = _oAuthTwitter;
        _loginPopup.delegate = self;
        _loginPopup.uiDelegate = self;
        
        activityView = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(5.0, 20.0, 40.0, 40)];
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_loginPopup.view addSubview: activityView];
    }
    return self;
}


#pragma mark -
#pragma mark oAuthLoginPopupDelegate

- (void)oAuthLoginPopupDidCancel:(UIViewController *)popup {
    NSLog(@"oAuthLoginPopupDidCancel");
    [[GrouchrViewController getInstance] hideTwitterLogin];
}

- (void)oAuthLoginPopupDidAuthorize:(UIViewController *)popup {
    NSLog(@"oAuthLoginPopupDidAuthorize");
}

#pragma mark -
#pragma mark TwitterLoginUiFeedback

- (void) tokenRequestDidStart:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"token request did start");
    [activityView startAnimating];
}

- (void) tokenRequestDidSucceed:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"token request did succeed");   
    [activityView stopAnimating];
}

- (void) tokenRequestDidFail:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"token request did fail");            
    [activityView stopAnimating];
}

- (void) authorizationRequestDidStart:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"authorization request did start");    
    [activityView startAnimating];
}

- (void) authorizationRequestDidSucceed:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"authorization request did succeed");
    [viewController dismissModalViewControllerAnimated: YES];
    [activityView stopAnimating];
    [model setOAuthTwitter: [[self loginPopup] oAuth]];
}

- (void) authorizationRequestDidFail:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"authorization token request did fail");

    [activityView stopAnimating];
    [viewController dismissModalViewControllerAnimated: YES];    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter login failed" message:@"Unable to login to Twitter, check username and password and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
