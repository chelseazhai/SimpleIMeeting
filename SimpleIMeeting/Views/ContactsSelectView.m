//
//  ContactsSelectView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ContactsSelectView.h"

#import "ContactListView.h"
#import "SelectedContactListView.h"

#import "ContactBean+ContactsSelect.h"

#import "SimpleIMeetingContentContainerView.h"

// new talking group started time select popup window present content view and its subview height
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING    6.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWTITLELABEL_HEIGHT  30.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABEL6COPYBUTTON_HEIGHT  58.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWDATEPICKER_HEIGHT  180.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWCONTROLLERBUTTON_HEIGHT    34.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_HEIGHT    320.0

// new talking group started time select popup window present content view title and invite note label text font size
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWTITLELABELTEXTFONTSIZE 18.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABELTEXTFONTSIZE    15.0

// talking group invite note
#define TALKINGGROUPINVITENOTE(startedTime, talkingGroupId)  [NSString stringWithFormat:NSLocalizedString(@"new talking group invite note label text format string", nil), [startedTime stringWithFormat:NSLocalizedString(@"new talking group started time select date picker date format string", nil)], talkingGroupId]

// milliseconds per second
#define MILLISECONDS_PER_SECOND 1000

@interface ContactsSelectView ()

// generate contact list view draw rectangle
- (CGRect)genContactListViewDrawRect;

// get new talking group id http request did finished selector
- (void)getNewTalkingGroupIdHttpRequestDidFinished:(ASIHTTPRequest *)pRequest;

// show new talking group started time select popup window
- (void)showNewTalkingGroupStartedTimeSelectPopupWindow;

// copy new talking group invite note to pasteboard
- (void)copyNewTalkingGroupInviteNote2Pasteboard;

// new talking group started time select date picker date changed
- (void)newTalkingGroupStartedTimeSelectDatePickerDateChanged;

// confirm schedule new talking group
- (void)confirmScheduleNewTalkingGroup;

// cancel schedule new talking group
- (void)cancelScheduleNewTalkingGroup;

// generate new talking group or invite new added attendees info json array
- (NSArray *)generateNewTalkingGroup6InviteNewAddedAttendeesInfoJSONArray;

// schedule new talking group http request did finished selector
- (void)scheduleNewTalkingGroupHttpRequestDidFinished:(ASIHTTPRequest *)pRequest;

// invite new added attendees to the talking group http request did finished selector
- (void)inviteNewAddedAttendees2TalkingGroupHttpRequestDidFinished:(ASIHTTPRequest *)pRequest;

@end

@implementation ContactsSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init addressbook contact list view
        _mABContactListView = [[ContactListView alloc] initWithFrame:[self genContactListViewDrawRect]];
        
        // init selected contact list view
        _mSelectedContactListView = [[SelectedContactListView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + FILL_PARENT * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), self.bounds.origin.y, FILL_PARENT * (RIGHTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), FILL_PARENT)];
        
        // hidden first
        _mSelectedContactListView.hidden = YES;
        
        // add addressBook contact list view and selected contact list view as subviews of contacts select view
        [self addSubview:_mABContactListView];
        [self addSubview:_mSelectedContactListView];
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
    if (0 < [_mSelectedContactListView.inTalkingGroupAttendeesPhoneArray count]) {
        [_mSelectedContactListView.inTalkingGroupAttendeesPhoneArray removeAllObjects];
    }
    
    // set new in talking group attendees phone array if not nil
    if (nil != inTalkingGroupAttendeesPhoneArray) {
        [_mSelectedContactListView.inTalkingGroupAttendeesPhoneArray addObjectsFromArray:inTalkingGroupAttendeesPhoneArray];
    }
}

- (NSArray *)inTalkingGroupAttendeesPhoneArray{
    return _mSelectedContactListView.inTalkingGroupAttendeesPhoneArray;
}

- (NSMutableArray *)preinTalkingGroupContactsInfoArray{
    return _mSelectedContactListView.preinTalkingGroupContactsInfoArray;
}

- (void)setSelectedContacts4Adding2TalkingGroupId:(NSString *)talkingGroupId startedTimestamp:(NSString *)startedTimestamp{
    // set sekected contacts for adding to the talking group id and invite note 
    _mNew6SelectedContacts4Adding2TalkingGroupId = talkingGroupId;
    _mSelectedContacts4Adding2TalkingGroupInviteNote = TALKINGGROUPINVITENOTE([NSDate dateWithTimeIntervalSince1970:startedTimestamp.doubleValue / MILLISECONDS_PER_SECOND], talkingGroupId);
}

