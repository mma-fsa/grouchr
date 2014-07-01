//
//  DataFetcher.m
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataFetcher.h"

@implementation DataFetcher

//fetches changes in apiUrl and pictureUploadUrl
static NSString *systemSettingsURL = @"http://grouchr.com/apienv.php";

//these values may change based on what the systeSettingsURL has
static NSString *apiUrl = @"http://grouchr.elasticbeanstalk.com/API";
static NSString *pictureUploadURL = @"http://grouchr.elasticbeanstalk.com/ImageUpload";

+ (void) setAPIURL:(NSString *)theAPIURL withPictureUploadURL:(NSString *)thePictureUploadURL {
    if (theAPIURL != nil) {
        apiUrl = theAPIURL;
    }
    if (thePictureUploadURL != nil) {
        pictureUploadURL = thePictureUploadURL;
    }
}


- (void) getSystemSettings:(NSObject *)respHandler {
    NSURL* nsurl = [NSURL URLWithString: systemSettingsURL];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL: nsurl];
    [request setDelegate: respHandler];
    [request startAsynchronous];
}

- (void) postData:(NSString *)url :(NSString *)reqStr: (NSObject*) respHandler{
    NSURL* nsurl = [NSURL URLWithString:url];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:nsurl];
    [request appendPostData:[reqStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDelegate:respHandler];
    [request startAsynchronous];
}

- (void) postDataToAPI:(NSString *)reqStr :(NSObject *)respHandler{
    [self postData:apiUrl: reqStr :respHandler];
}

- (void) postPictureToAPI: (NSData*) imageData withHandle: (NSString*) imageHandle withResponseHandler: (NSObject*) responseHandler {
    
    NSURL* pictureURL = [NSURL URLWithString: pictureUploadURL];
    
    ASIFormDataRequest* req = [ASIFormDataRequest requestWithURL: pictureURL];
    
    [req addRequestHeader:@"Content-type" value:@"multipart/mixed"]; 
    [req addData:imageData forKey:@"IMAGEFILE"];
    [req addPostValue: imageHandle forKey: @"IMAGEHANDLE"];
    
    [req setDelegate: responseHandler];
    [req startAsynchronous];
}

@end
