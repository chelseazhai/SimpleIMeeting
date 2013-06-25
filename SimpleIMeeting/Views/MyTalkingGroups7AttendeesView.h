//
//  MyTalkingGroups7AttendeesView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewTalkingGroupProtocol.h"

@class MyTalkingGroupListView;
@class SelectedTalkingGroupAttendeeListView;

@interface MyTalkingGroups7AttendeesView : UIView <NewTalkingGroupProtocol> {
    // my talking group list table view need to refresh
    BOOL _mMyTalkingGroupNeed2Refresh;
    
    // there is one talking group be selected
    BOOL _mOneTalkingGroupBeSelected;
    
    // present subviews
    // subview no talking group tip label
    UILabel *_mNoTalkingGroupTipLabel;
    // subview my talking group list view
    MyTalkingGroupListView *_mMyTalkingGroupListView;
    // selected talking group attendee list view
    SelectedTalkingGroupAttendeeListView *_mSelectedTalkingGroupAttendeeListView;
}

// my talking groups info array
@property (nonatomic, readonly) NSArray *myTalkingGroupsInfoArray;

@property (nonatomic, assign) BOOL myTalkingGroupNeed2Refresh;

@end
