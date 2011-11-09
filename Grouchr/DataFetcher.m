//
//  DataFetcher.m
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataFetcher.h"

@implementation DataFetcher
- (IBAction) postData:(NSString *)url :(NSString *)reqStr: (NSObject*) respHandler{
    NSURL* nsurl = [NSURL URLWithString:url];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:nsurl];
    [request appendPostData:[reqStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDelegate:respHandler];
    [request startAsynchronous];
}
@end
