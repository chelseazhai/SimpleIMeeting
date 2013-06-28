//
//  RegAndLoginWithDeviceIdLoginHttpRequestProcessor.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "RegAndLoginWithDeviceIdLoginHttpRequestProcessor.h"

@implementation RegAndLoginWithDeviceIdLoginHttpRequestProcessor

- (void)setReg7LoginWithDeviceIdType:(Reg7LoginWithDeviceIdType)reg7loginWithDeviceIdType{
    // set register and login with device id type
    _mReg7LoginWithDeviceIdType = reg7loginWithDeviceIdType;
}

- (void)setReg7LoginWithDeviceIdCompletion:(void (^)(NSInteger))completion{
    // set register and login with device id completion
    _mReg7LoginWithDeviceIdProcessCompletionBlock = completion;
}

// IHttpReqRespSelector
- (void)httpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send register and login with device id http request succeed");
    
    //
}

- (void)httpRequestDidFailed:(ASIHTTPRequest *)pRequest{
    NSLog(@"send register and login with device id http request failed");
    
    // test by ares
    NSLog(@"pRequest = %@", pRequest.url.absoluteString);
    _mReg7LoginWithDeviceIdProcessCompletionBlock(-1);
    
    //
}

@end
