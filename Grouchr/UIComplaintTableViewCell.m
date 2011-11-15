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
    
    NSLog(@"initWithStyle");
    
    if (self) {
        // Initialization code
//        venueName = [[UILabel alloc] init];
//        message = [[UILabel alloc] init];
//        userName = [[UILabel alloc] init];
//        shakePoints = [[UILabel alloc] init];
//        childCount = [[UILabel alloc] init];
//        childShakePoints = [[UILabel alloc] init];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
