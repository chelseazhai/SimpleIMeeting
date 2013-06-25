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

#import "SimpleIMeetingContentContainerView.h"

// no talking group tip label width, height weight and my talking groups and selected talking group attendees view total weight
#define NOTALKINGGROUPTIPLABEL_WIDTHWEIGHT  7
#define NOTALKINGGROUPTIPLABEL_HEIGHTWEIGHT 2
#define MYTALKINGGROUPS7ATTENDEESVIEW_TOTALSUMWEIGHT 10.0

@interface MyTalkingGroups7AttendeesView ()

// generate my talking group list view draw rectangle
- (CGRect)genMyTalkingGroupListViewDrawRect;

@end

@implementation MyTalkingGroups7AttendeesView

@synthesize myTalkingGroupNeed2Refresh = _mMyTalkingGroupNeed2Refresh;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background image
        self.backgroundImg = [UIImage compatibleImageNamed:@"img_mytalkinggroups7attendeesview_bg"];
        
        // create and init subviews
        // init no talking group tip label
        _mNoTalkingGroupTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + FILL_PARENT * (MYTALKINGGROUPS7ATTENDEESVIEW_TOTALSUMWEIGHT - NOTALKINGGROUPTIPLABEL_WIDTHWEIGHT) / (2 * MYTALKINGGROUPS7ATTENDEESVIEW_TOTALSUMWEIGHT), self.bounds.origin.y + FILL_PARENT * (NOTALKINGGROUPTIPLABEL_HEIGHTWEIGHT / (3 * MYTALKINGGROUPS7ATTENDEESVIEW_TOTALSUMWEIGHT)), FILL_PARENT * (NOTALKINGGROUPTIPLABEL_WIDTHWEIGHT / MYTALKINGGROUPS7ATTENDEESVIEW_TOTALSUMWEIGHT), FILL_PARENT * (NOTALKINGGROUPTIPLABEL_HEIGHTWEIGHT / MYTALKINGGROUPS7ATTENDEESVIEW_TOTALSUMWEIGHT))];
        
        // set its attributes
        _mNoTalkingGroupTipLabel.text = NSLocalizedString(@"no talking group tip label Text", nil);
        _mNoTalkingGroupTipLabel.backgroundColor = [UIColor clearColor];
        
        // hidden first
        _mNoTalkingGroupTipLabel.hidden = YES;
        
        // init my talking group list view
        _mMyTalkingGroupListView = [[MyTalkingGroupListView alloc] initWithFrame:[self genMyTalkingGroupListViewDrawRect]];
        
        // init selected talking group attendee list view
        _mSelectedTalkingGroupAttendeeListView = [[SelectedTalkingGroupAttendeeListView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + FILL_PARENT * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), self.bounds.origin.y, FILL_PARENT * (RIGHTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), FILL_PARENT)];
        
        // hidden first
        _mSelectedTalkingGroupAttendeeListView.hidden = YES;
        
        // add no talking group tip label, my talking group list view and selected talking group attendee list view as subviews of my talking groups and selected talking group attendees view
        [self addSubview:_mNoTalkingGroupTipLabel];
        [self addSubview:_mMyTalkingGroupListView];
        [self addSubview:_mSelectedTalkingGroupAttendeeListView];
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

- (NSArray *)myTalkingGroupsInfoArray{
    return _mMyTalkingGroupListView.myTalkingGroupsInfoArray;
}

- (void)setMyTalkingGroupNeed2Refresh:(BOOL)myTalkingGroupNeed2Refresh{
    //
}

// NewTalkingGroupProtocol
- (void)generateNewTalkingGroup{
    // switch to contacts select content view for adding selected contact for inviting to talking group
    [((SimpleIMeetingContentContainerView *)self.superview) switch2ContactsSelectContentView4AddingSelectedContact4Inviting];
}

- (void)cancelGenNewTalkingGroup{
    // back to my talking groups and selected talking group attendees content view for ending add selected contact for inviting to talking group
    [((SimpleIMeetingContentContainerView *)self.superview) back2MyTalkingGroups7AttendeesContentView4EndingAddSelectedContact4Inviting];
}

// inner extension
- (CGRect)genMyTalkingGroupListViewDrawRect{
    CGRect _myTalkingGroupListViewDrawRectangle;
    
    // check my talking group list view if or not init
    if (nil == _mMyTalkingGroupListView) {
        _myTalkingGroupListViewDrawRectangle = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT);
    }
    else {
        // get my talking group list view frame
        _myTalkingGroupListViewDrawRectangle = _mMyTalkingGroupListView.frame;
        
        // check there is  or no one talking group be selected and update my talking group list view draw rectangle width
        if (_mOneTalkingGroupBeSelected) {
            // compare my talking group list view frame size width with its parent view frame size width
            if (self.frame.size.width == _mMyTalkingGroupListView.frame.size.width) {
                _myTalkingGroupListViewDrawRectangle.size.width = _mMyTalkingGroupListView.frame.size.width * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT);
            }
        }
        else {
            // recover as parent view frame size width
            _myTalkingGroupListViewDrawRectangle.size.width = self.frame.size.width;
        }
    }
    
    return _myTalkingGroupListViewDrawRectangle;
}

@end
