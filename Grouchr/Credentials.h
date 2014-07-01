//
//  Credentials.h
//  Grouchr
//
//  Created by Joel Drotos on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Credentials : NSObject{}

@property(nonatomic, strong) NSString* username;
@property(nonatomic, strong) NSString* password;
@property(nonatomic, strong) NSString* token;

@end