- (void)addContact2SelectedContactListView{
    // add contact to in and prein talking group contact list table view prein talking group section
    [_mSelectedContactListView addContact2PreinTalkingGroupSection];
}

- (void)removeSelectedContactFromSelectedContactListView:(NSInteger)index{
    // get the selected contact index which is in addressBook contact list table view all contacts info array  and present contacts info array
    NSInteger _indexOfAllContactsInfoArray, _indexOfPresentContactsInfoArray = _indexOfAllContactsInfoArray = -1;
    for (NSInteger _index = 0; _index < [_mABContactListView.allContactsInfoArrayInABRef count]; _index++) {
        // compare contact id which is in addressBook contact list table view all contacts info array with the selected contact id
        if (((ContactBean *)[_mABContactListView.allContactsInfoArrayInABRef objectAtIndex:_index]).id == ((ContactBean *)[self.preinTalkingGroupContactsInfoArray objectAtIndex:index]).id) {
            // update index of all contacts info array
            _indexOfAllContactsInfoArray = _index;
            
            // update index of present contacts info array
            if ([_mABContactListView.presentContactsInfoArrayRef containsObject:[_mABContactListView.allContactsInfoArrayInABRef objectAtIndex:_index]]) {
                _indexOfPresentContactsInfoArray = [_mABContactListView.presentContactsInfoArrayRef indexOfObject:[_mABContactListView.allContactsInfoArrayInABRef objectAtIndex:_index]];
            }
            
            break;
        }
    }
    
    // check index of all contacts info array
    if (0 <= _indexOfAllContactsInfoArray) {
        // check index of present contacts info array
        if (0 <= _indexOfPresentContactsInfoArray) {
            // recover selected address book contact which is in present contacts info array cell is selected flag
            [_mABContactListView recoverSelectedContactCellIsSelectedFlag:_indexOfPresentContactsInfoArray];
        }
        
        // get the selected contact contactBean
        ContactBean *_selectedContactBean = [_mABContactListView.allContactsInfoArrayInABRef objectAtIndex:_indexOfAllContactsInfoArray];
        
        // recover the selected contact is selected flag and selected phone
        _selectedContactBean.isSelected = NO;
        _selectedContactBean.selectedPhoneNumber = @"";
    }
    else {
        NSLog(@"Info: temp added contact, needn't to recover original contact attributes");
    }
    
    // remove the selected contact from prein talking group contacts info array
    [self.preinTalkingGroupContactsInfoArray removeObjectAtIndex:index];
    
    // remove the selected contact from in and prein talking group contact list table view prein talking group section
    [_mSelectedContactListView removeSelectedContactFromPreinTalkingGroupSection:index];
}

- (void)scheduleNewTalkingGroup{
    // get new talking group id
    // get the http request
    [HttpUtils getSignatureRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"get new talking group id url format string", nil), NSUrlString(@"remote background server root url string", nil)] andParameter:nil andUserInfo:nil andRequestType:asynchronous andProcessor:self andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
}

- (void)sendInviteSMS:(NSArray *)recipients body:(NSString *)body{
    // check invite sms body
    if (nil == body || [@"" isEqualToString:body]) {
        // send invite short message to all attendees of talking group again
        body = _mSelectedContacts4Adding2TalkingGroupInviteNote;
    }
    
    NSLog(@"send invite short message to all attendees = %@ of talking group, invite note = %@", recipients, body);
    
    //
}

- (void)addMoreAttendees2TalkingGroup{
    // invite new added attendees to the talking group
    // generate invite new added attendees to the talking group param map
    NSMutableDictionary *_inviteNewAddedAttendees2TalkingGroupParamMap = [[NSMutableDictionary alloc] init];
    
    // set some params
    [_inviteNewAddedAttendees2TalkingGroupParamMap setObject:_mNew6SelectedContacts4Adding2TalkingGroupId forKey:NSRBGServerFieldString(@"remote background server http request get selected talking group attendees or schedule new talking group or invite new added contacts to talking group id", nil)];
    [_inviteNewAddedAttendees2TalkingGroupParamMap setObject:[[self generateNewTalkingGroup6InviteNewAddedAttendeesInfoJSONArray] JSONString] forKey:NSRBGServerFieldString(@"remote background server http request schedule new talking group or invite new added contacts to talking group attendees", nil)];
    
    // post the http request
    [HttpUtils postSignatureRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"invite new member to talking group url format string", nil), NSUrlString(@"remote background server root url string", nil)] andPostFormat:urlEncoded andParameter:_inviteNewAddedAttendees2TalkingGroupParamMap andUserInfo:nil andRequestType:asynchronous andProcessor:self andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
}

