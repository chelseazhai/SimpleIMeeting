//
//  ContactsSelectView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ContactsSelectView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "ContactListView.h"
#import "SelectedContactListView.h"

#import "ContactBean+ContactsSelect.h"

@interface ContactsSelectView ()

// generate contact list view draw rectangle
- (CGRect)genContactListViewDrawRect;

@end

@implementation ContactsSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init addressbook contact list view
        _mABContactListView = [[ContactListView alloc] initWithFrame:[self genContactListViewDrawRect]];
        
        // init selected contact list view
        _mSelectedContactListView = [[SelectedContactListView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + FILL_PARENT * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), self.bounds.origin.y, FILL_PARENT * (RIGHTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), FILL_PARENT)];
        
        // hidden first
        _mSelectedContactListView.hidden = YES;
        
        // add addressBook contact list view and selected contact list view as subviews of contacts select view
        [self addSubview:_mABContactListView];
        [self addSubview:_mSelectedContactListView];
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

- (void)setInTalkingGroupAttendeesPhoneArray:(NSArray *)inTalkingGroupAttendeesPhoneArray{
    // clear in talking group attendees phone array if needed
    if (0 < [_mSelectedContactListView.inTalkingGroupAttendeesPhoneArray count]) {
        [_mSelectedContactListView.inTalkingGroupAttendeesPhoneArray removeAllObjects];
    }
    
    // set new in talking group attendees phone array if not nil
    if (nil != inTalkingGroupAttendeesPhoneArray) {
        [_mSelectedContactListView.inTalkingGroupAttendeesPhoneArray addObjectsFromArray:inTalkingGroupAttendeesPhoneArray];
    }
}

- (NSArray *)inTalkingGroupAttendeesPhoneArray{
    return _mSelectedContactListView.inTalkingGroupAttendeesPhoneArray;
}

- (NSMutableArray *)preinTalkingGroupContactsInfoArray{
    return _mSelectedContactListView.preinTalkingGroupContactsInfoArray;
}

- (void)addContact2SelectedContactListView{
    // add contact to in or prein talking group contact list table view prein talking group section
    [_mSelectedContactListView addContact2PreinTalkingGroupSection];
}

- (void)removeSelectedContactFromSelectedContactListView:(NSInteger)index{
    // get the selected contact index which is in addressBook contact list table view all contacts info array  and present contacts info array
    NSInteger _indexOfAllContactsInfoArray, _indexOfPresentContactsInfoArray = _indexOfAllContactsInfoArray = -1;
    for (NSInteger _index = 0; _index < [_mABContactListView.allContactsInfoArrayInABRef count]; _index++) {
        // compare contact id which is in addressBook contact list table view all contacts info array with the selected contact id
        if (((ContactBean *)[_mABContactListView.allContactsInfoArrayInABRef objectAtIndex:_index]).id == ((ContactBean *)[self.preinTalkingGroupContactsInfoArray objectAtIndex:index]).id) {
            // update index of all contacts info array
            _indexOfAllContactsInfoArray = _index;
            
            // update index of present contacts info array
            if ([_mABContactListView.presentContactsInfoArrayRef containsObject:[_mABContactListView.allContactsInfoArrayInABRef objectAtIndex:_index]]) {
                _indexOfPresentContactsInfoArray = [_mABContactListView.presentContactsInfoArrayRef indexOfObject:[_mABContactListView.allContactsInfoArrayInABRef objectAtIndex:_index]];
            }
            
            break;
        }
    }
    
    // check index of all contacts info array
    if (0 <= _indexOfAllContactsInfoArray) {
        // check index of present contacts info array
        if (0 <= _indexOfPresentContactsInfoArray) {
            // recover selected address book contact which is in present contacts info array cell is selected flag
            [_mABContactListView recoverSelectedContactCellIsSelectedFlag:_indexOfPresentContactsInfoArray];
        }
        
        // get the selected contact contactBean
        ContactBean *_selectedContactBean = [_mABContactListView.allContactsInfoArrayInABRef objectAtIndex:_indexOfAllContactsInfoArray];
        
        // recover the selected contact is selected flag and selected phone
        _selectedContactBean.isSelected = NO;
        _selectedContactBean.selectedPhoneNumber = @"";
    }
    else {
        NSLog(@"Info: temp added contact, needn't to recover original contact attributes");
    }
    
    // remove the selected contact from prein talking group contacts info array
    [self.preinTalkingGroupContactsInfoArray removeObjectAtIndex:index];
    
    // remove the selected contact from in or prein talking group contact list table view prein talking group section
    [_mSelectedContactListView removeSelectedContactFromPreinTalkingGroupSection:index];
}

- (void)cancel6finishContactsSelecting{
    // clear in talking group attendees phone array if needed
    if (0 < [self.inTalkingGroupAttendeesPhoneArray count]) {
        [self setInTalkingGroupAttendeesPhoneArray:nil];
    }
    
    // clear prein talking group contacts info array if needed
    while (0 < [self.preinTalkingGroupContactsInfoArray count]) {
        // get the will be removed prein talking group contact index
        NSInteger _index = [self.preinTalkingGroupContactsInfoArray count] - 1;
        
        // remove each contact extension dictionary and contact from prein talking group contacts info array
        [((ContactBean *)[self.preinTalkingGroupContactsInfoArray objectAtIndex:_index]).extensionDic removeAllObjects];
        
        // remove selected contact from selected contact list view
        [self removeSelectedContactFromSelectedContactListView:_index];
    }
    
    // clear contact list view contact search text field text and selected address book contact cell index
    [_mABContactListView clearContactSearchTextFieldText7SelectedABContactCellIndex];
}

// NewTalkingGroupProtocol
- (void)generateNewTalkingGroup{
    // set it is ready for adding selected contact for inviting
    _mReady4AddingSelectedContact4Inviting = YES;
    
    // update address book contact list view
    [_mABContactListView setFrame:[self genContactListViewDrawRect]];
    
    // show selected contact list view
    if ([_mSelectedContactListView isHidden]) {
        _mSelectedContactListView.hidden = NO;
    }
}

- (void)cancelGenNewTalkingGroup{
    // set it is not ready for adding selected contact for inviting
    _mReady4AddingSelectedContact4Inviting = NO;
    
    // update address book contact list view
    [_mABContactListView setFrame:[self genContactListViewDrawRect]];
    
    // hide selected contact list view
    if (![_mSelectedContactListView isHidden]) {
        _mSelectedContactListView.hidden = YES;
    }
    
    // cancel contacts selecting
    [self cancel6finishContactsSelecting];
}

// inner extension
- (CGRect)genContactListViewDrawRect{
    CGRect _contactListViewDrawRectangle;
    
    // check address book contact list view if or not init
    if (nil == _mABContactListView) {
        _contactListViewDrawRectangle = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT);
    }
    else {
        // get address book contact list view frame
        _contactListViewDrawRectangle = _mABContactListView.frame;
        
        // check is ready for adding selected contact for inviting to the new talking group and update address book contact list view draw rectangle width
        if (_mReady4AddingSelectedContact4Inviting) {
            // compare address book contact list view frame size width with its parent view frame size width
            if (self.frame.size.width == _mABContactListView.frame.size.width) {
                _contactListViewDrawRectangle.size.width = _mABContactListView.frame.size.width * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT);
            }
        }
        else {
            // recover as parent view frame size width
            _contactListViewDrawRectangle.size.width = self.frame.size.width;
        }
    }
    
    return _contactListViewDrawRectangle;
}

@end
