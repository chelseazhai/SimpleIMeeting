//
//  IHttpReqRespSelector.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonToolkit/CommonToolkit.h>

@protocol IHttpReqRespSelector <NSObject>

@required

// http request did finished response selector
- (void)httpRequestDidFinished:(ASIHTTPRequest *)pRequest;

// http request did failed response selector
- (void)httpRequestDidFailed:(ASIHTTPRequest *)pRequest;

@end
