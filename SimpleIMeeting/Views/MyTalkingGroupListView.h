//
//  MyTalkingGroupListView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTalkingGroupListView : UIView <UITableViewDataSource, UITableViewDelegate> {
    // present subviews
    // subview my talking groups table view
    UITableView *_mMyTalkingGroupsTableView;
}

@end
