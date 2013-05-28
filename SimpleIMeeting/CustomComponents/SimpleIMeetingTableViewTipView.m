//
//  SimpleIMeetingTableViewTipView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SimpleIMeetingTableViewTipView.h"

#import <QuartzCore/QuartzCore.h>

// padding
#define PADDING_LEFT7RIGHT  14
#define PADDING_TOP7BOTTOM  4

// height
#define TIPVIEW_HEIGHT  26.0

#define TIPLABEL_FONTSIZE   14.0

@implementation SimpleIMeetingTableViewTipView

- (id)initWithTipViewMode:(SIMTableViewTipViewMode)tipViewType andParentView:(UIView *)parentView{
    CGRect _frameRectangle = CGRectMake(0.0, 0.0, 0.0, 0.0);
    
    // save tip view mode
    _mTipViewType = tipViewType;
    
    // check parent view
    if (nil != parentView) {
        // update its frame rectangle
        _frameRectangle = parentView.bounds;
        _frameRectangle.size.height = TIPVIEW_HEIGHT;
    }
    
    return [self initWithFrame:_frameRectangle];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init tip label
        _mTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + PADDING_LEFT7RIGHT, self.bounds.origin.y + PADDING_TOP7BOTTOM, self.bounds.size.width - 2 * PADDING_LEFT7RIGHT, self.bounds.size.height - 2 * PADDING_TOP7BOTTOM)];
        
        // set its attributes
        _mTipLabel.textColor = [UIColor whiteColor];
        _mTipLabel.font = [UIFont systemFontOfSize:TIPLABEL_FONTSIZE];
        _mTipLabel.backgroundColor = [UIColor clearColor];
        
        // add tip label as subview
        [self addSubview:_mTipLabel];
        
        // check simple imeeting table view tip view type and set background image
        UIImage *_backgroundImg;
        switch (_mTipViewType) {
            case RightAlign_TipView:
                _backgroundImg = [UIImage imageNamed:@"img_right_tipview_bg"];
                break;
                
            case LeftAlign_TipView:
            default:
                _backgroundImg = [UIImage imageNamed:@"img_left_tipview_bg"];
                break;
        }
        self.layer.contents = (__bridge id)(_backgroundImg.CGImage);
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGFloat)height{
    return TIPVIEW_HEIGHT;
}

- (void)setTipViewText:(NSString *)tipViewText{
    // set tip label text
    _mTipLabel.text = tipViewText;
}

@end
