//
//  BindedAccountLoginHttpRequestProcessor.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "BindedAccountLoginHttpRequestProcessor.h"

@implementation BindedAccountLoginHttpRequestProcessor

- (void)setLoginType:(BindedAccountLoginType)loginType{
    // save binded account login type
    _mLoginType = loginType;
}

- (void)setLoginCompletion:(void (^)(NSInteger))completion{
    // set binded account login completion
    _mBindedAccountLoginProcessCompletionBlock = completion;
}

// IHttpReqRespSelector
- (void)httpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    //
}

- (void)httpRequestDidFailed:(ASIHTTPRequest *)pRequest{
    //
}

@end
