//
//  MyTalkingGroupListView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTalkingGroupListView : UIView <UITableViewDataSource, UITableViewDelegate> {
    // my talking groups info array
    NSMutableArray *_mMyTalkingGroupsInfoArray;
    
    // load my talking group list table view data source completion block
    void (^ _mLoadMyTalkingGroupListTableViewDataSourceCompletionBlock)(NSInteger);
    
    // present subviews
    // subview my talking group list table view
    UITableView *_mMyTalkingGroupListTableView;
}

@property (nonatomic, readonly) NSMutableArray *myTalkingGroupsInfoArray;

// load my talking group list table view data source
- (void)loadMyTalkingGroupListTableViewDataSource:(void (^)(NSInteger))completion;

@end
