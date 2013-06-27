//
//  AssistantCommonViewController.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "AssistantCommonViewController.h"

@interface AssistantCommonViewController ()

@end

@implementation AssistantCommonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSponsorContentViewType:(SIMContentViewMode)contentViewType presentView:(UIView *)presentView{
    self = [super initWithCompatibleView:presentView];
    if (self) {
        // Custom initialization
        // init back to sponsor simple imeeting content view controller content view bar button item and set it as present view left bar button item
        presentView.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:MYTALKINGGROUPS == contentViewType ? NSLocalizedString(@"back to my talking groups and selected talking group attendees content view bar button item title", nil) : NSLocalizedString(@"back to contacts select content view bar button item title", nil) bgImage:[UIImage imageNamed:@"img_left_barbtnitem_bg"] target:self action:@selector(back2SponsorSimpleIMeetingContentViewControllerContentView)];
    }
    return self;
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
    // pop present view using assistant common view controller
    [self.navigationController popViewControllerAnimated:YES];
}

@end
