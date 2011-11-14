//
//  DataFetcher.h
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface DataFetcher : NSObject
- (void) postData:(NSString*) url: (NSString*)reqStr :(NSObject*)respHandler;
- (void) postDataToAPI:(NSString*) reqStr :(NSObject*)respHandler;
@end
