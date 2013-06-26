//
//  SupportView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SupportView.h"

@implementation SupportView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set title
        self.title = NSLocalizedString(@"support view title", nil);
        
        // create and init subviews
        // init support page loading indicator view
        _mSupportPageLoadingIndicatorView = [[UIDataLoadingIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge tip:NSLocalizedString(@"support page loading tip", nil)];
        
        // set its frame
        [_mSupportPageLoadingIndicatorView setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT)];
        
        // init support page webview
        _mSupportPageWebView = [[UIWebView alloc] initWithFrame:_mSupportPageLoadingIndicatorView.frame];
        
        // set its web view delegate
        _mSupportPageWebView.delegate = self;
        
        // load support page
        [_mSupportPageWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:NSUrlsString(@"support url format string", nil), NSUrlsString(@"remote background server root url string", nil)]]]];
        
        // hidden first
        _mSupportPageWebView.hidden = YES;
        
        // set support page webview background color as support view background color
        self.backgroundColor = _mSupportPageWebView.backgroundColor;
        
        // add support page loading indicator view and support page webview as subviews of support view
        [self addSubview:_mSupportPageLoadingIndicatorView];
        [self addSubview:_mSupportPageWebView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews{
    // resize all subviews
    [self resizesSubviews];
}

// UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // stop support page loading indicator view animating
    [_mSupportPageLoadingIndicatorView stopAnimating];
    
    // show support page webview if needed
    if ([_mSupportPageWebView isHidden]) {
        _mSupportPageWebView.hidden = NO;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    BOOL _ret = YES;
    
    // get the request url string
    NSString *_requestUrlString = request.URL.absoluteString;
    
    // check the request url string: new http request, mail and telephone using UIApplication to process
    if (([_requestUrlString hasPrefix:@"http://"] || [_requestUrlString hasPrefix:@"https://"] || [_requestUrlString hasPrefix:@"mailto://"] || [_requestUrlString hasPrefix:@"telprompt://"]) && UIWebViewNavigationTypeLinkClicked == navigationType) {
        _ret = ![[UIApplication sharedApplication] openURL:request.URL];
    }
    
    return _ret;
}

@end
