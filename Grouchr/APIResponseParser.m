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

+ (NSMutableArray*) getComplaintList:(NSDictionary *)payload{
    NSMutableArray* comps = [[NSMutableArray alloc] init];
    NSArray *jsonComps = [payload objectForKey:@"COMPLAINT_LIST"];
    
    for(NSDictionary* jsonComp in jsonComps){
        [comps addObject:[ComplaintParser parseComplaint:jsonComp]];
    }
    
    return comps;
}

+ (NSArray*) getThreadList:(NSDictionary *)payload {
    NSMutableArray* threads = [[NSMutableArray alloc] init];
    NSArray* jsonThread = [payload objectForKey: @"COMPLAINT_LIST"];
    
    for(NSDictionary* jsonComp in jsonThread) {
        [threads addObject: [ComplaintParser parseComplaint:jsonComp]];
    }
    
    return threads;
}

+ (NSMutableArray*) getVenueList:(NSDictionary *)payload{
    NSMutableArray* venues = [[NSMutableArray alloc] init];
    
    NSArray *jsonVenues = [payload objectForKey:@"VENUE_LIST"];
    
    for(NSDictionary* jsonVenue in jsonVenues){
        [venues addObject:[VenueParser parseVenue:jsonVenue]];
    }
    
    return venues;
}

+ (NSDictionary*) getSocialNetworkList:(NSDictionary *)payload {
    NSMutableDictionary* socialNetworkInfo = [[NSMutableDictionary alloc] init];
    NSArray* networkData = [payload objectForKey: @"SOCIAL_NETWORKS"];
    
    //convert list to dictionary
    for(NSDictionary* networkInfo in networkData) {
        NSString* service_name = [networkInfo objectForKey: @"SERVICE"];
        NSString* err_msg = [networkInfo objectForKey: @"ERROR_MESSAGE"];
        [socialNetworkInfo setObject:err_msg forKey:service_name];
    }
    return socialNetworkInfo;
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
