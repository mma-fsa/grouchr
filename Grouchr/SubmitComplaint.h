//
//  SubmitComplaint.h
//  Grouchr
//
//  Created by Mike on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "Venue.h"
#import "ViewUtility.h"

@interface SubmitComplaint : NSObject{
    UIImage* _image;
}

+ (NSString*) getMD5Hash: (NSData*) dataToHash;

- (UIImage*) image;
- (void) setImage: (UIImage*) imageToSet;

@property (strong, readwrite) NSString* submissionId;

@property (strong, readwrite) NSNumber* parentThreadId;
@property (strong, readwrite) Venue* venue;
@property (strong, readwrite) NSString* message;
@property (strong, readwrite) NSNumber* latitude;
@property (strong, readwrite) NSNumber* longitude;

@property(readwrite) NSInteger shakepoints;

@property (readwrite)  BOOL isImageUploaded;
@property (strong, readonly)   NSString* imageHash;
@property (strong, readonly)   NSData* imageData;
@property (strong, readwrite)   NSString* imageHandle;
@property (strong, readwrite)  NSString* imageurl_small;
@property (strong, readwrite)  NSString* imageurl_medium;
@property (strong, readwrite)  NSString* imageurl_large;
@property (strong, readwrite)  NSString* imageurl_orig;

@property (nonatomic) BOOL postToFacebook;
@property (nonatomic) BOOL postToTwitter;

@end
