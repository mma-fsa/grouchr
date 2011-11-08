//
//  Complaint.m
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Complaint.h"

@implementation Complaint

//ints
@synthesize venueid;
@synthesize userid;
@synthesize submissionid;
@synthesize shakepoints;
@synthesize childshakepoints;
@synthesize childcount;

//strings
@synthesize venuename;
@synthesize username;
@synthesize message;
@synthesize imageurl_small;
@synthesize imageurl_medium;
@synthesize imageurl_large;
@synthesize imageurl_orig;

- (NSString*) toString
{
    NSString* retStr = [NSString stringWithFormat:@"ID:%i, ChildCount:%i, Venue:%@, User:%@, Message:%@, ShakePoints:%i", submissionid, childcount,venuename, username, message,shakepoints];
    
    return retStr;
}
@end
