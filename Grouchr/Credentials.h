//
//  Credentials.h
//  Grouchr
//
//  Created by Joel Drotos on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Credentials : NSObject{
    NSString* username;
    NSString* token;
}

@property(copy,readwrite) NSString* username;
@property(copy,readwrite) NSString* token;

@end
