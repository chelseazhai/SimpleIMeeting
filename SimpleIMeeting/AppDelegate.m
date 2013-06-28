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

#import "RegAndLoginWithDeviceIdLoginHttpRequestProcessor.h"

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
    
    // get binded account login user info from storage and add to user manager
    UserBean *_localStorageUser = [[UserBean alloc] init];
    
    // set bind contact info and password
    _localStorageUser.bindContactInfo = [[NSUserDefaults standardUserDefaults] objectForKey:BINDEDACCOUNT_LOGINNAME];
    _localStorageUser.password = [[NSUserDefaults standardUserDefaults] objectForKey:BINDEDACCOUNT_LOGINPWD];
    
    // save user bean and add to user manager
    [[UserManager shareUserManager] setUserBean:_localStorageUser];
    
    // check user bind contact info and password
    if (nil != _localStorageUser.bindContactInfo && ![@"" isEqualToString:_localStorageUser.bindContactInfo]
        && nil != _localStorageUser.password && ![@"" isEqualToString:_localStorageUser.password]) {
        // binded account user login
        // generate binded account login param map
        NSMutableDictionary *_bindedAccountLoginParamMap = [[NSMutableDictionary alloc] init];
        
        // set some params
        [_bindedAccountLoginParamMap setObject:_localStorageUser.bindContactInfo forKey:@""];
        [_bindedAccountLoginParamMap setObject:_localStorageUser.password forKey:@""];
        
        // define binded account login http request processor
        BindedAccountLoginHttpRequestProcessor *_bindedAccountLoginHttpRequestProcessor = [[BindedAccountLoginHttpRequestProcessor alloc] init];
        
        // post the http request
        [HttpUtils postRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"binded account login url format string", nil), NSUrlString(@"remote background server root url string", nil)] andPostFormat:urlEncoded andParameter:_bindedAccountLoginParamMap andUserInfo:nil andRequestType:synchronous andProcessor:_bindedAccountLoginHttpRequestProcessor andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
    } else {
        // register and login using device combined unique id
        //sendReg7LoginWithDeviceCombinedUniqueIdHttpRequest();
    }
    
    // init application root view controller
    _rootViewController = [[AppRootViewController alloc] initWithNavigationViewController:[[SimpleIMeetingContentViewController alloc] init] andBarBackgroundImage:[UIImage imageNamed:@"img_navigationbar_bg"]];
    
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

@end
