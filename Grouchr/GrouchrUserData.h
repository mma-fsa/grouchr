//
//  GrouchrUserPreferences.h
//  Grouchr
//
//  Created by Mike on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Credentials.h"

@interface GrouchrUserData : NSObject {
    NSUserDefaults* userDefaults;
}
    
- (Credentials*) storedCredentials; 
- (void) setStoredCredentials: (Credentials*) credentialsToStore; 

@end
