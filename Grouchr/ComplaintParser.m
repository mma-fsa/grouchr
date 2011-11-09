//
//  ComplaintParser.m
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ComplaintParser.h"
#import "SBJson.h"

@implementation ComplaintParser
+ (Complaint*) parseComplaint:(NSDictionary *)json
{
    Complaint* retComp = [[Complaint alloc] init];
    
    
    NSNumber* tNum = [json objectForKey:@"SUBMISSIONID"];
    retComp.submissionid = [tNum integerValue];
    
    tNum = [json objectForKey:@"CHILDCOUNT"];
    retComp.childcount = [tNum integerValue];
    
    tNum = [json objectForKey:@"CHILDSHAKEPOINTS"];
    retComp.childshakepoints = [tNum integerValue];
    
    NSDictionary* locDict = [json objectForKey:@"LOCATION"];
    NSDictionary* usrDict = [json objectForKey:@"USER"];
    NSDictionary* msgDict = [json objectForKey:@"COMPLAINT"];
    
    tNum = [locDict objectForKey:@"VENUEID"];
    retComp.venueid = [tNum integerValue];
    
    retComp.venuename = [locDict objectForKey:@"LOCATION_NAME"];
    
    tNum = [usrDict objectForKey:@"USERID"];
    retComp.userid = [tNum integerValue];
    
    retComp.username = [usrDict objectForKey:@"USERNAME"];
    
    tNum = [msgDict objectForKey:@"SHAKEPOINTS"];
    retComp.shakepoints = [tNum integerValue];
    
    retComp.message = [msgDict objectForKey:@"MESSAGE"];
    
    if([msgDict objectForKey:@"IMAGE"] != nil){
        NSDictionary* imgDict = [msgDict objectForKey:@"IMAGE"];
        retComp.imageurl_small = [[imgDict objectForKey:@"SMALL"] objectForKey:@"URL"];
        retComp.imageurl_medium = [[imgDict objectForKey:@"MEDIUM"] objectForKey:@"URL"];
        retComp.imageurl_large = [[imgDict objectForKey:@"LARGE"] objectForKey:@"URL"];
        retComp.imageurl_orig = [[imgDict objectForKey:@"ORIGINAL"] objectForKey:@"URL"];
    }
    
    return retComp;
}
@end
