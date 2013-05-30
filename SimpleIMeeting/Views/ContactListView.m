//
//  ContactListView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ContactListView.h"

#import "SimpleIMeetingTableViewTipView.h"

@implementation ContactListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init contact list head tip view
        SimpleIMeetingTableViewTipView *_contactListHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:LeftAlign_TipView andParentView:self];
        
        // set contact list head tip view text
        [_contactListHeadTipView setTipViewText:NSLocalizedString(@"contacts select contact list head tip view text", nil)];
        
        // init addressbook contact list table view
        _mABContactListTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _contactListHeadTipView.height, FILL_PARENT, FILL_PARENT - (self.bounds.origin.y + _contactListHeadTipView.height))];
        
        // add contact list head tip view and contact list table view as subviews
        [self addSubview:_contactListHeadTipView];
        [self addSubview:_mABContactListTableView];
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
