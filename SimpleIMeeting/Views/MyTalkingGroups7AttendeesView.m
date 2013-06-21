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

@interface MyTalkingGroups7AttendeesView ()

// generate my talking groups view draw rectangle
- (CGRect)genMyTalkingGroupsViewDrawRect;

@end

@implementation MyTalkingGroups7AttendeesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init my talking groups view
        _mMyTalkingGroupsView = [[MyTalkingGroupListView alloc] initWithFrame:[self genMyTalkingGroupsViewDrawRect]];
        
        // init selected talking group attendees view
        _mSelectedTalkingGroupAttendeesView = [[SelectedTalkingGroupAttendeeListView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + FILL_PARENT * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), self.bounds.origin.y, FILL_PARENT * (RIGHTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), FILL_PARENT)];
        
        // hidden first
        _mSelectedTalkingGroupAttendeesView.hidden = YES;
        
        // add my talking groups view and selected talking group attendees view as subviews of my talking groups and selected talking group attendees view
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

// inner extension
- (CGRect)genMyTalkingGroupsViewDrawRect{
    CGRect _myTalkingGroupsViewDrawRectangle = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 0.0, FILL_PARENT);
    
    // check the selected talking group index and update my talking groups view draw rectangle width
    if (nil != _mSelectedTalkingGroupIndex) {
        _myTalkingGroupsViewDrawRectangle.size.width = FILL_PARENT * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT);
    }
    else {
        _myTalkingGroupsViewDrawRectangle.size.width = FILL_PARENT;
    }
    
    return _myTalkingGroupsViewDrawRectangle;
}

@end
