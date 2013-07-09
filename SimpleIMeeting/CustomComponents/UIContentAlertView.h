//
//  UIContentAlertView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-7-1.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIContentAlertView : UIAlertView <UIAlertViewDelegate> {
    // content alert view title
    NSString *_mTitle;
    
    // present subviews
    // subview content view
    UIView *_mContentView;
}

// init with title, content view cancel and other buttons
- (id)initWithTitle:(NSString *)title contentView:(UIView *)contentView cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
