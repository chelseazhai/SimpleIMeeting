//
//  SupportViewController.m
//  SimpleIMeeting
//
//  Created by Ares on 13-7-8.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SupportViewController.h"

#import "SupportView.h"

@interface SupportViewController ()

@end

@implementation SupportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSponsorContentViewType:(SIMContentViewMode)contentViewType{
    return [super initWithSponsorContentViewType:contentViewType presentView:[[SupportView alloc] init]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // start load support web page
    [((SupportView *)self.view) startLoadSupportWebPage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // cancel loading support web page if needed
    [((SupportView *)self.view) cancelLoadingSupportWebPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
