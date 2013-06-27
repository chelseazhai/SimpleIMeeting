//
//  SettingView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SettingView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "SimpleIMeetingGroupView.h"

// margin and padding
#define MARGIN  10.0
#define PADDING 20.0

// my account, bind contact info group view height weight and them total weight
#define MYACCOUNTGROUPVIEW_HEIGHTWEIGHT 1
#define BINDCONTACTINFOGROUPVIEW_HEIGHTWEIGHT   2
#define MYACCOUNT7BINDCONTACTINFOGROUPVIEW_TOTALSUMWEIGHT   3

// my account or bind contact info group view height value
#define MYACCOUNT6BINDCONTACTINFOGROUPVIEW_HEIGHTVALUE(selfWeight, totalWeight)  [NSValue valueWithCString:[[NSString stringWithFormat:@"((%d+%s)-2*(%d+%d)-%d)*%d/%d", (int)self.bounds.origin.y, FILL_PARENT_STRING, (int)MARGIN, (int)PADDING, (int)BINDCONTACTINFOACCOUNTLOGINBUTTON_HEIGHT, selfWeight, totalWeight] cStringUsingEncoding:NSUTF8StringEncoding]]

// bind contact info account login button height
#define BINDCONTACTINFOACCOUNTLOGINBUTTON_HEIGHT    40.0

@implementation SettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background color
        self.backgroundColor = [UIColor whiteColor];
        
        // set title
        self.title = NSLocalizedString(@"setting view title", nil);
        
        // create and init subviews
        // define subview origin x number and width value
        NSNumber *_subviewOriginXNumber = [NSNumber numberWithFloat:self.bounds.origin.x + MARGIN];
        NSValue *_subviewWidthValue = [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d", FILL_PARENT_STRING, (int)MARGIN] cStringUsingEncoding:NSUTF8StringEncoding]];
        
        // define my account group view
        SimpleIMeetingGroupView *_myAccountGroupView;
        
        // init my account group view
        _myAccountGroupView = [_myAccountGroupView = [SimpleIMeetingGroupView alloc] initWithFrame:CGRectMakeWithFormat(_myAccountGroupView, _subviewOriginXNumber, [NSNumber numberWithFloat:self.bounds.origin.y + MARGIN], _subviewWidthValue, MYACCOUNT6BINDCONTACTINFOGROUPVIEW_HEIGHTVALUE(MYACCOUNTGROUPVIEW_HEIGHTWEIGHT, MYACCOUNT7BINDCONTACTINFOGROUPVIEW_TOTALSUMWEIGHT))];
        
        // set its attributes
        [_myAccountGroupView setTipLabelText:NSLocalizedString(@"my account group view tip", nil)];
        _myAccountGroupView.backgroundColor = [UIColor whiteColor];
        
        // init device id or bind contact info login account label
        UILabel *_l = [[UILabel alloc] initWithFrame:CGRectMake(_myAccountGroupView.bounds.origin.x, _myAccountGroupView.bounds.origin.y, FILL_PARENT, FILL_PARENT)];
        
        _l.text = @"设备号：AKHD-HSHLDL-KLSJ-DJLKJ";
        _l.backgroundColor = [UIColor clearColor];
        
        //
        [_myAccountGroupView.contentView addSubview:_l];
        
        // define bind contact info goup view
        SimpleIMeetingGroupView *_bindContactInfoGroupView;
        
        // init bind contact info goup view
        _bindContactInfoGroupView = [_bindContactInfoGroupView = [SimpleIMeetingGroupView alloc] initWithFrame:CGRectMakeWithFormat(_bindContactInfoGroupView, _subviewOriginXNumber, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%d+%d+%@", (int)self.bounds.origin.y, (int)MARGIN, (int)PADDING, MYACCOUNT6BINDCONTACTINFOGROUPVIEW_HEIGHTVALUE(MYACCOUNTGROUPVIEW_HEIGHTWEIGHT, MYACCOUNT7BINDCONTACTINFOGROUPVIEW_TOTALSUMWEIGHT).stringValue] cStringUsingEncoding:NSUTF8StringEncoding]], _subviewWidthValue, MYACCOUNT6BINDCONTACTINFOGROUPVIEW_HEIGHTVALUE(BINDCONTACTINFOGROUPVIEW_HEIGHTWEIGHT, MYACCOUNT7BINDCONTACTINFOGROUPVIEW_TOTALSUMWEIGHT))];
        
        // set its attributes
        [_bindContactInfoGroupView setTipLabelText:NSLocalizedString(@"bind contact info group tip", nil)];
        _bindContactInfoGroupView.backgroundColor = [UIColor whiteColor];
        
        // init bind contact info account login button
        UIButton *_bindContactInfoAccountLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_bindContactInfoAccountLoginButton setFrame:CGRectMakeWithFormat(_bindContactInfoAccountLoginButton, _subviewOriginXNumber, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%s-%d-%d", (int)self.bounds.origin.y, FILL_PARENT_STRING, (int)MARGIN, (int)BINDCONTACTINFOACCOUNTLOGINBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], _subviewWidthValue, [NSNumber numberWithFloat:BINDCONTACTINFOACCOUNTLOGINBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_bindContactInfoAccountLoginButton setTitle:NSLocalizedString(@"bind contact info account login button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_bindContactInfoAccountLoginButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        
        // add my account, bind contact info group view and bind contact info account login button as subviews of setting view
        [self addSubview:_myAccountGroupView];
        [self addSubview:_bindContactInfoGroupView];
        [self addSubview:_bindContactInfoAccountLoginButton];
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

- (BOOL)check7clearLoginAccountIsChangedFlag{
    BOOL _isLoginAccountChanged = _mIsLoginAccountChanged;
    
    // check login account is or not changed
    if (_mIsLoginAccountChanged) {
        // recover login account is changed flag
        _mIsLoginAccountChanged = NO;
    }
    
    return _isLoginAccountChanged;
}

@end
