//
//  VenueParser.m
//  Grouchr
//
//  Created by Joel Drotos on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VenueParser.h"


@implementation VenueParser
+ (Venue*) parseVenue:(NSDictionary *)json{
    Venue *venue = [[Venue alloc] init];
    
    venue.provider = [json objectForKey:@"PROVIDER"];
    venue.venueid = [json objectForKey:@"ID"];
    venue.name = [json objectForKey:@"NAME"];
    
    return venue;
}
@end
