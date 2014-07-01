//
//  TwitterOAuthUtility.h
//  Grouchr
//
//  Created by Mike on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TwitterLoginPopup.h"
#import "OAuthTwitter.h"
#import "OAuthLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"
#import "GrouchrModelController.h"

@class GrouchrViewController;

@interface TwitterOAuthUtility : NSObject <oAuthLoginPopupDelegate, TwitterLoginUiFeedback> {
    UIActivityIndicatorView* activityView;
    GrouchrModelController* model;
    GrouchrViewController* viewController;
}

@property (nonatomic, strong, readonly) OAuthTwitter* oAuthTwitter;
@property (nonatomic, strong, readonly) TwitterLoginPopup* loginPopup;

@end
