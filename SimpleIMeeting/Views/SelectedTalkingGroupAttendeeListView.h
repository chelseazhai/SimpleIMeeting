//
//  SelectedTalkingGroupAttendeeListView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedTalkingGroupAttendeeListView : UIView <UITableViewDataSource, UITableViewDelegate> {
    // selected talking group is opened flag
    BOOL _mSelectedTalkingGroupIsOpened;
    
    // selected talking group attendees json info array
    NSMutableArray *_mSelectedTalkingGroupAttendeesJSONInfoArray;
    
    // present subviews
    // subview selected talking group attendee list table view
    UITableView *_mSelectedTalkingGroupAttendeeListTableView;
}

@property (nonatomic, readonly) NSMutableArray *selectedTalkingGroupAttendeesInfoArray;

// load selected talking group attendee list table view data source with selected talking group is opened flag
- (void)loadSelectedTalkingGroupAttendeeListTableViewDataSource:(NSArray *)selectedTalkingGroupAttendeesInfoArray selectedTalkingGroupOpened:(BOOL)isOpened;

@end
