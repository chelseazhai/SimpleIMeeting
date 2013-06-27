//
//  SimpleIMeetingContentContainerView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

#import "NewTalkingGroupProtocol.h"

@class ContactsSelectView;
@class MyTalkingGroups7AttendeesView;

// simple imeeting content view mode
typedef NS_ENUM(NSInteger, SIMContentViewMode) {
    // adress book contacts and my talking groups
    ADDRESSBOOKCONTACTS,
    MYTALKINGGROUPS
};




@interface SimpleIMeetingContentContainerView : UIView <UIViewGestureRecognizerDelegate> {
    // tap to generate new talking group title view
    UILabel *_mTap2GenNewTalkingGroupTitleView;
    
    // my talking groups and contacts select bar button item
    UIBarButtonItem *_mMyTalkingGroupsBarBtnItem;
    UIBarButtonItem *_mContactsSelectBarBtnItem;
    
    // back to my talking groups and selected talking group attendees or contacts select content view bar button item
    UIBarButtonItem *_mBack2MyTalkingGroups7Attendees6ContactsSelectContentViewBarBtnItem;
    
    // content view type
    SIMContentViewMode _mContentViewType;
    
    // new talking group protocol implementation
    id<NewTalkingGroupProtocol> _mNewTalkingGroupProtocolImpl;
    
    // content present subviews
    // subview contacts select view
    ContactsSelectView *_mContactsSelectContentView;
    // subview my talking group and attendee list
    MyTalkingGroups7AttendeesView *_mMyTalkingGroups7AttendeesContentView;
}

// tap to generate new talking group
- (void)tap2GenerateNewTalkingGroup;

// switch to contacts select content view for adding selected contact for inviting to talking group
- (void)switch2ContactsSelectContentView4AddingSelectedContact4Inviting;

// back to my talking groups and selected talking group attendees content view for ending add selected contact for inviting to talking group
- (void)back2MyTalkingGroups7AttendeesContentView4EndingAddSelectedContact4Inviting;

// set my talking groups need to refresh
- (void)setMyTalkingGroupsNeed2Refresh;

@end
