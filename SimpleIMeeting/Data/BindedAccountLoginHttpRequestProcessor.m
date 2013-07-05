//
//  BindedAccountLoginHttpRequestProcessor.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "BindedAccountLoginHttpRequestProcessor.h"

#import "UserBean+BindContactInfo.h"

@interface BindedAccountLoginHttpRequestProcessor ()

// binded account login failed with send binded account login http request response status code
- (void)bindedAccountLoginFailed:(NSInteger)respStatusCode;

@end

@implementation BindedAccountLoginHttpRequestProcessor

- (id)init{
    self = [super init];
    if (self) {
        // Initialization code
        // set binded account login type, auto login as default
        _mLoginType = BINDEDACCOUNT_AUTOLOGIN;
    }
    return self;
}

- (void)setLoginType:(BindedAccountLoginType)loginType{
    // save binded account login type
    _mLoginType = loginType;
}

- (void)setManualLoginUserName:(NSString *)userName password:(NSString *)password{
    // save manual login user name and password
    _mManualLoginUserName = userName;
    _mManualLoginPwd = password;
}

- (void)setLoginCompletion:(void (^)(NSInteger))completion{
    // set binded account login completion
    _mBindedAccountLoginProcessCompletionBlock = completion;
}

// IHttpReqRespProtocol
- (void)httpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send binded account login http request succeed - request url = %@, response status code = %d and data string = %@", pRequest.url, [pRequest responseStatusCode], pRequest.responseString);
    
    // check status code
    if (200 == [pRequest responseStatusCode]) {
        // get response data json format
        NSDictionary *_respDataJSONFormat = [pRequest.responseString objectFromJSONString];
        
        // get and check response data result
        NSString *_respDataResult = nil != _respDataJSONFormat ? [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request response result", nil)] : nil;
        if (nil != _respDataResult && 0 == _respDataResult.intValue) {
            // get binded account login response userId, userKey, nickname and bindStatus
            NSString *_bindedAccountLoginRespUserId = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request login or contact info bind response user id", nil)];
            NSString *_bindedAccountLoginRespUserKey = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request login or contact info bind response user key", nil)];
            NSString *_bindedAccountLoginRespNickname = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request login or contact info bind response nickname", nil)];
            NSString *_bindedAccountLoginRespBindStatus = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request login or register and login with device id or phone bind response bind status", nil)];
            
            NSLog(@"Binded account login successful, response user id = %@, user key = %@, nickname = %@ and bind status = %@", _bindedAccountLoginRespUserId, _bindedAccountLoginRespUserKey, _bindedAccountLoginRespNickname, _bindedAccountLoginRespBindStatus);
            
            // get user manager
            UserManager *_userManager = [UserManager shareUserManager];
            
            // check binded account login type
            if (BINDEDACCOUNT_MANUALLOGIN == _mLoginType) {
                // save manual login user name and password to local storage
                [[NSUserDefaults standardUserDefaults] setObject:_mManualLoginUserName forKey:BINDEDACCOUNT_LOGINNAME];
                [[NSUserDefaults standardUserDefaults] setObject:[_mManualLoginPwd md5] forKey:BINDEDACCOUNT_LOGINPWD];
                
				// generate manual login user and set password and bind contact info
				UserBean *_manualLoginUser = [[UserBean alloc] init];
				_manualLoginUser.password = [_mManualLoginPwd md5];
                _manualLoginUser.bindContactInfo = _mManualLoginUserName;
                
				// add manual login user to user manager
                [_userManager setUserBean:_manualLoginUser];
            }
            
            // get the user from user manager and complete its other attributes
			UserBean *_bindedAccountLoginRetUser = _userManager.userBean;
            _bindedAccountLoginRetUser.name = _bindedAccountLoginRespUserId;
            _bindedAccountLoginRetUser.userKey = _bindedAccountLoginRespUserKey;
            
            _bindedAccountLoginRetUser.nickname = _bindedAccountLoginRespNickname;
            _bindedAccountLoginRetUser.contactsInfoTypeBeBinded = _bindedAccountLoginRespBindStatus;
            
            // binded account login succeed completion
            _mBindedAccountLoginProcessCompletionBlock(0);
        }
        else {
            NSLog(@"binded account login user name or password wrong");
            
            // binded account login failed
            [self bindedAccountLoginFailed:[pRequest responseStatusCode]];
        }
    }
    else {
        NSLog(@"binded account login http request response error, response status message = %@", [pRequest responseStatusMessage]);
        
        // binded account login failed
        [self bindedAccountLoginFailed:[pRequest responseStatusCode]];
    }
}

- (void)httpRequestDidFailed:(ASIHTTPRequest *)pRequest{
    NSLog(@"send binded account login http request failed");
    
    // binded account login failed
    [self bindedAccountLoginFailed:[pRequest responseStatusCode]];
}

// inner extension
- (void)bindedAccountLoginFailed:(NSInteger)respStatusCode{
    // check binded account login type
    if (BINDEDACCOUNT_MANUALLOGIN == _mLoginType) {
        // define binded account login failed reason
        NSString *_bindedAccountLoginFailedReason;
        
        // check send binded account login http request response status code
        if (200 == respStatusCode) {
            // binded account login user name or password worng
            _bindedAccountLoginFailedReason = NSToastLocalizedString(@"toast binded account login user name or password wrong", nil);
        }
        else {
            // others
            _bindedAccountLoginFailedReason = NSToastLocalizedString(@"toast http request response error", nil);
        }
        
        // make binded account login failed toast with reason and show it
        [HTTPREQRESPRETTOASTMAKER(_bindedAccountLoginFailedReason) show:iToastTypeError];
    }
    
    // binded account login failed completion
    _mBindedAccountLoginProcessCompletionBlock(-1);
}

@end
