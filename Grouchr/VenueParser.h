//
//  VenueParser.h
//  Grouchr
//
//  Created by Joel Drotos on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Venue.h"

@interface VenueParser : NSObject
+ (Venue*) parseVenue:(NSDictionary*) json;
@end
