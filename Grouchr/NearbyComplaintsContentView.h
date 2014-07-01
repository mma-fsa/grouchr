//
//  NearbyComplaintsContentView.h
//  Grouchr
//
//  Created by Mike on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewUtility.h"
@interface NearbyComplaintsContentView : UIView <UITextViewDelegate> {

}

@property (strong, readwrite) UILabel* venueLabel;
@property (strong, readwrite) UILabel* submitterLabel;
@property (strong, readwrite) UITextView* complaintTextView;
@property (strong, readwrite) UILabel* pointsLabel;
@property (strong, readwrite) UILabel* repliesLabel;
@property (strong, readwrite) UILabel* picturesLabel;
@property (strong, readwrite) UILabel* noPicturesLabel;

- (void) initLabels;

@end
