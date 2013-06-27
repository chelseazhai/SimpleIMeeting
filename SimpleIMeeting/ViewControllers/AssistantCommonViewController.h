//
//  AssistantCommonViewController.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleIMeetingContentContainerView.h"

@interface AssistantCommonViewController : UIViewController

// init with sponsor simple imeeting content view controller content view type and present view
- (id)initWithSponsorContentViewType:(SIMContentViewMode)contentViewType presentView:(UIView *)presentView;

// back to sponsor simple imeeting content view controller content view
- (void)back2SponsorSimpleIMeetingContentViewControllerContentView;

@end
