//
//  SimpleIMeetingGroupView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleIMeetingGroupView : UIView {
    // present subviews
    // subview group header tip label
    UILabel *_mGroupHeaderTipLabel;
    // subview group content view
    UIView *_mGroupContentView;
}

@property (nonatomic, readonly) UIView *contentView;

// set group header tip label text
- (void)setTipLabelText:(NSString *)tipLabelText;

// set group header tip label text color
- (void)setTipLabelTextColor:(UIColor *)tipLabelTextColor;

// set group header tip label text font, mustn't bold
- (void)setTipLabelTextFont:(UIFont *)tipLabelTextFont;

@end
