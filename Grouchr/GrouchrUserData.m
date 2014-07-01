//
//  GrouchrUserPreferences.m
//  Grouchr
//
//  Created by Mike on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GrouchrUserData.h"

@implementation GrouchrUserData

- (GrouchrUserData*) init {
    if (self = [super init]) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (Credentials*) storedCredentials {
    Credentials* c = [[Credentials alloc] init];
    c.username = [userDefaults valueForKey: @"username"];
    c.token = [userDefaults valueForKey: @"token"];
    
    if (c.token == nil || [@"" isEqualToString: c.token]) {
        return nil;
    }
    else {
        return c;
    }
}

- (void) setStoredCredentials:(Credentials *)credentialsToStore {
    
    NSString* username = nil;
    NSString* token = nil;
    
    if (credentialsToStore != nil) {
        username = credentialsToStore.username;
        token = credentialsToStore.token;
    }
    
    [userDefaults setValue: username forKey: @"username"];
    [userDefaults setValue: token forKey: @"token"];
}

@end
