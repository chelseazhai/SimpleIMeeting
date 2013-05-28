//
//  ContactsListView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ContactsListView.h"

#import "SimpleIMeetingTableViewTipView.h"

@implementation ContactsListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init contacts list head tip view
        SimpleIMeetingTableViewTipView *_contactsListHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:LeftAlign_TipView andParentView:self];
        
        // set contacts list head tip view text
        [_contactsListHeadTipView setTipViewText:NSLocalizedString(@"contacts select contacts list head tip view text", nil)];
        
        // init addressbook contacts list table view
        _mABContactsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _contactsListHeadTipView.height, self.bounds.size.width, self.bounds.size.height - _contactsListHeadTipView.height)];
        
        // add contacts list head tip view and contacts list table view as subviews
        [self addSubview:_contactsListHeadTipView];
        [self addSubview:_mABContactsListTableView];
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
