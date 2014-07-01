//
//  ImageViewerViewController.h
//  Grouchr
//
//  Created by Mike on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewerViewController : UIViewController <UIScrollViewDelegate> {
    UIImage* image ;
    UIImageView* viewer;
    UIScrollView* scroller;
}

@property (nonatomic, strong) NSURL* imageURL;

@end
