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
    
    float filteredX;
    float filteredY;
    float filteredZ;
    
    int shakesX;
    int shakesY;
    int shakesZ;
    
    BOOL lastXPositive;
    BOOL lastYPositive;
    BOOL lastZPositive;
    
    NSTimer* activeTimer;
}

+(GrouchrShakeGesture*) sharedInstance;

-(void) shakeGesture: (id) delegate; 
-(void) didShakeGesture;

@property (nonatomic) float lastScore; 

@end
