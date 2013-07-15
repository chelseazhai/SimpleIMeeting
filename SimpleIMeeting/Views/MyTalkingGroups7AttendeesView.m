//
//  MyTalkingGroups7AttendeesView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "MyTalkingGroups7AttendeesView.h"

#import "MyTalkingGroupListView.h"
#import "SelectedTalkingGroupAttendeeListView.h"

#import "SimpleIMeetingContentContainerView.h"

// no talking group tip label width, height weight and my talking groups and selected talking group attendees view total weight
#define NOTALKINGGROUPTIPLABEL_WIDTHWEIGHT  7
#define NOTALKINGGROUPTIPLABEL_HEIGHTWEIGHT 2
#define MYTALKINGGROUPS7ATTENDEESVIEW_TOTALSUMWEIGHT 10.0

@interface MyTalkingGroups7AttendeesView ()

// connect my account soctet IO to notify server
- (void)connectMyAccountSoctetIO2NotifyServer;

// generate my talking group list view draw rectangle with has one talking group be selected flag
- (CGRect)genMyTalkingGroupListViewDrawRect:(BOOL)hasOneTalkingGroupBeSelected;

@end

@implementation MyTalkingGroups7AttendeesView

@synthesize myTalkingGroupsNeed2Refresh = _mMyTalkingGroupsNeed2Refresh;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background image
        self.backgroundImg = [UIImage compatibleImageNamed:@"img_mytalkinggroups7attendeesview_bg"];
        
        // init my socket IO and make my socket IO need to reconnect again when disconnect or connect error
        _mMyAccountSocketIO = [[SocketIO alloc] initWithDelegate:self];
        _mMySocketIONeed2Reconnect = YES;
        
        // connect my account soctet IO to notify server
        [self connectMyAccountSoctetIO2NotifyServer];
        
        // create and init subviews
        // init my talking groups loading indicator view
        _mMyTalkingGroupsLoadingIndicatorView = [[UIDataLoadingIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge tip:NSLocalizedString(@"my talking groups loading tip", nil)];
        
        // set its frame
        [_mMyTalkingGroupsLoadingIndicatorView setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT)];
        
        // init no talking group tip label
        _mNoTalkingGroupTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + FILL_PARENT * (MYTALKINGGROUPS7ATTENDEESVIEW_TOTALSUMWEIGHT - NOTALKINGGROUPTIPLABEL_WIDTHWEIGHT) / (2 * MYTALKINGGROUPS7ATTENDEESVIEW_TOTALSUMWEIGHT), self.bounds.origin.y + FILL_PARENT * (NOTALKINGGROUPTIPLABEL_HEIGHTWEIGHT / (3 * MYTALKINGGROUPS7ATTENDEESVIEW_TOTALSUMWEIGHT)), FILL_PARENT * (NOTALKINGGROUPTIPLABEL_WIDTHWEIGHT / MYTALKINGGROUPS7ATTENDEESVIEW_TOTALSUMWEIGHT), FILL_PARENT * (NOTALKINGGROUPTIPLABEL_HEIGHTWEIGHT / MYTALKINGGROUPS7ATTENDEESVIEW_TOTALSUMWEIGHT))];
        
        // set its attributes
        _mNoTalkingGroupTipLabel.text = NSLocalizedString(@"no talking group tip label Text", nil);
        _mNoTalkingGroupTipLabel.backgroundColor = [UIColor clearColor];
        
        // hidden first
        _mNoTalkingGroupTipLabel.hidden = YES;
        
        // init my talking group list view
        _mMyTalkingGroupListView = [[MyTalkingGroupListView alloc] initWithFrame:[self genMyTalkingGroupListViewDrawRect:NO]];
        
        // hidden first
        _mMyTalkingGroupListView.hidden = YES;
        
        // init selected talking group attendee list view
        _mSelectedTalkingGroupAttendeeListView = [[SelectedTalkingGroupAttendeeListView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + FILL_PARENT * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), self.bounds.origin.y, FILL_PARENT * (RIGHTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), FILL_PARENT)];
        
        // hidden first
        _mSelectedTalkingGroupAttendeeListView.hidden = YES;
        
        // add my talking groups loading indicator view, no talking group tip label, my talking group list view and selected talking group attendee list view as subviews of my talking groups and selected talking group attendees view
        [self addSubview:_mMyTalkingGroupsLoadingIndicatorView];
        [self addSubview:_mNoTalkingGroupTipLabel];
        [self addSubview:_mMyTalkingGroupListView];
        [self addSubview:_mSelectedTalkingGroupAttendeeListView];
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

