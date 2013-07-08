//
//  ContactListView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ContactListView.h"

#import "SimpleIMeetingTableViewTipView.h"

#import "ABContactListTableViewCell.h"

#import "ContactsSelectView.h"

#import "SimpleIMeetingContentContainerView.h"

#import "ContactBean+ContactsSelect.h"

// contact operate view height
#define CONTACTOPERATEVIEW_HEIGHT   38.0

// contact operate view margin and padding
#define CONTACTOPERATEVIEW_MATGIN7PADDING   4.0

// contact search text field text font size
#define CONTACTSEARCHTEXTFIELDTEXTFONTSIZE  14.0

// search image view width, height and right margin
#define SEARCHIMAGEVIEW_WIDTH7HEIGHT    24.0
#define SEARCHIMAGEVIEW_MARGINRIGHT 4.0

// add temp added contact button width
#define ADDTEMPADDEDCONTACTBUTTON_WIDTH 38.0

// phonetics indication string
#define PHONETICSINDIACATION_STRING  @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"

@interface ContactListView ()

// contact search user input text field text did changed
- (void)contactSearchTextDidChanged;

// set it is ready for adding selected contact for inviting to talking group
- (void)setReady4AddingSelectedContact4Inviting2TalkingGroup:(UIResponder *)responder;

// add temp added contact button on clicked
- (void)addTempAddedContactButtonOnClicked:(UIButton *)tempAddedContactButton;

// add the selected contact with the selected phone number to in and prein talking group contact list table view prein talking group section
- (void)addSelectedContact2PreinTalkingGroupSection:(ContactBean *)selectedContact andSelectedPhone:(NSString *)selectedPhoneNumber;

// selected contact phone numbers select action sheet button clicked event selector
- (void)selectedContactPhonesSelectActionSheet:(UIActionSheet *)pActionSheet clickedButtonAtIndex:(NSInteger)pButtonIndex;

@end


// contact operate view
@interface ContactOperateView : UIView

@end


@implementation ContactListView

@synthesize allContactsInfoArrayInABRef = _mAllContactsInfoArrayInABRef;