- (void)cancel6finishContactsSelecting{
    // clear contact list view contact search text field text and selected address book contact cell index
    [_mABContactListView clearContactSearchTextFieldText7SelectedABContactCellIndex];
    
    // clear prein talking group contacts info array if needed
    while (0 < [self.preinTalkingGroupContactsInfoArray count]) {
        // get the will be removed prein talking group contact index
        NSInteger _index = [self.preinTalkingGroupContactsInfoArray count] - 1;
        
        // remove each contact extension dictionary and contact from prein talking group contacts info array
        [((ContactBean *)[self.preinTalkingGroupContactsInfoArray objectAtIndex:_index]).extensionDic removeAllObjects];
        
        // remove selected contact from selected contact list view
        [self removeSelectedContactFromSelectedContactListView:_index];
    }
    
    // clear in talking group attendees phone array if needed
    if (0 < [self.inTalkingGroupAttendeesPhoneArray count]) {
        [self setInTalkingGroupAttendeesPhoneArray:nil];
    }
}

// ITalkingGroupGeneratorProtocol
- (void)generateNewTalkingGroup{
    // set it is ready for adding selected contact for inviting
    _mReady4AddingSelectedContact4Inviting = YES;
    
    // update address book contact list view
    [_mABContactListView setFrame:[self genContactListViewDrawRect]];
    
    // show selected contact list view if needed
    if ([_mSelectedContactListView isHidden]) {
        _mSelectedContactListView.hidden = NO;
        
        // reload selected contact list table view in and prein talking group contact list table view data source
        [_mSelectedContactListView loadInPreinTalkingGroupContactListTableViewDataSource];
    }
}

- (void)cancelGenTalkingGroup{
    // set it is not ready for adding selected contact for inviting
    _mReady4AddingSelectedContact4Inviting = NO;
    
    // update address book contact list view
    [_mABContactListView setFrame:[self genContactListViewDrawRect]];
    
    // hide selected contact list view
    if (![_mSelectedContactListView isHidden]) {
        _mSelectedContactListView.hidden = YES;
    }
    
    // cancel contacts selecting
    [self cancel6finishContactsSelecting];
}

// IHttpReqRespProtocol
- (void)httpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send http request succeed - request url = %@", pRequest.url);
    
    // check the request url string
    if ([pRequest.url.absoluteString hasPrefix:[NSString stringWithFormat:NSUrlString(@"get new talking group id url format string", nil), NSUrlString(@"remote background server root url string", nil)]]) {
        // get new talking group id http request
        [self getNewTalkingGroupIdHttpRequestDidFinished:pRequest];
    }
    else if ([pRequest.url.absoluteString hasPrefix:[NSString stringWithFormat:NSUrlString(@"schedule new talking group url format string", nil), NSUrlString(@"remote background server root url string", nil)]]) {
        // schedule new talking group http request
        [self scheduleNewTalkingGroupHttpRequestDidFinished:pRequest];
    }
    else if ([pRequest.url.absoluteString hasPrefix:[NSString stringWithFormat:NSUrlString(@"invite new member to talking group url format string", nil), NSUrlString(@"remote background server root url string", nil)]]) {
        // invite new added attendees to the talking group http request
        [self inviteNewAddedAttendees2TalkingGroupHttpRequestDidFinished:pRequest];
    }
    else {
        //
    }
}

- (void)httpRequestDidFailed:(ASIHTTPRequest *)pRequest{
    NSLog(@"send http request failed - request url = %@", pRequest.url);
    
    //
}

