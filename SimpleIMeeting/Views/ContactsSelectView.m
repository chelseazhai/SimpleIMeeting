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

- (void)removeContactFromPreinTalkingGroupSection:(NSInteger)index{
    //
}

- (void)cancel6finishContactsSelecting{
    // clear in talking group attendees phone array and prein talking group contacts info array if needed
    if (0 < [_mSelectedContactsView.inTalkingGroupAttendeesPhoneArray count]) {
        [_mSelectedContactsView.inTalkingGroupAttendeesPhoneArray removeAllObjects];
    }
    if (0 < [_mSelectedContactsView.preinTalkingGroupContactsInfoArray count]) {
        // remove each contact extension dictionary and contact from prein talking group contacts info array
        for (ContactBean *_contact in _mSelectedContactsView.preinTalkingGroupContactsInfoArray) {
            [_contact.extensionDic removeAllObjects];
            
            [_mSelectedContactsView.preinTalkingGroupContactsInfoArray removeObject:_contact];
        }
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
