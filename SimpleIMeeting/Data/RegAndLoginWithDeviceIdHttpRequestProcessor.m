//
//  RegAndLoginWithDeviceIdHttpRequestProcessor.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "RegAndLoginWithDeviceIdHttpRequestProcessor.h"

#import "UserBean+BindContactInfo.h"

@interface RegAndLoginWithDeviceIdHttpRequestProcessor ()

// register and login with device id failed
- (void)registerAndLoginWithDeviceIdFailed;

@end

@implementation RegAndLoginWithDeviceIdHttpRequestProcessor

- (id)init{
    self = [super init];
    if (self) {
        // Initialization code
        // set register and login with device id type, application launch as default
        _mReg7LoginWithDeviceIdType = APPLAUNCH_REG7LOGINWITHDEVICEID;
    }
    return self;
}

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
    NSLog(@"send register and login with device id http request succeed - request url = %@, response status code = %d and data string = %@", pRequest.url, [pRequest responseStatusCode], pRequest.responseString);
    
    // check status code
    if (200 == [pRequest responseStatusCode]) {
        // get response data json format
        NSDictionary *_respDataJSONFormat = [pRequest.responseString objectFromJSONString];
        
        // get and check response data result
        NSString *_respDataResult = nil != _respDataJSONFormat ? [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request response result", nil)] : nil;
        if (nil != _respDataResult && 0 == _respDataResult.intValue) {
            // get register and login with device id response userId, userKey, bindStatus and bindInfo
            NSString *_reg7LoginWithDeviceIdRespUserId = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request login or contact info bind response user id", nil)];
            NSString *_reg7LoginWithDeviceIdRespUserKey = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request login or contact info bind response user key", nil)];
            NSString *_reg7LoginWithDeviceIdRespBindStatus = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request login or register and login with device id or phone bind response bind status", nil)];
            NSString *_reg7LoginWithDeviceIdRespBindInfo = [_respDataJSONFormat objectForKey:_reg7LoginWithDeviceIdRespBindStatus];
            
            NSLog(@"Register and login with device combined unique id successful, response user id = %@, user key = %@, bind status = %@ and bind info = %@", _reg7LoginWithDeviceIdRespUserId, _reg7LoginWithDeviceIdRespUserKey, _reg7LoginWithDeviceIdRespBindStatus, _reg7LoginWithDeviceIdRespBindInfo);
            
            // generate new user bean and complete its attributes
            UserBean *_reg7LoginWithDeviceIdRetUser = [[UserBean alloc] init];
            _reg7LoginWithDeviceIdRetUser.name = _reg7LoginWithDeviceIdRespUserId;
            _reg7LoginWithDeviceIdRetUser.userKey = _reg7LoginWithDeviceIdRespUserKey;
            
            _reg7LoginWithDeviceIdRetUser.contactsInfoTypeBeBinded = _reg7LoginWithDeviceIdRespBindStatus;
            _reg7LoginWithDeviceIdRetUser.contactsInfoBeBinded = _reg7LoginWithDeviceIdRespBindInfo;
            
            // add it to user manager
            [[UserManager shareUserManager] setUserBean:_reg7LoginWithDeviceIdRetUser];
            
            // check register and login with device combined id type
            if (BINDEDACCOUNTLOGOUT_REG7LOGINWITHDEVICEID == _mReg7LoginWithDeviceIdType) {
                // clear binded account login user name and password from local storage
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:BINDEDACCOUNT_LOGINNAME];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:BINDEDACCOUNT_LOGINPWD];
            }
            
            // register and login with device id succeed completion
            _mReg7LoginWithDeviceIdProcessCompletionBlock(0);
        }
        else {
            // register and login with device id failed
            [self registerAndLoginWithDeviceIdFailed];
        }
    }
    else {
        // register and login with device id failed
        [self registerAndLoginWithDeviceIdFailed];
    }
}

- (void)httpRequestDidFailed:(ASIHTTPRequest *)pRequest{
    NSLog(@"send register and login with device id http request failed");
    
    // register and login with device id failed
    [self registerAndLoginWithDeviceIdFailed];
}

// inner extension
- (void)registerAndLoginWithDeviceIdFailed{
    // check register and login with device combined id type
    if (BINDEDACCOUNTLOGOUT_REG7LOGINWITHDEVICEID == _mReg7LoginWithDeviceIdType) {
        // make register and login with device id failed toast with reason and show it
        [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil)) show:iToastTypeError];
    }
    
    // register and login with device id failed completion
    _mReg7LoginWithDeviceIdProcessCompletionBlock(-1);
}

@end
