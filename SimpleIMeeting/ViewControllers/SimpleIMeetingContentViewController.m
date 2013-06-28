//
//  SimpleIMeetingContentViewController.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SimpleIMeetingContentViewController.h"

#import <CommonToolkit/CommonToolkit.h>

#import "SimpleIMeetingContentContainerView.h"

@interface SimpleIMeetingContentViewController ()

@end

@implementation SimpleIMeetingContentViewController

- (id)init{
    return [super initWithCompatibleView:[[SimpleIMeetingContentContainerView alloc] init]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // check my account is or not changed
    if (_mIsMyAccountChanged) {
        // recover my account is changed flag
        _mIsMyAccountChanged = NO;
        
        // set my talking groups need to refresh
        [(SimpleIMeetingContentContainerView *)self.view setMyTalkingGroupsNeed2Refresh];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)markMyAccountIsChanged{
    // set my account is changed
    _mIsMyAccountChanged = YES;
}

@end
