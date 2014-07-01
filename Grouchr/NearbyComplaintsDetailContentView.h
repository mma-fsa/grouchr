//
//  NearbyComplaintsDetailContentView.h
//  Grouchr
//
//  Created by Mike on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewUtility.h"

@interface NearbyComplaintsDetailContentView : UIView <UITextViewDelegate>
@property (nonatomic, strong) UILabel* detailTitle;
@property (nonatomic, strong) UILabel* detailSubTitle;
@property (nonatomic, strong) UILabel* pointsLabel;
@property (nonatomic, strong) UIButton* viewPictureButton;
@property (nonatomic, strong) UITextView* complaintText;
@property (nonatomic, strong) UIView* loadingView;

- (void) setupControls;

@end
