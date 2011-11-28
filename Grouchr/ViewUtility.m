//
//  ViewUtility.m
//  Grouchr
//
//  Created by Mike on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewUtility.h"

static UIImage* smallFistIcon = nil;
static UIImage* smallCameraIcon = nil;
static UIImage* smallPictureIcon = nil;
static UIImage* smallLocationIcon = nil;

@implementation ViewUtility

+ (UIImage*)getResizedImage: (UIImage*) imageToResize withSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [imageToResize drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

+ (UIImage *)getSmallCameraIcon {
    if (smallCameraIcon == nil) {
        smallCameraIcon = [UIImage imageNamed: @"camera.png"];
    }
    return smallCameraIcon;
}
+ (UIImage *)getSmallFistIcon {
    if (smallFistIcon == nil) {
        smallFistIcon = [UIImage imageNamed: @"small_fist_gradient.png"];
    }
    return smallFistIcon;
}
+ (UIImage *)getSmallPictureIcon {
    if (smallPictureIcon == nil) {
        smallPictureIcon = [UIImage imageNamed: @"picture.png"];
    }
    return smallPictureIcon;
}
+ (UIImage *)getSmallLocationIcon {
    if (smallLocationIcon == nil) {
        smallLocationIcon = [UIImage imageNamed: @"location.png"];
    }
    return smallLocationIcon;
}
@end
