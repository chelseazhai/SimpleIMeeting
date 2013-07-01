//
//  ContactsSelectView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewTalkingGroupProtocol.h"

#import <CommonToolkit/CommonToolkit.h>

@class ContactListView;
@class SelectedContactListView;

@interface ContactsSelectView : UIView <NewTalkingGroupProtocol> {
    // ready for adding selected contact for inviting to the new talking group
    BOOL _mReady4AddingSelectedContact4Inviting;
    
    // new or selected contacts adding talking group id
    NSString *_mNew6SelectedContactsAddingTalkingGroupId;
    
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

// add contact to selected contact list view
- (void)addContact2SelectedContactListView;

// remove the selected contact from selected contact list view with index
- (void)removeSelectedContactFromSelectedContactListView:(NSInteger)index;

// show new talking group started time select view with talking group id
- (void)showNewTalkingGroupStartedTimeSelectView:(NSString *)newTalkingGroupId;

// cancel or finish contacts selecting
- (void)cancel6finishContactsSelecting;

@end
