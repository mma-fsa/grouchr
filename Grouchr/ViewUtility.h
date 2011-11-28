//
//  ViewUtility.h
//  Grouchr
//
//  Created by Mike on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewUtility : NSObject 
+ (UIImage*) getResizedImage: (UIImage*) imageToResize withSize: (CGSize) newSize;
+ (UIImage*) getSmallFistIcon; 
+ (UIImage*) getSmallCameraIcon;
+ (UIImage*) getSmallPictureIcon;
+ (UIImage*) getSmallLocationIcon;
@end
