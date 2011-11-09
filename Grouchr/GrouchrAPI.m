//
//  GrouchrAPI.m
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GrouchrAPI.h"
#import "SBJsonWriter.h"

@implementation GrouchrAPI

//+ (NSObject*) buildJsonRequest:(NSString *)requestType :(NSString *)payloadStr{
//    //TODO:This needs to come from someplace (and prob be class vars?)
//    static NSString* username = @"GrouchrWeb";
//    static NSString* token = @"256cbecc-300e-486c-985c-3480b5767fe7";
//    
//    NSString* reqType = [NSString stringWithFormat:@"\"REQUEST_TYPE\":\"%@\"",requestType];
//    NSString* userinfo = [NSString stringWithFormat:@"\"USER_INFO\":{\"USERNAME\":\"%@\",\"TOKEN\":\"%@\"}",username,token];
//    NSString* payload = [NSString stringWithFormat:@"\"PAYLOAD\":{%@}",payloadStr];
//    NSString* retStr = [NSString stringWithFormat:@"{%@,%@,%@}",reqType,userinfo,payload];
//    
//    return retStr;
//}

+ (NSObject*) buildJsonRequest:(NSString *)requestType :(NSObject *)payloadStr{
    //TODO:This needs to come from someplace (and prob be class vars?)
    static NSString* username = @"GrouchrWeb";
    static NSString* token = @"256cbecc-300e-486c-985c-3480b5767fe7";
    
    NSDictionary *user = [NSDictionary dictionaryWithObjectsAndKeys:
                             username, @"USERNAME",
                             token, @"TOKEN",nil];
    
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             requestType, @"REQUEST_TYPE",
                             user, @"USER_INFO",
                             payloadStr, @"PAYLOAD",nil];
    
    return payload;
}


+ (NSString*) jsonize:(NSObject *)obj{
    SBJsonWriter* writer = [SBJsonWriter new];
    return [writer stringWithObject:obj];
}

+ (NSObject*) buildLoginPayload:(NSString *)username :(NSString *)password{
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             username, @"USERNAME",
                             password, @"PASSWORD",nil];
    return payload;
}

+ (NSObject*) buildAuthenticatePayload:(NSString *)username :(NSString *)token{
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             username, @"USERNAME",
                             token, @"TOKEN",nil];
    return payload;
}
        
+ (NSObject*) buildNewUserPayload:(NSString *)username :(NSString *)password{
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             username, @"USERNAME",
                             password, @"PASSWORD",nil];
    return payload;
}

+ (NSObject*) buildNearbyComplaintsPayload:(NSNumber *)lat :(NSNumber *)lon :(NSInteger)page{
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             lat, @"LATITUDE",
                             lon, @"LONGITUDE",
                             [NSNumber numberWithInteger:page] , @"PAGE", nil];
    return payload;
}

+ (NSObject*) buildUserComplaintsPayload:(NSString *)username :(NSInteger)page{
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             username, @"USERNAME",
                             [NSNumber numberWithInteger:page], @"PAGE", nil];
    return payload;
}

+ (NSObject*) buildSingleComplaintPayload:(NSInteger)submissionid{
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:submissionid], @"SUBMISSIONID", nil];
    return payload;
}

+ (NSObject*) buildGetThreadPayload:(NSInteger)submissionid{
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:submissionid], @"SUBMISSIONID", nil];
    return payload;
}

+ (NSObject*) buildNearbyVenuesPayload:(NSNumber *)lat :(NSNumber *)lon{
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             lat, @"LATITUDE",
                             lon, @"LONGITUDE", nil];
    return payload;
}

+ (NSObject*) buildUserInfoPayload:(NSString *)username{
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             username, @"USERNAME", nil];
    return payload;
}

@end
