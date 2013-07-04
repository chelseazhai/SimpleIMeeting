//
//  SelectedTalkingGroupAttendeeListTableViewCell.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-25.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SelectedTalkingGroupAttendeeListTableViewCell.h"

#import <CommonToolkit/CommonToolkit.h>

// tableViewCell margin top, right and bottom
#define MARGINTRB   6.0

// cell attendee status imageview margin
#define ATTENDEESTATUSIMGVIEW_MARGIN    4.0

// cell attendee status imageview width and height
#define ATTENDEESTATUSIMGVIEW_WIDTH7HEIGHT  14.0
// cell display name label height
#define DISPLAYNAMELABEL_HEIGHT 22.0

@implementation SelectedTalkingGroupAttendeeListTableViewCell

@synthesize attendeeStatus = _mAttendeeStatus;
@synthesize displayName = _mDisplayName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier selectedTalkingGroupOpened:YES];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier selectedTalkingGroupOpened:(BOOL)isOpened{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // set selection style is UITableViewCellSelectionStyleNone
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // init contentView subviews
        // check selected talking group is opened
        if (isOpened) {
            // selected talking group attendee status image view
            _mAttendeeStatusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + ATTENDEESTATUSIMGVIEW_MARGIN, self.bounds.origin.y + MARGINTRB + ATTENDEESTATUSIMGVIEW_MARGIN, ATTENDEESTATUSIMGVIEW_WIDTH7HEIGHT, ATTENDEESTATUSIMGVIEW_WIDTH7HEIGHT)];
            
            // add to content view
            [self.contentView addSubview:_mAttendeeStatusImgView];
        }
        
        // selected talking group attendee display name label
        _mDisplayNameLabel = [_mDisplayNameLabel = [UILabel alloc] initWithFrame:CGRectMakeWithFormat(_mDisplayNameLabel, [NSNumber numberWithFloat:_mAttendeeStatusImgView.frame.origin.x + _mAttendeeStatusImgView.frame.size.width + isOpened ? ATTENDEESTATUSIMGVIEW_MARGIN : MARGINTRB], [NSNumber numberWithFloat:self.bounds.origin.y + MARGINTRB], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-(%d+2*%d)-%d", FILL_PARENT_STRING, (int)MARGINTRB, (int)(isOpened ? ATTENDEESTATUSIMGVIEW_MARGIN : 0.0), (int)(isOpened ? ATTENDEESTATUSIMGVIEW_WIDTH7HEIGHT : MARGINTRB)] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:DISPLAYNAMELABEL_HEIGHT])];
        
        // set text color and font
        _mDisplayNameLabel.textColor = [UIColor darkGrayColor];
        _mDisplayNameLabel.font = [UIFont systemFontOfSize:16.0];
        
        // set cell content view background color clear
        _mDisplayNameLabel.backgroundColor = [UIColor clearColor];
        
        // add to content view
        [self.contentView addSubview:_mDisplayNameLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // resize all subviews
    [self resizesSubviews];
}

- (void)setAttendeeStatus:(NSString *)attendeeStatus{
    // set selected talking group attendee status
    _mAttendeeStatus = attendeeStatus;
    
    //
}

- (void)setDisplayName:(NSString *)displayName{
    // set selected talking group attendee display name
    _mDisplayName = displayName;
    
    // set selected talking group attendee display name label text
    _mDisplayNameLabel.text = displayName;
}

+ (CGFloat)cellHeight{
    // set tableViewCell default height
    return 2 * /*top margin*/MARGINTRB + /*display name label height*/DISPLAYNAMELABEL_HEIGHT;
}

@end
