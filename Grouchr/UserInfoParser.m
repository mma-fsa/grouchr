//
//  UserInfoParser.m
//  Grouchr
//
//  Created by Joel Drotos on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UserInfoParser.h"

@implementation UserInfoParser
+ (UserInfo*) parseUserInfo:(NSDictionary *)json{
    UserInfo* userinfo = [[UserInfo alloc] init];
    
    userinfo.username = [json objectForKey:@"USERNAME"];
    userinfo.datejoined = [json objectForKey:@"DATE_JOINED"];
    
    NSNumber* tNum = [json objectForKey:@"TOTAL_SHAKEPOINTS"];
    userinfo.totalshakepoints = [tNum integerValue];
    
    tNum = [json objectForKey:@"TOTAL_SUBMISSIONS"];
    userinfo.totalsubmissions = [tNum integerValue];
    
    tNum = [json objectForKey:@"SHAKE_POINT_RANK"];
    userinfo.shakepointrank = [tNum integerValue];
    
    return userinfo;
}
@end
