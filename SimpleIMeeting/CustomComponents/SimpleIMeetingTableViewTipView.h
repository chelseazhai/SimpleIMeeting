//
//  SimpleIMeetingTableViewTipView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

// simple imeeting table view tip view mode
typedef NS_ENUM(NSInteger, SIMTableViewTipViewMode){
    LeftAlign_TipView,
    RightAlign_TipView
};




@interface SimpleIMeetingTableViewTipView : UIView {
    // tip view mode
    SIMTableViewTipViewMode _mTipViewType;
    
    // present subviews
    // subview tip label
    UILabel *_mTipLabel;
}

// tip view height
@property (nonatomic, readonly) CGFloat height;

// init with simple imeeting table view tip view mode and parent view
- (id)initWithTipViewMode:(SIMTableViewTipViewMode)tipViewType andParentView:(UIView *)parentView;

// set tip view text
- (void)setTipViewText:(NSString *)tipViewText;

@end
