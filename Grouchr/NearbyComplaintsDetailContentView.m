//
//  NearbyComplaintsDetailContentView.m
//  Grouchr
//
//  Created by Mike on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyComplaintsDetailContentView.h"

@implementation NearbyComplaintsDetailContentView
@synthesize detailTitle;
@synthesize detailSubTitle;
@synthesize pointsLabel;
@synthesize viewPictureButton;
@synthesize complaintText;
@synthesize loadingView;

- (id)init {
    if (self = [super init]) {
        [self setupControls];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (void) setupControls {
    
    self.backgroundColor = [UIColor clearColor];
    
    //detailTitle: o 74 x 23, s 246 x 20
    self.detailTitle = [[UILabel alloc] initWithFrame: CGRectMake(74, 33, 246, 20)];
    self.detailTitle.font = [UIFont boldSystemFontOfSize:18.0f];
    self.detailTitle.backgroundColor = [UIColor clearColor];
    self.detailTitle.textColor = [UIColor blackColor];
    [self addSubview: self.detailTitle];
    
    //detailSubTitle: 74 x 45, 246 x 15
    self.detailSubTitle = [[UILabel alloc] initWithFrame: CGRectMake(74, 55, 246, 15)];
    self.detailSubTitle.font = [UIFont systemFontOfSize: 14.0f];
    self.detailSubTitle.backgroundColor = [UIColor clearColor];
    self.detailSubTitle.textColor = [UIColor darkGrayColor];
    [self addSubview: self.detailSubTitle];
    
    //pointsLabel: 45 x 325, 80 x 20
    self.pointsLabel = [[UILabel alloc] initWithFrame: CGRectMake(45, 326, 100, 20)];
    self.pointsLabel.font = [UIFont systemFontOfSize: 18.0f];
    self.pointsLabel.backgroundColor = [UIColor clearColor];
    self.pointsLabel.textColor = [ViewUtility getOrangeLabelColor];
    [self addSubview: self.pointsLabel];
    
    //view picture button: 165 x 318, 140 x 30
    self.viewPictureButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.viewPictureButton.frame = CGRectMake(150, 322, 140, 30);
    [self.viewPictureButton setTitleEdgeInsets: UIEdgeInsetsMake(0.0, 28.0, 0.0, 0.0)];
    [self.viewPictureButton setTitle: @"View image" forState: UIControlStateNormal];
    [self.viewPictureButton setTitleColor:[ViewUtility getOrangeLabelColor] forState:UIControlStateNormal];
    self.viewPictureButton.backgroundColor = [UIColor clearColor];
    self.viewPictureButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.viewPictureButton.layer.borderWidth = 0.5f;
    self.viewPictureButton.layer.cornerRadius = 10.0f;
    
    self.viewPictureButton.layer.masksToBounds = YES; 
    
    UIImage *grayImage = [UIImage imageNamed:@"grayGradient.png"];
    UIImage *grayButtonImage = [grayImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [self.viewPictureButton setBackgroundImage:grayButtonImage forState:UIControlStateNormal];
    
    UIImage *darkGrayImage = [UIImage imageNamed:@"darkGrayGradient.png"];
    UIImage *darkGrayButtonImage = [darkGrayImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [self.viewPictureButton setBackgroundImage:darkGrayButtonImage forState:UIControlStateHighlighted];
    
    UIImageView* cameraImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"camera.png"]];
    cameraImage.frame = CGRectMake(7.0, 3.0, 25, 25);
    [self.viewPictureButton addSubview: cameraImage];
     
    [self addSubview: self.viewPictureButton];
    
    //complaint text view: 30 x 75, 200 x 220
    self.complaintText = [[UITextView alloc] initWithFrame: CGRectMake(30, 85, 260, 220)];
    self.complaintText.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    self.complaintText.font = [UIFont systemFontOfSize: 16.0f];
    self.complaintText.layer.cornerRadius = 7;
    self.complaintText.layer.borderWidth = 0.5f;
    self.complaintText.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.complaintText.backgroundColor = [UIColor clearColor];
    self.complaintText.delegate = self;
    [self addSubview: self.complaintText];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
