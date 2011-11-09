//
//  GrouchrModelController.h
//  Grouchr
//
//  Created by Mike on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GrouchrModelDelegate.h"

@interface GrouchrModelController : NSObject<CLLocationManagerDelegate> {
    CLLocationManager* locationManager;
    id<GrouchrModelDelegate> delegate;
}

@property (nonatomic, retain) CLLocation* lastLocation;

@end
