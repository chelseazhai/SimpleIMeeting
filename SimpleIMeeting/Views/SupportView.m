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
        
        // set webview delegate
        self.delegate = self;
        
        // hidden scroll view first
        if ([self respondsToSelector:@selector(scrollView)]) {
            self.scrollView.hidden = YES;
        }
        
        // add support page loading indicator view as subview of support view
        [self addSubview:_mSupportPageLoadingIndicatorView];
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

- (void)startLoadSupportWebPage{
    // load support web page
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:/*[NSString stringWithFormat:NSUrlString(@"support url format string", nil), NSUrlString(@"remote background server root url string", nil)]*/NSUrlString(@"remote background server root url string", nil)]]];
}

- (void)cancelLoadingSupportWebPage{
    // hide network activity indicator if needed
    if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    // check support page webview is loading or not
    if (self.isLoading) {
        // stop loading support web page
        [self stopLoading];
    }
}

// UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    // show network activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // hide network activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // stop support page loading indicator view animating
    [_mSupportPageLoadingIndicatorView stopAnimating];
    
    // show support page webview scroll view if needed
    if ([webView respondsToSelector:@selector(scrollView)] && [webView.scrollView isHidden]) {
        webView.scrollView.hidden = NO;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    // hide network activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // stop support page loading indicator view animating
    [_mSupportPageLoadingIndicatorView stopAnimating];
    
    // load the error page inside the webview
    [webView loadHTMLString:[NSString stringWithFormat:NSLocalizedString(@"support page retrieve error html string format", nil), error.localizedDescription] baseURL:nil];
    
    // show support page webview scroll view if needed
    if ([webView.scrollView isHidden]) {
        webView.scrollView.hidden = NO;
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
