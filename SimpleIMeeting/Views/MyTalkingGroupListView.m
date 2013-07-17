//
//  MyTalkingGroupListView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "MyTalkingGroupListView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "SimpleIMeetingTableViewTipView.h"

#import "MyTalkingGroupListTableViewCell.h"

#import "MyTalkingGroups7AttendeesView.h"

#import "UIWindow+AsyncHttpReqMBProgressHUD.h"

// get my talking groups mode
typedef NS_ENUM(NSInteger, GetMyTalkingGroupsMode){
    // reloading and get more my talking groups
    RELOADING_MYTALKINGGROUPS, APPENDMORE_MYTALKINGGROUPS
};

// get my talking groups mode key for request user info
#define GETMYTALKINGGROUPS_GETMODEKEY4REQUESTUSERINFO   @"get my talking groups mode"

// my talking group list table view refresh header view height
#define MYTALKINGGROUPLISTTABLEVIEWREFRESHHEADERVIEW_HEIGHT 300.0

@interface MyTalkingGroupListView ()

// send get my talking groups http request with get mode
- (void)sendGetMyTalkingGroupsHttpRequest:(GetMyTalkingGroupsMode)getMode;

// get my talking groups http request did finished selector
- (void)getMyTalkingGroupsHttpRequestDidFinished:(ASIHTTPRequest *)pRequest;

// done reloading my talking groups
- (void)doneReloadingMyTalkingGroups;

// done appending more my talking groups
- (void)doneAppendingMoreMyTalkingGroups;

// get selected talking group attendees http request did finished selector
- (void)getSelectedTalkingGroupAttendeesHttpRequestDidFinished:(ASIHTTPRequest *)pRequest;

// set selected talking group attendees info array and resize my talking groups and selected talking group attendees view
- (void)setSelectedTalkingGroupAttendeesInfoArrayAnsResizeMyTalkingGroups7AttendeesView:(NSArray *)selectedTalkingGroupAttendeesInfoArray;

@end

@implementation MyTalkingGroupListView

@synthesize myTalkingGroupsInfoArray = _mMyTalkingGroupsJSONInfoArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init my talking groups head tip view
        SimpleIMeetingTableViewTipView *_myTalkingGroupsHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:LeftAlign_TipView andParentView:self];
        
        // set my talking groups head tip view text
        [_myTalkingGroupsHeadTipView setTipViewText:NSLocalizedString(@"my talking groups head tip view text", nil)];
        
        // init my talking group list table view
        _mMyTalkingGroupListTableView = [_mMyTalkingGroupListTableView = [UITableView alloc] initWithFrame:CGRectMakeWithFormat(_mMyTalkingGroupListTableView, [NSNumber numberWithFloat:self.bounds.origin.x], [NSNumber numberWithFloat:self.bounds.origin.y + _myTalkingGroupsHeadTipView.height], [NSNumber numberWithFloat:FILL_PARENT], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)_myTalkingGroupsHeadTipView.height] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // init my talking groups info array
        _mMyTalkingGroupsJSONInfoArray = [[NSMutableArray alloc] init];
        
        // set its background color
        _mMyTalkingGroupListTableView.backgroundColor = [UIColor clearColor];
        
        // set separator style UITableViewCellSeparatorStyleNone
        _mMyTalkingGroupListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // set my talking group list table view dataSource and delegate
        _mMyTalkingGroupListTableView.dataSource = self;
        _mMyTalkingGroupListTableView.delegate = self;
        
        // init my talking group list table view refresh header view
        _mMyTalkingGroupListTableViewRefreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(_mMyTalkingGroupListTableView.bounds.origin.x, -MYTALKINGGROUPLISTTABLEVIEWREFRESHHEADERVIEW_HEIGHT, FILL_PARENT, MYTALKINGGROUPLISTTABLEVIEWREFRESHHEADERVIEW_HEIGHT)];
        
        // set its background color
        _mMyTalkingGroupListTableViewRefreshHeaderView.backgroundColor = [UIColor clearColor];
        
        // set my talking group list table view refresh header view EGO refresh table header delegate
        _mMyTalkingGroupListTableViewRefreshHeaderView.delegate = self;
        
        //  update the last update date
        [_mMyTalkingGroupListTableViewRefreshHeaderView refreshLastUpdatedDate];
        
        // add my talking group list table view refresh header view as subview of my talking group list table view
        [_mMyTalkingGroupListTableView addSubview:_mMyTalkingGroupListTableViewRefreshHeaderView];
        
        // init my talking group list table view append more footer view
        _mMyTalkingGroupListTableViewAppendMoreFooterView = [[AppendMoreTableFooterView alloc] initWithFrame:CGRectMake(_mMyTalkingGroupListTableView.bounds.origin.x, _mMyTalkingGroupListTableView.bounds.origin.y, FILL_PARENT, CGSizeZero.height)];
        
        // set my talking group list table view append more footer view append more footer delegate
        _mMyTalkingGroupListTableViewAppendMoreFooterView.delegate = self;
        
        // add my talking groups head tip view and my talking group list table view as subviews of my talking group list view
        [self addSubview:_myTalkingGroupsHeadTipView];
        [self addSubview:_mMyTalkingGroupListTableView];
        
        // set my talking group list view all subviews auto resizing mask
        for (int _index = 0; _index < [self.subviews count]; _index++) {
            ((UIView *)[self.subviews objectAtIndex:_index]).autoresizingMask = UIViewAutoresizingFlexibleWidth;
        }
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

