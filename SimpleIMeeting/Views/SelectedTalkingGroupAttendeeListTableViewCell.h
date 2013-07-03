//
//  SelectedTalkingGroupAttendeeListTableViewCell.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-25.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedTalkingGroupAttendeeListTableViewCell : UITableViewCell {
    // is selected talking gruop opened
    BOOL _mIsSelectedTalkingGroupOpened;
    
    // selected talking group attendee status
    NSString *_mAttendeeStatus;
    // selected talking group attendee display name
    NSString *_mDisplayName;
    
    // selected talking group attendee status imageview
    UIImageView *_mAttendeeStatusImgView;
    // selected talking group attendee display name label
    UILabel *_mDisplayNameLabel;
}

// get the height of the selected talking group attendee list tableViewCell
+ (CGFloat)cellHeight;

@end
