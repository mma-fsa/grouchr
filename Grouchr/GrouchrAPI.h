//
//  GrouchrAPI.h
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubmitComplaint.h"
#import "Credentials.h"
#import "SBJsonWriter.h"

@interface GrouchrAPI : NSObject

+ (NSString*) jsonize:(NSObject*) obj;

+ (NSObject*) buildJsonRequest:(NSString *)requestType withPayload:(NSObject *)payloadStr withCredentials: (Credentials*) userCredentials;

+ (NSObject*) buildNearbyComplaintsPayload:(NSNumber*) lat:(NSNumber*) lon: (NSInteger) page;

+ (NSObject*) buildUserComplaintsPayload:(NSString*) username: (NSInteger) page;

+ (NSObject*) buildSingleComplaintPayload:(NSInteger) submissionid;

+ (NSObject*) buildGetThreadPayload:(NSInteger) submissionid;

+ (NSObject*) buildNearbyVenuesPayload:(NSNumber*) lat:(NSNumber*) lon;

+ (NSObject*) buildUserInfoPayload:(NSString*) username;

+ (NSObject*) buildSubmitComplaintPayload: (SubmitComplaint*) newComplaint;

+ (NSObject*) buildAuthenticationPayloadForUser: (NSString*) username withToken: (NSString*) token;

+ (NSObject*) buildLoginPayloadForUser: (NSString*) username withPassword: (NSString*) password;

+ (NSObject*) buildNewUserPayloadForUser: (NSString*) username withPassword: (NSString*) password;

+ (NSObject*) buildAddSocialNetworkFacebookPayload: (NSString*)token withExpiration: (NSNumber*) expiration;

+ (NSObject*) buildAddSocialNetworkTwitterPayload: (NSString*)token withSecretToken: (NSString*) secretToken;

+ (NSObject*) buildRemoveSocialNetworkFacebookPayload;

+ (NSObject*) buildRemoveSocialNetworkTwitterPayload;

@end
