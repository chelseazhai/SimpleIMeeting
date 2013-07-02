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

@interface MyTalkingGroupListView ()

// send get my talking groups http request
- (void)sendGetMyTalkingGroupsHttpRequest;

// get my talking groups http request did finished selector
- (void)getMyTalkingGroupsHttpRequestDidFinished:(ASIHTTPRequest *)pRequest;

@end

@implementation MyTalkingGroupListView

@synthesize myTalkingGroupsInfoArray = _mMyTalkingGroupsInfoArray;

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
        _mMyTalkingGroupsInfoArray = [[NSMutableArray alloc] init];
        
        // set its background color
        _mMyTalkingGroupListTableView.backgroundColor = [UIColor clearColor];
        
        // set separator style UITableViewCellSeparatorStyleNone
        _mMyTalkingGroupListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // set my talking group list table view dataSource and delegate
        _mMyTalkingGroupListTableView.dataSource = self;
        _mMyTalkingGroupListTableView.delegate = self;
        
        // add my talking groups head tip view and my talking group list table view as subviews of my talking group list view
        [self addSubview:_myTalkingGroupsHeadTipView];
        [self addSubview:_mMyTalkingGroupListTableView];
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

- (void)loadMyTalkingGroupListTableViewDataSource:(void (^)(NSInteger))completion{
    // save loading my talking group list table view data source completion block
    _mLoadMyTalkingGroupListTableViewDataSourceCompletionBlock = completion;
    
    // send get my talking groups http request
    [self sendGetMyTalkingGroupsHttpRequest];
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [_mMyTalkingGroupsInfoArray count];
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
    NSDictionary *_myTalkingGroupInfoJSONObject = [_mMyTalkingGroupsInfoArray objectAtIndex:indexPath.row];
    
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
    NSLog(@"my talking groups did select row at index path = %@", indexPath);
    
    //
}

// IHttpReqRespSelector
- (void)httpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send http request succeed - request url = %@", pRequest.url);
    
    // check the request url string
    if ([pRequest.url.absoluteString hasPrefix:[NSString stringWithFormat:NSUrlString(@"my talking groups url format string", nil), NSUrlString(@"remote background server root url string", nil)]]) {
        // get my talking groups http request
        [self getMyTalkingGroupsHttpRequestDidFinished:pRequest];
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
- (void)sendGetMyTalkingGroupsHttpRequest{
    // post the http request
    [HttpUtils postSignatureRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"my talking groups url format string", nil), NSUrlString(@"remote background server root url string", nil)] andPostFormat:urlEncoded andParameter:nil andUserInfo:nil andRequestType:asynchronous andProcessor:self andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
}

- (void)getMyTalkingGroupsHttpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send get my talking groups http request succeed - request url = %@, response status code = %d and data string = %@", pRequest.url, [pRequest responseStatusCode], pRequest.responseString);
    
    // check status code
    if (200 == [pRequest responseStatusCode]) {
        // get response data json format
        NSDictionary *_respDataJSONFormat = [pRequest.responseString objectFromJSONString];
        
        // get my talking groups pager and info list from response data json format
        _mMyTalkingGroupsPagerJSONObject = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups response pager", nil)];
        [_mMyTalkingGroupsInfoArray addObjectsFromArray:[_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request get my talking groups response info list", nil)]];
        
        // reload my talking group list table view data
        [_mMyTalkingGroupListTableView reloadData];
        
        // load my talking group list table view data source succeed completion
        _mLoadMyTalkingGroupListTableViewDataSourceCompletionBlock(0);
    }
    else {
        //
    }
}

@end
