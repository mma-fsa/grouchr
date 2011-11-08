//
//  APIResponseParser.m
//  Grouchr
//
//  Created by Joel Drotos on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "APIResponseParser.h"
#import "SBJsonParser.h"


@implementation APIResponseParser
+(NSDictionary*) parseAPIResponse:(NSString *)respStr{
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    NSDictionary* resp = [jsonParser objectWithString:respStr];
    return resp;
}
@end
