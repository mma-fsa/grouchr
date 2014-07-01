//
//  ShakeViewController.h
//  Grouchr
//
//  Created by Mike on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouchrModelController.h"
#import "ViewUtility.h"
@interface ShakeViewController : UIViewController {
    BOOL didCancelShake;
}
@property (readwrite) BOOL isReply;
- (void) shakeGestureDone;
@end
