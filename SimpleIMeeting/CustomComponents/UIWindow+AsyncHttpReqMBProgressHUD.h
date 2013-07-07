//
//  UIWindow+AsyncHttpReqMBProgressHUD.h
//  SimpleIMeeting
//
//  Created by Ares on 13-7-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

@interface UIWindow (AsyncHttpReqMBProgressHUD)

// show asynchronous http request MBProgressHUD
- (MBProgressHUD *)showMBProgressHUD;

// hide asynchronous http request MBProgressHUD
- (BOOL)hideMBProgressHUD;

@end
