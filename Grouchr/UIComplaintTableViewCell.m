//
//  UIComplaintTableViewCell.m
//  Grouchr
//
//  Created by Joel Drotos on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIComplaintTableViewCell.h"

@implementation UIComplaintTableViewCell

@synthesize venueName;
@synthesize message;
@synthesize userName;
@synthesize shakePoints;
@synthesize childCount;
@synthesize childShakePoints;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
