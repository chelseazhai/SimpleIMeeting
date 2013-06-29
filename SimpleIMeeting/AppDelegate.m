//
//  AppDelegate.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "AppDelegate.h"

#import <CommonToolkit/CommonToolkit.h>

#import "SimpleIMeetingContentViewController.h"

#import "UserBean+BindContactInfo.h"

#import "BindedAccountLoginHttpRequestProcessor.h"

#import "RegAndLoginWithDeviceIdHttpRequestProcessor.h"

#import "NetworkUnavailableViewController.h"

@interface AppDelegate ()

// send register and login using device combined unique id http request
- (void)sendReg7LoginWithDeviceCombinedUniqueIdHttpRequest;

@end

@implementation AppDelegate

@synthesize rootViewController = _rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    // show status bar when application did finish launching
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // traversal addressBook
    [[AddressBookManager shareAddressBookManager] traversalAddressBook];
    
    // get binded account login user info from storage
    NSString *_storageBindedAccountLoginName = [[NSUserDefaults standardUserDefaults] objectForKey:BINDEDACCOUNT_LOGINNAME];
    NSString *_storageBindedAccountLoginPwd = [[NSUserDefaults standardUserDefaults] objectForKey:BINDEDACCOUNT_LOGINPWD];
    
    NSLog(@"storage binded account login name = %@ and password = %@", _storageBindedAccountLoginName, _storageBindedAccountLoginPwd);
    
    // generate local storage user
    UserBean *_localStorageUser = [[UserBean alloc] init];
    
    // set bind contact info and password
    if (nil != _storageBindedAccountLoginName && ![@"" isEqualToString:_storageBindedAccountLoginName]) {
        _localStorageUser.bindContactInfo = _storageBindedAccountLoginName;
    }
    if (nil != _storageBindedAccountLoginPwd && ![@"" isEqualToString:_storageBindedAccountLoginPwd]) {
        _localStorageUser.password = _storageBindedAccountLoginPwd;
    }
    
    // save local storage user bean and add it to user manager
    [[UserManager shareUserManager] setUserBean:_localStorageUser];
    
    // check binded account login name and password
    if (nil != _storageBindedAccountLoginName && ![@"" isEqualToString:_storageBindedAccountLoginName]
        && nil != _storageBindedAccountLoginPwd && ![@"" isEqualToString:_storageBindedAccountLoginPwd]) {
        // binded account user login
        // generate binded account login param map
        NSMutableDictionary *_bindedAccountLoginParamMap = [[NSMutableDictionary alloc] init];
        
        // set some params
        [_bindedAccountLoginParamMap setObject:_storageBindedAccountLoginName forKey:NSRBGServerFieldString(@"remote background server http request binded account login name", nil)];
        [_bindedAccountLoginParamMap setObject:_storageBindedAccountLoginPwd forKey:NSRBGServerFieldString(@"remote background server http request binded account login password", nil)];
        [_bindedAccountLoginParamMap addEntriesFromDictionary:REQUESTPARAMWITHDEVICEINFOIDC];
        
        // define binded account login http request processor
        BindedAccountLoginHttpRequestProcessor *_bindedAccountLoginHttpRequestProcessor = [[BindedAccountLoginHttpRequestProcessor alloc] init];
        
        // set binded account login http request processor login completion
        [_bindedAccountLoginHttpRequestProcessor setLoginCompletion:^(NSInteger result) {
            // check binded account login request response result
            if (0 == result) {
                // binded account login succeed, init application root view controller with simple imeeting content view controller
                _rootViewController = [[AppRootViewController alloc] initWithNavigationViewController:[[SimpleIMeetingContentViewController alloc] init] andBarBackgroundImage:[UIImage imageNamed:@"img_navigationbar_bg"]];
            }
            else {
                // binded account login failed, register and login using device combined unique id again
                [self sendReg7LoginWithDeviceCombinedUniqueIdHttpRequest];
            }
        }];
        
        // post binded account login http request
        [HttpUtils postRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"binded account login url format string", nil), NSUrlString(@"remote background server root url string", nil)] andPostFormat:urlEncoded andParameter:_bindedAccountLoginParamMap andUserInfo:nil andRequestType:synchronous andProcessor:_bindedAccountLoginHttpRequestProcessor andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
    } else {
        // register and login using device combined unique id
        [self sendReg7LoginWithDeviceCombinedUniqueIdHttpRequest];
    }
    
    // set application window rootViewController and show the main window
    self.window.rootViewController = _rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// inner extension
- (void)sendReg7LoginWithDeviceCombinedUniqueIdHttpRequest{
    // generate register and login with device combined unique id param map
    NSMutableDictionary *_reg7LoginWithDeviceIdParamMap = [[NSMutableDictionary alloc] init];
    
    // set some params
    [_reg7LoginWithDeviceIdParamMap setObject:[[UIDevice currentDevice] combinedUniqueId] forKey:NSRBGServerFieldString(@"remote background server http request register and login with device id or contact info bind device id", nil)];
    [_reg7LoginWithDeviceIdParamMap addEntriesFromDictionary:REQUESTPARAMWITHDEVICEINFOIDC];
    
    // define register and login with device combined unique id http request processor
    RegAndLoginWithDeviceIdHttpRequestProcessor *_regAndLoginWithDeviceIdLoginHttpRequestProcessor = [[RegAndLoginWithDeviceIdHttpRequestProcessor alloc] init];
    
    // set register and login with device combined unique id http request processor register and login with device id completion
    [_regAndLoginWithDeviceIdLoginHttpRequestProcessor setReg7LoginWithDeviceIdCompletion:^(NSInteger result) {
        // check register and login with device combined unique id request response result
        if (0 == result) {
            // register and login with device combined unique id succeed, init application root view controller with simple imeeting content view controller
            _rootViewController = [[AppRootViewController alloc] initWithNavigationViewController:[[SimpleIMeetingContentViewController alloc] init] andBarBackgroundImage:[UIImage imageNamed:@"img_navigationbar_bg"]];
        }
        else {
            // register and login with device combined unique id failed, init application root view controller with network unavailable view controller
            _rootViewController = [[AppRootViewController alloc] initWithPresentViewController:[[NetworkUnavailableViewController alloc] init] andMode:normalController];
        }
    }];
    
    // post register and login with device combined unique id http request
    [HttpUtils postRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"register and login with device id url format string", nil), NSUrlString(@"remote background server root url string", nil)] andPostFormat:urlEncoded andParameter:_reg7LoginWithDeviceIdParamMap andUserInfo:nil andRequestType:synchronous andProcessor:_regAndLoginWithDeviceIdLoginHttpRequestProcessor andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
}

@end
