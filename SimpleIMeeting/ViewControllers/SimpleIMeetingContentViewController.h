//
//  SimpleIMeetingContentViewController.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleIMeetingContentViewController : UIViewController {
    // is my account changed
    BOOL _mIsMyAccountChanged;
}

// mark my account is changed
- (void)markMyAccountIsChanged;

@end
