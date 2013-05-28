//
//  ContactsListView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

@interface ContactsListView : UIView <UITableViewDataSource, UITableViewDelegate, AddressBookChangedDelegate> {
    // present subviews
    // subview contacts list table view
    UITableView *_mABContactsListTableView;
}

@end
