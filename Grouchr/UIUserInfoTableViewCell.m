//
//  UIUserInfoTableViewCell.m
//  Grouchr
//
//  Created by Joel Drotos on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIUserInfoTableViewCell.h"

@implementation UIUserInfoTableViewCell

@synthesize userName;
@synthesize joinDate;
@synthesize totalSubmissions;
@synthesize totalShakePoints;
@synthesize shakePointRank;

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
