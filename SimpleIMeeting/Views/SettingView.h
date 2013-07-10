//
//  SettingView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIContentAlertView.h"

@interface SettingView : UIView <UITextFieldDelegate> {
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
}

// check and clear my account is changed flag
- (BOOL)check7clearMyAccountIsChangedFlag;

@end