// inner extension
- (CGRect)genContactListViewDrawRect{
    CGRect _contactListViewDrawRectangle;
    
    // check address book contact list view if or not init
    if (nil == _mABContactListView) {
        _contactListViewDrawRectangle = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT);
    }
    else {
        // get address book contact list view frame
        _contactListViewDrawRectangle = _mABContactListView.frame;
        
        // check is ready for adding selected contact for inviting to the new talking group and update address book contact list view draw rectangle width
        if (_mReady4AddingSelectedContact4Inviting) {
            // compare address book contact list view frame size width with its parent view frame size width
            if (self.frame.size.width == _mABContactListView.frame.size.width) {
                _contactListViewDrawRectangle.size.width = _mABContactListView.frame.size.width * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT);
            }
        }
        else {
            // recover as parent view frame size width
            _contactListViewDrawRectangle.size.width = self.frame.size.width;
        }
    }
    
    return _contactListViewDrawRectangle;
}

- (void)getNewTalkingGroupIdHttpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send get new talking group id http request succeed - request url = %@, response status code = %d and data string = %@", pRequest.url, [pRequest responseStatusCode], pRequest.responseString);
    
    // check status code
    if (200 == [pRequest responseStatusCode]) {
        // get response data json format
        NSDictionary *_respDataJSONFormat = [pRequest.responseString objectFromJSONString];
        
        // get and check new talking group id
        NSString *_newTalkingGroupId = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups or new talking group id response id", nil)];
        if (nil != _newTalkingGroupId && ![@"" isEqualToString:_newTalkingGroupId]) {
            // save new talking group id
            _mNew6SelectedContacts4Adding2TalkingGroupId = _newTalkingGroupId;
            
            // show new talking group started time select popup window
            [self showNewTalkingGroupStartedTimeSelectPopupWindow];
        }
        else {
            //
        }
    }
    else {
        //
    }
}

