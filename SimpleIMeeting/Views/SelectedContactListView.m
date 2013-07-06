//
//  SelectedContactListView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SelectedContactListView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "SimpleIMeetingTableViewTipView.h"

#import "In6PreinTalkingGroupContactTableViewCell.h"

#import "ContactsSelectView.h"

#import "SimpleIMeetingContentContainerView.h"

// section number ans each row number array
#define SECTIONNUMBER_ROWSNUMBERARRAY   [NSArray arrayWithObjects:[NSNumber numberWithInteger:[_mInTalkingGroupAttendeesPhoneArray count]], [NSNumber numberWithInteger:[_mPreinTalkingGroupContactsInfoArray count]], nil]

// invite selected contacts to the talking group button height and margin
#define INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_HEIGHT    34.0
#define INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_MARGIN    4.0

@interface SelectedContactListView ()

// invite the selected contacts with the selected phone number to talking group
- (void)inviteSelectedContacts2TalkingGroup;

@end

@implementation SelectedContactListView

@synthesize inTalkingGroupAttendeesPhoneArray = _mInTalkingGroupAttendeesPhoneArray;

@synthesize preinTalkingGroupContactsInfoArray = _mPreinTalkingGroupContactsInfoArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background image
        self.backgroundImg = [UIImage compatibleImageNamed:@"img_selectedcontactsview_bg"];
        
        // create and init subviews
        // init selected contacts head tip view
        SimpleIMeetingTableViewTipView *_selectedContactsHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:RightAlign_TipView andParentView:self];
        
        // set selected contacts head tip view text
        [_selectedContactsHeadTipView setTipViewText:NSLocalizedString(@"contacts select selected contacts head tip view text", nil)];
        
        // init in and prein talking group contact list table view
        _mInPreinTalkingGroupContactListTableView = [_mInPreinTalkingGroupContactListTableView = [UITableView alloc] initWithFrame:CGRectMakeWithFormat(_mInPreinTalkingGroupContactListTableView, [NSNumber numberWithFloat:self.bounds.origin.x], [NSNumber numberWithFloat:self.bounds.origin.y + _selectedContactsHeadTipView.height], [NSNumber numberWithFloat:FILL_PARENT], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d-(2*%d+%d)", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)_selectedContactsHeadTipView.height, (int)INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_MARGIN, (int)INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // set its background color
        _mInPreinTalkingGroupContactListTableView.backgroundColor = [UIColor clearColor];
        
        // set separator style UITableViewCellSeparatorStyleNone
        _mInPreinTalkingGroupContactListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // init in talking group attendees phone array and prein talking group contacts info array
        _mInTalkingGroupAttendeesPhoneArray = [[NSMutableArray alloc] init];
        _mPreinTalkingGroupContactsInfoArray = [[NSMutableArray alloc] init];
        
        // set in and prein talking group contact list table view dataSource and delegate
        _mInPreinTalkingGroupContactListTableView.dataSource = self;
        _mInPreinTalkingGroupContactListTableView.delegate = self;
        
        // init invite selected contacts to the talking group button
        UIButton *_inviteSelectedContacts2TalkingGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_inviteSelectedContacts2TalkingGroupButton setFrame:CGRectMakeWithFormat(_inviteSelectedContacts2TalkingGroupButton, [NSNumber numberWithFloat:self.bounds.origin.x + INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_MARGIN], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d-%d", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_MARGIN, (int)INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d", FILL_PARENT_STRING, (int)INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_MARGIN] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_inviteSelectedContacts2TalkingGroupButton setTitle:NSLocalizedString(@"invite the selected contacts to talking group button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_inviteSelectedContacts2TalkingGroupButton addTarget:self action:@selector(inviteSelectedContacts2TalkingGroup) forControlEvents:UIControlEventTouchUpInside];
        
        // add selected contacts head tip view, in and prein talking group contact list table view and invite selected contacts to talking group button as subviews of selected contact list view
        [self addSubview:_selectedContactsHeadTipView];
        [self addSubview:_mInPreinTalkingGroupContactListTableView];
        [self addSubview:_inviteSelectedContacts2TalkingGroupButton];
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

- (void)loadInPreinTalkingGroupContactListTableViewDataSource{
    // reload in and prein talking group contact list table view data source
    [_mInPreinTalkingGroupContactListTableView reloadData];
}

- (void)addContact2PreinTalkingGroupSection{
    // insert the selected contact to the end of in and prein talking group contact list table view prein talking group section
    [_mInPreinTalkingGroupContactListTableView insertRowAtIndexPath:[NSIndexPath indexPathForRow:[_mPreinTalkingGroupContactsInfoArray count] - 1 inSection:_mInPreinTalkingGroupContactListTableView.numberOfSections - 1] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)removeSelectedContactFromPreinTalkingGroupSection:(NSInteger)index{
    // remove the selected contact from in and prein talking group contact list table view prein talking group section
    [_mInPreinTalkingGroupContactListTableView deleteRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:_mInPreinTalkingGroupContactListTableView.numberOfSections - 1] withRowAnimation:UITableViewRowAnimationTop];
}

// UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return [SECTIONNUMBER_ROWSNUMBERARRAY count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return ((NSNumber *)[SECTIONNUMBER_ROWSNUMBERARRAY objectAtIndex:section]).integerValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"In or Prein talking group contact cell";
    
    // get in and prein talking group contact list table view cell
    In6PreinTalkingGroupContactTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[In6PreinTalkingGroupContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    _cell.contactIsInTalkingGroupFlag = 0 == indexPath.section ? YES : NO;
    _cell.displayName = 0 == indexPath.section ? [[[AddressBookManager shareAddressBookManager] contactsDisplayNameArrayWithPhoneNumber:[_mInTalkingGroupAttendeesPhoneArray objectAtIndex:indexPath.row]] objectAtIndex:0] : ((ContactBean *)[_mPreinTalkingGroupContactsInfoArray objectAtIndex:indexPath.row]).displayName;
    
    return _cell;
}

// UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return the height for row at indexPath.
    return [In6PreinTalkingGroupContactTableViewCell cellHeight];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *_ret = indexPath;
    
    // check will select row if or not in talking group
    if (0 == indexPath.section) {
        _ret = nil;
    }
    
    return _ret;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // remove the selected contact from in and prein talking group contact list table view prein talking group section
    [(ContactsSelectView *)self.superview removeSelectedContactFromSelectedContactListView:indexPath.row];
}

// inner extension
- (void)inviteSelectedContacts2TalkingGroup{
    // get parent view: contacts select view
    ContactsSelectView *_contactsSelectView = (ContactsSelectView *)self.superview;
    
    // check prein talking group contacts info array
    if (0 < [_mPreinTalkingGroupContactsInfoArray count]) {
        // check in talking group attendees phone array
        if (0 < [_mInTalkingGroupAttendeesPhoneArray count]) {
            // add more attendees to the talking group
            [_contactsSelectView addMoreAttendees2TalkingGroup];
        }
        else {
            // schedule new talking group
            [_contactsSelectView scheduleNewTalkingGroup];
        }
    }
    // check in talking group attendees phone array again
    else if (0 < [_mInTalkingGroupAttendeesPhoneArray count]) {
        // finish contacts selecting
        [((SimpleIMeetingContentContainerView *)_contactsSelectView.superview) back2MyTalkingGroups7AttendeesContentView4EndingAddSelectedContact4Inviting:NOREFRESH];
        
        // send invite short message to all attendees of talking group again
        [_contactsSelectView sendInviteSMS:_mInTalkingGroupAttendeesPhoneArray body:nil];
    }
    else {
        NSLog(@"Warning: you must select one contact for be invited to talking group at least");
        
        // show toast
        [[iToast makeText:NSToastLocalizedString(@"toast select at least one contact for inviting to talking group", nil)] show:iToastTypeWarning];
    }
}

@end
