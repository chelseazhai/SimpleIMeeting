//
//  ContactListView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

@interface ContactListView : UIView <UITableViewDataSource, UITableViewDelegate, AddressBookChangedDelegate> {
    // present subviews
    // subview contact operate view
    // contact search text field
    UITextField *_mContactSearchTextField;
    
    // subview contact list table view
    UITableView *_mABContactListTableView;
}

@end
