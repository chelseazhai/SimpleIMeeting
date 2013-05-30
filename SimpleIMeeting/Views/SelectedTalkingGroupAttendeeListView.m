//
//  SelectedTalkingGroupAttendeeListView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SelectedTalkingGroupAttendeeListView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "SimpleIMeetingTableViewTipView.h"

@implementation SelectedTalkingGroupAttendeeListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init selected talking group attendees head tip view
        SimpleIMeetingTableViewTipView *_selectedTalkingGroupAttendeesHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:RightAlign_TipView andParentView:self];
        
        // set selected talking group attendees head tip view text
        [_selectedTalkingGroupAttendeesHeadTipView setTipViewText:NSLocalizedString(@"my talking group attendees head tip view text", nil)];
        
        // init selected talking group attendees table view
        _mSelectedTalkingGroupAttendeesTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _selectedTalkingGroupAttendeesHeadTipView.height, FILL_PARENT, FILL_PARENT - (self.bounds.origin.y + _selectedTalkingGroupAttendeesHeadTipView.height))];
        
        // add selected talking group attendees head tip view and selected talking group attendees table view as subviews
        [self addSubview:_selectedTalkingGroupAttendeesHeadTipView];
        [self addSubview:_mSelectedTalkingGroupAttendeesTableView];
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
