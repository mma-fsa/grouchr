//
//  UIComplaintTableViewCell.h
//  Grouchr
//
//  Created by Joel Drotos on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIComplaintTableViewCell : UITableViewCell{
    IBOutlet UILabel *venueName;
    IBOutlet UILabel *message;
    IBOutlet UILabel *userName;
    IBOutlet UILabel *shakePoints;
    IBOutlet UILabel *childCount;
    IBOutlet UILabel *childShakePoints;

}

@property(copy,readwrite) UILabel* venueName;
@property(copy,readwrite) UILabel* message;
@property(copy,readwrite) UILabel* userName;
@property(copy,readwrite) UILabel* shakePoints;
@property(copy,readwrite) UILabel* childCount;
@property(copy,readwrite) UILabel* childShakePoints;


@end
