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
static UIImage* nearbyCellBackground = nil;
static UIImage* emptyNearbyCellBackground = nil;
static UIImage* largeBackground = nil;
static UIImage* largeEmptyBackground = nil;
static UIImage* detailBackground = nil;
static UIColor* orangeLabelColor = nil;
static UIColor* grayBackgroundColor = nil;

@implementation ViewUtility

+ (NSData*)encodeImage:(UIImage *)image {
    return UIImageJPEGRepresentation(image, 0.5f);
}

+ (UIColor*)getGrayBackgroundColor {
    if (grayBackgroundColor == nil) {
        grayBackgroundColor = [UIColor colorWithRed:.9058 green:.9058 blue:.9058 alpha:1.0];
    }
    return grayBackgroundColor;
}

+ (UIColor*)getOrangeLabelColor {
    if (orangeLabelColor == nil) {
        orangeLabelColor = [UIColor colorWithRed:1.0 green:.5776 blue:.1549 alpha:1.0];
    }
    return orangeLabelColor;
}

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
+ (UIImage *)getNearbyCellBackground {
    if (nearbyCellBackground == nil) {
        nearbyCellBackground = [UIImage imageNamed:@"table_cell.png"];
    }
    return nearbyCellBackground;
}
+ (UIImage*)getDetailViewBackground {
    if (detailBackground == nil) {
        detailBackground = [UIImage imageNamed:@"large_detail_bg.png"];
    }
    return detailBackground;
}
+ (UIImage *)getEmptyDetailViewBackground {
    if (largeEmptyBackground == nil) {
        largeEmptyBackground = [UIImage imageNamed: @"blank_large_bg.png"];
    }
    return largeEmptyBackground;
}
+ (UIImage *)getEmptyNearbyCellBackground {
    if (emptyNearbyCellBackground == nil) {
        emptyNearbyCellBackground = [UIImage imageNamed:@"table_cell_empty.png"];
    }
    return emptyNearbyCellBackground;
}
+ (NSArray *)getShakeAnimationImages {
    NSArray* imagesArray = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"shake_animation_1.png"],
                            [UIImage imageNamed:@"shake_animation_2.png"],
                            nil];
    return imagesArray;
}

@end
