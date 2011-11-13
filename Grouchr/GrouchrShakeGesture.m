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

    shakes = 0;
    filteredZ = 0;
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
    
    self.lastScore = MAX(1, 2.0 * MAX(filteredZ, 1.0) * .75 * shakes);
    
    if(callbackDelegate) {
        [callbackDelegate didShakeGesture];
    }
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    //record number of changes in direction
    if (((lastZPositive && acceleration.z < 0) || 
         (!lastZPositive && acceleration.z > 0)) && fabs(acceleration.z) > CHANGE_THRESHOLD) {
        shakes += 1; 
        lastZPositive = !lastZPositive;
    }
    
    //record average acceleration adjusted for gravity (low-pass filter)
    filteredZ = (fabs(acceleration.z) * FILTERING_FACTOR) + (filteredZ * (1 - FILTERING_FACTOR));
}

@end
