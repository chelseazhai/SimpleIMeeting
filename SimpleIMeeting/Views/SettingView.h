//
//  SettingView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIView {
    // is login account changed
    BOOL _mIsLoginAccountChanged;
}

// check and clear login account is changed flag
- (BOOL)check7clearLoginAccountIsChangedFlag;

@end
