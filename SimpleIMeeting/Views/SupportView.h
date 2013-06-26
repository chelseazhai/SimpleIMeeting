//
//  SupportView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

@interface SupportView : UIView <UIWebViewDelegate> {
    // present subviews
    // subview support page loading indicator view
    UIDataLoadingIndicatorView *_mSupportPageLoadingIndicatorView;
    // subview support page webview
    UIWebView *_mSupportPageWebView;
}

@end
