//
//  ContactListView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

@interface ContactListView : UIView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AddressBookChangedDelegate> {
    // all contacts info array in addressBook reference
    NSMutableArray *_mAllContactsInfoArrayInABRef;
    
    // present contacts info array reference
    NSMutableArray *_mPresentContactsInfoArrayRef;
    
    // selected address book contact cell index
    NSInteger _mSelectedABContactCellIndex;
    
    // present subviews
    // subview contact operate view
    // contact search text field
    UITextField *_mContactSearchTextField;
    
    // subview contact list table view
    UITableView *_mABContactListTableView;
}

@property (nonatomic, readonly) NSArray *allContactsInfoArrayInABRef;

@property (nonatomic, readonly) NSMutableArray *presentContactsInfoArrayRef;

// recover the selected contact which is in present contacts info array cell is selected flag with index
- (void)recoverSelectedContactCellIsSelectedFlag:(NSInteger)index;

// clear contact search text field text and selected address book contact cell index
- (void)clearContactSearchTextFieldText7SelectedABContactCellIndex;

@end