- (void)showNewTalkingGroupStartedTimeSelectPopupWindow{
    // check new talking group started time select popup window
    if (nil == _mNewTalkingGroupStartedTimeSelectPopupWindow) {
        // init new talking group started time select popup window
        _mNewTalkingGroupStartedTimeSelectPopupWindow = [[UIPopupWindow alloc] init];
        
        // define new talking group started time select popup window present content view
        UIView *_presentContentView;
        
        // init new talking group started time select popup window present content view
        _presentContentView = [_presentContentView = [UIView alloc] initWithFrame:CGRectMakeWithFormat(_presentContentView, [NSNumber numberWithFloat:_mNewTalkingGroupStartedTimeSelectPopupWindow.bounds.origin.x], [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+(%s-%d)", (int)_mNewTalkingGroupStartedTimeSelectPopupWindow.bounds.origin.y, FILL_PARENT_STRING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:FILL_PARENT], [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_HEIGHT])];
        
        // set its background color
        _presentContentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        
        // init new talking group started time select popup window present content view date picker
        _mNewTalkingGroupStartedTimeSelectDatePicker = [[UIDatePicker alloc] init];
        
        // init new talking group started time select popup window present content view title label
        UILabel *_presentContentViewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_presentContentView.bounds.origin.x, _presentContentView.bounds.origin.y, FILL_PARENT, NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWTITLELABEL_HEIGHT)];
        
        // set its attributes
        _presentContentViewTitleLabel.text = NSLocalizedString(@"new talking group started time select popup window title label text", nil);
        _presentContentViewTitleLabel.textColor = [UIColor whiteColor];
        _presentContentViewTitleLabel.textAlignment = NSTextAlignmentCenter;
        _presentContentViewTitleLabel.font = [UIFont boldSystemFontOfSize:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWTITLELABELTEXTFONTSIZE];
        _presentContentViewTitleLabel.backgroundColor = [UIColor clearColor];
        
        // init new talking group started time select popup window present content view invite note label
        _mNewTalkingGroupInviteNoteLabel = [_mNewTalkingGroupInviteNoteLabel = [UILabel alloc] initWithFrame:CGRectMakeWithFormat(_mNewTalkingGroupInviteNoteLabel, [NSNumber numberWithFloat:_presentContentView.bounds.origin.x + NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING], [NSNumber numberWithFloat:_presentContentView.bounds.origin.y + _presentContentViewTitleLabel.frame.size.height], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-4*%d-%d", FILL_PARENT_STRING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABEL6COPYBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABEL6COPYBUTTON_HEIGHT])];
        
        // set its attributes
        _mNewTalkingGroupInviteNoteLabel.text = TALKINGGROUPINVITENOTE(_mNewTalkingGroupStartedTimeSelectDatePicker.date, _mNew6SelectedContacts4Adding2TalkingGroupId);
        _mNewTalkingGroupInviteNoteLabel.textColor = [UIColor whiteColor];
        _mNewTalkingGroupInviteNoteLabel.font = [UIFont systemFontOfSize:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABELTEXTFONTSIZE];
        _mNewTalkingGroupInviteNoteLabel.numberOfLines = 0;
        _mNewTalkingGroupInviteNoteLabel.backgroundColor = [UIColor clearColor];
        
        // init new talking group invite note copy button
        UIButton *_copyNewTalkingGroupInviteNoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_copyNewTalkingGroupInviteNoteButton setFrame:CGRectMakeWithFormat(_copyNewTalkingGroupInviteNoteButton, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%s-%d-%d", (int)_presentContentView.bounds.origin.x, FILL_PARENT_STRING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABEL6COPYBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:_presentContentView.bounds.origin.y + _presentContentViewTitleLabel.frame.size.height], [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABEL6COPYBUTTON_HEIGHT], [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABEL6COPYBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_copyNewTalkingGroupInviteNoteButton setTitle:NSLocalizedString(@"new talking group invite note copy button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_copyNewTalkingGroupInviteNoteButton addTarget:self action:@selector(copyNewTalkingGroupInviteNote2Pasteboard) forControlEvents:UIControlEventTouchUpInside];
        
        // set new talking group started time select popup window present content view date picker frame
        [_mNewTalkingGroupStartedTimeSelectDatePicker setFrame:CGRectMake(_presentContentView.bounds.origin.x, _presentContentView.bounds.origin.y + _presentContentViewTitleLabel.frame.size.height + _mNewTalkingGroupInviteNoteLabel.frame.size.height + NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING, FILL_PARENT, NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWDATEPICKER_HEIGHT)];
        
        // add its date changed target and action selector
        [_mNewTalkingGroupStartedTimeSelectDatePicker addTarget:self action:@selector(newTalkingGroupStartedTimeSelectDatePickerDateChanged) forControlEvents:UIControlEventValueChanged];
        
        // new talking group started time select popup window present content view controller button origin y number and width value
        NSNumber *_newTalkingGroupStartedTimeSelectPopupWindowControllerButtonOriginYNumber = [NSNumber numberWithFloat:_presentContentView.bounds.origin.y + _presentContentViewTitleLabel.frame.size.height + _mNewTalkingGroupInviteNoteLabel.frame.size.height + _mNewTalkingGroupStartedTimeSelectDatePicker.frame.size.height + 2 * NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING];
        NSValue *_newTalkingGroupStartedTimeSelectPopupWindowControllerButtonWidthValue = [NSValue valueWithCString:[[NSString stringWithFormat:@"(%s-4*%d)/2", FILL_PARENT_STRING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING] cStringUsingEncoding:NSUTF8StringEncoding]];
        
        // init confirm schedule new talking group controller button
        UIButton *_confirmScheduleNewTalkingGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_confirmScheduleNewTalkingGroupButton setFrame:CGRectMakeWithFormat(_confirmScheduleNewTalkingGroupButton, [NSNumber numberWithFloat:_presentContentView.bounds.origin.x + NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING], _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonOriginYNumber, _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonWidthValue, [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWCONTROLLERBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_confirmScheduleNewTalkingGroupButton setTitle:NSLocalizedString(@"confirm schedule new talking group button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_confirmScheduleNewTalkingGroupButton addTarget:self action:@selector(confirmScheduleNewTalkingGroup) forControlEvents:UIControlEventTouchUpInside];
        
        // init cancel schedule new talking group controller button
        UIButton *_cancelScheduleNewTalkingGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_cancelScheduleNewTalkingGroupButton setFrame:CGRectMakeWithFormat(_cancelScheduleNewTalkingGroupButton, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%@+3*%d", (int)_presentContentView.bounds.origin.x, _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonWidthValue.stringValue, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING] cStringUsingEncoding:NSUTF8StringEncoding]], _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonOriginYNumber, _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonWidthValue, [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWCONTROLLERBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_cancelScheduleNewTalkingGroupButton setTitle:NSLocalizedString(@"cancel schedule new talking group button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_cancelScheduleNewTalkingGroupButton addTarget:self action:@selector(cancelScheduleNewTalkingGroup) forControlEvents:UIControlEventTouchUpInside];
        
        // add title, new talking group invite note label, copy new talking group invite note button, new talking group started time select date picker, confirm and cancel schedule new talking group button as subviews of new talking group started time select present content view
        [_presentContentView addSubview:_presentContentViewTitleLabel];
        [_presentContentView addSubview:_mNewTalkingGroupInviteNoteLabel];
        [_presentContentView addSubview:_copyNewTalkingGroupInviteNoteButton];
        [_presentContentView addSubview:_mNewTalkingGroupStartedTimeSelectDatePicker];
        [_presentContentView addSubview:_confirmScheduleNewTalkingGroupButton];
        [_presentContentView addSubview:_cancelScheduleNewTalkingGroupButton];
        
        // set its present content view
        _mNewTalkingGroupStartedTimeSelectPopupWindow.presentContentView = _presentContentView;
    }
    else {
        // update new talking group started time select date picker
        _mNewTalkingGroupStartedTimeSelectDatePicker.date = [NSDate date];
        
        // update new talking group invite note label text
        _mNewTalkingGroupInviteNoteLabel.text = TALKINGGROUPINVITENOTE(_mNewTalkingGroupStartedTimeSelectDatePicker.date, _mNew6SelectedContacts4Adding2TalkingGroupId);
    }
    
//    // set current date as new talking goup started time select date picker minimum date
//    _mNewTalkingGroupStartedTimeSelectDatePicker.minimumDate = [NSDate date];
    
    // show new talking group started time select popup window
    [_mNewTalkingGroupStartedTimeSelectPopupWindow showAtLocation:self];
}

- (void)copyNewTalkingGroupInviteNote2Pasteboard{
    // generate pasteboard and copy new talking group invite note label text to it
    [[UIPasteboard generalPasteboard] setString:_mNewTalkingGroupInviteNoteLabel.text];
    
    // show toast
    [[iToast makeText:NSToastLocalizedString(@"toast copy new talking group invite note to pasteboard successful", nil)] show:iToastTypeNotice];
}

- (void)newTalkingGroupStartedTimeSelectDatePickerDateChanged{
    // update new talking group invite note label text
    _mNewTalkingGroupInviteNoteLabel.text = TALKINGGROUPINVITENOTE(_mNewTalkingGroupStartedTimeSelectDatePicker.date, _mNew6SelectedContacts4Adding2TalkingGroupId);
}

- (void)confirmScheduleNewTalkingGroup{
    // compare new talking group started time with current date, get and check the comparison result
    NSComparisonResult _comparisonResult = [_mNewTalkingGroupStartedTimeSelectDatePicker.date compare:[NSDate date] componentUnitFlags:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit];
    if (NSOrderedAscending == _comparisonResult) {
        // selected time has been passed
        NSLog(@"Error: the selected started time for new talking group has been passed");
        
        // show toast
        [[iToast makeText:NSToastLocalizedString(@"toast new talking group started time selected is too early", nil)] show:iToastTypeError];
    }
    else {
        // confirm schedule new talking group
        // define confirm schedule new talking group http request url
        NSString *_confirmScheduleNewTalkingGroupUrl;
        
        // generate confirm schedule new talking group param map
        NSMutableDictionary *_confirmScheduleNewTalkingGroupParamMap = [[NSMutableDictionary alloc] init];
        
        // set some params
        [_confirmScheduleNewTalkingGroupParamMap setObject:_mNew6SelectedContacts4Adding2TalkingGroupId forKey:NSRBGServerFieldString(@"remote background server http request get my talking groups or new talking group id response id", nil)];
        [_confirmScheduleNewTalkingGroupParamMap setObject:[[self generateNewTalkingGroup6InviteNewAddedAttendeesInfoJSONArray] JSONString] forKey:NSRBGServerFieldString(@"remote background server http request schedule new talking group or invite new added contacts to talking group attendees", nil)];
        
        // check the comparison result again
        if (NSOrderedSame == _comparisonResult) {
            // create and start an new talking group immediately
            NSLog(@"create and start new talking group immediately");
            
            // init confirm schedule new talking group http request url
            _confirmScheduleNewTalkingGroupUrl = [NSString stringWithFormat:NSUrlString(@"create and start new talking group url format string", nil), NSUrlString(@"remote background server root url string", nil)];
        }
        else if (NSOrderedDescending == _comparisonResult) {
            // schedule an new talking group at selected started time
            NSLog(@"schedule an new talking group at selected time = %@", [_mNewTalkingGroupStartedTimeSelectDatePicker.date stringWithFormat:@"yyyy-MM-dd HH:mm"]);
            
            // init confirm schedule new talking group http request url
            _confirmScheduleNewTalkingGroupUrl = [NSString stringWithFormat:NSUrlString(@"schedule new talking group url format string", nil), NSUrlString(@"remote background server root url string", nil)];
            
            // complete confirm schedule new talking group param
            [_confirmScheduleNewTalkingGroupParamMap setObject:[_mNewTalkingGroupStartedTimeSelectDatePicker.date stringWithFormat:@"yyyy-MM-dd HH:mm"] forKey:NSRBGServerFieldString(@"remote background server http request schedule new talking group scheduled time", nil)];
        }
        
        // post the http request
        [HttpUtils postSignatureRequestWithUrl:_confirmScheduleNewTalkingGroupUrl andPostFormat:urlEncoded andParameter:_confirmScheduleNewTalkingGroupParamMap andUserInfo:nil andRequestType:asynchronous andProcessor:self andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
    }
}

- (void)cancelScheduleNewTalkingGroup{
    // dismiss new talking group started time select popup window
    [_mNewTalkingGroupStartedTimeSelectPopupWindow dismiss];
}

- (NSArray *)generateNewTalkingGroup6InviteNewAddedAttendeesInfoJSONArray{
    // define new talking group or invite new added attendees info json array
    NSMutableArray *_newTalkingGroup6InviteNewAddedAttendeesInfoJSONArray = [[NSMutableArray alloc] init];
    
    // process each prein talking group contact
    for (int index = 0; index < [[self preinTalkingGroupContactsInfoArray] count]; index++) {
        // get each prein talking group contact
        ContactBean *_preinTalkingGroupContact = [[self preinTalkingGroupContactsInfoArray] objectAtIndex:index];
        
        // generate prein talking group contact JSONObject
        NSMutableDictionary *_preinTalkingGroupContactJSONObject = [[NSMutableDictionary alloc] init];
        
        // put prein talking group contact name and selected phone
        [_preinTalkingGroupContactJSONObject setObject:_preinTalkingGroupContact.displayName forKey:NSRBGServerFieldString(@"remote background server http request schedule new talking group or invite new added attendee nickname", nil)];
        [_preinTalkingGroupContactJSONObject setObject:_preinTalkingGroupContact.selectedPhoneNumber forKey:NSRBGServerFieldString(@"remote background server http request schedule new talking group or invite new added attendee phone", nil)];
        
        // add prein talking group contact JSONObject to new talking group or invite new added attendees JSONArray
        [_newTalkingGroup6InviteNewAddedAttendeesInfoJSONArray addObject:_preinTalkingGroupContactJSONObject];
    }
    
    return _newTalkingGroup6InviteNewAddedAttendeesInfoJSONArray;
}

- (void)scheduleNewTalkingGroupHttpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send schedule new talking group http request succeed - request url = %@, response status code = %d and data string = %@", pRequest.url, [pRequest responseStatusCode], pRequest.responseString);
    
    // check status code
    if (201 == [pRequest responseStatusCode]) {
        // dismiss new talking group started time select popup window
        [_mNewTalkingGroupStartedTimeSelectPopupWindow dismiss];
        
        // finish contacts selecting
        [((SimpleIMeetingContentContainerView *)self.superview) back2MyTalkingGroups7AttendeesContentView4EndingAddSelectedContact4Inviting:REFRESH_TALKINGGROUPS];
        
        // send invite short message to all attendees of the scheduled new talking group
        [self sendInviteSMS:[self generateNewTalkingGroup6InviteNewAddedAttendeesInfoJSONArray] body:_mNewTalkingGroupInviteNoteLabel.text];
    }
    else {
        NSLog(@"Error, schedule new talking group failed, remote background server refuse");
        
        // show toast
        [[iToast makeText:NSToastLocalizedString(@"toast remote background server can't accept to schedule new talking group", nil)] show:iToastTypeError];
    }
}

- (void)inviteNewAddedAttendees2TalkingGroupHttpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send invite new added attendees to the talking group http request succeed - request url = %@, response status code = %d and data string = %@", pRequest.url, [pRequest responseStatusCode], pRequest.responseString);
    
    // check status code
    if (200 == [pRequest responseStatusCode]) {
        //
        
        // finish contacts selecting
        [self cancel6finishContactsSelecting];
    }
    else {
        //
    }
}

@end
