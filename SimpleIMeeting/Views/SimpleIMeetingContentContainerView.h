//
//  SimpleIMeetingContentContainerView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

#import "ITalkingGroupGeneratorProtocol.h"

#import "MyTalkingGroups7AttendeesView.h"

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
    
    // talking group generator protocol implementation
    id<ITalkingGroupGeneratorProtocol> _mTalkingGroupGeneratorProtocolImpl;
    
    // content present subviews
    // subview contacts select view
    ContactsSelectView *_mContactsSelectContentView;
    // subview my talking group and attendee list
    MyTalkingGroups7AttendeesView *_mMyTalkingGroups7AttendeesContentView;
}

// generate talking group with responder
- (void)generateTalkingGroup:(UIResponder *)responder;

// switch to contacts select content view for adding selected contact for inviting to talking group with selected contacts for adding to the talking group id, started time timestamp and added contacts phone array
- (void)switch2ContactsSelectContentView4AddingSelectedContact4Inviting:(NSArray *)selectedContacts4Adding2TalkingGroupId7StartedTimestampAndAddedContactsPhones;

// back to my talking groups and selected talking group attendees content view for ending add selected contact for inviting to talking group
- (void)back2MyTalkingGroups7AttendeesContentView4EndingAddSelectedContact4Inviting:(MyTalkingGroups7AttendeesViewRefreshType)myTalkingGroups7AttendeesViewRefreshType;

// set my talking groups need to refresh
- (void)setMyTalkingGroupsNeed2Refresh;

@end
