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

#import "UIWindow+AsyncHttpReqMBProgressHUD.h"

// add temp added contact popup window present content view margin bottom
#define ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_MARGINBOTTOM   226.0

// add temp added contact popup window present content view and its subview width, height
#define ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CANCELADDBUTTON_WIDTH7HEIGHT   14.0
#define ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_TEMPADDEDCONTACTPHONETEXTFIELD_HEIGHT 28.0
#define ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CONFIRMADDBUTTON_WIDTH 80.0
#define ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CONFIRMADDBUTTON_HEIGHT    32.0
#define ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_WIDTH  240.0
#define ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_HEIGHT 120.0

// add temp added contact popup window present content view subview margin and padding
#define ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_MARGIN 6.0
#define ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_PADDING    16.0

// temp added contact phone text field text font size
#define TEMPADDEDCONTACTPHONETEXTFIELDTEXTFONTSIZE  14.0

// new talking group started time select popup window present content view and its subview height
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_TITLELABEL_HEIGHT 30.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_INVITENOTELABEL6COPYBUTTON_HEIGHT 58.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_DATEPICKER_HEIGHT 180.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_CONTROLLERBUTTON_HEIGHT   34.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_HEIGHT    320.0

// new talking group started time select popup window present content view subview padding
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_PADDING    6.0

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

// confirm add temp added contact to selected contact list view
- (void)confirmAddTempAddedContact2SelectedContactListView;

// cancel add temp added contact to selected contact list view
- (void)cancelAddTempAddedContact2SelectedContactListView;

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

// generate new talking group or invite new atted attendees phone array as invite sms recipients
- (NSArray *)generateNewTalkingGroup6InviteNewAddedAttendeesInviteSMSRecipients;

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

