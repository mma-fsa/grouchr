//
//  APIResponseParser.h
//  Grouchr
//
//  Created by Joel Drotos on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIResponseParser : NSObject
    + (NSDictionary*) parseAPIResponse:(NSString*) respStr;
@end
