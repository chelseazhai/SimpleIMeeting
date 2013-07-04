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

// selected talking group attendee list table view margin top and bottom
#define SELECTEDTALKINGGROUPATTENDEELISTTABLEVIEWMARGINTB   6.0
// selected talking group attendee list table view margin left and right
#define SELECTEDTALKINGGROUPATTENDEELISTTABLEVIEWMARGINLR   8.0

// add more attendees to selected talking group button height and margin
#define ADDMOREATTENDEES2SELECTEDTALKINGGROUPBUTTON_HEIGHT  34.0
#define ADDMOREATTENDEES2SELECTEDTALKINGGROUPBUTTON_MARGINTB    4.0
#define ADDMOREATTENDEES2SELECTEDTALKINGGROUPBUTTON_MARGINLR    10.0

@interface SelectedTalkingGroupAttendeeListView ()

// add more attendees to the selected talking group
- (void)addMoreAttendees2SelectedTalkingGroup;

@end

@implementation SelectedTalkingGroupAttendeeListView

@synthesize selectedTalkingGroupAttendeesInfoArray = _mSelectedTalkingGroupAttendeesJSONInfoArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background image
        self.backgroundImg = [UIImage compatibleImageNamed:@"img_selectedtalkinggroupattendeesview_bg"];
        
        // create and init subviews
        // init selected talking group attendees head tip view
        SimpleIMeetingTableViewTipView *_selectedTalkingGroupAttendeesHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:RightAlign_TipView andParentView:self];
        
        // set selected talking group attendees head tip view text
        [_selectedTalkingGroupAttendeesHeadTipView setTipViewText:NSLocalizedString(@"my talking group attendees head tip view text", nil)];
        
        // init selected talking group attendee list table view
        _mSelectedTalkingGroupAttendeeListTableView = [_mSelectedTalkingGroupAttendeeListTableView = [UITableView alloc] initWithFrame:CGRectMakeWithFormat(_mSelectedTalkingGroupAttendeeListTableView, [NSNumber numberWithFloat:self.bounds.origin.x + SELECTEDTALKINGGROUPATTENDEELISTTABLEVIEWMARGINLR], [NSNumber numberWithFloat:self.bounds.origin.y + _selectedTalkingGroupAttendeesHeadTipView.height + SELECTEDTALKINGGROUPATTENDEELISTTABLEVIEWMARGINTB], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d", FILL_PARENT_STRING, (int)SELECTEDTALKINGGROUPATTENDEELISTTABLEVIEWMARGINLR] cStringUsingEncoding:NSUTF8StringEncoding]], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d-2*%d-(2*%d+%d)", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)_selectedTalkingGroupAttendeesHeadTipView.height, (int)SELECTEDTALKINGGROUPATTENDEELISTTABLEVIEWMARGINTB, (int)ADDMOREATTENDEES2SELECTEDTALKINGGROUPBUTTON_MARGINTB, (int)ADDMOREATTENDEES2SELECTEDTALKINGGROUPBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // init selected talking group attendees info array
        _mSelectedTalkingGroupAttendeesJSONInfoArray = [[NSMutableArray alloc] init];
        
        // set its background color
        _mSelectedTalkingGroupAttendeeListTableView.backgroundColor = [UIColor clearColor];
        
        // set selected talking group attendee list table view dataSource and delegate
        _mSelectedTalkingGroupAttendeeListTableView.dataSource = self;
        _mSelectedTalkingGroupAttendeeListTableView.delegate = self;
        
        // init add more attendees to the selected talking group button
        UIButton *_addMoreAttendees2SelectedTalkingGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_addMoreAttendees2SelectedTalkingGroupButton setFrame:CGRectMakeWithFormat(_addMoreAttendees2SelectedTalkingGroupButton, [NSNumber numberWithFloat:self.bounds.origin.x + ADDMOREATTENDEES2SELECTEDTALKINGGROUPBUTTON_MARGINLR], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d-%d-%d", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)SELECTEDTALKINGGROUPATTENDEELISTTABLEVIEWMARGINTB, (int)ADDMOREATTENDEES2SELECTEDTALKINGGROUPBUTTON_HEIGHT, (int)ADDMOREATTENDEES2SELECTEDTALKINGGROUPBUTTON_MARGINTB] cStringUsingEncoding:NSUTF8StringEncoding]], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d", FILL_PARENT_STRING, (int)ADDMOREATTENDEES2SELECTEDTALKINGGROUPBUTTON_MARGINLR] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:ADDMOREATTENDEES2SELECTEDTALKINGGROUPBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_addMoreAttendees2SelectedTalkingGroupButton setTitle:NSLocalizedString(@"add more attendees to the selected talking group button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_addMoreAttendees2SelectedTalkingGroupButton addTarget:self action:@selector(addMoreAttendees2SelectedTalkingGroup) forControlEvents:UIControlEventTouchUpInside];
        
        // add selected talking group attendees head tip view, selected talking group attendee list table view and add more attendees to the selected talking group button as subviews of selected talking group attendee list view
        [self addSubview:_selectedTalkingGroupAttendeesHeadTipView];
        [self addSubview:_mSelectedTalkingGroupAttendeeListTableView];
        [self addSubview:_addMoreAttendees2SelectedTalkingGroupButton];
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

- (void)loadSelectedTalkingGroupAttendeeListTableViewDataSource:(NSArray *)selectedTalkingGroupAttendeesInfoArray selectedTalkingGroupOpened:(BOOL)isOpened{
    // set selected talking group is opened flag
    _mSelectedTalkingGroupIsOpened = isOpened;
    
    // clear selected talking group attendees info array if needed
    if (0 < [_mSelectedTalkingGroupAttendeesJSONInfoArray count]) {
        [_mSelectedTalkingGroupAttendeesJSONInfoArray removeAllObjects];
    }
    
    // set selected talking group attendees info array if not nil
    if (nil != selectedTalkingGroupAttendeesInfoArray) {
        [_mSelectedTalkingGroupAttendeesJSONInfoArray addObjectsFromArray:selectedTalkingGroupAttendeesInfoArray];
    }
    
    // reload selected talking group attendee list table view data source
    [_mSelectedTalkingGroupAttendeeListTableView reloadData];
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [_mSelectedTalkingGroupAttendeesJSONInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifierSelectedTalkingGroupOpened = @"Selected talking group(opened) attendee cell";
    static NSString *cellIdentifierSelectedTalkingGroupScheduled = @"Selected talking group(scheduled) attendee cell";
    
    // get selected talking group attendee list table view cell
    SelectedTalkingGroupAttendeeListTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:_mSelectedTalkingGroupIsOpened ? cellIdentifierSelectedTalkingGroupOpened : cellIdentifierSelectedTalkingGroupScheduled];
    
    if (nil == _cell) {
        _cell = [[SelectedTalkingGroupAttendeeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_mSelectedTalkingGroupIsOpened ? cellIdentifierSelectedTalkingGroupOpened : cellIdentifierSelectedTalkingGroupScheduled selectedTalkingGroupOpened:_mSelectedTalkingGroupIsOpened];
    }
    
    // Configure the cell...
    // get selected talking group attendee info json object
    NSDictionary *_selectedTalkingGroupAttendeeInfoJSONObject = [_mSelectedTalkingGroupAttendeesJSONInfoArray objectAtIndex:indexPath.row];
    
    // get selected talking group attendee nickname
    NSString *_selectedTalkingGroupAttendeeNickname = [_selectedTalkingGroupAttendeeInfoJSONObject objectForKey:NSRBGServerFieldString(@"remote background server http request get selected talking group attendees response info list nickname", nil)];
    
    _cell.attendeeStatus = [_selectedTalkingGroupAttendeeInfoJSONObject objectForKey:NSRBGServerFieldString(@"remote background server http request get selected talking group attendees response info list status", nil)];
    _cell.displayName = nil != _selectedTalkingGroupAttendeeNickname && ![@"" isEqualToString:_selectedTalkingGroupAttendeeNickname] ? _selectedTalkingGroupAttendeeNickname : [[[AddressBookManager shareAddressBookManager] contactsDisplayNameArrayWithPhoneNumber:[_selectedTalkingGroupAttendeeInfoJSONObject objectForKey:NSRBGServerFieldString(@"remote background server http request get selected talking group attendees response info list phone", nil)]] objectAtIndex:0];
    
    return _cell;
}

// UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return the height for row at indexPath.
    return [SelectedTalkingGroupAttendeeListTableViewCell cellHeight];
}

// inner extension
- (void)addMoreAttendees2SelectedTalkingGroup{
    NSLog(@"addMoreAttendees2SelectedTalkingGroup");
    
    //
}

@end