- (void)addTempAddedContact2SelectedContactListView:(void (^)(ContactBean *))confirmCompletion{
    // save add temp added contact confirm completion block
    _mConfirmAddTempAddedContactCompletionBlock = confirmCompletion;
    
    // check add temp added contact popup window
    if (nil == _mAddTempAddedContactPopupWindow) {
        // init add temp added contact popup window
        _mAddTempAddedContactPopupWindow = [[UIPopupWindow alloc] init];
        
        // define add temp added contact popup window present content view
        UIView *_presentContentView;
        
        // init add temp added contact popup window present content view
        _presentContentView = [_presentContentView = [UIView alloc] initWithFrame:CGRectMakeWithFormat(_presentContentView, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+(%s-%d)/2", (int)_mAddTempAddedContactPopupWindow.bounds.origin.x, FILL_PARENT_STRING, (int)ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_WIDTH] cStringUsingEncoding:NSUTF8StringEncoding]], [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+(%s-%d)", (int)_mAddTempAddedContactPopupWindow.bounds.origin.y, FILL_PARENT_STRING, (int)(ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_MARGINBOTTOM + ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_HEIGHT)] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_WIDTH], [NSNumber numberWithFloat:ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_HEIGHT])];
        
        // set its background color
        _presentContentView.backgroundColor = [UIColor blackColor];
        
        // set corner radius and border
        [_presentContentView setCornerRadius:5.0];
        [_presentContentView setBorderWithWidth:1.0 andColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
        
        // init add temp added contact popup window present content view cancel add button
        UIButton *_cancelAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        [_cancelAddButton setFrame:CGRectMakeWithFormat(_cancelAddButton, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+(%s-%d-%d)", (int)_presentContentView.bounds.origin.x, FILL_PARENT_STRING, (int)ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_MARGIN, (int)ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CANCELADDBUTTON_WIDTH7HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:_presentContentView.bounds.origin.y + ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_MARGIN], [NSNumber numberWithFloat:ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CANCELADDBUTTON_WIDTH7HEIGHT], [NSNumber numberWithFloat:ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CANCELADDBUTTON_WIDTH7HEIGHT])];
        
        // set its title for normal state
        [_cancelAddButton setTitle:@"×" forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_cancelAddButton addTarget:self action:@selector(cancelAddTempAddedContact2SelectedContactListView) forControlEvents:UIControlEventTouchUpInside];
        
        // init temp added contact phone text field
        _mTempAddedContactPhoneTextField = [_mTempAddedContactPhoneTextField = [UITextField alloc] initWithFrame:CGRectMakeWithFormat(_mTempAddedContactPhoneTextField, [NSNumber numberWithFloat:_presentContentView.bounds.origin.x + 3 * ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_MARGIN + ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CANCELADDBUTTON_WIDTH7HEIGHT], [NSNumber numberWithFloat:_presentContentView.bounds.origin.y + ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_MARGIN + ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CANCELADDBUTTON_WIDTH7HEIGHT + ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_PADDING], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-6*%d-2*%d", FILL_PARENT_STRING, (int)ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_MARGIN, (int)ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CANCELADDBUTTON_WIDTH7HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_TEMPADDEDCONTACTPHONETEXTFIELD_HEIGHT])];
        
        // set contact search text field border style, content vertical alignment, clear button, keyboard type, text font and placeholder
        _mTempAddedContactPhoneTextField.borderStyle = UITextBorderStyleRoundedRect;
        _mTempAddedContactPhoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _mTempAddedContactPhoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _mTempAddedContactPhoneTextField.keyboardType = UIKeyboardTypePhonePad;
        _mTempAddedContactPhoneTextField.font = [UIFont systemFontOfSize:TEMPADDEDCONTACTPHONETEXTFIELDTEXTFONTSIZE];
        _mTempAddedContactPhoneTextField.placeholder = NSLocalizedString(@"temp added contact phone text field placeholder", nil);
        
        // init add temp added contact popup window present content view confirm add button
        UIButton *_confirmAddButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_confirmAddButton setFrame:CGRectMakeWithFormat(_confirmAddButton, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+(%s-%d)/2", (int)_presentContentView.bounds.origin.x, FILL_PARENT_STRING, (int)ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CONFIRMADDBUTTON_WIDTH] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:_presentContentView.bounds.origin.y + ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_MARGIN + ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CANCELADDBUTTON_WIDTH7HEIGHT + ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_TEMPADDEDCONTACTPHONETEXTFIELD_HEIGHT + 2 * ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_PADDING], [NSNumber numberWithFloat:ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CONFIRMADDBUTTON_WIDTH], [NSNumber numberWithFloat:ADDTEMPADDEDCONTACTPOPUPWINDOWPRESENTCONTENTVIEW_CONFIRMADDBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_confirmAddButton setTitle:NSLocalizedString(@"confirm add temp added contact button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_confirmAddButton addTarget:self action:@selector(confirmAddTempAddedContact2SelectedContactListView) forControlEvents:UIControlEventTouchUpInside];
        
        // add cancel add button, temp added contact phone text field and confirm add button as subviews of add temp added contact present content view
        [_presentContentView addSubview:_cancelAddButton];
        [_presentContentView addSubview:_mTempAddedContactPhoneTextField];
        [_presentContentView addSubview:_confirmAddButton];
        
        // set its present content view
        _mAddTempAddedContactPopupWindow.presentContentView = _presentContentView;
    }
    else {
        // clear temp added contact phone text field text
        _mTempAddedContactPhoneTextField.text = nil;
    }
    
    // show temp added contact phone text field keyboard
    [_mTempAddedContactPhoneTextField becomeFirstResponder];
    
    // show add temp added contact popup window
    [_mAddTempAddedContactPopupWindow showAtLocation:self];
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
    // show asynchronous http request progress view
    [self.window showMBProgressHUD];
    
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
    
    // judge sms supply of the device
    if([MFMessageComposeViewController canSendText]){
        NSLog(@"send invite short message to all attendees = %@ of talking group and invite note = %@", recipients, body);
        
        // init invite short message compose view controller
        MFMessageComposeViewController *_inviteShortMessageComposeViewController = [[MFMessageComposeViewController alloc] init];
        
        // set invite short message recipients and body
        _inviteShortMessageComposeViewController.recipients = recipients;
        _inviteShortMessageComposeViewController.body = body;
        
        // message compose delegate
        _inviteShortMessageComposeViewController.messageComposeDelegate = self;
        
        // present invite short message compose view controller
        [self.superview.viewControllerRef presentModalViewController:_inviteShortMessageComposeViewController animated:YES];
    }
    else{
        // show the device not support sms alertView
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"device not support sms alertView message", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"device not support sms alertView confirm button title", nil), nil] show];
    }
}

