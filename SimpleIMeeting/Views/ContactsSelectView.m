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
#import "SelectedContactsView.h"

#import "ContactBean+SimpleIMeeting.h"

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
        // test by ares
        _mReady4AddingSelectedContact4Inviting = YES;
        
        // create and init subviews
        // init addressbook contact list view
        _mABContactListView = [[ContactListView alloc] initWithFrame:[self genContactListViewDrawRect]];
        
        // init selected contacts view
        _mSelectedContactsView = [[SelectedContactsView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + FILL_PARENT * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), self.bounds.origin.y, FILL_PARENT * (RIGHTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), FILL_PARENT)];
        
//        // hidden first
//        _mSelectedContactsView.hidden = YES;
        
        // add addressBook contact list view and selected contacts view as subviews of contacts select view
        [self addSubview:_mABContactListView];
        [self addSubview:_mSelectedContactsView];
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
    if (0 < [_mSelectedContactsView.inTalkingGroupAttendeesPhoneArray count]) {
        [_mSelectedContactsView.inTalkingGroupAttendeesPhoneArray removeAllObjects];
    }
    
    // set new in talking group attendees phone array if not nil
    if (nil != inTalkingGroupAttendeesPhoneArray) {
        [_mSelectedContactsView.inTalkingGroupAttendeesPhoneArray addObjectsFromArray:inTalkingGroupAttendeesPhoneArray];
    }
}

- (NSArray *)inTalkingGroupAttendeesPhoneArray{
    return _mSelectedContactsView.inTalkingGroupAttendeesPhoneArray;
}

- (NSMutableArray *)preinTalkingGroupContactsInfoArray{
    return _mSelectedContactsView.preinTalkingGroupContactsInfoArray;
}

- (void)addContact2SelectedContactsView{
    // add contact to in or prein talking group contacts table view prein talking group section
    [_mSelectedContactsView addContact2PreinTalkingGroupSection];
}

- (void)removeSelectedContactFromSelectedContactsView:(NSInteger)index{
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
    
    // remove the selected contact from in or prein talking group contacts table view prein talking group section
    [_mSelectedContactsView removeSelectedContactFromPreinTalkingGroupSection:index];
}

- (void)cancel6finishContactsSelecting{
    // clear in talking group attendees phone array and prein talking group contacts info array if needed
    if (0 < [self.inTalkingGroupAttendeesPhoneArray count]) {
        [self setInTalkingGroupAttendeesPhoneArray:nil];
    }
    while (0 < [self.preinTalkingGroupContactsInfoArray count]) {
        // remove each contact extension dictionary and contact from prein talking group contacts info array
        // get the will be removed prein talking group contact index
        NSInteger _index = [self.preinTalkingGroupContactsInfoArray count] - 1;
        
        [((ContactBean *)[self.preinTalkingGroupContactsInfoArray objectAtIndex:_index]).extensionDic removeAllObjects];
        
        // test by ares
        NSLog(@"%d", _index);
        [self.preinTalkingGroupContactsInfoArray removeObjectAtIndex:_index];
        //[self removeSelectedContactFromSelectedContactsView:_index];
    }
}

// inner extension
- (CGRect)genContactListViewDrawRect{
    CGRect _contactListViewDrawRectangle = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 0.0, FILL_PARENT);
    
    // check is ready for adding selected contact for inviting to the new talking group and update contact list view draw rectangle width
    if (_mReady4AddingSelectedContact4Inviting) {
        _contactListViewDrawRectangle.size.width = FILL_PARENT * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT);
    }
    else {
        _contactListViewDrawRectangle.size.width = FILL_PARENT;
    }
    
    return _contactListViewDrawRectangle;
}

@end
