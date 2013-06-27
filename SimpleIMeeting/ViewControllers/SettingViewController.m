//
//  SettingViewController.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SettingViewController.h"

#import "SettingView.h"

#import "SimpleIMeetingContentViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSponsorContentViewType:(SIMContentViewMode)contentViewType{
    return [super initWithSponsorContentViewType:contentViewType presentView:[[SettingView alloc] init]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back2SponsorSimpleIMeetingContentViewControllerContentView{
    // define simple imeeting content view controller
    UIViewController *_simpleIMeetingContentViewController;
    
    // get navigation controller all view controllers array
    NSArray *_allViewControllers = self.navigationController.viewControllers;
    
    // check navigation controller all view controllers array count and login account if is or not changed
    if (0 < [_allViewControllers count] - 1 && [_simpleIMeetingContentViewController = [_allViewControllers objectAtIndex:[_allViewControllers count] - 1 - 1] isMemberOfClass:[SimpleIMeetingContentViewController class]] && [(SettingView *)self.view check7clearLoginAccountIsChangedFlag]) {
        [(SimpleIMeetingContentViewController *)_simpleIMeetingContentViewController markLoginAccountIsChanged];
    }
    
    [super back2SponsorSimpleIMeetingContentViewControllerContentView];
}

@end
