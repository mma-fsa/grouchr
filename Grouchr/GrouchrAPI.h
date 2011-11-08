//
//  GrouchrAPI.h
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrouchrAPI : NSObject

+ (NSString*) buildJsonRequest:(NSString*) requestType:(NSString*)jsonString;

@end
