//
//  ContactsSelectView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactsListView;
@class SelectedContactsView;

@interface ContactsSelectView : UIView {
    // present subviews
    // subview addressbook contacts view
    ContactsListView *_mABContactsListView;
    // subview selected contacts view
    SelectedContactsView *_mSelectedContactsView;
}

@end
