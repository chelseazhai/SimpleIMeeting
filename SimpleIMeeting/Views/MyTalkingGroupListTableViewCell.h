//
//  MyTalkingGroupListTableViewCell.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-25.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTalkingGroupListTableViewCell : UITableViewCell {
    // talking group started time unix timestamp
    NSTimeInterval _mStartedTimeUnixTimestamp;
    // talking group id
    NSString *_mTalkingGroupId;
    // talking group status
    NSString *_mTalkingGroupStatus;
    
    // talking group started time label
    UILabel *_mStartedTimeLabel;
    // talking group id label
    UILabel *_mTalkingGroupIdLabel;
    // talking group status label
    UILabel *_mTalkingGroupStatusLabel;
}

@property (nonatomic, retain) NSString *startedTimeTimestamp;
@property (nonatomic, retain) NSString *talkingGroupId;
@property (nonatomic, retain) NSString *talkingGroupStatus;

// get talking group started time unix timestamp
- (NSTimeInterval)startedTimeUnixTimestamp;

// get the height of my talking group list tableViewCell
+ (CGFloat)cellHeight;

@end
