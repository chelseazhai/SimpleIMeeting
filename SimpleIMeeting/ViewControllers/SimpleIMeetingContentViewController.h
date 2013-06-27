//
//  SimpleIMeetingContentViewController.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleIMeetingContentViewController : UIViewController {
    // is login account changed
    BOOL _mIsLoginAccountChanged;
}

// mark login account is changed
- (void)markLoginAccountIsChanged;

@end
