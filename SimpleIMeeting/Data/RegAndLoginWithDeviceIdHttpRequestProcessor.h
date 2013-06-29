//
//  RegAndLoginWithDeviceIdHttpRequestProcessor.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IHttpReqRespSelector.h"

// register and login with device combined id type
typedef NS_ENUM(NSInteger, Reg7LoginWithDeviceIdType){
    // application launch and logout
    APPLAUNCH_REG7LOGINWITHDEVICEID, BINDEDACCOUNTLOGOUT_REG7LOGINWITHDEVICEID
};

@interface RegAndLoginWithDeviceIdHttpRequestProcessor : NSObject <IHttpReqRespSelector> {
    // register and login with device combined id type
    Reg7LoginWithDeviceIdType _mReg7LoginWithDeviceIdType;
    
    // register and login with device combined id process completion block
    void (^ _mReg7LoginWithDeviceIdProcessCompletionBlock)(NSInteger);
}

// set register and login with device combined id type
- (void)setReg7LoginWithDeviceIdType:(Reg7LoginWithDeviceIdType)reg7loginWithDeviceIdType;

// set register and login with device combined id process completion block
- (void)setReg7LoginWithDeviceIdCompletion:(void (^)(NSInteger))completion;

@end
