//
//  ViewUtility.h
//  Grouchr
//
//  Created by Mike on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewUtility : NSObject 

+ (NSData*)  encodeImage: (UIImage*) image;

+ (UIColor*) getGrayBackgroundColor;
+ (UIColor*) getOrangeLabelColor;
+ (UIImage*) getResizedImage: (UIImage*) imageToResize withSize: (CGSize) newSize;
+ (UIImage*) getNearbyCellBackground;
+ (UIImage*) getEmptyNearbyCellBackground ;
+ (UIImage*) getSmallFistIcon; 
+ (UIImage*) getSmallCameraIcon;
+ (UIImage*) getSmallPictureIcon;
+ (UIImage*) getSmallLocationIcon;
+ (UIImage*) getEmptyDetailViewBackground;
+ (UIImage*) getDetailViewBackground;
+ (NSArray*) getShakeAnimationImages;

@end
