//
//  ComplaNSInteger*.h
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Complaint : NSObject{
    NSInteger venueid;
    NSInteger userid;
    NSInteger submissionid;
    
    NSString* venuename;
    NSString* username;
    NSString* message;
    
    NSInteger shakepoints;
    NSInteger childshakepoints;
    NSInteger childcount;
    
    NSString* imageurl_small;
    NSString* imageurl_medium;
    NSString* imageurl_large;
    NSString* imageurl_orig;
    
}

@property(readwrite) NSInteger venueid;
@property(readwrite) NSInteger userid;
@property(readwrite) NSInteger submissionid;

@property(copy,readwrite) NSString* venuename;
@property(copy,readwrite) NSString* username;
@property(copy,readwrite) NSString* message;

@property(readwrite) NSInteger shakepoints;
@property(readwrite) NSInteger childshakepoints;
@property(readwrite) NSInteger childcount;

@property(copy,readwrite) NSString* imageurl_small;
@property(copy,readwrite) NSString* imageurl_medium;
@property(copy,readwrite) NSString* imageurl_large;
@property(copy,readwrite) NSString* imageurl_orig;

- (NSString*) toString;

//- (NSInteger*) venueid;
//- (NSInteger*) userid;
//- (NSInteger*) submissionid;
//
//- (NSString*) venuename;
//- (NSString*) username;
//- (NSString*) message;
//
//- (NSInteger*) shakepoints;
//- (NSInteger*) childshakepoints;
//- (NSInteger*) childcount;
//
//- (NSString*) imageurl_small;
//- (NSString*) imageurl_medium;
//- (NSString*) imageurl_large;
//- (NSString*) imageurl_orig;
//    
//
//- (void) setVenueid: (NSInteger*)input;
//- (void) setUserid: (NSInteger*)input;
//- (void) setSubmissionid: (NSInteger*)input;
//
//- (void) setVenuename: (NSString*)input;
//- (void) setUsername: (NSString*)input;
//- (void) setMessage: (NSString*)input;
//
//- (void) setShakepoints: (NSInteger*)input;
//- (void) setChildshakepoints: (NSInteger*)input;
//- (void) setChildcount: (NSInteger*)input;
//
//- (void) setImageurl_small: (NSString*)input;
//- (void) setImageurl_medium: (NSString*)input;
//- (void) setImageurl_large: (NSString*)input;
//- (void) setImageurl_orig: (NSString*)input;

@end
