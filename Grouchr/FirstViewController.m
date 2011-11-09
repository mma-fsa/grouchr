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
    NSString* reqStr = [GrouchrAPI buildJsonRequest:reqType : payloadStr];
    
    NSLog(@"Manual allocs..");
    handler = [[DataFetcherResponseHandler alloc] init];
    fetcher = [[DataFetcher alloc] init];
    
    NSLog(@"Make call");
    [fetcher postData:urlStr :reqStr :handler];
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
