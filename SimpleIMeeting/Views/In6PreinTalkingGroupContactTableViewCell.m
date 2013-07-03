//
//  In6PreinTalkingGroupContactTableViewCell.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "In6PreinTalkingGroupContactTableViewCell.h"

// prein talking group contact indicate image
#define PREINTALKINGGROUPCONTACT_INDICATEIMAGE  [UIImage imageNamed:@"img_preintalkinggroup_indicateimage"]

// tableViewCell margin
#define MARGIN  6.0
// tableViewCell padding
#define PADDING 2.0

// cell indicate imageview margin
#define INDICATEIMGVIEW_MARGIN  4.0

// cell indicate imageview width and height
#define INDICATEIMGVIEW_WIDTH7HEIGHT    14.0
// cell display name label height
#define DISPLAYNAMELABEL_HEIGHT 22.0

@implementation In6PreinTalkingGroupContactTableViewCell

@synthesize contactIsInTalkingGroupFlag = _mContactIsInTalkingGroupFlag;
@synthesize displayName = _mDisplayName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // set selection style is UITableViewCellSelectionStyleNone
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // init contentView subviews
        // contact indicate image view
        _mIndicateImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + MARGIN + INDICATEIMGVIEW_MARGIN, self.bounds.origin.y + MARGIN + INDICATEIMGVIEW_MARGIN, INDICATEIMGVIEW_WIDTH7HEIGHT, INDICATEIMGVIEW_WIDTH7HEIGHT)];
        
        // add to content view
        [self.contentView addSubview:_mIndicateImgView];
        
        // contact display name label
        _mDisplayNameLabel = [_mDisplayNameLabel = [UILabel alloc] initWithFrame:CGRectMakeWithFormat(_mDisplayNameLabel, [NSNumber numberWithFloat:_mIndicateImgView.frame.origin.x + _mIndicateImgView.frame.size.width + INDICATEIMGVIEW_MARGIN + PADDING], [NSNumber numberWithFloat:self.bounds.origin.y + MARGIN], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*(%d+%d)-(%d+%d)", FILL_PARENT_STRING, (int)MARGIN, (int)INDICATEIMGVIEW_MARGIN, (int)INDICATEIMGVIEW_WIDTH7HEIGHT, (int)PADDING] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:DISPLAYNAMELABEL_HEIGHT])];
        
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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    // Configure the view for the highlighted state
    // set the content view background of prein talking group section for highlighted state
    if (!_mContactIsInTalkingGroupFlag && highlighted) {
        self.contentView.backgroundImg = [UIImage imageNamed:@"img_in6preintalkinggroupcontactcell_selected_bg"];
    }
    else {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    // update contact display name label frame
//    [_mDisplayNameLabel setFrame:CGRectMake(_mIndicateImgView.frame.origin.x + _mIndicateImgView.frame.size.width + INDICATEIMGVIEW_MARGIN + PADDING, self.bounds.origin.y + MARGIN, self.frame.size.width - 2 * (MARGIN + INDICATEIMGVIEW_MARGIN) - (_mIndicateImgView.frame.size.width + PADDING), DISPLAYNAMELABEL_HEIGHT)];
    
    // resize all subviews
    [self resizesSubviews];
}

- (void)setContactIsInTalkingGroupFlag:(BOOL)contactIsInTalkingGroupFlag{
    // set contact is in talking group flag
    _mContactIsInTalkingGroupFlag = contactIsInTalkingGroupFlag;
    
    // check contact if or not in talking group
    if (contactIsInTalkingGroupFlag) {
        // clear indicate image view image
        _mIndicateImgView.image = nil;
    }
    else {
        // set prein talking group contact indicate as indicate image view image
        _mIndicateImgView.image = PREINTALKINGGROUPCONTACT_INDICATEIMAGE;
    }
}

- (void)setDisplayName:(NSString *)displayName{
    // set display name
    _mDisplayName = displayName;
    
    // set display name label text
    _mDisplayNameLabel.text = displayName;
}

+ (CGFloat)cellHeight{
    // set tableViewCell default height
    return 2 * /*top margin*/MARGIN + /*display name label height*/DISPLAYNAMELABEL_HEIGHT;
}

@end
