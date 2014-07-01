//
//  GrouchrAPI.m
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GrouchrAPI.h"

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

+ (NSObject*) buildJsonRequest:(NSString *)requestType withPayload:(NSObject *)payloadStr withCredentials: (Credentials*) userCredentials {
    
    NSString* username = userCredentials.username;
    NSString* token = userCredentials.token;
    
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
                             [NSNumber numberWithInteger:submissionid], @"SUBMISSIONID", nil];
    return payload;
}

+ (NSObject*) buildGetThreadPayload:(NSInteger)submissionid{
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInteger:submissionid], @"SUBMISSIONID", nil];
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

+ (NSObject*) buildSubmitComplaintPayload: (SubmitComplaint*) newComplaint {
 
    //todo: bust this out into utility methods
    
    NSDictionary* venue = nil;
    if (newComplaint.venue.isCustom == YES) {
        venue = [NSDictionary dictionaryWithObject:newComplaint.venue.name forKey:@"CUSTOMVENUENAME"];    
    }
    else {
        venue = [NSDictionary dictionaryWithObjectsAndKeys:
                           newComplaint.venue.venueid, @"ID",
                           newComplaint.venue.provider, @"PROVIDER",
                           nil];
    }
    
    NSDictionary* location = [NSDictionary dictionaryWithObjectsAndKeys:
                              newComplaint.latitude.stringValue, @"LAT",
                              newComplaint.longitude.stringValue, @"LON",
                              venue, @"VENUE",
                              nil];
    
    NSMutableDictionary* payLoad = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    newComplaint.message, @"MESSAGE",
                                    [NSString stringWithFormat: @"%d", newComplaint.shakepoints], @"SHAKEPOINTS",
                                    location, @"LOCATION", 
                                    nil];
    
    if (newComplaint.image != nil && newComplaint.isImageUploaded == NO) {
        [payLoad setObject: [NSDictionary dictionaryWithObject: [newComplaint.imageHash lowercaseString] forKey:@"MD5"] forKey: @"IMAGE"];        
    }
    
    if (newComplaint.postToTwitter == YES || newComplaint.postToFacebook == YES) {
        NSMutableArray* socialNetworks = [[NSMutableArray alloc] init];
        if (newComplaint.postToTwitter == YES) {
            [socialNetworks addObject: @"TWITTER"];
        }
        if (newComplaint.postToFacebook == YES) {
            [socialNetworks addObject: @"FACEBOOK"];
        }
        [payLoad setObject:socialNetworks forKey:@"SOCIAL_NETWORKS"];
    }
    
    if (newComplaint.parentThreadId != nil) {
        [payLoad setObject:newComplaint.parentThreadId.stringValue forKey:@"PARENT_SUBMISSIONID"];
    }
    
    return payLoad;
}

+ (NSObject*) buildAuthenticationPayloadForUser:(NSString *)username withToken:(NSString *)token {
    
    NSDictionary* payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             username, @"USERNAME", 
                             token, @"TOKEN", nil];
    
    return payload;    
}

+ (NSObject*) buildNewUserPayloadForUser:(NSString *)username withPassword:(NSString *)password {
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             username, @"USERNAME",
                             password, @"PASSWORD",nil];
    return payload;
}

+ (NSObject*) buildLoginPayloadForUser:(NSString *)username withPassword:(NSString *)password {
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             username, @"USERNAME",
                             password, @"PASSWORD",nil];
    return payload;
}

+ (NSObject*) buildAddSocialNetworkFacebookPayload:(NSString *)token withExpiration:(NSNumber *)expiration {
    NSDictionary* serviceData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 token, @"TOKEN",
                                 [NSNumber numberWithInt:0], @"EXPIRES", nil];
    NSDictionary* payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"FACEBOOK", @"SERVICE",
                             serviceData, @"SERVICE_DATA", nil];
    return payload;
}

+ (NSObject*) buildAddSocialNetworkTwitterPayload:(NSString *)token withSecretToken:(NSString *)secretToken {
    NSDictionary* serviceData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 token, @"TOKEN", 
                                 secretToken, @"TOKEN_SECRET", nil]; 
    NSDictionary* payload = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"TWITTER", @"SERVICE",
                             serviceData, @"SERVICE_DATA", nil];
    return payload;
}

+ (NSObject*) buildRemoveSocialNetworkTwitterPayload {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"TWITTER", @"SERVICE", nil];
}

+ (NSObject*) buildRemoveSocialNetworkFacebookPayload {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"FACEBOOK", @"SERVICE", nil];
}

@end
