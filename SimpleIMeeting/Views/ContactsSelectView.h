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
    // present subviews
    // subview addressbook contacts view
    ContactListView *_mABContactListView;
    // subview selected contacts view
    SelectedContactsView *_mSelectedContactsView;
}

@end
