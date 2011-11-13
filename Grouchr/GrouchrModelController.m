//
//  GrouchrModelController.m
//  Grouchr
//
//  Created by Mike on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GrouchrModelController.h"


@implementation GrouchrModelController

@synthesize lastLocation;

- (GrouchrModelController*) init {
    
    if (self = [super init]) {
        
        //configuration for GPS
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.distanceFilter = 100;
        
        self.lastLocation = nil;
        
        //begin monitoring GPS changes
        [locationManager startUpdatingLocation];
    }
    
    return self;    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    self.lastLocation = newLocation;
 
    //send message to delegate that our location has changes
    [delegate didLocationChange];
}

- (void) startShakeGesture: (NSNumber*) durationInSeconds autoStop: (BOOL) shouldAutoStop {
    UIAccelerometer *myAccel = [UIAccelerometer sharedAccelerometer];
    myAccel.updateInterval = .2; //5 updates per second
    myAccel.delegate = self;
}

@end
