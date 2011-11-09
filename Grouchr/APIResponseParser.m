//
//  APIResponseParser.m
//  Grouchr
//
//  Created by Joel Drotos on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "APIResponseParser.h"
#import "SBJson.h"
#import "ComplaintParser.h"

@implementation APIResponseParser
+(NSDictionary*) parseAPIResponse:(NSString *)respStr{
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    NSDictionary* resp = [jsonParser objectWithString:respStr];
    return resp;
}
+(NSArray*) parseAPIResponseComplaintList:(NSString*) respStr{
    SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
    NSDictionary* resp = [jsonParser objectWithString:respStr];
    NSDictionary* payload = [resp objectForKey:@"PAYLOAD"];
    NSArray* compList = [payload objectForKey:@"COMPLAINT_LIST"];
    
    ComplaintParser* cp = [[ComplaintParser alloc] init];
    
    for(NSDictionary* comp in compList){
        
        Complaint* c = [cp parseComplaint:comp]; 
        
        NSLog(@"%@", [c toString]);
    }
    
    return compList;
}
@end
