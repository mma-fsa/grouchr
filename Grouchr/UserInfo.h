//
//  UserInfo.h
//  Grouchr
//
//  Created by Joel Drotos on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject{
}

@property(nonatomic) NSInteger totalsubmissions;
@property(nonatomic) NSInteger totalshakepoints;
@property(nonatomic) NSInteger shakepointrank;
@property(nonatomic, strong) NSString* username;
@property(copy) NSString* datejoined;
@end
