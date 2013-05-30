//
//  MyTalkingGroups7AttendeesView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "MyTalkingGroups7AttendeesView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "MyTalkingGroupListView.h"
#import "SelectedTalkingGroupAttendeeListView.h"

@implementation MyTalkingGroups7AttendeesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init my talking groups view
        _mMyTalkingGroupsView = [[MyTalkingGroupListView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT * (2 / 3.0), FILL_PARENT)];
        // init selected talking group attendees view
        _mSelectedTalkingGroupAttendeesView = [[SelectedTalkingGroupAttendeeListView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + _mMyTalkingGroupsView.bounds.size.width, self.bounds.origin.y, FILL_PARENT / 3.0, FILL_PARENT)];
        
        // add my talking groups view as subview
        [self addSubview:_mMyTalkingGroupsView];
        [self addSubview:_mSelectedTalkingGroupAttendeesView];
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
