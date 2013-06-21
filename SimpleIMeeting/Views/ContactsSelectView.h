//
//  ContactsSelectView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactListView;
@class SelectedContactsView;

@interface ContactsSelectView : UIView {
    // ready for adding selected contact for inviting to the new talking group
    BOOL _mReady4AddingSelectedContact4Inviting;
    
    // present subviews
    // subview addressbook contact list view
    ContactListView *_mABContactListView;
    // subview selected contacts view
    SelectedContactsView *_mSelectedContactsView;
}

@end
