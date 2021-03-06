//
//  SelectedTalkingGroupAttendeeListTableViewCell.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-25.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedTalkingGroupAttendeeListTableViewCell : UITableViewCell {
    // selected talking group attendee status
    NSString *_mAttendeeStatus;
    // selected talking group attendee display name
    NSString *_mDisplayName;
    
    // selected talking group attendee status imageview
    UIImageView *_mAttendeeStatusImgView;
    // selected talking group attendee display name label
    UILabel *_mDisplayNameLabel;
}

@property (nonatomic, retain) NSString *attendeeStatus;
@property (nonatomic, retain) NSString *displayName;

// init with style, reuse identifier and selected talking group is opened flag
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier selectedTalkingGroupOpened:(BOOL)isOpened;

// get the height of the selected talking group attendee list tableViewCell
+ (CGFloat)cellHeight;

@end
