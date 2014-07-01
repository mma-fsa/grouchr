//
//  DataFetcher.h
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ViewUtility.h"
#import "NSData+Base64.h"
#import "DataFetcherResponseHandler.h"

@interface DataFetcher : NSObject

+ (void) setAPIURL: (NSString*) theAPIURL withPictureUploadURL: (NSString*) thePictureUploadURL;

- (void) getSystemSettings: (NSObject*) respHandler;
- (void) postData:(NSString*) url: (NSString*)reqStr :(NSObject*)respHandler;
- (void) postDataToAPI:(NSString*) reqStr :(NSObject*)respHandler;
- (void) postPictureToAPI: (NSData*) imageData withHandle: (NSString*) imageHandle withResponseHandler: (NSObject*) responseHandler;
@end
