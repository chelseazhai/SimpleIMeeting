//
//  MyTalkingGroups7AttendeesView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTalkingGroupListView;
@class SelectedTalkingGroupAttendeeListView;

@interface MyTalkingGroups7AttendeesView : UIView {
    // present subviews
    // subview my talking groups view
    MyTalkingGroupListView *_mMyTalkingGroupsView;
    // selected talking group attendees view
    SelectedTalkingGroupAttendeeListView *_mSelectedTalkingGroupAttendeesView;
}

@end
