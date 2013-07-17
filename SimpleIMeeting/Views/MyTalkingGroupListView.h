//
//  MyTalkingGroupListView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IHttpReqRespProtocol.h"

#import "EGORefreshTableHeaderView.h"

#import "AppendMoreTableFooterView.h"

@interface MyTalkingGroupListView : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, EGORefreshTableHeaderDelegate, AppendMoreTableFooterDelegate, IHttpReqRespProtocol> {
    // my talking groups pager json object and info array
    NSDictionary *_mMyTalkingGroupsPagerJSONObject;
    NSMutableArray *_mMyTalkingGroupsJSONInfoArray;
    
    // load my talking group list table view data source completion block
    void (^ _mLoadMyTalkingGroupListTableViewDataSourceCompletionBlock)(NSInteger);
    
    // selected talking group cell index
    NSInteger _mSelectedTalkingGroupCellIndex;
    
    // present subviews
    // subview my talking group list table view
    UITableView *_mMyTalkingGroupListTableView;
    
    // my talking group list table view refresh header view
    EGORefreshTableHeaderView *_mMyTalkingGroupListTableViewRefreshHeaderView;
    // reload my talking groups flag
    BOOL _mIsReloadingMyTalkingGroups;
    
    // my talking group list table view append more footer view
    AppendMoreTableFooterView *_mMyTalkingGroupListTableViewAppendMoreFooterView;
    // append more my talking groups flag
    BOOL _mIsAppendingMoreMyTalkingGroups;
}

@property (nonatomic, readonly) NSMutableArray *myTalkingGroupsInfoArray;

// selected talking group json object info
@property (nonatomic, readonly) NSDictionary *selectedTalkingGroupJSONObjectInfo;

// load my talking group list table view data source
- (void)loadMyTalkingGroupListTableViewDataSource:(void (^)(NSInteger))completion;

// load the selected talking group attendee list table view data source
- (void)loadSelectedTalkingGroupAttendeeListTableViewDataSource;

// my account socket IO notify to reload the selected talking group attendee list table view data source
- (void)notify2reloadSelectedTalkingGroupAttendeeListTableViewDataSource;

@end
