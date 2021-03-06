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

#import "SocketIO.h"

@class MyTalkingGroupListView;
@class SelectedTalkingGroupAttendeeListView;

// my talking groups and selected talking group attendees view needed to refresh type
typedef NS_ENUM(NSInteger, MyTalkingGroups7AttendeesViewRefreshType){
    NOREFRESH, REFRESH_TALKINGGROUPS, REFRESH_SELECTEDTALKINGGROUP_ATTENDEES
};

@interface MyTalkingGroups7AttendeesView : UIView <ITalkingGroupGeneratorProtocol, SocketIODelegate> {
    // my talking group list table view need to refresh
    BOOL _mMyTalkingGroupsNeed2Refresh;
    
    // my account socket IO and need to reconnect again flag when disconnect or connect error
    SocketIO *_mMyAccountSocketIO;
    BOOL _mMySocketIONeed2Reconnect;
    
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

// reconnect my account soctet IO to notify server
- (void)reconnectMyAccountSoctetIO2NotifyServer;

// stop get my account notice from notify server
- (void)stopGetMyAccountNoticeFromNotifyServer;

// refresh the selected talking group attendees
- (void)refreshSelectedTalkingGroupAttendees;

@end
