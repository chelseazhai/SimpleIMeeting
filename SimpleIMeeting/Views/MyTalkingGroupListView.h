//
//  MyTalkingGroupListView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IHttpReqRespSelector.h"

@interface MyTalkingGroupListView : UIView <UITableViewDataSource, UITableViewDelegate, IHttpReqRespSelector> {
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
}

@property (nonatomic, readonly) NSMutableArray *myTalkingGroupsInfoArray;

// selected talking group is opened
@property (nonatomic, readonly) BOOL selectedTalkingGroupIsOpened;

// load my talking group list table view data source
- (void)loadMyTalkingGroupListTableViewDataSource:(void (^)(NSInteger))completion;

@end
