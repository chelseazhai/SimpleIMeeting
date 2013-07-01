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
        
        // init in or prein talking group contact list table view
        _mIn6PreinTalkingGroupContactListTableView = [_mIn6PreinTalkingGroupContactListTableView = [UITableView alloc] initWithFrame:CGRectMakeWithFormat(_mIn6PreinTalkingGroupContactListTableView, [NSNumber numberWithFloat:self.bounds.origin.x], [NSNumber numberWithFloat:self.bounds.origin.y + _selectedContactsHeadTipView.height], [NSNumber numberWithFloat:FILL_PARENT], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d-(2*%d+%d)", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)_selectedContactsHeadTipView.height, (int)INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_MARGIN, (int)INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // set its background color
        _mIn6PreinTalkingGroupContactListTableView.backgroundColor = [UIColor clearColor];
        
        // set separator style UITableViewCellSeparatorStyleNone
        _mIn6PreinTalkingGroupContactListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // init in talking group attendees phone array and prein talking group contacts info array
        _mInTalkingGroupAttendeesPhoneArray = [[NSMutableArray alloc] init];
        _mPreinTalkingGroupContactsInfoArray = [[NSMutableArray alloc] init];
        
        // set in or prein talking group contact list table view dataSource and delegate
        _mIn6PreinTalkingGroupContactListTableView.dataSource = self;
        _mIn6PreinTalkingGroupContactListTableView.delegate = self;
        
        // init invite selected contacts to the talking group button
        UIButton *_inviteSelectedContacts2TalkingGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_inviteSelectedContacts2TalkingGroupButton setFrame:CGRectMakeWithFormat(_inviteSelectedContacts2TalkingGroupButton, [NSNumber numberWithFloat:self.bounds.origin.x + INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_MARGIN], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d-%d", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_MARGIN, (int)INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d", FILL_PARENT_STRING, (int)INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_MARGIN] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:INVITESELECTEDCONTACTS2TALKINGGROUPBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_inviteSelectedContacts2TalkingGroupButton setTitle:NSLocalizedString(@"invite the selected contacts to talking group button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_inviteSelectedContacts2TalkingGroupButton addTarget:self action:@selector(inviteSelectedContacts2TalkingGroup) forControlEvents:UIControlEventTouchUpInside];
        
        // add selected contacts head tip view, in or prein talking group contact list table view and invite selected contacts to talking group button as subviews of selected contact list view
        [self addSubview:_selectedContactsHeadTipView];
        [self addSubview:_mIn6PreinTalkingGroupContactListTableView];
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

- (void)addContact2PreinTalkingGroupSection{
    // insert the selected contact to the end of in or prein talking group contact list table view prein talking group section
    [_mIn6PreinTalkingGroupContactListTableView insertRowAtIndexPath:[NSIndexPath indexPathForRow:[_mPreinTalkingGroupContactsInfoArray count] - 1 inSection:_mIn6PreinTalkingGroupContactListTableView.numberOfSections - 1] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)removeSelectedContactFromPreinTalkingGroupSection:(NSInteger)index{
    // remove the selected contact from in or prein talking group contact list table view prein talking group section
    [_mIn6PreinTalkingGroupContactListTableView deleteRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:_mIn6PreinTalkingGroupContactListTableView.numberOfSections - 1] withRowAnimation:UITableViewRowAnimationTop];
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
    
    // get in or prein talking group contact list table view cell
    In6PreinTalkingGroupContactTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[In6PreinTalkingGroupContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    _cell.contactIsInTalkingGroupFlag = 0 == indexPath.section ? YES : NO;
    _cell.displayName = 0 == indexPath.section ? [_mInTalkingGroupAttendeesPhoneArray objectAtIndex:indexPath.row] : ((ContactBean *)[_mPreinTalkingGroupContactsInfoArray objectAtIndex:indexPath.row]).displayName;
    
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
    // remove the selected contact from in or prein talking group contact list table view prein talking group section
    [(ContactsSelectView *)self.superview removeSelectedContactFromSelectedContactListView:indexPath.row];
}

// IHttpReqRespSelector
- (void)httpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send get new talking group id http request succeed - request url = %@, response status code = %d and data string = %@", pRequest.url, [pRequest responseStatusCode], pRequest.responseString);
    
    // check status code
    if (200 == [pRequest responseStatusCode]) {
        // get response data json format
        NSDictionary *_respDataJSONFormat = [pRequest.responseString objectFromJSONString];
        
        // get and check new talking group id
        NSString *_newTalkingGroupId = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups or new talking group id response id", nil)];
        if (nil != _newTalkingGroupId && ![@"" isEqualToString:_newTalkingGroupId]) {
            // show new talking group started time select view with new talking group id
            [((ContactsSelectView *)self.superview) showNewTalkingGroupStartedTimeSelectView:_newTalkingGroupId];
        }
        else {
            //
        }
    }
    else {
        //
    }
}

- (void)httpRequestDidFailed:(ASIHTTPRequest *)pRequest{
    NSLog(@"send get new talking group id http request failed");
    
    //
}

// inner extension
- (void)inviteSelectedContacts2TalkingGroup{
    // check prein talking group contacts info array
    if (0 < [_mPreinTalkingGroupContactsInfoArray count]) {
        // check in talking group attendees phone array
        if (0 < [_mInTalkingGroupAttendeesPhoneArray count]) {
            NSLog(@"invite the prein talking group contacts to talking group");
            
            // invite the prein talking group contacts to talking group
            //
        }
        else {
            // get new talking group id
            // get the http request
            [HttpUtils getSignatureRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"get new talking group id url format string", nil), NSUrlString(@"remote background server root url string", nil)] andParameter:nil andUserInfo:nil andRequestType:asynchronous andProcessor:self andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
        }
    }
    // check in talking group attendees phone array again
    else if (0 < [_mInTalkingGroupAttendeesPhoneArray count]) {
        NSLog(@"send invite short message to all attendees of talking group again");
        
        // send invite short message to all attendees of talking group again
        //
    }
    else {
        NSLog(@"Warning: you must select one contact for be invited to talking group at least");
        
        // show toast
        [[iToast makeText:NSToastLocalizedString(@"toast select at least one contact for inviting to talking group", nil)] show:iToastTypeWarning];
    }
    
    //
    //[(ContactsSelectView *)self.superview cancel6finishContactsSelecting];
}

@end
