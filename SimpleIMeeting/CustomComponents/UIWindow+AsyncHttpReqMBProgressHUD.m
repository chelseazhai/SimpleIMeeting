//
//  UIWindow+AsyncHttpReqMBProgressHUD.m
//  SimpleIMeeting
//
//  Created by Ares on 13-7-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "UIWindow+AsyncHttpReqMBProgressHUD.h"

@implementation UIWindow (AsyncHttpReqMBProgressHUD)

- (MBProgressHUD *)showMBProgressHUD{
    // init asynchronous http request MBProgressHUD
    MBProgressHUD *_hud = [[MBProgressHUD alloc] initWithView:self];
    
    // add it as subview of window
	[self addSubview:_hud];
    
    // set its message
    _hud.labelText = NSLocalizedString(@"asynchronous http request progress view message", nil);
    
    // show it with animation
	[_hud show:YES];
    
    // return the asynchronous http request MBProgressHUD
	return _hud;
}

- (BOOL)hideMBProgressHUD{
    // get the asynchronous http request MBProgressHUD from the window
    MBProgressHUD *_hud = [MBProgressHUD HUDForView:self];
    
    // check it
	if (nil != _hud) {
        // remove it when hide
		_hud.removeFromSuperViewOnHide = YES;
        
        // hide it
		[_hud hide:YES];
        
		return YES;
	}
    
	return NO;
}

@end
