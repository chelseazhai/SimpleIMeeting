//
//  NetworkUnavailableView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "NetworkUnavailableView.h"

#import <CommonToolkit/CommonToolkit.h>

// margin weight and total weight
#define MARGIN_WEIGHT  1
#define NETWORKUNAVAILABLEVIEW_TOTALSUMWEIGHT   10.0

// network unavailable tip label height
#define NETWORKUNAVAILABLETIPLABELHEIGHT    80.0

// network unavailable tip label text font size
#define NETWORKUNAVAILABLETIPLABELTEXTFONTSIZE  18.0

@implementation NetworkUnavailableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background image
        self.backgroundImg = [UIImage compatibleImageNamed:@"img_simpleimeeting_bg"];
        
        // create and init subviews
        // init network unavailable tip label
        UILabel *_networkUnavailableTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + FILL_PARENT * (MARGIN_WEIGHT / NETWORKUNAVAILABLEVIEW_TOTALSUMWEIGHT), self.bounds.origin.y + FILL_PARENT * (MARGIN_WEIGHT / NETWORKUNAVAILABLEVIEW_TOTALSUMWEIGHT), FILL_PARENT * ((NETWORKUNAVAILABLEVIEW_TOTALSUMWEIGHT - 2 * MARGIN_WEIGHT) / NETWORKUNAVAILABLEVIEW_TOTALSUMWEIGHT), NETWORKUNAVAILABLETIPLABELHEIGHT)];
        
        // set its attributes
        _networkUnavailableTipLabel.text = NSLocalizedString(@"network unavailable tip label text", nil);
        _networkUnavailableTipLabel.font = [UIFont systemFontOfSize:NETWORKUNAVAILABLETIPLABELTEXTFONTSIZE];
        _networkUnavailableTipLabel.numberOfLines = 0;
        _networkUnavailableTipLabel.backgroundColor = [UIColor clearColor];
        
        // add network unavailable tip label as subview of network unavailable view
        [self addSubview:_networkUnavailableTipLabel];
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

- (void)layoutSubviews{
    // resize all subviews
    [self resizesSubviews];
}

@end
