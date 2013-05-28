//
//  ContactsSelectView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ContactsSelectView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "ContactsListView.h"
#import "SelectedContactsView.h"

@implementation ContactsSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init addressbook contacts list view
        _mABContactsListView = [[ContactsListView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height)];
        // init selected contacts view
        _mSelectedContactsView = [[SelectedContactsView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + _mABContactsListView.bounds.size.width, self.bounds.origin.y, self.bounds.size.width / 3, self.bounds.size.height)];
        
        // add addressBook contacts list view as subview
        [self addSubview:_mABContactsListView];
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
