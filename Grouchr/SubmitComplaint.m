//
//  SubmitComplaint.m
//  Grouchr
//
//  Created by Mike on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SubmitComplaint.h"

@implementation SubmitComplaint

@synthesize parentThreadId;

@synthesize venue;
@synthesize message;
@synthesize shakepoints;
@synthesize latitude;
@synthesize longitude;

@synthesize isImageUploaded; 
@synthesize imageHandle;
@synthesize imageData = _imageData;
@synthesize imageHash = _imageHash;
@synthesize imageurl_small;
@synthesize imageurl_medium;
@synthesize imageurl_large;
@synthesize imageurl_orig;

@synthesize postToTwitter;
@synthesize postToFacebook;

@synthesize submissionId;

+ (NSString *) getMD5Hash: (NSData*) dataToHash {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(dataToHash.bytes, dataToHash.length, result );
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15] ];
}

- (id)init {
    self = [super init];
    if (self) {
        self.venue = nil;
        self.message = nil;
        [self setImage: nil];
        _imageHash = nil;
        postToFacebook = NO;
        postToTwitter = NO;
        isImageUploaded = NO;
        self.parentThreadId = nil;
    }
    return self;
}

- (UIImage*) image {
    return _image;
}

- (void) setImage: (UIImage*) imageToSet {
    if (imageToSet == nil) {
        _image = nil;
        _imageData = nil;
        _imageHash = nil;
        self.isImageUploaded = NO;
    }
    else if (_image != imageToSet) {
        _image = imageToSet;
        _imageData = [ViewUtility encodeImage: _image];
        _imageHash = [SubmitComplaint getMD5Hash: _imageData];
        self.isImageUploaded = NO;    
    }
    self.imageHandle = nil;
}


@end
