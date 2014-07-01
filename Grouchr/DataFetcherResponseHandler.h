//
//  DataFetcherResponseHandler.h
//  Grouchr
//
//  Created by Joel Drotos on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "GrouchrModelDelegate.h"
#import "APIResponseDelegate.h"
#import "APIResponseParser.h"

@interface DataFetcherResponseHandler : NSObject <UIAlertViewDelegate> {
    NSObject<APIResponseDelegate> *delegate;
    SEL delegateCallbackFunction;
    
    NSString* requestType;
    
    NSInteger statusCode;
    NSString* statusMessage;
    NSDictionary* payload;
    
    NSString* responseString;
    NSError* error;
    
    NSObject* obj;
    
    BOOL canShowErrorMsg;
}

@property(readwrite) BOOL APIJsonRequest;
@property(copy,readwrite) NSString* responseString;
@property(copy,readwrite) NSError* error;
@property(copy,readwrite) NSString* requestType;

@property(readwrite) NSInteger statusCode;
@property(copy,readwrite) NSString* statusMessage;
@property(copy,readwrite) NSDictionary* payload;
@property(readonly) NSUInteger tag;

+ (NSUInteger) maxTag;
+ (void) invalidateRequests;

-(id) initWithDelegate:(NSObject<APIResponseDelegate>*) del;
-(id) initWithDelegate:(NSObject<APIResponseDelegate> *)del withSelector: (SEL)callbackFunction;
-(id) initWithDelegate:(NSObject<APIResponseDelegate> *)del withSelector: (SEL)callbackFunction withObject: (NSObject*) theObj;

- (void) requestFinished:(ASIHTTPRequest *) request;
- (void) requestFailed:(ASIHTTPRequest *) request;
@end

