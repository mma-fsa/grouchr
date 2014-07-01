//
//  NearbyComplaintsContentView.m
//  Grouchr
//
//  Created by Mike on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyComplaintsContentView.h"

@implementation NearbyComplaintsContentView

@synthesize venueLabel;
@synthesize submitterLabel;
@synthesize complaintTextView;
@synthesize pointsLabel;
@synthesize repliesLabel;
@synthesize picturesLabel;
@synthesize noPicturesLabel;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initLabels];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self initLabels];
    }
    
    return self;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

- (void) initLabels {
    self.backgroundColor = [UIColor clearColor];
    
    self.venueLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 10, 185, 20)];
    self.venueLabel.textColor = [UIColor blackColor];
    self.venueLabel.backgroundColor = [UIColor clearColor];
    self.venueLabel.font = [UIFont boldSystemFontOfSize: 16.0f];
    [self addSubview: self.venueLabel];
    
    self.submitterLabel = [[UILabel alloc] initWithFrame: CGRectMake(195, 15, 115, 15)];
    self.submitterLabel.textColor = [UIColor darkGrayColor];
    self.submitterLabel.font = [UIFont systemFontOfSize: 12.0f];
    self.submitterLabel.textAlignment = UITextAlignmentRight;
    self.submitterLabel.backgroundColor = [UIColor clearColor];
    [self addSubview: self.submitterLabel];
    
    UIColor* orangeLabelColor = [ViewUtility getOrangeLabelColor];
    UIFont* commentStatsFont = [UIFont boldSystemFontOfSize: 14.0f];
    
    self.pointsLabel = [[UILabel alloc] initWithFrame: CGRectMake(35.0, 97.0, 75.0, 15.0)];
    self.pointsLabel.textColor = orangeLabelColor;
    self.pointsLabel.backgroundColor = [UIColor clearColor];
    self.pointsLabel.font = commentStatsFont;
    [self addSubview: self.pointsLabel];
    
    self.repliesLabel = [[UILabel alloc] initWithFrame: CGRectMake(135, 97.0, 75.0, 15.0)];
    self.repliesLabel.textColor = orangeLabelColor;
    self.repliesLabel.backgroundColor = [UIColor clearColor];
    self.repliesLabel.font = commentStatsFont;
    [self addSubview: self.repliesLabel];
    
    self.picturesLabel = [[UILabel alloc] initWithFrame: CGRectMake(247, 97.0, 75.0, 15.0)];
    self.picturesLabel.textColor = orangeLabelColor;
    self.picturesLabel.backgroundColor = [UIColor clearColor];
    self.picturesLabel.font = commentStatsFont;
    [self addSubview: self.picturesLabel];
    
    self.noPicturesLabel = [[UILabel alloc] initWithFrame: CGRectMake(247, 97.0, 75.0, 15.0)];
    self.noPicturesLabel.textColor = [UIColor lightGrayColor];
    self.noPicturesLabel.backgroundColor = [UIColor clearColor];
    self.noPicturesLabel.font = commentStatsFont;
    [self addSubview: self.noPicturesLabel];
    
    self.complaintTextView = [[UITextView alloc] initWithFrame: CGRectMake(13, 33, 240, 50)];
    self.complaintTextView.backgroundColor = [UIColor clearColor];
    self.complaintTextView.font = [UIFont systemFontOfSize: 14.0];
    self.complaintTextView.delegate = self;
    [self.complaintTextView setUserInteractionEnabled: NO];
    [self addSubview: self.complaintTextView];    
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
