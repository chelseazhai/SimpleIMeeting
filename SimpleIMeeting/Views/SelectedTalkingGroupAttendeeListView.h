//
//  SelectedTalkingGroupAttendeeListView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedTalkingGroupAttendeeListView : UIView <UITableViewDataSource, UITableViewDelegate> {
    // present subviews
    // subview selected talking group attendee list table view
    UITableView *_mSelectedTalkingGroupAttendeeListTableView;
}

@end