- (NSDictionary *)selectedTalkingGroupJSONObjectInfo{
    return 0 <= _mSelectedTalkingGroupCellIndex ? [_mMyTalkingGroupsJSONInfoArray objectAtIndex:_mSelectedTalkingGroupCellIndex] : nil;
}

- (void)loadMyTalkingGroupListTableViewDataSource:(void (^)(NSInteger))completion{
    // save loading my talking group list table view data source completion block
    _mLoadMyTalkingGroupListTableViewDataSourceCompletionBlock = completion;
    
    // clear selected talking group cell index
    _mSelectedTalkingGroupCellIndex = -1;
    
    // clear selected talking group attenees info array and resize my talking groups and selected talking group attendees view
    [self setSelectedTalkingGroupAttendeesInfoArrayAnsResizeMyTalkingGroups7AttendeesView:nil];
    
    // send get my talking groups http request
    [self sendGetMyTalkingGroupsHttpRequest:RELOADING_MYTALKINGGROUPS];
}

- (void)loadSelectedTalkingGroupAttendeeListTableViewDataSource{
    // show asynchronous http request progress view
    [self.window showMBProgressHUD];
    
    // get selected talking group attendees
    [self notify2reloadSelectedTalkingGroupAttendeeListTableViewDataSource];
}

- (void)notify2reloadSelectedTalkingGroupAttendeeListTableViewDataSource{
    // get selected talking group attendees
    // generate get the selected talking group attendees param map
    NSMutableDictionary *_getSelectedTalkingGroupAttendeesParamMap = [[NSMutableDictionary alloc] init];
    
    // set some params
    [_getSelectedTalkingGroupAttendeesParamMap setObject:[[_mMyTalkingGroupsJSONInfoArray objectAtIndex:_mSelectedTalkingGroupCellIndex] objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups or new talking group id response id", nil)] forKey:NSRBGServerFieldString(@"remote background server http request get selected talking group attendees or schedule new talking group or invite new added contacts to talking group id", nil)];
    
    // post the http request
    [HttpUtils postSignatureRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"get selected talking group attendee list url format string", nil), NSUrlString(@"remote background server root url string", nil)] andPostFormat:urlEncoded andParameter:_getSelectedTalkingGroupAttendeesParamMap andUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:NSUTF8StringEncoding], HTTPREQUESTRESPONSEENCODING, nil] andRequestType:asynchronous andProcessor:self andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [_mMyTalkingGroupsJSONInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"My talking group cell";
    
    // get my talking group list table view cell
    MyTalkingGroupListTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[MyTalkingGroupListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    // get my talking group info json object
    NSDictionary *_myTalkingGroupInfoJSONObject = [_mMyTalkingGroupsJSONInfoArray objectAtIndex:indexPath.row];
    
    // set my talking group started time timestamp, id and status
    _cell.startedTimeTimestamp = [[_myTalkingGroupInfoJSONObject objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups response info list talking group started time timestamp", nil)] description];
    _cell.talkingGroupId = [_myTalkingGroupInfoJSONObject objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups or new talking group id response id", nil)];
    _cell.talkingGroupStatus = [_myTalkingGroupInfoJSONObject objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups response info list talking group status", nil)];
    
    return _cell;
}

// UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return the height for row at indexPath.
    return [MyTalkingGroupListTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // set selected talking group cell index
    _mSelectedTalkingGroupCellIndex = indexPath.row;
    
    // load the selected talking group attendee list table view data source
    [self loadSelectedTalkingGroupAttendeeListTableViewDataSource];
}

// UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // my talking group list table view did scroll
    [_mMyTalkingGroupListTableViewRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_mMyTalkingGroupListTableViewAppendMoreFooterView appendMoreScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // my talking group list table view did end dragging
    [_mMyTalkingGroupListTableViewRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // my talking group list table view did end decelerating
    [_mMyTalkingGroupListTableViewAppendMoreFooterView appendMoreScrollViewDidEndDecelerating:scrollView];
}

// EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    // reloading my talking groups
    _mIsReloadingMyTalkingGroups = YES;
    
    // send get my talking groups http request
    [self sendGetMyTalkingGroupsHttpRequest:RELOADING_MYTALKINGGROUPS];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    // should return if data source model is reloading
    return _mIsReloadingMyTalkingGroups;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    // should return date data source was last changed
    return [NSDate date];
}

// AppendMoreTableFooterDelegate
- (void)appendMoreTableFooterDidScrollAppend:(AppendMoreTableFooterView *)view{
    // appending more my talking groups
    _mIsAppendingMoreMyTalkingGroups = YES;
    
    // send get my talking groups http request
    [self sendGetMyTalkingGroupsHttpRequest:APPENDMORE_MYTALKINGGROUPS];
}

- (BOOL)appendMoreTableFooterDataSourceIsAppending:(AppendMoreTableFooterView *)view{
    // should return if more data source model is appending
    return _mIsAppendingMoreMyTalkingGroups;
}

// IHttpReqRespProtocol
- (void)httpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send http request succeed - request url = %@", pRequest.url);
    
    // hide asynchronous http request progress view
    [self.window hideMBProgressHUD];
    
    // check the request url string
    if ([pRequest.url.absoluteString hasPrefix:[NSString stringWithFormat:NSUrlString(@"my talking groups url format string", nil), NSUrlString(@"remote background server root url string", nil)]]) {
        // get and check get my talking groups mode
        switch (((NSNumber *)[pRequest.userInfo objectForKey:GETMYTALKINGGROUPS_GETMODEKEY4REQUESTUSERINFO]).integerValue) {
            case APPENDMORE_MYTALKINGGROUPS:
                // done appending more my talking groups
                [self doneAppendingMoreMyTalkingGroups];
                break;
                
            case RELOADING_MYTALKINGGROUPS:
            default:
                // done reloading my talking groups
                [self doneReloadingMyTalkingGroups];
                break;
        }
        
        // get my talking groups http request
        [self getMyTalkingGroupsHttpRequestDidFinished:pRequest];
    }
    else if ([pRequest.url.absoluteString hasPrefix:[NSString stringWithFormat:NSUrlString(@"get selected talking group attendee list url format string", nil), NSUrlString(@"remote background server root url string", nil)]]) {
        // get selected talking group attendees http request
        [self getSelectedTalkingGroupAttendeesHttpRequestDidFinished:pRequest];
    }
    else {
        NSLog(@"Warning: the request not recognized");
    }
}

- (void)httpRequestDidFailed:(ASIHTTPRequest *)pRequest{
    NSLog(@"send http request failed - request url = %@", pRequest.url);
    
    // hide asynchronous http request progress view
    [self.window hideMBProgressHUD];
    
    // check the request url string
    if ([pRequest.url.absoluteString hasPrefix:[NSString stringWithFormat:NSUrlString(@"my talking groups url format string", nil), NSUrlString(@"remote background server root url string", nil)]]) {
        // get and check get my talking groups mode
        switch (((NSNumber *)[pRequest.userInfo objectForKey:GETMYTALKINGGROUPS_GETMODEKEY4REQUESTUSERINFO]).integerValue) {
            case APPENDMORE_MYTALKINGGROUPS:
                // done appending more my talking groups
                [self doneAppendingMoreMyTalkingGroups];
                break;
                
            case RELOADING_MYTALKINGGROUPS:
            default:
                // done reloading my talking groups
                [self doneReloadingMyTalkingGroups];
                break;
        }
        
        // get my talking groups http request
        // load my talking group list table view data source succeed completion
        _mLoadMyTalkingGroupListTableViewDataSourceCompletionBlock(-1);
    }
    else if ([pRequest.url.absoluteString hasPrefix:[NSString stringWithFormat:NSUrlString(@"get selected talking group attendee list url format string", nil), NSUrlString(@"remote background server root url string", nil)]]) {
        // get selected talking group attendees http request
        // clear selected talking group attenees info array and resize my talking groups and selected talking group attendees view
        [self setSelectedTalkingGroupAttendeesInfoArrayAnsResizeMyTalkingGroups7AttendeesView:nil];
        
        // show toast
        [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil)) show:iToastTypeError];
    }
    else {
        NSLog(@"Warning: the request not recognized");
    }
}

// inner extension
- (void)sendGetMyTalkingGroupsHttpRequest:(GetMyTalkingGroupsMode)getMode{
    // get my talking groups
    // generate get my talking groups param map and user info
    NSMutableDictionary *_getMyTalkingGroupsParamMap = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *_getMyTalkingGroupsUserInfo = [[NSMutableDictionary alloc] init];
    
    // set some params and user info
    if (APPENDMORE_MYTALKINGGROUPS == getMode) {
        [_getMyTalkingGroupsParamMap setObject:[NSNumber numberWithInt:((NSNumber *)[_mMyTalkingGroupsPagerJSONObject objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups response pager offset", nil)]).intValue + 1] forKey:NSRBGServerFieldString(@"remote background server http request get my talking groups response pager offset", nil)];
        [_getMyTalkingGroupsUserInfo setObject:[NSNumber numberWithInteger:getMode] forKey:GETMYTALKINGGROUPS_GETMODEKEY4REQUESTUSERINFO];
    }
    
    // post the http request
    [HttpUtils postSignatureRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"my talking groups url format string", nil), NSUrlString(@"remote background server root url string", nil)] andPostFormat:urlEncoded andParameter:_getMyTalkingGroupsParamMap andUserInfo:_getMyTalkingGroupsUserInfo andRequestType:asynchronous andProcessor:self andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
}

- (void)getMyTalkingGroupsHttpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send get my talking groups http request succeed - request url = %@, response status code = %d and data string = %@", pRequest.url, [pRequest responseStatusCode], pRequest.responseString);
    
    // check status code
    if (200 == [pRequest responseStatusCode]) {
        // get response data json format
        NSDictionary *_respDataJSONFormat = [pRequest.responseString objectFromJSONString];
        
        // get my talking groups pager from response data json format and set it
        _mMyTalkingGroupsPagerJSONObject = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups response pager", nil)];
        
        // set my talking group list table view append more footer view has more data
        _mMyTalkingGroupListTableViewAppendMoreFooterView.hasMoreData = ((NSNumber *)[_mMyTalkingGroupsPagerJSONObject objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups response pager has next", nil)]).boolValue;
        
        // get my talking groups info list from response data json format and set it
        // get and check get my talking groups mode
        GetMyTalkingGroupsMode _getMyTalkingGroupsMode;
        if (RELOADING_MYTALKINGGROUPS == (_getMyTalkingGroupsMode = ((NSNumber *)[pRequest.userInfo objectForKey:GETMYTALKINGGROUPS_GETMODEKEY4REQUESTUSERINFO]).integerValue)) {
            // clear my talking groups info list json format if needed for reloading my talking groups
            if (0 < [_mMyTalkingGroupsJSONInfoArray count]) {
                [_mMyTalkingGroupsJSONInfoArray removeAllObjects];
            }
        }
        [_mMyTalkingGroupsJSONInfoArray addObjectsFromArray:[_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups response info list", nil)]];
        
        // reload my talking group list table view data
        [_mMyTalkingGroupListTableView reloadData];
        
        // check get my talking groups mode again
        if (APPENDMORE_MYTALKINGGROUPS == _getMyTalkingGroupsMode) {
//            [[_mMyTalkingGroupListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_mSelectedTalkingGroupCellIndex inSection:0]] setSelected:YES];
        }
        
        // load my talking group list table view data source succeed completion
        _mLoadMyTalkingGroupListTableViewDataSourceCompletionBlock(0);
    }
    else {
        // load my talking group list table view data source succeed completion
        _mLoadMyTalkingGroupListTableViewDataSourceCompletionBlock(-1);
    }
}

- (void)doneReloadingMyTalkingGroups{
    // check my talking groups is reloading
    if (_mIsReloadingMyTalkingGroups) {
        // set done reloading my talking groups
        _mIsReloadingMyTalkingGroups = NO;
        
        // my talking group list table view refresh header view did finished loading
        [_mMyTalkingGroupListTableViewRefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_mMyTalkingGroupListTableView];
        
        // resize my talking groups and the selected talking group attendees view
        [(MyTalkingGroups7AttendeesView *)self.superview resizeMyTalkingGroupsAndAttendeesView:NO];
    }
}

- (void)doneAppendingMoreMyTalkingGroups{
    // check my talking groups is appending
    if (_mIsAppendingMoreMyTalkingGroups) {
        // set done appending my talking groups
        _mIsAppendingMoreMyTalkingGroups = NO;
        
        // my talking group list table view append more footer view did finished appending
        [_mMyTalkingGroupListTableViewAppendMoreFooterView appendMoreScrollViewDataSourceDidFinishedAppending:_mMyTalkingGroupListTableView];
    }
}

- (void)getSelectedTalkingGroupAttendeesHttpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send get selected talking group attendees http request succeed - request url = %@, response status code = %d and data string = %@", pRequest.url, [pRequest responseStatusCode], pRequest.responseString);
    
    // check status code
    if (200 == [pRequest responseStatusCode]) {
        // get response data json format
        NSArray *_respDataJSONFormat = [pRequest.responseString objectFromJSONString];
        
        // set selected talking group attendees info array and resize my talking groups and selected talking group attendees view
        [self setSelectedTalkingGroupAttendeesInfoArrayAnsResizeMyTalkingGroups7AttendeesView:_respDataJSONFormat];
    }
    else {
        // show toast
        [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil)) show:iToastTypeError];
    }
}

- (void)setSelectedTalkingGroupAttendeesInfoArrayAnsResizeMyTalkingGroups7AttendeesView:(NSArray *)selectedTalkingGroupAttendeesInfoArray{
    // get parent view: my talking groups and selected talking group attendees view
    MyTalkingGroups7AttendeesView *_myTalkingGroups7AttendeesView = (MyTalkingGroups7AttendeesView *)self.superview;
    
    // set selected talking group attendees info array
    _myTalkingGroups7AttendeesView.selectedTalkingGroupAttendeesInfoArray = selectedTalkingGroupAttendeesInfoArray;
    
    // resize my talking groups and selected talking group attendees view
    [_myTalkingGroups7AttendeesView resizeMyTalkingGroupsAndAttendeesView:nil != selectedTalkingGroupAttendeesInfoArray && 0 != [selectedTalkingGroupAttendeesInfoArray count] ? YES : NO];
}

@end
