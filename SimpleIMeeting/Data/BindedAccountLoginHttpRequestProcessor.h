//
//  BindedAccountLoginHttpRequestProcessor.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IHttpReqRespSelector.h"

// binded account login type
typedef NS_ENUM(NSInteger, BindedAccountLoginType){
    // auto and manual
    AUTO, MANUAL
};

@interface BindedAccountLoginHttpRequestProcessor : NSObject <IHttpReqRespSelector> {
    // binded account login type
    BindedAccountLoginType _mLoginType;
    
    // 
}

// set binded account login type
- (void)setLoginType:(BindedAccountLoginType)loginType;

// set binded account login process done block
- (void)setLoginDone:

@end