- (void)addMoreAttendees2TalkingGroup{
    // show asynchronous http request progress view
    [self.window showMBProgressHUD];
    
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

- (void)updateTalkingGroupAttendees{
    // generate new talking group
    [self generateNewTalkingGroup];
}

// IHttpReqRespProtocol
- (void)httpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send http request succeed - request url = %@", pRequest.url);
    
    // hide asynchronous http request progress view
    if (![self.window hideMBProgressHUD]) {
        [_mNewTalkingGroupStartedTimeSelectPopupWindow.window hideMBProgressHUD];
    }
    
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
        NSLog(@"Warning: the request not recognized");
    }
}

- (void)httpRequestDidFailed:(ASIHTTPRequest *)pRequest{
    NSLog(@"send http request failed - request url = %@", pRequest.url);
    
    // hide asynchronous http request progress view
    if (![self.window hideMBProgressHUD]) {
        [_mNewTalkingGroupStartedTimeSelectPopupWindow.window hideMBProgressHUD];
    }
    
    // show toast
    [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil)) show:iToastTypeError];
}

// MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    // check the result
    switch (result) {
        case MessageComposeResultFailed:
            NSLog(@"Error: invite short message send failed");
            
            // show toast
            [[iToast makeText:NSToastLocalizedString(@"toast send inviting all talking group attendees to join the scheduled talking group failed", nil)] show:iToastTypeError];
            break;
            
        case MessageComposeResultCancelled:
        case MessageComposeResultSent:
        default:
            // nothing to do
            break;
    }
    
    // dismiss invite short message compose view controller
    [self.superview.viewControllerRef dismissModalViewControllerAnimated:YES];
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
                _contactListViewDrawRectangle.size.width = _mABContactListView.frame.size.width * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT) + 1.0/*add i pixel*/;
            }
        }
        else {
            // recover as parent view frame size width
            _contactListViewDrawRectangle.size.width = self.frame.size.width;
        }
    }
    
    return _contactListViewDrawRectangle;
}

