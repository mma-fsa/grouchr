//
//  Venue.h
//  Grouchr
//
//  Created by Joel Drotos on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject{
}

@property(copy,readwrite) NSString* provider;
@property(copy,readwrite) NSString* venueid;
@property(copy,readwrite) NSString* name;
@property(nonatomic) BOOL isCustom;
@end
