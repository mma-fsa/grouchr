//
//  UserInfo.h
//  Grouchr
//
//  Created by Joel Drotos on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject{
    
    NSString* username;
    NSInteger totalsubmissions;
    NSInteger totalshakepoints;
    NSString* datejoined;
    NSInteger shakepointrank;
    
}

@property(readwrite) NSInteger totalsubmissions;
@property(readwrite) NSInteger totalshakepoints;
@property(readwrite) NSInteger shakepointrank;
@property(copy,readwrite) NSString* username;
@property(copy,readwrite) NSString* datejoined;

@end