@synthesize presentContactsInfoArrayRef = _mPresentContactsInfoArrayRef;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background image
        self.backgroundImg = [UIImage compatibleImageNamed:@"img_contactlistview_bg"];
        
        // create and init subviews
        // init contact list head tip view
        SimpleIMeetingTableViewTipView *_contactListHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:LeftAlign_TipView andParentView:self];
        
        // set contact list head tip view text
        [_contactListHeadTipView setTipViewText:NSLocalizedString(@"contacts select contact list head tip view text", nil)];
        
        // init contact operate view
        ContactOperateView *_contactOperateView = [[ContactOperateView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _contactListHeadTipView.height, FILL_PARENT, CONTACTOPERATEVIEW_HEIGHT)];
        
        // init contact search text field
        _mContactSearchTextField = [_mContactSearchTextField = [UITextField alloc] initWithFrame:CGRectMakeWithFormat(_mContactSearchTextField, [NSNumber numberWithFloat:_contactOperateView.bounds.origin.x + CONTACTOPERATEVIEW_MATGIN7PADDING], [NSNumber numberWithFloat:_contactOperateView.bounds.origin.y + CONTACTOPERATEVIEW_MATGIN7PADDING], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d-%d-%d", FILL_PARENT_STRING, (int)CONTACTOPERATEVIEW_MATGIN7PADDING, (int)CONTACTOPERATEVIEW_MATGIN7PADDING, (int)ADDTEMPADDEDCONTACTBUTTON_WIDTH] cStringUsingEncoding:NSUTF8StringEncoding]], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d", FILL_PARENT_STRING, (int)CONTACTOPERATEVIEW_MATGIN7PADDING] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // set contact search text field border style, content vertical alignment, return key, clear button, keyboard type, text font and placeholder
        _mContactSearchTextField.borderStyle = UITextBorderStyleRoundedRect;
        _mContactSearchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _mContactSearchTextField.returnKeyType = UIReturnKeySearch;
        _mContactSearchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _mContactSearchTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _mContactSearchTextField.font = [UIFont systemFontOfSize:CONTACTSEARCHTEXTFIELDTEXTFONTSIZE];
        _mContactSearchTextField.placeholder = NSLocalizedString(@"contact search text field placeholder", nil);
        
        // define search image view as contact search text field left view and show always
        UIImageView *_searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_contactsearchtextfield_search"]];
        
        // set its frame
        [_searchImageView setFrame:CGRectMake(CGPointZero.x, CGPointZero.y, SEARCHIMAGEVIEW_WIDTH7HEIGHT + SEARCHIMAGEVIEW_MARGINRIGHT, SEARCHIMAGEVIEW_WIDTH7HEIGHT)];
        
        // set content mode
        _searchImageView.contentMode = UIViewContentModeLeft;
        
        // set as contact search text field left view and show always
        _mContactSearchTextField.leftView = _searchImageView;
        _mContactSearchTextField.leftViewMode = UITextFieldViewModeAlways;
        
        // set contact search text field delegate
        _mContactSearchTextField.delegate = self;
        
        // add contact search text field text did changed notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactSearchTextDidChanged) name:UITextFieldTextDidChangeNotification object:_mContactSearchTextField];
        
        // init add temp added contact button
        UIButton *_addTempAddedContactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        [_addTempAddedContactButton setFrame:CGRectMakeWithFormat(_addTempAddedContactButton, [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d", FILL_PARENT_STRING, (int)CONTACTOPERATEVIEW_MATGIN7PADDING, (int)ADDTEMPADDEDCONTACTBUTTON_WIDTH] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:_contactOperateView.bounds.origin.y + CONTACTOPERATEVIEW_MATGIN7PADDING], [NSNumber numberWithFloat:ADDTEMPADDEDCONTACTBUTTON_WIDTH], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d", FILL_PARENT_STRING, (int)CONTACTOPERATEVIEW_MATGIN7PADDING] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // set background image for normal state
        [_addTempAddedContactButton setBackgroundImage:[UIImage imageNamed:@"img_addtempaddedcontactbutton_bg"] forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_addTempAddedContactButton addTarget:self action:@selector(addTempAddedContactButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // add contact search text field and add temp added contact button as subviews of contact operate view
        [_contactOperateView addSubview:_mContactSearchTextField];
        [_contactOperateView addSubview:_addTempAddedContactButton];
        
        // init addressbook contact list table view
        _mABContactListTableView = [_mABContactListTableView = [UITableView alloc] initWithFrame:CGRectMakeWithFormat(_mABContactListTableView, [NSNumber numberWithFloat:self.bounds.origin.x], [NSNumber numberWithFloat:self.bounds.origin.y + _contactListHeadTipView.height + CONTACTOPERATEVIEW_HEIGHT], [NSNumber numberWithFloat:FILL_PARENT], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d-%d", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)_contactListHeadTipView.height, (int)CONTACTOPERATEVIEW_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // set its background color
        _mABContactListTableView.backgroundColor = [UIColor clearColor];
        
        // set separator style UITableViewCellSeparatorStyleNone
        //_mABContactListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // get all contacts info array from addressBook
        _mAllContactsInfoArrayInABRef = _mPresentContactsInfoArrayRef = [[AddressBookManager shareAddressBookManager].allContactsInfoArray optPhoneticsSortedContactsInfoArray];
        
        // set contact list table view dataSource and delegate
        _mABContactListTableView.dataSource = self;
        _mABContactListTableView.delegate = self;
        
        // add addressBook changed observer
        [[AddressBookManager shareAddressBookManager] addABChangedObserver:self];
        
        // add contact list head tip view, contact operate view and contact list table view as subviews of contact list view
        [self addSubview:_contactListHeadTipView];
        [self addSubview:_contactOperateView];
        [self addSubview:_mABContactListTableView];
        
        // set contact list view all subviews auto resizing mask
        for (int _index = 0; _index < [self.subviews count]; _index++) {
            ((UIView *)[self.subviews objectAtIndex:_index]).autoresizingMask = UIViewAutoresizingFlexibleWidth;
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)recoverSelectedContactCellIsSelectedFlag:(NSInteger)index{
    // recover the cell contact is selected flag
    ((ABContactListTableViewCell *)[_mABContactListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]]).contactIsSelectedFlag = NO;
}

- (void)clearContactSearchTextFieldText7SelectedABContactCellIndex{
    // check contact search text field text
    if (![@"" isEqualToString:_mContactSearchTextField.text]) {
        // clear contact search text field text
        _mContactSearchTextField.text = @"";
        
        // notify contact search text did changed
        [self contactSearchTextDidChanged];
    }
    else {
        // check selected address book contact cell index
        if (nil != _mSelectedABContactCellIndex) {
            // clear selected address book contact cell background color
            [_mABContactListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_mSelectedABContactCellIndex.integerValue inSection:0]].backgroundColor = [UIColor clearColor];
        }
    }
    
    // clear selected address book contact cell index
    _mSelectedABContactCellIndex = nil;
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [_mPresentContactsInfoArrayRef count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Address book contact cell";
    
    // get address book contact list table view cell
    ABContactListTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[ABContactListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    // get contact bean
    ContactBean *_contactBean = [_mPresentContactsInfoArrayRef objectAtIndex:indexPath.row];
    
    // set cell attributes
    _cell.contactIsSelectedFlag = _contactBean.isSelected;
    _cell.displayName = _contactBean.displayName;
    _cell.fullNames = _contactBean.fullNames;
    _cell.phoneNumbersArray = _contactBean.phoneNumbers;
    _cell.phoneNumberMatchingIndexs = [_contactBean.extensionDic objectForKey:PHONENUMBER_MATCHING_INDEXS];
    _cell.nameMatchingIndexs = [_contactBean.extensionDic objectForKey:NAME_MATCHING_INDEXS];
    
    return _cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    // define phonetics indication string array
    NSMutableSet *_indices = [[NSMutableSet alloc] init];
    
    // process present contacts info array
    for (ContactBean *_contact in _mPresentContactsInfoArrayRef) {
        // contact has name
        if ([_contact.namePhonetics count] > 0) {
            [_indices addObject:[[[[_contact.namePhonetics objectAtIndex:0] objectAtIndex:0] substringToIndex:1] uppercaseString]];
        }
        // contact has no name
        else {
            [_indices addObject:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]];
        }
    }
    
    return [[_indices allObjects] sortedArrayUsingComparator:^(NSString *_string1, NSString *_string2){
        NSComparisonResult _stringComparisonResult = NSOrderedSame;
        
        // compare
        if ([_string1 isEqualToString:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]]) {
            _stringComparisonResult = NSOrderedDescending;
        }
        else if ([_string2 isEqualToString:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]]) {
            _stringComparisonResult = NSOrderedAscending;
        }
        else {
            _stringComparisonResult = [_string1 compare:_string2];
        }
        
        return _stringComparisonResult;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    // process procent contacts info array
    for (NSInteger _index = 0; _index < [_mPresentContactsInfoArrayRef count]; _index++) {
        // 26 chars, 'ABCD...XYZ'
        if (![[title lowercaseString] isEqualToString:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]]) {
            // contact has name
            if ([((ContactBean *)[_mPresentContactsInfoArrayRef objectAtIndex:_index]).namePhonetics count] > 0) {
                // get the matching contacts header
                if ([[[[((ContactBean *)[_mPresentContactsInfoArrayRef objectAtIndex:_index]).namePhonetics objectAtIndex:0] objectAtIndex:0] substringToIndex:1] compare:[title lowercaseString]] >= NSOrderedSame) {
                    // scroll to row at indexPath
                    [_mABContactListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    
                    break;
                }
            }
            // contact has no name
            else {
                // scroll to row at indexPath
                [_mABContactListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                break;
            }
        }
        // '#'
        else {
            // contact has no name
            if ([((ContactBean *)[_mPresentContactsInfoArrayRef objectAtIndex:_index]).namePhonetics count] == 0) {
                // scroll to row at indexPath
                [_mABContactListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                break;
            }
        }
    }
    
    // default value
    return -1;
}

// UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return the height for row at indexPath.
    return [ABContactListTableViewCell cellHeightWithContact:[_mPresentContactsInfoArrayRef objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // get parent view: contacts select view
    ContactsSelectView *_contactsSelectView = (ContactsSelectView *)self.superview;
    
    // set it is ready for adding selected contact for inviting to talking group
    [self setReady4AddingSelectedContact4Inviting2TalkingGroup:[tableView cellForRowAtIndexPath:indexPath]];
    
    // save selected cell index
    _mSelectedABContactCellIndex = [NSNumber numberWithInteger:indexPath.row];
    
    // get the selected contact contactBean
    ContactBean *_selectedContactBean = [_mPresentContactsInfoArrayRef objectAtIndex:indexPath.row];
    
    // check the selected contact if or not existed in prein talking group contacts info array which are in in and prein talking group contact list table view prein talking group section
    if ([_contactsSelectView.preinTalkingGroupContactsInfoArray containsObject:_selectedContactBean]) {
        // the selected contact existed in prein talking group contacts info array which are in in and prein talking group contact list table view prein talking group section, remove it
        for (NSInteger _index = 0; _index < [_contactsSelectView.preinTalkingGroupContactsInfoArray count]; _index++) {
            // compare contact id in present contacts info array with each contact which in prein talking group contacts info array
            if (((ContactBean *)[_contactsSelectView.preinTalkingGroupContactsInfoArray objectAtIndex:_index]).id == _selectedContactBean.id) {
                // remove the selected contact from selected contact list view
                [_contactsSelectView removeSelectedContactFromSelectedContactListView:_index];
                
                break;
            }
        }
    }
    else {
        // check selected contact phone number array
        if (!_selectedContactBean.phoneNumbers || 0 == [_selectedContactBean.phoneNumbers count]) {
            // show contact has no phone number alertView
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"contact has no phone number alertView title", nil) message:_selectedContactBean.displayName delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"contact has no phone number alertView reselect button title", nil), nil] show];
        }
        else if (1 == [_selectedContactBean.phoneNumbers count]) {
            // add the selected contact with his phone number to in and prein talking group contact list table view prein talking group section
            [self addSelectedContact2PreinTalkingGroupSection:_selectedContactBean andSelectedPhone:[_selectedContactBean.phoneNumbers objectAtIndex:0]];
        }
        else {
            // init the selected contact phones select action sheet and show it
            UIActionSheet *_selectedContactPhonesSelectActionSheet = [[UIActionSheet alloc] initWithContent:_selectedContactBean.phoneNumbers andTitleFormat:NSLocalizedString(@"contact phone numbers select actionSheet title format", nil), _selectedContactBean.displayName];
            
            // set actionSheet processor and button clicked event selector
            _selectedContactPhonesSelectActionSheet.processor = self;
            _selectedContactPhonesSelectActionSheet.buttonClickedEventSelector = @selector(selectedContactPhonesSelectActionSheet:clickedButtonAtIndex:);
            
            // show the selected contact phones select action sheet
            [_selectedContactPhonesSelectActionSheet showInView:tableView];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // dismiss soft input keyboard
    [_mContactSearchTextField resignFirstResponder];
}

// UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // dismiss soft input keyboard
    [_mContactSearchTextField resignFirstResponder];
    
    return YES;
}

// AddressBookChangedDelegate
- (void)addressBookChanged:(ABAddressBookRef)pAddressBook info:(NSDictionary *)pInfo observer:(id)pObserver{
//    // reset all contacts info array from address book and present contacts info array of addressBook contacts list table view
//    NSArray *_newAllContactsInfoArrayInAB = [[AddressBookManager shareAddressBookManager].allContactsInfoArray optPhoneticsSortedContactsInfoArray];
//    
//    // process changed contact id array
//    for (NSNumber *_contactId in [pInfo allKeys]) {
//        // get action
//        switch (((NSNumber *)[[pInfo objectForKey:_contactId] objectForKey:CONTACT_ACTION]).intValue) {
//            case contactAdd:
//            {
//                // add to all contacts info array in addressBook reference
//                for (NSInteger _index = 0; _index < [_newAllContactsInfoArrayInAB count]; _index++) {
//                    if (((ContactBean *)[_newAllContactsInfoArrayInAB objectAtIndex:_index]).id == _contactId.integerValue) {
//                        [_mAllContactsInfoArrayInABRef insertObject:[_newAllContactsInfoArrayInAB objectAtIndex:_index] atIndex:_index];
//                        
//                        [self searchBar:_mContactSearchBar textDidChange:_mContactSearchBar.text];
//                        
//                        break;
//                    }
//                }
//            }
//                break;
//                
//            case contactModify:
//            {
//                // save the modify contact index of all contacts info array in addressBook reference and new temp all contacts info array in addressBook
//                NSInteger _oldindex = 0, _newIndex = 0;
//                for (NSInteger _index = 0; _index < [_mAllContactsInfoArrayInABRef count]; _index++) {
//                    if (((ContactBean *)[_mAllContactsInfoArrayInABRef objectAtIndex:_index]).id == _contactId.integerValue) {
//                        _oldindex = _index;
//                        
//                        _newIndex = [_newAllContactsInfoArrayInAB indexOfObject:[_mAllContactsInfoArrayInABRef objectAtIndex:_index]];
//                        
//                        break;
//                    }
//                }
//                
//                // check the two indexes
//                if (_oldindex != _newIndex) {
//                    [_mAllContactsInfoArrayInABRef removeObjectAtIndex:_oldindex];
//                    [_mAllContactsInfoArrayInABRef insertObject:[_newAllContactsInfoArrayInAB objectAtIndex:_newIndex] atIndex:_newIndex];
//                }
//                
//                [self searchBar:_mContactSearchBar textDidChange:_mContactSearchBar.text];
//            }
//                break;
//                
//            case contactDelete:
//            {
//                // delete from all contacts info array in addressBook reference
//                for (NSInteger _index = 0; _index < [_mAllContactsInfoArrayInABRef count]; _index++) {
//                    if (((ContactBean *)[_mAllContactsInfoArrayInABRef objectAtIndex:_index]).id == _contactId.integerValue) {
//                        [_mAllContactsInfoArrayInABRef removeObjectAtIndex:_index];
//                        
//                        [self searchBar:_mContactSearchBar textDidChange:_mContactSearchBar.text];
//                        
//                        break;
//                    }
//                }
//            }
//                break;
//        }
//    }
}

// inner extension
- (void)contactSearchTextDidChanged{
    // get contact search text field user input text
    NSString *_searchText = _mContactSearchTextField.text;
    
    // check search parameter, check if or not nil or empty string
    if (nil == _searchText || [@"" isEqualToString:_searchText]) {
        // reset contact matching index array
        for (ContactBean *_contact in _mAllContactsInfoArrayInABRef) {
            [_contact.extensionDic removeObjectForKey:PHONENUMBER_MATCHING_INDEXS];
            [_contact.extensionDic removeObjectForKey:NAME_MATCHING_INDEXS];
        }
        
        // show all contacts in addressBook
        _mPresentContactsInfoArrayRef = _mAllContactsInfoArrayInABRef;
    }
    else {
        // define temp array
        NSArray *_tmpArray = nil;
        
        // check search parameter again, check if or not contains none numeric character
        BOOL _isNumeric;
        if ((_isNumeric = [_searchText isMatchedByRegex:@"^[0-9]+$"])) {
            // search by phone number
            _tmpArray = [[AddressBookManager shareAddressBookManager] getContactByPhoneNumber:_searchText];
        }
        else {
            // search by name
            _tmpArray = [[AddressBookManager shareAddressBookManager] getContactByName:_searchText];
        }
        
        // define searched contacts array
        NSMutableArray *_searchedContactsArray = [[NSMutableArray alloc] initWithCapacity:[_tmpArray count]];
        
        // compare seached contacts temp array contact with all contacts info array in addressBook contact
        for (ContactBean *_searchedContact in _tmpArray) {
            for (ContactBean *_contact in _mAllContactsInfoArrayInABRef) {
                // if the two contacts id is equal, add it to searched contacts array
                if (_contact.id == _searchedContact.id) {
                    [_searchedContactsArray addObject:_searchedContact];
                    
                    // check the search text is numeric and reset searched contact matching index array
                    if (_isNumeric) {
                        // remove name matching indexs
                        [_contact.extensionDic removeObjectForKey:NAME_MATCHING_INDEXS];
                    }
                    else {
                        // remove phone number matching indexs
                        [_contact.extensionDic removeObjectForKey:PHONENUMBER_MATCHING_INDEXS];
                    }
                    
                    break;
                }
            }
        }
        
        // set addressBook contact list view present contacts info array
        _mPresentContactsInfoArrayRef = _searchedContactsArray;
    }
    
    // reload addressBook contact list table view data
    [_mABContactListTableView reloadData];
}

- (void)setReady4AddingSelectedContact4Inviting2TalkingGroup:(UIResponder *)responder{
    // get parent view: contacts select view
    ContactsSelectView *_contactsSelectView = (ContactsSelectView *)self.superview;
    
    // compare self and parent view width and set it is ready for adding selected contact for inviting to talking group if needed
    if (self.frame.size.width == _contactsSelectView.frame.size.width) {
        [(SimpleIMeetingContentContainerView *)_contactsSelectView.superview generateTalkingGroup:responder];
    }
}

- (void)addTempAddedContactButtonOnClicked:(UIButton *)tempAddedContactButton{
    // add temp added contact to selected contact list view
    [(ContactsSelectView *)self.superview addTempAddedContact2SelectedContactListView:^(ContactBean * tempAddedContact) {
        // get the temp added contact index of present contacts info array
        _mSelectedABContactCellIndex = [NSNumber numberWithUnsignedInteger:[_mPresentContactsInfoArrayRef indexOfObject:tempAddedContact]];
        
        // add selected contact to prein talking group section
        [self addSelectedContact2PreinTalkingGroupSection:tempAddedContact andSelectedPhone:tempAddedContact.selectedPhoneNumber];
        
        // set it is ready for adding selected contact for inviting to talking group
        [self setReady4AddingSelectedContact4Inviting2TalkingGroup:tempAddedContactButton];
    }];
}

- (void)addSelectedContact2PreinTalkingGroupSection:(ContactBean *)selectedContact andSelectedPhone:(NSString *)selectedPhoneNumber{
    // get parent view: contacts select view
    ContactsSelectView *_contactsSelectView = (ContactsSelectView *)self.superview;
    
    // check the selected contact the selected phone number if or not existed in talking group phone array which are in in and prein talking group contact list table view in talking group section
    if (![_contactsSelectView.inTalkingGroupAttendeesPhoneArray containsObject:selectedPhoneNumber]) {
        // the selected contact the selected phone number not existed in talking group phone array which are in in and prein talking group contact list table view in talking group section
        // update selected address book contact list table view cell contact is selected flag
        ((ABContactListTableViewCell *)[_mABContactListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_mSelectedABContactCellIndex.integerValue inSection:0]]).contactIsSelectedFlag = YES;
        
        // set the selected contact selected flag image and phone number
        selectedContact.isSelected = YES;
        selectedContact.selectedPhoneNumber = selectedPhoneNumber;
        
        // add the selected contact to prein talking group contacts info array
        [_contactsSelectView.preinTalkingGroupContactsInfoArray addObject:selectedContact];
        
        // add the selected contact to selected contact list view
        [_contactsSelectView addContact2SelectedContactListView];
    }
    else {
        NSLog(@"Warning: the selected contact = %@ with the selected phone number = %@ had existed in the talking group attendees, mustn't add twice", selectedContact, selectedPhoneNumber);
        
        // show toast
        [[iToast makeText:[NSString stringWithFormat:@"%@%@", selectedContact.displayName, NSToastLocalizedString(@"toast selected contact existed in talking group attendees", nil)]] show:iToastTypeWarning];
    }
}

- (void)selectedContactPhonesSelectActionSheet:(UIActionSheet *)pActionSheet clickedButtonAtIndex:(NSInteger)pButtonIndex{
    // add the selected contact with the selected phone number to in and prein talking group contact list table view prein talking group section
    [self addSelectedContact2PreinTalkingGroupSection:[_mPresentContactsInfoArrayRef objectAtIndex:_mSelectedABContactCellIndex.integerValue] andSelectedPhone:[pActionSheet buttonTitleAtIndex:pButtonIndex]];
}

@end


@implementation ContactOperateView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)layoutSubviews{
    // get the last subview button
    UIButton *_lastSubviewButton = [[self subviews] objectAtIndex:[[self subviews] count] - 1];
    
    // compare its origin x and width size sum with contact operate view size width
    if (_lastSubviewButton.frame.origin.x + _lastSubviewButton.frame.size.width + CONTACTOPERATEVIEW_MATGIN7PADDING != self.frame.size.width) {
        // get the D-value
        float _dValue = self.frame.size.width - (_lastSubviewButton.frame.origin.x + _lastSubviewButton.frame.size.width + CONTACTOPERATEVIEW_MATGIN7PADDING);
        
        // update subview button center
        _lastSubviewButton.center = CGPointMake(_lastSubviewButton.center.x + _dValue, _lastSubviewButton.center.y);
        
        // get the other subview(the first) textField
        UITextField *_firstSubviewTextField = [[self subviews] objectAtIndex:0];
        
        // update its frame
        _firstSubviewTextField.frame = CGRectMake(_firstSubviewTextField.frame.origin.x, _firstSubviewTextField.frame.origin.y, _firstSubviewTextField.frame.size.width + _dValue, _firstSubviewTextField.frame.size.height);
    }
}

@end
