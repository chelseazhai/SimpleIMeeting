//
//  SettingView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIView {
    // is my account changed
    BOOL _mIsMyAccountChanged;
}

// check and clear my account is changed flag
- (BOOL)check7clearMyAccountIsChangedFlag;

@end
