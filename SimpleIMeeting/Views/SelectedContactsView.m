//
//  SelectedContactsView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SelectedContactsView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "SimpleIMeetingTableViewTipView.h"

@implementation SelectedContactsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init selected contacts head tip view
        SimpleIMeetingTableViewTipView *_selectedContactsHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:RightAlign_TipView andParentView:self];
        
        // set selected contacts head tip view text
        [_selectedContactsHeadTipView setTipViewText:NSLocalizedString(@"contacts select selected contacts head tip view text", nil)];
        
        // init selected contacts table view
        _mSelectedContactsTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _selectedContactsHeadTipView.height, FILL_PARENT, FILL_PARENT - (self.bounds.origin.y + _selectedContactsHeadTipView.height))];
        
        // add selected contacts head tip view and selected contacts table view as subviews
        [self addSubview:_selectedContactsHeadTipView];
        [self addSubview:_mSelectedContactsTableView];
        
        // test
        self.backgroundColor = [UIColor redColor];
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
    NSLog(@"SelectedContactsView self frame = %@", NSStringFromCGRect(self.frame));
}

@end