- (void)setSelectedTalkingGroupAttendeesInfoArray:(NSArray *)selectedTalkingGroupAttendeesInfoArray{
    // reload selected talking group attendee list table view data source with selected talking group is opened flag
    [_mSelectedTalkingGroupAttendeeListView loadSelectedTalkingGroupAttendeeListTableViewDataSource:selectedTalkingGroupAttendeesInfoArray selectedTalkingGroupOpened:[NSRBGServerFieldString(@"remote background server http request get my talking groups response info list talking group open status", nil) isEqualToString:[_mMyTalkingGroupListView.selectedTalkingGroupJSONObjectInfo objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups response info list talking group status", nil)]]];
}

- (NSArray *)selectedTalkingGroupAttendeesInfoArray{
    return _mSelectedTalkingGroupAttendeeListView.selectedTalkingGroupAttendeesInfoArray;
}

- (void)refreshMyTalkingGroups{
    // set my talking group list table view not need to refresh
    _mMyTalkingGroupsNeed2Refresh = NO;
    
    // check my talking groups loading indicator view if is or not animating
    if (!_mMyTalkingGroupsLoadingIndicatorView.isAnimating) {
        // prepare to refresh my talking group list table view data source
        [_mMyTalkingGroupsLoadingIndicatorView startAnimating];
        if (![_mNoTalkingGroupTipLabel isHidden]) {
            _mNoTalkingGroupTipLabel.hidden = YES;
        }
        if (![_mMyTalkingGroupListView isHidden]) {
            _mMyTalkingGroupListView.hidden = YES;
        }
    }
    
    // load my talking group list table view data source
    [_mMyTalkingGroupListView loadMyTalkingGroupListTableViewDataSource:^(NSInteger result) {
        // stop my talking groups loading indicator view animating
        [_mMyTalkingGroupsLoadingIndicatorView stopAnimating];
        
        // check load my talking group list table view data source result
        if (0 == result) {
            // check my talking groups info array
            if (0 == [_mMyTalkingGroupListView.myTalkingGroupsInfoArray count]) {
                // update no talking group tip label number of lines and show it if needed
                if ([_mNoTalkingGroupTipLabel isHidden]) {
                    // get no talking group tip label number of lines float
                    float _numberOfLinesFloat = [_mNoTalkingGroupTipLabel.text stringPixelLengthByFontSize:_mNoTalkingGroupTipLabel.font.pointSize andIsBold:NO] / _mNoTalkingGroupTipLabel.bounds.size.width;
                    
                    // update no talking group tip label number of lines
                    _mNoTalkingGroupTipLabel.numberOfLines = (int)_numberOfLinesFloat < _numberOfLinesFloat ? (int)_numberOfLinesFloat + 1 : (int)_numberOfLinesFloat;
                    
                    // show it
                    _mNoTalkingGroupTipLabel.hidden = NO;
                }
            }
            else {
                // show my talking group list table view if needed
                if ([_mMyTalkingGroupListView isHidden]) {
                    _mMyTalkingGroupListView.hidden = NO;
                }
            }
        }
        else {
            // show my talking group list table view if needed
            if ([_mMyTalkingGroupListView isHidden]) {
                _mMyTalkingGroupListView.hidden = NO;
            }
        }
    }];
}

- (void)resizeMyTalkingGroupsAndAttendeesView:(BOOL)hasOneTalkingGroupBeSelected{
    // update my talking group list view frame
    [_mMyTalkingGroupListView setFrame:[self genMyTalkingGroupListViewDrawRect:hasOneTalkingGroupBeSelected]];
    
    // show selected talking group attendee list view if needed
    if (hasOneTalkingGroupBeSelected && [_mSelectedTalkingGroupAttendeeListView isHidden]) {
        _mSelectedTalkingGroupAttendeeListView.hidden = NO;
    }
    
    // hide selected talking group attendee list view if needed
    if (!hasOneTalkingGroupBeSelected && ![_mSelectedTalkingGroupAttendeeListView isHidden]) {
        _mSelectedTalkingGroupAttendeeListView.hidden = YES;
    }
}

- (void)reconnectMyAccountSoctetIO2NotifyServer{
    // stop first and connect again
    // fake to disconnect my socket io
    [_mMyAccountSocketIO disconnect];
}

- (void)stopGetMyAccountNoticeFromNotifyServer{
    // set my socket io not need to reconnect
    _mMySocketIONeed2Reconnect = NO;
    
    // disconnect my socket io
    [_mMyAccountSocketIO disconnect];
}

- (void)refreshSelectedTalkingGroupAttendees{
    // load the selected talking group attendee list table view data source
    [_mMyTalkingGroupListView loadSelectedTalkingGroupAttendeeListTableViewDataSource];
}

// ITalkingGroupGeneratorProtocol
- (void)generateNewTalkingGroup{
    // switch to contacts select content view for adding selected contact for inviting to talking group
    [((SimpleIMeetingContentContainerView *)self.superview) switch2ContactsSelectContentView4AddingSelectedContact4Inviting:nil];
}

- (void)cancelGenTalkingGroup{
    // back to my talking groups and selected talking group attendees content view for ending add selected contact for inviting to talking group
    [((SimpleIMeetingContentContainerView *)self.superview) back2MyTalkingGroups7AttendeesContentView4EndingAddSelectedContact4Inviting:NOREFRESH];
}

- (void)updateTalkingGroupAttendees{
    // define selected talking group id, invite note and attendees phone array
    NSMutableArray *_selectedTalkingGroupId7InviteNote7AttendeesPhoneArray = [[NSMutableArray alloc] init];
    
    // add selected talking group id and started time timestamp
    [_selectedTalkingGroupId7InviteNote7AttendeesPhoneArray addObject:[_mMyTalkingGroupListView.selectedTalkingGroupJSONObjectInfo objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups or new talking group id response id", nil)]];
    [_selectedTalkingGroupId7InviteNote7AttendeesPhoneArray addObject:[_mMyTalkingGroupListView.selectedTalkingGroupJSONObjectInfo objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups response info list talking group started time timestamp", nil)]];
    
    // process each selected talking group attendees info array
    for (int index = 0; index < [[self selectedTalkingGroupAttendeesInfoArray] count]; index++) {
        // get selected talking group attendee phone and add it to selected talking group id, invite note and attendees phone array
        [_selectedTalkingGroupId7InviteNote7AttendeesPhoneArray addObject:[[[self selectedTalkingGroupAttendeesInfoArray] objectAtIndex:index] objectForKey:NSRBGServerFieldString(@"remote background server http request get selected talking group attendees response info list phone", nil)]];
    }
    
    // switch to contacts select content view for adding selected contact for inviting to talking group
    [((SimpleIMeetingContentContainerView *)self.superview) switch2ContactsSelectContentView4AddingSelectedContact4Inviting:_selectedTalkingGroupId7InviteNote7AttendeesPhoneArray];
}

// SocketIODelegate
- (void)socketIODidConnect:(SocketIO *)socket{
    // send subscribe event
    // generate subscribe event data
    NSMutableDictionary *_subscribeEventData = [[NSMutableDictionary alloc] init];
    
    // get user name and set it as subscribe and topic
    NSString *_userName = [UserManager shareUserManager].userBean.name;
    [_subscribeEventData setObject:_userName forKey:NSRBGServerFieldString(@"my account socket io notifier subscribe event data subscriber id", nil)];
    [_subscribeEventData setObject:_userName forKey:NSRBGServerFieldString(@"my account socket io notifier subscribe event data topic", nil)];
    
    NSLog(@"subscribe event data = %@", _subscribeEventData);
    
    // send event
    [socket sendEvent:NSRBGServerFieldString(@"my account socket io notifier subscribe event", nil) withData:_subscribeEventData];
}

- (void)socketIODidConnectError:(SocketIO *)socket error:(NSString *)errorMsg{
    NSLog(@"socket = %@ did connect error = %@,%@need to reconnect", socket, errorMsg, _mMySocketIONeed2Reconnect ? @" " : @" not ");
    
    // check my socket io if or not need to reconnect
    if (_mMySocketIONeed2Reconnect) {
        [self connectMyAccountSoctetIO2NotifyServer];
    }
}

- (void)socketIODidDisconnect:(SocketIO *)socket{
    NSLog(@"socket = %@ did disconnect,%@need to reconnect", socket, _mMySocketIONeed2Reconnect ? @" " : @" not ");
    
    // check my socket io if or not need to reconnect
    if (_mMySocketIONeed2Reconnect) {
        [self connectMyAccountSoctetIO2NotifyServer];
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet{
    // get receive event name
    NSString *_eventName = packet.name;
    
    // check receive event name, just process notice event
    if ([NSRBGServerFieldString(@"my account socket io notifier notice event", nil) isEqualToString:_eventName]) {
        // get notice event arguments
        NSArray *_noticeEventArgs = packet.args;
        
        // get and check notice event command argument
        NSString *_noticeEventCommandArgument = [[_noticeEventArgs objectAtIndex:0] objectForKey:NSRBGServerFieldString(@"my account socket io notifier notice event command argument", nil)];
        if (nil != _noticeEventCommandArgument && ([NSRBGServerFieldString(@"my account socket io notifier notice event cache command", nil) isEqualToString:_noticeEventCommandArgument] || [NSRBGServerFieldString(@"my account socket io notifier notice event notify command", nil) isEqualToString:_noticeEventCommandArgument])) {
            // get notice event notice list argument and process each one by one
            NSArray *_noticeEventNoticeListArgument = [[_noticeEventArgs objectAtIndex:0] objectForKey:NSRBGServerFieldString(@"my account socket io notifier notice event notice list argument", nil)];
            NSLog(@"needed to process notice event notice list = %@", _noticeEventNoticeListArgument);
            
            for (NSDictionary *_noticeEventNotice in _noticeEventNoticeListArgument) {
                // get notice event notice action
                NSString *_noticeEventNoticeAction = [_noticeEventNotice objectForKey:NSRBGServerFieldString(@"my account socket io notifier notice event notice action", nil)];
                
                // check notice event notice action
                if ([NSRBGServerFieldString(@"my account socket io notifier notice event notice update my talking group list action", nil) isEqualToString:_noticeEventNoticeAction]) {
                    // update my talking group list
                    [self refreshMyTalkingGroups];
                }
                else if ([NSRBGServerFieldString(@"my account socket io notifier notice event notice update my talking group attendee list action", nil) isEqualToString:_noticeEventNoticeAction] || [NSRBGServerFieldString(@"my account socket io notifier notice event notice update my talking group attendee status action", nil) isEqualToString:_noticeEventNoticeAction]) {
                    // get notice event notice talking group id
                    NSString *_noticeEventNoticeTalkingGroupId = [_noticeEventNotice objectForKey:NSRBGServerFieldString(@"my account socket io notifier notice event notice talking group id for updating my talking group list or one of my talking group attendee list", nil)];
                    
                    // check selected talking group info and compare its talking group id with notice event notice talking group id
                    if (nil != _mMyTalkingGroupListView.selectedTalkingGroupJSONObjectInfo && [[_mMyTalkingGroupListView.selectedTalkingGroupJSONObjectInfo objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups or new talking group id response id", nil)] isEqualToString:_noticeEventNoticeTalkingGroupId]) {
                        // check notice event notice action again
                        if ([NSRBGServerFieldString(@"my account socket io notifier notice event notice update my talking group attendee list action", nil) isEqualToString:_noticeEventNoticeAction]) {
                            // update one of my talking group attendee list
                            [_mMyTalkingGroupListView notify2reloadSelectedTalkingGroupAttendeeListTableViewDataSource];
                        }
                        else {
                            // update one of my talking group attendee status
                            [_mSelectedTalkingGroupAttendeeListView updateAttendeeStatus:[_noticeEventNotice objectForKey:NSRBGServerFieldString(@"my account socket io notifier notice event notice attendee for updating one of my talking group attendee status", nil)]];
                        }
                    }
                    else {
                        NSLog(@"Warning: need to notice talking group id = %@ not be selected in my talking group list table view", _noticeEventNoticeTalkingGroupId);
                    }
                }
            }
        }
        else {
            NSLog(@"Warning: notice event command = %@ not needed to process", _noticeEventCommandArgument);
        }
    }
    else {
        NSLog(@"Warning: %@ event not needed to process", _eventName);
    }
}

// inner extension
- (void)connectMyAccountSoctetIO2NotifyServer{
    // connect my account socket IO to notify server
    [_mMyAccountSocketIO connectToHost:NSUrlString(@"web socket notify server url", nil) onPort:NSUrlString(@"web socket notify server port", nil).integerValue];
}

- (CGRect)genMyTalkingGroupListViewDrawRect:(BOOL)hasOneTalkingGroupBeSelected{
    CGRect _myTalkingGroupListViewDrawRectangle;
    
    // check my talking group list view if or not init
    if (nil == _mMyTalkingGroupListView) {
        _myTalkingGroupListViewDrawRectangle = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT);
    }
    else {
        // get my talking group list view frame
        _myTalkingGroupListViewDrawRectangle = _mMyTalkingGroupListView.frame;
        
        // check there is  or no one talking group be selected and update my talking group list view draw rectangle width
        if (hasOneTalkingGroupBeSelected) {
            // compare my talking group list view frame size width with its parent view frame size width
            if (self.frame.size.width == _mMyTalkingGroupListView.frame.size.width) {
                _myTalkingGroupListViewDrawRectangle.size.width = _mMyTalkingGroupListView.frame.size.width * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT) + 1.0/*add i pixel*/;
            }
        }
        else {
            // recover as parent view frame size width
            _myTalkingGroupListViewDrawRectangle.size.width = self.frame.size.width;
        }
    }
    
    return _myTalkingGroupListViewDrawRectangle;
}

@end
