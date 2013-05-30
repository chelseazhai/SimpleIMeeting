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

@implementation ContactsSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init addressbook contact list view
        _mABContactListView = [[ContactListView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT)];
        // init selected contacts view
        _mSelectedContactsView = [[SelectedContactsView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + _mABContactListView.bounds.size.width, self.bounds.origin.y, FILL_PARENT / 3.0, FILL_PARENT)];
        
        // add addressBook contact list view as subview
        [self addSubview:_mABContactListView];
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

@end
