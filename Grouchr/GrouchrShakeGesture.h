//
//  GrouchrShakeGesture.h
//  Grouchr
//
//  Created by Mike on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrouchrShakeGesture : NSObject<UIAccelerometerDelegate> {
    id callbackDelegate;
    
    float filteredZ;
    int shakes;
    BOOL lastZPositive;
}

+(GrouchrShakeGesture*) sharedInstance;

-(void) shakeGesture: (id) delegate; 
-(void) didShakeGesture;

@property (nonatomic, retain) float lastScore; 

@end