- (void)confirmAddTempAddedContact2SelectedContactListView{
    // get temp added contact phone number
    NSString *_tempAddedContactPhoneNumber = _mTempAddedContactPhoneTextField.text;
    
    // check temp added contact phone number
    if (nil == _tempAddedContactPhoneNumber || [@"" isEqualToString:_tempAddedContactPhoneNumber]) {
        NSLog(@"Warning: temp added contact phone number is nil");
        
        // show toast
        [[iToast makeText:NSToastLocalizedString(@"toast manual input contact for inviting to talking group whose phone number is null", nil)] show:iToastTypeWarning];
    }
    else {
        // get address book manager
        AddressBookManager *_addressBookManager = [AddressBookManager shareAddressBookManager];
        
        // check temp added contact with phone number is in address book
        NSNumber *_tempAddedContactId = [_addressBookManager isContactWithPhoneInAddressBook:_tempAddedContactPhoneNumber];
        if (nil == _tempAddedContactId) {
            // define temp added contact is or not in prein talking group contacts flag and existed object
            BOOL _isExisted = NO;
            ContactBean *_existedTempContact = nil;
            
            // process each prein talking group contact
            for (ContactBean *_preinTalkingGroupContact in [self preinTalkingGroupContactsInfoArray]) {
                // check prein talking group contact is and selected phone number
                if (-1 == _preinTalkingGroupContact.id && [_tempAddedContactPhoneNumber isEqualToString:_preinTalkingGroupContact.selectedPhoneNumber]) {
                    _isExisted = YES;
                    _existedTempContact = _preinTalkingGroupContact;
                    
                    break;
                }
            }
            
            // check temp added contact is or not in prein talking group contacts
            if (_isExisted) {
                NSLog(@"Warning: temp added contact = %@ with user input phone number = %@ has been existed in prein talking group contacts", _existedTempContact, _tempAddedContactPhoneNumber);
                
                // dismiss add temp added contact popup window
                [_mAddTempAddedContactPopupWindow dismiss];
                
                // show toast
                [[iToast makeText:[NSString stringWithFormat:@"%@%@", _existedTempContact.displayName, NSToastLocalizedString(@"toast selected contact existed in prein talking group contacts with the selected phone", nil)]] show:iToastTypeWarning];
            }
            else {
                // generate new temp added contact
                ContactBean *_newTempAddedContact = [[ContactBean alloc] init];
                
                // init new temp added contact
                // set id
                _newTempAddedContact.id = -1;
                // set display name
                _newTempAddedContact.displayName = _tempAddedContactPhoneNumber;
                // set phone numbers
                _newTempAddedContact.phoneNumbers = [NSArray arrayWithObject:_tempAddedContactPhoneNumber];
                
                // mark new temp added contact be selected
                _newTempAddedContact.isSelected = YES;
                _newTempAddedContact.selectedPhoneNumber = _tempAddedContactPhoneNumber;
                
                // dismiss add temp added contact popup window
                [_mAddTempAddedContactPopupWindow dismiss];
                
                // confirm add temp added contact completion
                _mConfirmAddTempAddedContactCompletionBlock(_newTempAddedContact);
            }
        }
        else {
            // get the matched contact
            ContactBean *_matchedContact = [_addressBookManager getContactInfoById:_tempAddedContactId.integerValue];
            
            // check the matched contact is or not be selected
            if (_matchedContact.isSelected) {
                NSLog(@"Warning: contact = %@ with %@ has been existed in prein talking group contacts", _matchedContact, [_tempAddedContactPhoneNumber isEqualToString:_matchedContact.selectedPhoneNumber] ? [NSString stringWithFormat:@"user input phone number = %@", _tempAddedContactPhoneNumber] : [NSString stringWithFormat:@"another phone number = %@", _matchedContact.selectedPhoneNumber]);
                
                // dismiss add temp added contact popup window
                [_mAddTempAddedContactPopupWindow dismiss];
                
                // show toast
                [[iToast makeText:[NSString stringWithFormat:@"%@%@", _matchedContact.displayName, [_tempAddedContactPhoneNumber isEqualToString:_matchedContact.selectedPhoneNumber] ? NSToastLocalizedString(@"toast selected contact existed in prein talking group contacts with the selected phone", nil) : NSToastLocalizedString(@"toast selected contact existed in prein talking group contacts with another phone", nil)]] show:iToastTypeWarning];
            }
            else {
                // mark the matched contact be selected
                _matchedContact.isSelected = YES;
                _matchedContact.selectedPhoneNumber = _tempAddedContactPhoneNumber;
                
                // dismiss add temp added contact popup window
                [_mAddTempAddedContactPopupWindow dismiss];
                
                // confirm add temp added contact completion
                _mConfirmAddTempAddedContactCompletionBlock(_matchedContact);
            }
        }
    }
}

