//
//  SelectedTalkingGroupAttendeeListView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SelectedTalkingGroupAttendeeListView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "SimpleIMeetingTableViewTipView.h"

#import "SelectedTalkingGroupAttendeeListTableViewCell.h"

@implementation SelectedTalkingGroupAttendeeListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init selected talking group attendees head tip view
        SimpleIMeetingTableViewTipView *_selectedTalkingGroupAttendeesHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:RightAlign_TipView andParentView:self];
        
        // set selected talking group attendees head tip view text
        [_selectedTalkingGroupAttendeesHeadTipView setTipViewText:NSLocalizedString(@"my talking group attendees head tip view text", nil)];
        
        // init selected talking group attendee list table view
        _mSelectedTalkingGroupAttendeeListTableView = [_mSelectedTalkingGroupAttendeeListTableView = [UITableView alloc] initWithFrame:CGRectMakeWithFormat(_mSelectedTalkingGroupAttendeeListTableView, [NSNumber numberWithFloat:self.bounds.origin.x], [NSNumber numberWithFloat:self.bounds.origin.y + _selectedTalkingGroupAttendeesHeadTipView.height], [NSNumber numberWithFloat:FILL_PARENT], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)_selectedTalkingGroupAttendeesHeadTipView.height] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // set selected talking group attendee list table view dataSource and delegate
        _mSelectedTalkingGroupAttendeeListTableView.dataSource = self;
        _mSelectedTalkingGroupAttendeeListTableView.delegate = self;
        
        // add selected talking group attendees head tip view and selected talking group attendee list table view as subviews of selected talking group attendee list view
        [self addSubview:_selectedTalkingGroupAttendeesHeadTipView];
        [self addSubview:_mSelectedTalkingGroupAttendeeListTableView];
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

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Selected talking group attendee cell";
    
    // get selected talking group attendee list table view cell
    SelectedTalkingGroupAttendeeListTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[SelectedTalkingGroupAttendeeListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    _cell.textLabel.text = @"参与者";
    
    return _cell;
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected talking group attendees did select row at index path = %@", indexPath);
    
    //
}

@end
