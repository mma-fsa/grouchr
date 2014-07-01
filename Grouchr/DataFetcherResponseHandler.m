//
//  DataFetcherResponseHandler.m
//  Grouchr
//
//  Created by Joel Drotos on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataFetcherResponseHandler.h"
#import "GrouchrViewController.h"

static NSUInteger tagCount = 0;
static NSUInteger invalidThreshold = -1;

@implementation DataFetcherResponseHandler

@synthesize requestType;
@synthesize statusCode;
@synthesize statusMessage;
@synthesize payload;
@synthesize responseString;
@synthesize error;
@synthesize APIJsonRequest;
@synthesize tag = _tag;

+ (NSUInteger) maxTag {
    return tagCount;
}

+ (void) invalidateRequests {
    invalidThreshold = tagCount;
}

- (id) init{
    if(self = [super init]){
        responseString = @"";
        error = [[NSError alloc] init];
        obj = nil;
        self.APIJsonRequest = YES;
        _tag = ++tagCount;
    }
    return self;
}
-(id) initWithDelegate:(NSObject<APIResponseDelegate>*) del{
    
    if (self = [self init]) {
        delegate = del;
        delegateCallbackFunction = nil;
    }
    
    return self;
}

-(id) initWithDelegate:(NSObject<APIResponseDelegate> *)del withSelector:(SEL)callbackFunction {
    if (self = [self initWithDelegate: del]) {
        delegateCallbackFunction = callbackFunction;
    }
    return self;
}

-(id) initWithDelegate:(NSObject<APIResponseDelegate> *)del withSelector:(SEL)callbackFunction withObject:(NSObject *)theObj {
    if (self = [self initWithDelegate:del withSelector:callbackFunction]) {
        obj = theObj;
    }
    return self;
}

- (void) requestFinished:(ASIHTTPRequest *) request{
    
    NSLog(@"requestFinished");
    
    responseString = [request responseString];
    
    if (self.APIJsonRequest == YES) {
        NSDictionary* respDict = [APIResponseParser parseAPIResponse:responseString];
        NSNumber *tNum = [respDict objectForKey:@"STATUS"];
        
        statusCode = [tNum integerValue];
        statusMessage = [respDict objectForKey:@"MESSAGE"];
        payload = [respDict objectForKey:@"PAYLOAD"];
    }
    
    error = nil;
    
    if(delegate != nil && delegateCallbackFunction != nil){
        NSLog(@"Calling delegate");
        if(obj != nil) {
            [delegate performSelector:delegateCallbackFunction withObject:self withObject: obj];
        }
        else {
            [delegate performSelector:delegateCallbackFunction withObject:self];
        }
    } else {
        NSLog(@"No delegate, exiting");
    }
}
- (void) requestFailed:(ASIHTTPRequest *) request{
    
    NSLog(@"requestFailed: %@, %d, %@", self.requestType, self.statusCode, self.statusMessage);
    
    NSDictionary* respDict = [APIResponseParser parseAPIResponse:responseString];
    NSNumber *tNum = [respDict objectForKey:@"STATUS"];
    
    statusCode = [tNum integerValue];
    statusMessage = [respDict objectForKey:@"MESSAGE"];
    payload = [respDict objectForKey:@"PAYLOAD"];
    error = [request error];
    
    if (self.tag > invalidThreshold && [[GrouchrViewController getInstance] canShowNetworkError]) {        
        [[GrouchrViewController getInstance] setCanShowNetworkError: NO];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Network/Protocol Error."
                                                          message:@"An error occurred during a network request, check your network connectivity and firewall settings."
                                                         delegate: self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];

        if ([[GrouchrViewController getInstance] alert] == nil) {
            [[GrouchrViewController getInstance] setAlert: message];
            [message show];            
        }

    }
    else if (delegate != nil && delegateCallbackFunction != nil){
        NSLog(@"Calling delegate");
        if(obj != nil) {
            [delegate performSelector:delegateCallbackFunction withObject:self withObject: obj];
        }
        else {
            [delegate performSelector:delegateCallbackFunction withObject:self];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(delegate != nil && delegateCallbackFunction != nil){
        NSLog(@"Calling delegate");
        if(obj != nil) {
            [delegate performSelector:delegateCallbackFunction withObject:self withObject: obj];
        }
        else {
            [delegate performSelector:delegateCallbackFunction withObject:self];
        }
    } else {
        NSLog(@"No delegate, exiting");
    }
}

@end
