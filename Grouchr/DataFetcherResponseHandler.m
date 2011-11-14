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

@synthesize requestType;
@synthesize statusCode;
@synthesize statusMessage;
@synthesize payload;
@synthesize responseString;
@synthesize error;

- (id) init{
    if(self = [super init]){
        responseString = @"";
        error = [[NSError alloc] init];
    }
    return self;
}
-(id) initWithDelegate:(NSObject<APIResponseDelegate>*) del{
    self = [self init];
    delegate = del;
    return self;
}

- (void) requestFinished:(ASIHTTPRequest *) request{
    responseString = [request responseString];
//    NSLog(@"Response got!: %@",responseString);
        NSLog(@"Response got!");
    
    NSDictionary* respDict = [APIResponseParser parseAPIResponse:responseString];
    NSNumber *tNum = [respDict objectForKey:@"STATUS"];
    statusCode = [tNum integerValue];
    statusMessage = [respDict objectForKey:@"MESSAGE"];
    payload = [respDict objectForKey:@"PAYLOAD"];
    NSLog(@"Props set");
    
    if(delegate != nil){
        NSLog(@"Calling delegate");
        
        [delegate didAPIRespond];
    }
}
- (void) requestFailed:(ASIHTTPRequest *) request{
    error = [request error];
    NSLog(@"Error got!");
}
@end
