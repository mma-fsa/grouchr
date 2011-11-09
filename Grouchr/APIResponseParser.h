//
//  APIResponseParser.h
//  Grouchr
//
//  Created by Joel Drotos on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Credentials.h"
#import "Complaint.h"
#import "UserInfo.h"

@interface APIResponseParser : NSObject
    + (NSDictionary*) parseAPIResponse:(NSString*) respStr;

    + (NSArray*) getComplaintList:(NSDictionary*) payload;

    + (NSArray*) getVenueList:(NSDictionary*) payload;

    + (Credentials*) getCredentials:(NSDictionary*) payload;

    + (NSString*) getFailureCode:(NSDictionary*) payload;

    + (UserInfo*) getUserInfo:(NSDictionary*) payload;
@end
