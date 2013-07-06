//
//  MyTalkingGroupListTableViewCell.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-25.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "MyTalkingGroupListTableViewCell.h"

#import <CommonToolkit/CommonToolkit.h>

// tableViewCell margin top
#define MARGINTOP   10.0
// tableViewCell margin left and tight
#define MARGINLR    14.0
// tableViewCell margin bottom
#define MARGINBOTTOM    16.0

// cell tip label width
#define TIPLABEL_WIDTH  76.0

// cell label height
#define LABEL_HEIGHT    22.0

// set label attributes with text
#define SetLabelAttributes(label, labelText)   \
    {   \
        label.text = labelText; \
        label.font = [UIFont systemFontOfSize:15.0];    \
        label.textColor = [UIColor darkGrayColor];  \
        label.lineBreakMode = NSLineBreakByTruncatingMiddle;    \
        label.backgroundColor = [UIColor clearColor];   \
    }

// milliseconds per second
#define MILLISECONDS_PER_SECOND 1000

// seconds per minute, hour and day
#define SECONDS_PER_MINUTE  60
#define SECONDS_PER_HOUR    (60 * 60)
#define SECONDS_PER_DAY (24 * 60 * 60)

@implementation MyTalkingGroupListTableViewCell

@synthesize talkingGroupId = _mTalkingGroupId;
@synthesize talkingGroupStatus = _mTalkingGroupStatus;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // set selection style is UITableViewCellSelectionStyleNone
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // init contentView subviews
        // talking group started time tip label
        UILabel *_startedTimeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + MARGINLR, self.bounds.origin.y + MARGINTOP, TIPLABEL_WIDTH, LABEL_HEIGHT)];
        
        // set its attributes
        SetLabelAttributes(_startedTimeTipLabel, NSLocalizedString(@"talking group started time tip", nil));
        
        // add to content view
        [self.contentView addSubview:_startedTimeTipLabel];
        
        // talking group started time label
        _mStartedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + MARGINLR + _startedTimeTipLabel.frame.size.width, _startedTimeTipLabel.frame.origin.y, self.frame.size.width - _startedTimeTipLabel.frame.size.width - 2 * MARGINLR, LABEL_HEIGHT)];
        
        // set its attributes
        SetLabelAttributes(_mStartedTimeLabel, nil);
        
        // add to content view
        [self.contentView addSubview:_mStartedTimeLabel];
        
        // talking group id tip label
        UILabel *_talkingGroupIdTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + MARGINLR, self.bounds.origin.y + MARGINTOP + _startedTimeTipLabel.frame.size.height, TIPLABEL_WIDTH, LABEL_HEIGHT)];
        
        // set its attributes
        SetLabelAttributes(_talkingGroupIdTipLabel, NSLocalizedString(@"talking group id tip", nil));
        
        // add to content view
        [self.contentView addSubview:_talkingGroupIdTipLabel];
        
        // talking group id label
        _mTalkingGroupIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + MARGINLR + _talkingGroupIdTipLabel.frame.size.width, _talkingGroupIdTipLabel.frame.origin.y, self.frame.size.width - _talkingGroupIdTipLabel.frame.size.width - 2 * MARGINLR, LABEL_HEIGHT)];
        
        // set its attributes
        SetLabelAttributes(_mTalkingGroupIdLabel, nil);
        
        // add to content view
        [self.contentView addSubview:_mTalkingGroupIdLabel];
        
        // talking group status tip label
        UILabel *_talkingGroupStatusTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + MARGINLR, self.bounds.origin.y + MARGINTOP + _startedTimeTipLabel.frame.size.height + _talkingGroupIdTipLabel.frame.size.height, TIPLABEL_WIDTH, LABEL_HEIGHT)];
        
        // set its attributes
        SetLabelAttributes(_talkingGroupStatusTipLabel, NSLocalizedString(@"talking group status tip", nil));
        
        // add to content view
        [self.contentView addSubview:_talkingGroupStatusTipLabel];
        
        // talking group status label
        _mTalkingGroupStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + MARGINLR + _talkingGroupStatusTipLabel.frame.size.width, _talkingGroupStatusTipLabel.frame.origin.y, self.frame.size.width - _talkingGroupStatusTipLabel.frame.size.width - 2 * MARGINLR, LABEL_HEIGHT)];
        
        // set its attributes
        SetLabelAttributes(_mTalkingGroupStatusLabel, nil);
        
        // add to content view
        [self.contentView addSubview:_mTalkingGroupStatusLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    // set the view background for selected and unselected state
    if (selected) {
        self.backgroundImg = [UIImage imageNamed:[UIScreen mainScreen].bounds.size.width == self.frame.size.width ? @"img_talkinggroup_selected_bg" : @"img_talkinggroup_short_selected_bg"];
    }
    else {
        self.backgroundImg = [UIImage imageNamed:[UIScreen mainScreen].bounds.size.width == self.frame.size.width ? @"img_talkinggroup_normal_bg" : @"img_talkinggroup_short_normal_bg"];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // update the view background
    [self setSelected:self.selected animated:NO];
}

- (NSString *)startedTimeTimestamp{
    // return started time timestamp
    return [NSString stringWithFormat:@"%f", _mStartedTimeUnixTimestamp * MILLISECONDS_PER_SECOND];
}

- (void)setStartedTimeTimestamp:(NSString *)startedTimeTimestamp{
    // set started time unix timestamp
    _mStartedTimeUnixTimestamp = startedTimeTimestamp.doubleValue / MILLISECONDS_PER_SECOND;
    
    // set started time label text
    _mStartedTimeLabel.text = [[NSDate dateWithTimeIntervalSince1970:_mStartedTimeUnixTimestamp] stringWithFormat:@"yy-MM-dd HH:mm"];
}

- (NSTimeInterval)startedTimeUnixTimestamp{
    // return started time unix timestamp
    return _mStartedTimeUnixTimestamp;
}

- (void)setTalkingGroupId:(NSString *)talkingGroupId{
    // set talking group id and its label text
    _mTalkingGroupIdLabel.text = _mTalkingGroupId = talkingGroupId;
}

- (void)setTalkingGroupStatus:(NSString *)talkingGroupStatus{
    // set talking group status
    _mTalkingGroupStatus = talkingGroupStatus;
    
    // check talking group status, generate tip string and set it as talking group status label text
    NSString *_statusTipString;
    if ([NSRBGServerFieldString(@"remote background server http request get my talking groups response info list talking group open status", nil) isEqualToString:talkingGroupStatus]) {
        _statusTipString = NSLocalizedString(@"talking group is opened", nil);
    }
    else if ([NSRBGServerFieldString(@"remote background server http request get my talking groups response info list talking group schedule status", nil) isEqualToString:talkingGroupStatus]) {
        // get current date
        NSDate *_currentDate = [NSDate date];
        
        // compare talking group started time with current date
        switch ([[NSDate dateWithTimeIntervalSince1970:_mStartedTimeUnixTimestamp] compare:_currentDate componentUnitFlags:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit]) {
            case NSOrderedAscending:
                // invalid talking group
                NSLog(@"Error: the talking group is invalided");
                
                _statusTipString = NSLocalizedString(@"talking group is invalided", nil);
                break;
                
            case NSOrderedSame:
                // will open soon
                _statusTipString = NSLocalizedString(@"talking group will open", nil);
                break;
                
            case NSOrderedDescending:
            default:
                {
                    // get and check remain time interval
                    NSTimeInterval _remainTimeInterval = _mStartedTimeUnixTimestamp - _currentDate.timeIntervalSince1970;
                    if (SECONDS_PER_DAY <= _remainTimeInterval) {
                        // days remain
                        _statusTipString = [NSString stringWithFormat:NSLocalizedString(@"talking group is unopened days remain format string", nil), (int)(_remainTimeInterval / SECONDS_PER_DAY)];
                    }
                    else if (SECONDS_PER_HOUR <= _remainTimeInterval) {
                        // hours remain
                        _statusTipString = [NSString stringWithFormat:NSLocalizedString(@"talking group is unopened hours remain format string", nil), (int)(_remainTimeInterval / SECONDS_PER_HOUR)];
                    }
                    else if (SECONDS_PER_MINUTE <= _remainTimeInterval) {
                        // minutes remain
                        _statusTipString = [NSString stringWithFormat:NSLocalizedString(@"talking group is unopened minutes remain format string", nil), (int)(_remainTimeInterval / SECONDS_PER_MINUTE)];
                    }
                    else {
                        // less then one minute, will open soon
                        _statusTipString = NSLocalizedString(@"talking group will open", nil);
                    }
                }
                break;
        }
    }
    
    _mTalkingGroupStatusLabel.text = _statusTipString;
}

+ (CGFloat)cellHeight{
    // set tableViewCell default height
    return /*top margin*/MARGINTOP + /*bottom margin*/MARGINBOTTOM + /*label height*/3 * LABEL_HEIGHT;
}

@end
