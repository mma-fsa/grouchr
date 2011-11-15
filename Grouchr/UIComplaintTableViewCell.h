//
//  UIComplaintTableViewCell.h
//  Grouchr
//
//  Created by Joel Drotos on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIComplaintTableViewCell : UITableViewCell{
    __weak IBOutlet UILabel *venueName;
    __weak IBOutlet UILabel *message;
    __weak IBOutlet UILabel *userName;
    __weak IBOutlet UILabel *shakePoints;
    __weak IBOutlet UILabel *childCount;
    __weak IBOutlet UILabel *childShakePoints;

}

@property(weak) IBOutlet UILabel* venueName;
@property(weak) IBOutlet UILabel* message;
@property(weak) IBOutlet UILabel* userName;
@property(weak) IBOutlet UILabel* shakePoints;
@property(weak) IBOutlet UILabel* childCount;
@property(weak) IBOutlet UILabel* childShakePoints;


@end
