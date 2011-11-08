//
//  DataFetcher.m
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataFetcher.h"
#import "ASIHTTPRequest.h"

@implementation DataFetcher
+ (NSString*) postData:(NSString *)url :(NSString *)reqStr{
    NSURL* nsurl = [NSURL URLWithString:url];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:nsurl];
    [request appendPostData:[reqStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
    NSError* error = [request error];
    if(!error){
        NSString* response = [request responseString];
        return response;
    }
    return @"";
    
}
@end
