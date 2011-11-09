//
//  DataFetcherResponseHandler.h
//  Grouchr
//
//  Created by Joel Drotos on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface DataFetcherResponseHandler : NSObject{
    NSString* responseString;
    NSError* error;
}

@property(copy,readwrite) NSString* responseString;
@property(copy,readwrite) NSError* error;

- (void) requestFinished:(ASIHTTPRequest *) request;
- (void) requestFailed:(ASIHTTPRequest *) request;
@end

