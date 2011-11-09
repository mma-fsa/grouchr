//
//  APIResponseParser.m
//  Grouchr
//
//  Created by Joel Drotos on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "APIResponseParser.h"
#import "SBJson.h"
#import "ComplaintParser.h"
#import "VenueParser.h"
#import "UserInfoParser.h"

@implementation APIResponseParser
+(NSDictionary*) parseAPIResponse:(NSString *)respStr{
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    NSDictionary* resp = [jsonParser objectWithString:respStr];
    return resp;
}

+ (NSArray*) getComplaintList:(NSDictionary *)payload{
    NSMutableArray* comps = [[NSMutableArray alloc] init];
    NSArray *jsonComps = [payload objectForKey:@"COMPLAINT_LIST"];
    
    for(NSDictionary* jsonComp in jsonComps){
        [comps addObject:[ComplaintParser parseComplaint:jsonComp]];
    }
    
    return comps;
}

+ (NSArray*) getVenueList:(NSDictionary *)payload{
    NSMutableArray* venues = [[NSMutableArray alloc] init];
    
    NSArray *jsonVenues = [payload objectForKey:@"VENUE_LIST"];
    
    for(NSDictionary* jsonVenue in jsonVenues){
        [venues addObject:[VenueParser parseVenue:jsonVenue]];
    }
    
    return venues;
}

//Get the failure code from a login/auth request
+ (NSString*) getFailureCode:(NSDictionary*) payload{
    return [payload objectForKey:@"FAILURE_CODE"];
}

+ (Credentials*) getCredentials:(NSDictionary*) payload{
    Credentials* creds = [[Credentials alloc] init];
    
    creds.username = [payload objectForKey:@"USERNAME"];
    creds.token = [payload objectForKey:@"TOKEN"];
    
    return creds;
}

+ (UserInfo*) getUserInfo:(NSDictionary *)payload{
    return [UserInfoParser parseUserInfo:payload];
}

@end
