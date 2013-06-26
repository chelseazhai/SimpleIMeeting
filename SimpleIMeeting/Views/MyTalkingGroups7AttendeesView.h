//
//  MyTalkingGroups7AttendeesView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

#import "NewTalkingGroupProtocol.h"

@class MyTalkingGroupListView;
@class SelectedTalkingGroupAttendeeListView;

@interface MyTalkingGroups7AttendeesView : UIView <NewTalkingGroupProtocol> {
    // my talking group list table view need to refresh
    BOOL _mMyTalkingGroupsNeed2Refresh;
    
    // there is one talking group be selected
    BOOL _mOneTalkingGroupBeSelected;
    
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

// my talking groups info array
@property (nonatomic, readonly) NSArray *myTalkingGroupsInfoArray;

// refresh my talking groups
- (void)refreshMyTalkingGroups;

@end
