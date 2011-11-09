//
//  FirstViewController.m
//  Grouchr
//
//  Created by Joel Drotos on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

#import "GrouchrAPI.h"
#import "DataFetcher.h"
#import "DataFetcherResponseHandler.h"

@implementation FirstViewController

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
    
    NSLog(@"applicationDidBecomeActive");
    
    NSString* urlStr = @"http://tomcat.jdrotos.dyndns.org:8080/GrouchrServer/API";
    NSString* payloadStr = @"";
    NSString* reqType = @"NEWCOMPLAINTS";
    NSString* reqStr = [GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:reqType : payloadStr]];
    
    NSLog(@"Basic request:%@",reqStr);
    
    
    NSLog(@"Login Payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"LOGIN" :[GrouchrAPI buildLoginPayload:@"User" :@"<password>"]]]);
    NSLog(@"Authenticate Payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"AUTHENTICATE" :[GrouchrAPI buildAuthenticatePayload:@"User" :@"tok123"]]]);
    NSLog(@"New user payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"NEWUSER" :[GrouchrAPI buildNewUserPayload:@"User" :@"Pass"]]]);
    NSLog(@"Nearby payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"COMPLAINTS" :[GrouchrAPI buildNearbyComplaintsPayload:[NSNumber numberWithDouble:44.12345] : [NSNumber numberWithDouble:99.12345] :0]]]);
    NSLog(@"UserComps payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"USERCOMPLAINTS" :[GrouchrAPI buildUserComplaintsPayload:@"whiskeyjoe" :0]]]);
    NSLog(@"SingleComp payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"SINGLECOMPLAINT" :[GrouchrAPI buildSingleComplaintPayload:1]]]);
    NSLog(@"GetThread payload:%@",[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"GETTHREAD" :[GrouchrAPI buildGetThreadPayload:1]]]);
                               
    
    NSLog(@"Manual allocs..");
    handler = [[DataFetcherResponseHandler alloc] init];
    fetcher = [[DataFetcher alloc] init];
    
    NSLog(@"Make call");
    [fetcher postData:urlStr :[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"COMPLAINTS" :[GrouchrAPI buildNearbyComplaintsPayload:[NSNumber numberWithDouble:44.12345] : [NSNumber numberWithDouble:99.12345] :0]]] :handler];
    
    [fetcher postData:urlStr :[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"USERCOMPLAINTS" :[GrouchrAPI buildUserComplaintsPayload:@"whiskeyjoe" :0]]] :handler];
    
    [fetcher postData:urlStr :[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"SINGLECOMPLAINT" :[GrouchrAPI buildSingleComplaintPayload:1]]] :handler];
    
    [fetcher postData:urlStr :[GrouchrAPI jsonize:[GrouchrAPI buildJsonRequest:@"GETTHREAD" :[GrouchrAPI buildGetThreadPayload:1]]] :handler];
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
