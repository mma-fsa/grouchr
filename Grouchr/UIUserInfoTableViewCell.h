//
//  UIUserInfoTableViewCell.h
//  Grouchr
//
//  Created by Joel Drotos on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIUserInfoTableViewCell : UITableViewCell{
    __weak IBOutlet UILabel *userName;
    __weak IBOutlet UILabel *joinDate;
    __weak IBOutlet UILabel *totalSubmissions;
    __weak IBOutlet UILabel *totalShakePoints;
    __weak IBOutlet UILabel *shakePointRank;

}

@property(weak) IBOutlet UILabel* userName;
@property(weak) IBOutlet UILabel* joinDate;
@property(weak) IBOutlet UILabel* totalSubmissions;
@property(weak) IBOutlet UILabel* totalShakePoints;
@property(weak) IBOutlet UILabel* shakePointRank;

@end
