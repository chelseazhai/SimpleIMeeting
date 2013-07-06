//
//  ContactsSelectView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ITalkingGroupGeneratorProtocol.h"

#import <CommonToolkit/CommonToolkit.h>

#import "IHttpReqRespProtocol.h"

@class ContactListView;
@class SelectedContactListView;

@interface ContactsSelectView : UIView <ITalkingGroupGeneratorProtocol, IHttpReqRespProtocol> {
    // ready for adding selected contact for inviting to the new talking group
    BOOL _mReady4AddingSelectedContact4Inviting;
    
    // new or selected contacts for adding to the talking group id
    NSString *_mNew6SelectedContacts4Adding2TalkingGroupId;
    
    // selected contacts for adding to the talking group invite note
    NSString *_mSelectedContacts4Adding2TalkingGroupInviteNote;
    
    // new talking group started time select popup window, invite note label and date picker
    UIPopupWindow *_mNewTalkingGroupStartedTimeSelectPopupWindow;
    UILabel *_mNewTalkingGroupInviteNoteLabel;
    UIDatePicker *_mNewTalkingGroupStartedTimeSelectDatePicker;
    
    // present subviews
    // subview addressbook contact list view
    ContactListView *_mABContactListView;
    // subview selected contact list view
    SelectedContactListView *_mSelectedContactListView;
}

// in talking group attendees phone array
@property (nonatomic, retain) NSArray *inTalkingGroupAttendeesPhoneArray;

// prein talking group contacts info array
@property (nonatomic, readonly) NSMutableArray *preinTalkingGroupContactsInfoArray;

// set talking group id and started time timtstamp which is for adding selected contacts to
- (void)setSelectedContacts4Adding2TalkingGroupId:(NSString *)talkingGroupId startedTimestamp:(NSString *)startedTimestamp;

// add contact to selected contact list view
- (void)addContact2SelectedContactListView;

// remove the selected contact from selected contact list view with index
- (void)removeSelectedContactFromSelectedContactListView:(NSInteger)index;

// schedule new talking group
- (void)scheduleNewTalkingGroup;

// send invite sms with recipients and body
- (void)sendInviteSMS:(NSArray *)recipients body:(NSString *)body;

// add more attendees to the talking group
- (void)addMoreAttendees2TalkingGroup;

// cancel or finish contacts selecting
- (void)cancel6finishContactsSelecting;

@end
