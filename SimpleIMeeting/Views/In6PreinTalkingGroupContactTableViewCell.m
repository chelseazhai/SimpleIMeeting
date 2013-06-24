//
//  In6PreinTalkingGroupContactTableViewCell.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "In6PreinTalkingGroupContactTableViewCell.h"

// prein talking group contact indicate photo
#define PREINTALKINGGROUPCONTACT_INDICATE_PHOTO [UIImage imageNamed:@"img_preintalkinggroup_indicatephoto"]

// tableViewCell margin
#define MARGIN  6.0
// tableViewCell padding
#define PADDING 2.0

// cell indicate photo imageView margin
#define INDICATEPHOTOIMGVIEW_MARGIN 4.0

// cell indicate photo imageView width and height
#define INDICATEPHOTOIMGVIEW_WIDTH7HEIGHT   14.0
// cell display name label height
#define DISPLAYNAMELABEL_HEIGHT 22.0

@implementation In6PreinTalkingGroupContactTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // set selection style is UITableViewCellSelectionStyleNone
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // init contentView subviews
        // contact indicate photo image view
        _mIndicatePhotoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + MARGIN + INDICATEPHOTOIMGVIEW_MARGIN, self.bounds.origin.y + MARGIN + INDICATEPHOTOIMGVIEW_MARGIN, INDICATEPHOTOIMGVIEW_WIDTH7HEIGHT, INDICATEPHOTOIMGVIEW_WIDTH7HEIGHT)];
        
        // add to content view
        [self.contentView addSubview:_mIndicatePhotoImgView];
        
        // contact display name label
        _mDisplayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mIndicatePhotoImgView.frame.origin.x + _mIndicatePhotoImgView.frame.size.width + INDICATEPHOTOIMGVIEW_MARGIN + 4 * PADDING, self.bounds.origin.y + MARGIN, self.frame.size.width - 2 * (MARGIN + INDICATEPHOTOIMGVIEW_MARGIN) - (_mIndicatePhotoImgView.frame.size.width + 4 * PADDING), DISPLAYNAMELABEL_HEIGHT)];
        
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

- (void)setContactIsInTalkingGroupFlag:(BOOL)contactIsInTalkingGroupFlag{
    // set contact is in talking group flag
    _mContactIsInTalkingGroupFlag = contactIsInTalkingGroupFlag;
    
    // check contact if or not in talking group
    if (contactIsInTalkingGroupFlag) {
        // clear indicate photo image view image
        _mIndicatePhotoImgView.image = nil;
    }
    else {
        // set prein talking group contact indicate photo as indicate photo image view image
        _mIndicatePhotoImgView.image = PREINTALKINGGROUPCONTACT_INDICATE_PHOTO;
    }
}

- (void)setDisplayName:(NSString *)displayName{
    // set display name text
    _mDisplayName = displayName;
    
    // set display name label text
    _mDisplayNameLabel.text = displayName;
}

+ (CGFloat)cellHeight{
    // set tableViewCell default height
    return 2 * /*top margin*/MARGIN + /*display name label height*/DISPLAYNAMELABEL_HEIGHT;
}

@end
