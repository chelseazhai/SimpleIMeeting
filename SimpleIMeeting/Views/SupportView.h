//
//  SupportView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

@interface SupportView : UIWebView <UIWebViewDelegate> {
    // present subviews
    // subview support page loading indicator view
    UIDataLoadingIndicatorView *_mSupportPageLoadingIndicatorView;
}

// start load support web page
- (void)startLoadSupportWebPage;

// cancel loading support web page
- (void)cancelLoadingSupportWebPage;

@end
