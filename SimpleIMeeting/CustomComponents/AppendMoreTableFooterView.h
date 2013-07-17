//
//  AppendMoreTableFooterView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-7-17.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppendMoreTableFooterView;

@protocol AppendMoreTableFooterDelegate

// appene more table footer view did scroll append
- (void)appendMoreTableFooterDidScrollAppend:(AppendMoreTableFooterView *)view;

// append more table view data source is appending
- (BOOL)appendMoreTableFooterDataSourceIsAppending:(AppendMoreTableFooterView *)view;

@end


@interface AppendMoreTableFooterView : UIView {
    // there is more data flag
    BOOL _mHasMoreData;
    
    // append more table footer view visibility
    BOOL _mIsAppendMoreTableFooterViewVisiable;
    
    // append more table footer delegate
    id<AppendMoreTableFooterDelegate> _mAppendMoreTableFooterDelegate;
    
    // present subviews
    // subview appending more data indicator view
    UIActivityIndicatorView *_mAppendingMoreDataIndicatorView;
    // subview appending more data tip label
    UILabel *_mAppendingMoreDataTipLabel;
    
    // subview no more data tip label
    UILabel *_mNoMoreDataTipLabel;
}

@property (nonatomic, readwrite) BOOL hasMoreData;

@property (nonatomic, retain) id<AppendMoreTableFooterDelegate> delegate;

// append more scroll view did scroll
- (void)appendMoreScrollViewDidScroll:(UIScrollView *)scrollView;

// append more scroll view did end decelerating
- (void)appendMoreScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

// append more scroll view data source did finished appending
- (void)appendMoreScrollViewDataSourceDidFinishedAppending:(UIScrollView *)scrollView;

@end
