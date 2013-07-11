//
//  SettingView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIContentAlertView.h"

#import "IHttpReqRespProtocol.h"

@interface SettingView : UIView <IHttpReqRespProtocol, UITextFieldDelegate> {
    // is my account changed
    BOOL _mIsMyAccountChanged;
    
    // present subviews
    // subview my account group view
    // device id or contacts info be binded or account tip label
    UILabel *_mDeviceId6ContactsInfoBeBinded6AccountTipLabel;
    // device id or contacts info be binded or account label
    UILabel *_mDeviceId6ContactsInfoBeBinded6AccountLabel;
    // binded account logout button
    UIButton *_mBindedAccountLogoutButton;
    
    // subview bind contact info group view
    UIButton *_mPhoneBindButton;
    
    // phone bind and binded account login alert view
    UIContentAlertView *_mPhoneBind7BindedAccountLoginAlertView;
    
    // last editing text field
    UITextField *_mLastEditingTextField;
    
    // get phone bind verification code again remain seconds and timer
    NSInteger _mGetPhoneBindVerificationCodeAgainRemainSeconds;
    NSTimer *_mGetPhoneBindVerificationCodeAgainTimer;
    
    // phone bind alert view content view
    // phone bind phone number text field
    UITextField *_mPhoneBindPhoneNumberTextField;
    // phone bind verification code text field
    UITextField *_mPhoneBindVerificationCodeTextField;
    // phone bind get verification code button
    UIButton *_mPhoneBindGetVerificationCodeButton;
    // phone bind password text field
    UITextField *_mPhoneBindPasswordTextField;
    // phone bind confirm password text field
    UITextField *_mPhoneBindConfirmPwdTextField;
    
    // binded account login alert view content view
    // binded account login name text field
    UITextField *_mBindedAccountLoginNameTextField;
    // binded account login password text field
    UITextField *_mBindedAccountLoginPasswordTextField;
}

// check and clear my account is changed flag
- (BOOL)check7clearMyAccountIsChangedFlag;

@end
