//
//  DataFetcherResponseHandler.m
//  Grouchr
//
//  Created by Joel Drotos on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataFetcherResponseHandler.h"
#import "APIResponseParser.h"

@implementation DataFetcherResponseHandler

@synthesize responseString;
@synthesize error;

- (id) init{
    if(self = [super init]){
        responseString = @"";
        error = [[NSError alloc] init];
    }
    return self;
}

- (void) requestFinished:(ASIHTTPRequest *) request{
    responseString = [request responseString];
    NSLog(@"Response got!: %@",responseString);
    
//    NSLog(@"Attempt parse out complist...");
//    [APIResponseParser getComplaintList:[APIResponseParser parseAPIResponse:responseString]];
    
}
- (void) requestFailed:(ASIHTTPRequest *) request{
    error = [request error];
    NSLog(@"Error got!");
}
@end
