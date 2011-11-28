//
//  UIPlaceHolderTextView.h
//  Grouchr
//
//  Created by Mike on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView  {

}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeHolder;
@property (nonatomic, retain) UIColor *placeHolderColor; 

- (void) textChanged: (NSNotification*) notification;

@end
