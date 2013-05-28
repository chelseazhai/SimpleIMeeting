//
//  MyTalkingGroupListView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "MyTalkingGroupListView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "SimpleIMeetingTableViewTipView.h"

@implementation MyTalkingGroupListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init my talking groups head tip view
        SimpleIMeetingTableViewTipView *_myTalkingGroupsHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:LeftAlign_TipView andParentView:self];
        
        // set my talking groups head tip view text
        [_myTalkingGroupsHeadTipView setTipViewText:NSLocalizedString(@"my talking groups head tip view text", nil)];
        
        // init my talking groups table view
        _mMyTalkingGroupsTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _myTalkingGroupsHeadTipView.height, self.bounds.size.width, self.bounds.size.height - _myTalkingGroupsHeadTipView.height)];
        
        // add my talking groups head tip view and my talking groups table view as subviews
        [self addSubview:_myTalkingGroupsHeadTipView];
        [self addSubview:_mMyTalkingGroupsTableView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
