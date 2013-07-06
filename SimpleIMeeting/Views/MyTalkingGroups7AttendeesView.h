//
//  MyTalkingGroups7AttendeesView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

#import "ITalkingGroupGeneratorProtocol.h"

@class MyTalkingGroupListView;
@class SelectedTalkingGroupAttendeeListView;

// my talking groups and selected talking group attendees view needed to refresh type
typedef NS_ENUM(NSInteger, MyTalkingGroups7AttendeesViewRefreshType){
    NOREFRESH, REFRESH_TALKINGGROUPS, REFRESH_SELECTEDTALKINGGROUP_ATTENDEES
};

@interface MyTalkingGroups7AttendeesView : UIView <ITalkingGroupGeneratorProtocol> {
    // my talking group list table view need to refresh
    BOOL _mMyTalkingGroupsNeed2Refresh;
    
    // present subviews
    // subview my talking groups loading indicator view
    UIDataLoadingIndicatorView *_mMyTalkingGroupsLoadingIndicatorView;
    // subview no talking group tip label
    UILabel *_mNoTalkingGroupTipLabel;
    // subview my talking group list view
    MyTalkingGroupListView *_mMyTalkingGroupListView;
    // selected talking group attendee list view
    SelectedTalkingGroupAttendeeListView *_mSelectedTalkingGroupAttendeeListView;
}

@property (nonatomic, assign) BOOL myTalkingGroupsNeed2Refresh;

// selected talking group attendees info array
@property (nonatomic, retain) NSArray *selectedTalkingGroupAttendeesInfoArray;

// refresh my talking groups
- (void)refreshMyTalkingGroups;

// resize my talking group and selected talking group attendee list view
- (void)resizeMyTalkingGroupsAndAttendeesView:(BOOL)hasOneTalkingGroupBeSelected;

// refresh the selected talking group attendees
- (void)refreshSelectedTalkingGroupAttendees;

@end
