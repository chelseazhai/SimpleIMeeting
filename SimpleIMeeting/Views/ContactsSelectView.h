//
//  ContactsSelectView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewTalkingGroupProtocol.h"

@class ContactListView;
@class SelectedContactsView;

@interface ContactsSelectView : UIView <NewTalkingGroupProtocol> {
    // ready for adding selected contact for inviting to the new talking group
    BOOL _mReady4AddingSelectedContact4Inviting;
    
    // present subviews
    // subview addressbook contact list view
    ContactListView *_mABContactListView;
    // subview selected contacts view
    SelectedContactsView *_mSelectedContactsView;
}

@property (nonatomic, retain) NSArray *inTalkingGroupAttendeesPhoneArray;

@property (nonatomic, readonly) NSMutableArray *preinTalkingGroupContactsInfoArray;

// add contact to selected contacts view
- (void)addContact2SelectedContactsView;

// remove the selected contact from selected contacts view with index
- (void)removeSelectedContactFromSelectedContactsView:(NSInteger)index;

// cancel or finish contacts selecting
- (void)cancel6finishContactsSelecting;

@end
