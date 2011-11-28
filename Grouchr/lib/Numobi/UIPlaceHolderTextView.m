//
//  UIPlaceHolderTextView.m
//  Grouchr
//
//  Created by Mike on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView

@synthesize placeHolderLabel;
@synthesize placeHolderColor;
@synthesize placeHolder;


- (void) awakeFromNib {
    [super awakeFromNib];
    [self setPlaceHolder: @""];
    [self setPlaceHolderColor: [UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id) initWithFrame: (CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setPlaceHolder: @""];
        [self setPlaceHolderColor: [UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void) textChanged:(NSNotification *)notification {
    if ([[self placeHolder] length] == 0) {
        return;
    }
    
    if ([[self text] length] == 0) {
        [[self viewWithTag:999] setAlpha:1];
    }
    else {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void) setText:(NSString *)text {
    [super setText: text];
    [self textChanged: nil];
}

- (void) drawRect:(CGRect)rect {
    if ([[self placeHolder] length] > 0) {
        if (placeHolderLabel == nil) {
            placeHolderLabel = [[UILabel alloc] initWithFrame: CGRectMake(8, 8, self.bounds.size.width, self.bounds.size.height)];
            placeHolderLabel.lineBreakMode = UILineBreakModeWordWrap;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeHolderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
        
        placeHolderLabel.text = self.placeHolder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if ([[self text] length] == 0 && [[self placeHolder] length] > 0) {
        [[self viewWithTag:999] setAlpha: 1];
    }
    
    [super drawRect:rect];
}

@end
