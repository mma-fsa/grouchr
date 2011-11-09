//
//  UserInfoParser.h
//  Grouchr
//
//  Created by Joel Drotos on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface UserInfoParser : NSObject
+ (UserInfo*) parseUserInfo:(NSDictionary*) json;
@end
