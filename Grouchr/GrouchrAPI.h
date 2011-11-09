//
//  GrouchrAPI.h
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrouchrAPI : NSObject

+ (NSString*) jsonize:(NSObject*) obj;

+ (NSObject*) buildJsonRequest:(NSString*) requestType:(NSObject*)jsonString;

+ (NSObject*) buildLoginPayload:(NSString*) username:(NSString*)password;

+ (NSObject*) buildAuthenticatePayload:(NSString*) username:(NSString*)token;

+ (NSObject*) buildNewUserPayload:(NSString*) username:(NSString*)password;

+ (NSObject*) buildNearbyComplaintsPayload:(NSNumber*) lat:(NSNumber*) lon: (NSInteger) page;

+ (NSObject*) buildUserComplaintsPayload:(NSString*) username: (NSInteger) page;

+ (NSObject*) buildSingleComplaintPayload:(NSInteger) submissionid;

+ (NSObject*) buildGetThreadPayload:(NSInteger) submissionid;

+ (NSObject*) buildNearbyVenuesPayload:(NSNumber*) lat:(NSNumber*) lon;

+ (NSObject*) buildUserInfoPayload:(NSString*) username;

@end
