//
//  AboutView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "AboutView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "AssistantCommonViewController.h"

// set label attributes with text
#define SetLabelAttributesWithText(label, labelText)    \
    {   \
        label.text = labelText; \
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];   \
        label.font = [UIFont systemFontOfSize:16.0];    \
        label.textAlignment = NSTextAlignmentCenter;    \
        label.numberOfLines = 0;    \
        label.lineBreakMode = NSLineBreakByCharWrapping;    \
        label.backgroundColor = [UIColor clearColor];   \
    }

// padding groups view weight
#define PADDINGGROUPSVIEW_WEIGHT    0.1

// product, authors, copyright and acknowledgement group view weight and about view total weight
#define PRODUCTGROUPVIEW_WEIGHT 1.2
#define AUTHORSGROUPVIEW_WEIGHT 1
#define COPYRIGHT7ACKNOWLEDGEMENTGROUPVIEW_WEIGHT   1
#define ABOUTVIEW_TOTALSUMWEIGHT    3.6 

@implementation AboutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background image
        self.backgroundImg = [UIImage imageNamed:@"img_simpleimeeting_bg"];
        
        // set title
        self.title = NSLocalizedString(@"about view title", nil);
        
        // create and init subviews
        // init product group view
        UIView *_productGroupView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT * (PRODUCTGROUPVIEW_WEIGHT / ABOUTVIEW_TOTALSUMWEIGHT))];
        
        _productGroupView.backgroundColor = [UIColor redColor];
        
        // init authors group view
        UIView *_authorsGroupView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _productGroupView.frame.size.height + FILL_PARENT * (PADDINGGROUPSVIEW_WEIGHT / ABOUTVIEW_TOTALSUMWEIGHT), FILL_PARENT, FILL_PARENT * (AUTHORSGROUPVIEW_WEIGHT / ABOUTVIEW_TOTALSUMWEIGHT))];
        
        // init programming author label
        UILabel *_programmingAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(_authorsGroupView.bounds.origin.x, _authorsGroupView.bounds.origin.y, FILL_PARENT, FILL_PARENT / 2.0)];
        
        // set its attributes
        SetLabelAttributesWithText(_programmingAuthorLabel, NSLocalizedString(@"programming author label text", nil));
        
        // init user interface author label
        UILabel *_userInterfaceAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(_authorsGroupView.bounds.origin.x, _authorsGroupView.bounds.origin.y + _programmingAuthorLabel.frame.size.height, FILL_PARENT, FILL_PARENT / 2.0)];
        
        // set its attributes
        SetLabelAttributesWithText(_userInterfaceAuthorLabel, NSLocalizedString(@"user interface author label text", nil));
        
        // add programming and user interface author label as subviews of authors group view
        [_authorsGroupView addSubview:_programmingAuthorLabel];
        [_authorsGroupView addSubview:_userInterfaceAuthorLabel];
        
        // init copyright and acknowledgement group view
        UIView *_copyright7acknowledgementGroupView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _productGroupView.frame.size.height + FILL_PARENT * (PADDINGGROUPSVIEW_WEIGHT / ABOUTVIEW_TOTALSUMWEIGHT) + _authorsGroupView.frame.size.height + FILL_PARENT * (PADDINGGROUPSVIEW_WEIGHT / ABOUTVIEW_TOTALSUMWEIGHT), FILL_PARENT, FILL_PARENT * (COPYRIGHT7ACKNOWLEDGEMENTGROUPVIEW_WEIGHT / ABOUTVIEW_TOTALSUMWEIGHT))];
        
        // init copyright label
        UILabel *_copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(_copyright7acknowledgementGroupView.bounds.origin.x, _copyright7acknowledgementGroupView.bounds.origin.y, FILL_PARENT, FILL_PARENT / 2.0)];
        
        // set its attributes
        SetLabelAttributesWithText(_copyrightLabel, NSLocalizedString(@"copyright label text", nil));
        
        // init acknowledgement label
        UILabel *_acknowledgementLabel = [[UILabel alloc] initWithFrame:CGRectMake(_copyright7acknowledgementGroupView.bounds.origin.x, _copyright7acknowledgementGroupView.bounds.origin.y + _copyrightLabel.frame.size.height, FILL_PARENT, FILL_PARENT / 2.0)];
        
        // set its attributes
        SetLabelAttributesWithText(_acknowledgementLabel, NSLocalizedString(@"acknowledgement label text", nil));
        
        // add copyright and acknowledgement label as subviews of copyright and acknowledgement group view
        [_copyright7acknowledgementGroupView addSubview:_copyrightLabel];
        [_copyright7acknowledgementGroupView addSubview:_acknowledgementLabel];
        
        // add product, authors and copyright and acknowledgement group view as subviews of about view
        [self addSubview:_productGroupView];
        [self addSubview:_authorsGroupView];
        [self addSubview:_copyright7acknowledgementGroupView];
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
