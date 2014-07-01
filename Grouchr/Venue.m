//
//  Venue.m
//  Grouchr
//
//  Created by Joel Drotos on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Venue.h"

@implementation Venue

@synthesize provider;
@synthesize venueid;
@synthesize name;
@synthesize isCustom;

- (id) init {
    if (self = [super init]) {
        self.isCustom = NO;
    }
    return self;
}

@end
