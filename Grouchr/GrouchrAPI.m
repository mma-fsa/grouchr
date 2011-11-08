//
//  GrouchrAPI.m
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GrouchrAPI.h"

@implementation GrouchrAPI

+ (NSString*) buildJsonRequest:(NSString *)requestType :(NSString *)payloadStr{
    //TODO:This needs to come from someplace (and prob be class vars?)
    NSString* username = @"GrouchrWeb";
    NSString* token = @"256cbecc-300e-486c-985c-3480b5767fe7";
    
    NSString* reqType = [NSString stringWithFormat:@"\"REQUEST_TYPE\":\"%@\"",requestType];
    NSString* userinfo = [NSString stringWithFormat:@"\"USER_INFO\":{\"USERNAME\":\"%@\",\"TOKEN\":\"%@\"}",username,token];
    NSString* payload = [NSString stringWithFormat:@"\"PAYLOAD\":{%@}",payloadStr];
    NSString* retStr = [NSString stringWithFormat:@"{%@,%@,%@}",reqType,userinfo,payload];
    
    return retStr;
}
@end
