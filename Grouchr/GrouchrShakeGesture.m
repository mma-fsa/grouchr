//
//  GrouchrShakeGesture.m
//  Grouchr
//
//  Created by Mike on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GrouchrShakeGesture.h"


/******************************************
 
 READ ME

//CALL THIS TO GET THE SINGLETON INSTANCE
//E.G.

GrouchrShakeGesture* shakeGesture = [GrouchrShakeGesture sharedInstance];
 
//HOW TO USE:
 
 <begin your class>
 
 -(void) yourMethod {
    //start shake gesture, set self as callback
    [[GrouchrShakeGesture sharedInstance] shakeGesture: self];
 }
 
 //the callback method in your class for the shakeGesture
 -(void) didShakeGesture {
    //shake gesture done
    float score = [[GrouchrShakeGesture sharedInstance] lastScore];
 }
 <end your class>

*******************************************/


/* Shake gesture configuration parameters */

//low pass filter threshold.
//increasing the FILTERING_FACTOR will make the gesture require
//more vigorous shaking
#define FILTERING_FACTOR 0.20f  

//longest time in seconds the shake gesture
//will sample movements (i.e. the max duration of the gesture)
#define MAX_GESTURE_TIME 10

//define minimum accelleration needed ot signal a change of direction
#define CHANGE_THRESHOLD 0.75f

//length of shake gesture
#define SHAKE_DURATION 3.0f //3 seconds

//where we keep our singleton
static GrouchrShakeGesture* sharedInstance = nil;

@implementation GrouchrShakeGesture

@synthesize lastScore;

+(void)initialize {
    if(sharedInstance == nil) {
        sharedInstance = [[GrouchrShakeGesture alloc] init];
    }
}

+(GrouchrShakeGesture*) sharedInstance {
    return sharedInstance;
}

-(GrouchrShakeGesture*) init {
    
    if (sharedInstance != nil) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"[%@ %@] cannot be called; use +[%@ %@] instead",
                    NSStringFromClass([self class]), NSStringFromSelector(_cmd), 
                    NSStringFromClass([self class]), NSStringFromSelector(@selector(sharedInstance))];
    }
    else if(self = [super init]) {
        self.lastScore = 0.0; 
    }
    
    return self;
}

-(void) shakeGesture:(id)delegate {

    shakesX = 0;
    shakesY = 0;
    shakesZ = 0;
    
    filteredX = 0;
    filteredY = 0;
    filteredZ = 0;
    
    lastXPositive = YES;
    lastYPositive = YES;
    lastZPositive = YES;
    
    callbackDelegate = delegate;
    
    //set the callback for when the shake gesture's duration has elapsed
    //and we are ready to read the score
    [NSTimer scheduledTimerWithTimeInterval: SHAKE_DURATION target:self selector:@selector(didShakeGesture) userInfo:nil repeats:NO];
    
    UIAccelerometer* accell = [UIAccelerometer sharedAccelerometer];
    accell.updateInterval = .10;
    accell.delegate = self;
} 

-(void) didShakeGesture {
    
    UIAccelerometer* accell = [UIAccelerometer sharedAccelerometer];
    accell.delegate = nil;
    
    float scoreX = MAX(1, 2.0 * MAX(filteredX, 1.0) * .75 * shakesX);
    float scoreY = MAX(1, 2.0 * MAX(filteredY, 1.0) * .75 * shakesY);
    float scoreZ = MAX(1, 2.0 * MAX(filteredZ, 1.0) * .75 * shakesZ);
    
    self.lastScore = floorf(MAX(MAX(scoreX, scoreY), MAX(scoreY, scoreZ)));
    
    if(callbackDelegate) {
        [callbackDelegate didShakeGesture];
    }
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    //record number of changes in direction
    if (((lastXPositive && acceleration.x < 0) || 
         (!lastXPositive && acceleration.x > 0)) && fabs(acceleration.x) > CHANGE_THRESHOLD) {
        shakesX += 1; 
        lastXPositive = !lastXPositive;
    }
    
    if (((lastYPositive && acceleration.y < 0) || 
         (!lastYPositive && acceleration.y > 0)) && fabs(acceleration.y) > CHANGE_THRESHOLD) {
        shakesY += 1; 
        lastYPositive = !lastYPositive;
    }
    
    if (((lastZPositive && acceleration.z < 0) || 
         (!lastZPositive && acceleration.z > 0)) && fabs(acceleration.z) > CHANGE_THRESHOLD) {
        shakesZ += 1; 
        lastZPositive = !lastZPositive;
    }
    
    //record average acceleration adjusted for gravity (low-pass filter)
    filteredX = (fabs(acceleration.x) * FILTERING_FACTOR) + (filteredX * (1 - FILTERING_FACTOR));
    filteredY = (fabs(acceleration.y) * FILTERING_FACTOR) + (filteredY * (1 - FILTERING_FACTOR));
    filteredZ = (fabs(acceleration.z) * FILTERING_FACTOR) + (filteredZ * (1 - FILTERING_FACTOR));
}

@end
