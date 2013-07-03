//
//  SelectedTalkingGroupAttendeeListTableViewCell.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-25.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SelectedTalkingGroupAttendeeListTableViewCell.h"

// tableViewCell margin
#define MARGIN  6.0
// tableViewCell padding
#define PADDING 2.0

// cell attendee status imageview margin
#define ATTENDEESTATUSIMGVIEW_MARGIN    4.0

// cell attendee status imageview width and height
#define ATTENDEESTATUSIMGVIEW_WIDTH7HEIGHT  14.0
// cell display name label height
#define DISPLAYNAMELABEL_HEIGHT 22.0

@implementation SelectedTalkingGroupAttendeeListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // set selection style is UITableViewCellSelectionStyleNone
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight{
    // set tableViewCell default height
    return 2 * /*top margin*/MARGIN + /*display name label height*/DISPLAYNAMELABEL_HEIGHT;
}

@end