- (void)cancelAddTempAddedContact2SelectedContactListView{
    // dismiss add temp added contact popup window
    [_mAddTempAddedContactPopupWindow dismiss];
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
            // show toast
            [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil)) show:iToastTypeError];
        }
    }
    else {
        // show toast
        [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil)) show:iToastTypeError];
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
        UILabel *_presentContentViewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_presentContentView.bounds.origin.x, _presentContentView.bounds.origin.y, FILL_PARENT, NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_TITLELABEL_HEIGHT)];
        
        // set its attributes
        _presentContentViewTitleLabel.text = NSLocalizedString(@"new talking group started time select popup window title label text", nil);
        _presentContentViewTitleLabel.textColor = [UIColor whiteColor];
        _presentContentViewTitleLabel.textAlignment = NSTextAlignmentCenter;
        _presentContentViewTitleLabel.font = [UIFont boldSystemFontOfSize:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWTITLELABELTEXTFONTSIZE];
        _presentContentViewTitleLabel.backgroundColor = [UIColor clearColor];
        
        // init new talking group started time select popup window present content view invite note label
        _mNewTalkingGroupInviteNoteLabel = [_mNewTalkingGroupInviteNoteLabel = [UILabel alloc] initWithFrame:CGRectMakeWithFormat(_mNewTalkingGroupInviteNoteLabel, [NSNumber numberWithFloat:_presentContentView.bounds.origin.x + NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_PADDING], [NSNumber numberWithFloat:_presentContentView.bounds.origin.y + _presentContentViewTitleLabel.frame.size.height], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-4*%d-%d", FILL_PARENT_STRING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_PADDING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_INVITENOTELABEL6COPYBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_INVITENOTELABEL6COPYBUTTON_HEIGHT])];
        
        // set its attributes
        _mNewTalkingGroupInviteNoteLabel.text = TALKINGGROUPINVITENOTE(_mNewTalkingGroupStartedTimeSelectDatePicker.date, _mNew6SelectedContacts4Adding2TalkingGroupId);
        _mNewTalkingGroupInviteNoteLabel.textColor = [UIColor whiteColor];
        _mNewTalkingGroupInviteNoteLabel.font = [UIFont systemFontOfSize:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABELTEXTFONTSIZE];
        _mNewTalkingGroupInviteNoteLabel.numberOfLines = 0;
        _mNewTalkingGroupInviteNoteLabel.backgroundColor = [UIColor clearColor];
        
        // init new talking group invite note copy button
        UIButton *_copyNewTalkingGroupInviteNoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_copyNewTalkingGroupInviteNoteButton setFrame:CGRectMakeWithFormat(_copyNewTalkingGroupInviteNoteButton, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%s-%d-%d", (int)_presentContentView.bounds.origin.x, FILL_PARENT_STRING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_PADDING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_INVITENOTELABEL6COPYBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:_presentContentView.bounds.origin.y + _presentContentViewTitleLabel.frame.size.height], [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_INVITENOTELABEL6COPYBUTTON_HEIGHT], [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_INVITENOTELABEL6COPYBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_copyNewTalkingGroupInviteNoteButton setTitle:NSLocalizedString(@"new talking group invite note copy button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_copyNewTalkingGroupInviteNoteButton addTarget:self action:@selector(copyNewTalkingGroupInviteNote2Pasteboard) forControlEvents:UIControlEventTouchUpInside];
        
        // set new talking group started time select popup window present content view date picker frame
        [_mNewTalkingGroupStartedTimeSelectDatePicker setFrame:CGRectMake(_presentContentView.bounds.origin.x, _presentContentView.bounds.origin.y + _presentContentViewTitleLabel.frame.size.height + _mNewTalkingGroupInviteNoteLabel.frame.size.height + NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_PADDING, FILL_PARENT, NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_DATEPICKER_HEIGHT)];
        
        // add its date changed target and action selector
        [_mNewTalkingGroupStartedTimeSelectDatePicker addTarget:self action:@selector(newTalkingGroupStartedTimeSelectDatePickerDateChanged) forControlEvents:UIControlEventValueChanged];
        
        // new talking group started time select popup window present content view controller button origin y number and width value
        NSNumber *_newTalkingGroupStartedTimeSelectPopupWindowControllerButtonOriginYNumber = [NSNumber numberWithFloat:_presentContentView.bounds.origin.y + _presentContentViewTitleLabel.frame.size.height + _mNewTalkingGroupInviteNoteLabel.frame.size.height + _mNewTalkingGroupStartedTimeSelectDatePicker.frame.size.height + 2 * NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_PADDING];
        NSValue *_newTalkingGroupStartedTimeSelectPopupWindowControllerButtonWidthValue = [NSValue valueWithCString:[[NSString stringWithFormat:@"(%s-4*%d)/2", FILL_PARENT_STRING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_PADDING] cStringUsingEncoding:NSUTF8StringEncoding]];
        
        // init confirm schedule new talking group controller button
        UIButton *_confirmScheduleNewTalkingGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_confirmScheduleNewTalkingGroupButton setFrame:CGRectMakeWithFormat(_confirmScheduleNewTalkingGroupButton, [NSNumber numberWithFloat:_presentContentView.bounds.origin.x + NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_PADDING], _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonOriginYNumber, _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonWidthValue, [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_CONTROLLERBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_confirmScheduleNewTalkingGroupButton setTitle:NSLocalizedString(@"confirm schedule new talking group button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_confirmScheduleNewTalkingGroupButton addTarget:self action:@selector(confirmScheduleNewTalkingGroup) forControlEvents:UIControlEventTouchUpInside];
        
        // init cancel schedule new talking group controller button
        UIButton *_cancelScheduleNewTalkingGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_cancelScheduleNewTalkingGroupButton setFrame:CGRectMakeWithFormat(_cancelScheduleNewTalkingGroupButton, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%@+3*%d", (int)_presentContentView.bounds.origin.x, _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonWidthValue.stringValue, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_SUBVIEW_PADDING] cStringUsingEncoding:NSUTF8StringEncoding]], _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonOriginYNumber, _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonWidthValue, [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_CONTROLLERBUTTON_HEIGHT])];
        
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
        [[iToast makeText:NSToastLocalizedString(@"toast new talking group started time selected is too early", nil)] show:iToastTypeWarning];
    }
    else {
        // show asynchronous http request progress view
        [_mNewTalkingGroupStartedTimeSelectPopupWindow.window showMBProgressHUD];
        
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

- (NSArray *)generateNewTalkingGroup6InviteNewAddedAttendeesInviteSMSRecipients{
    // define new talking group or invite new added attendees phone array
    NSMutableArray *_newTalkingGroup6InviteNewAddedAttendeesPhoneArray = [[NSMutableArray alloc] init];
    
    // process each prein talking group contact
    for (int index = 0; index < [[self preinTalkingGroupContactsInfoArray] count]; index++) {
        // put prein talking group contact selected phone to new talking group or invite new added attendees phone array
        [_newTalkingGroup6InviteNewAddedAttendeesPhoneArray addObject:((ContactBean *)[[self preinTalkingGroupContactsInfoArray] objectAtIndex:index]).selectedPhoneNumber];
    }
    
    return _newTalkingGroup6InviteNewAddedAttendeesPhoneArray;
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
        
        // get new talking group invite sms recipients
        NSArray *_inviteSMSRecipients = [self generateNewTalkingGroup6InviteNewAddedAttendeesInviteSMSRecipients];
        
        // finish contacts selecting
        [((SimpleIMeetingContentContainerView *)self.superview) back2MyTalkingGroups7AttendeesContentView4EndingAddSelectedContact4Inviting:REFRESH_TALKINGGROUPS];
        
        // send invite short message to all attendees of the scheduled new talking group
        [self sendInviteSMS:_inviteSMSRecipients body:_mNewTalkingGroupInviteNoteLabel.text];
    }
    else {
        NSLog(@"Error, schedule new talking group failed, remote background server refuse");
        
        // show toast
        [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast remote background server can't accept to schedule new talking group", nil)) show:iToastTypeError];
    }
}

- (void)inviteNewAddedAttendees2TalkingGroupHttpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send invite new added attendees to the talking group http request succeed - request url = %@, response status code = %d and data string = %@", pRequest.url, [pRequest responseStatusCode], pRequest.responseString);
    
    // check status code
    if (200 == [pRequest responseStatusCode]) {
        // get invite new atted attendees invite sms recipients
        NSArray *_inviteSMSRecipients = [self generateNewTalkingGroup6InviteNewAddedAttendeesInviteSMSRecipients];
        
        // finish contacts selecting
        [((SimpleIMeetingContentContainerView *)self.superview) back2MyTalkingGroups7AttendeesContentView4EndingAddSelectedContact4Inviting:REFRESH_SELECTEDTALKINGGROUP_ATTENDEES];
        
        // send invite short message to all attendees of the scheduled new talking group
        [self sendInviteSMS:_inviteSMSRecipients body:_mSelectedContacts4Adding2TalkingGroupInviteNote];
    }
    else {
        // show toast
        [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil)) show:iToastTypeError];
    }
}

@end
