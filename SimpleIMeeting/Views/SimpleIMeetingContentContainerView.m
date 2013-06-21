//
//  SimpleIMeetingContentContainerView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SimpleIMeetingContentContainerView.h"

#import "ContactsSelectView.h"
#import "MyTalkingGroups7AttendeesView.h"

// tap to generate new talking group title view width
#define TAP2GENNEWTALKINGGROUPTITLEVIEW_WIDTH   100.0

@interface SimpleIMeetingContentContainerView ()

// set navigation title and left bar button item with content view type
- (void)setNavigationTitle7LeftBarButtonItem:(SIMContentViewMode)contentViewType;

// more menu bar button item action selector
- (void)moreMenuBarBtnItemClicked;

// switch content view
- (void)switchContentView;

// set contacts select or my talking groups and its attednees subview as content view
- (void)setContentView:(SIMContentViewMode)contentViewType;

@end

@implementation SimpleIMeetingContentContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set navigation title and left bar button item with default contacts select as content view
        [self setNavigationTitle7LeftBarButtonItem:_mContentViewType = ADDRESSBOOKCONTACTS];
        
        // set more menu as right bar button item
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_moremenu_barbuttonitem"] bgImage:[UIImage imageNamed:@"img_right_barbtnitem_bg"] target:self action:@selector(moreMenuBarBtnItemClicked)];
        
        // create and init subviews and switch one as content view
        // init contacts select content view
        _mContactsSelectContentView = [[ContactsSelectView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT)];
        
        // init my talking groups and selected talking group attendees content view
        _mMyTalkingGroups7AttendeesContentView = [[MyTalkingGroups7AttendeesView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT)];
        
        // set content view, contacts select as default
        [self setContentView:_mContentViewType];
        
        // add contacts select and my talking groups and selected talking group attendees content view as subviews of simple imeeting content container view
        [self addSubview:_mContactsSelectContentView];
        [self addSubview:_mMyTalkingGroups7AttendeesContentView];
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

- (UILabel *)tap2GenNewTalkingGroupTitleView{
    // check tap to generate new talking group title view
    if (nil == _mTap2GenNewTalkingGroupTitleView) {
        // create and init tap to generate new talking group title view
        _mTap2GenNewTalkingGroupTitleView = [[UILabel alloc] initWithFrame:CGRectMake(CGPointZero.x, CGPointZero.y, TAP2GENNEWTALKINGGROUPTITLEVIEW_WIDTH, [DisplayScreenUtils navigationBarHeight])];
        
        // set its attributes
        _mTap2GenNewTalkingGroupTitleView.text = NSLocalizedString(@"tap to generate new talking group title view title", nil);
        _mTap2GenNewTalkingGroupTitleView.textColor = [UIColor whiteColor];
        _mTap2GenNewTalkingGroupTitleView.font = [UIFont boldSystemFontOfSize:22.0];
        _mTap2GenNewTalkingGroupTitleView.textAlignment = NSTextAlignmentCenter;
        _mTap2GenNewTalkingGroupTitleView.backgroundColor = [UIColor clearColor];
        
        // set tap to generate new talking group title view tap gesture recognizer
        _mTap2GenNewTalkingGroupTitleView.userInteractionEnabled = YES;
        _mTap2GenNewTalkingGroupTitleView.viewGestureRecognizerDelegate = self;
    }
    
    return _mTap2GenNewTalkingGroupTitleView;
}

// UIViewGestureRecognizerDelegate
- (GestureType)supportedGestureInView:(UIView *)pView{
    GestureType _ret = tap;
    
    // check view if it is or not tap to generate new talking group title view
    if (_mTap2GenNewTalkingGroupTitleView == pView) {
        _ret = tap;
    }
    else {
        NSLog(@"View = %@ need supported gesture", pView);
    }
    
    return _ret;
}

- (void)view:(UIView *)pView tapAtPoint:(CGPoint)pPoint andFingerMode:(TapFingerMode)pFingerMode andCountMode:(TapCountMode)pCountMode{
    // check view if it is or not tap to generate new talking group title view
    if (_mTap2GenNewTalkingGroupTitleView == pView) {
        NSLog(@"Tap to generate new talking group");
        
        //
    }
}

// inner extension
- (void)setNavigationTitle7LeftBarButtonItem:(SIMContentViewMode)contentViewType{
    // set title
    self.titleView = self.tap2GenNewTalkingGroupTitleView;
    
    // define left bar button item
    UIBarButtonItem *_leftBarBtnItem;
    
    // check content view type and set left bar button item
    switch (contentViewType) {
        case MYTALKINGGROUPS:
            // check my talking groups bar button item
            if (nil == _mMyTalkingGroupsBarBtnItem) {
                _mMyTalkingGroupsBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"my talking group list left bar button item title", nil) bgImage:[UIImage imageNamed:@"img_right_barbtnitem_bg"] target:self action:@selector(switchContentView)];
            }
            
            _leftBarBtnItem = _mMyTalkingGroupsBarBtnItem;
            break;
            
        case ADDRESSBOOKCONTACTS:
        default:
            // check contacts select bar button item
            if (nil == _mContactsSelectBarBtnItem) {
                _mContactsSelectBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"contacts select left bar button item title", nil) bgImage:[UIImage imageNamed:@"img_right_barbtnitem_bg"] target:self action:@selector(switchContentView)];
            }
            
            _leftBarBtnItem = _mContactsSelectBarBtnItem;
            break;
    }
    
    // set left bar button item
    self.leftBarButtonItem = _leftBarBtnItem;
}

- (void)moreMenuBarBtnItemClicked{
    // show more menu as popup menu
    NSLog(@"Show more menu as popup menu");
    
    //
}

- (void)switchContentView{
    // set content view
    switch (_mContentViewType) {
        case MYTALKINGGROUPS:
            // switch to contacts select view
            [self setContentView:ADDRESSBOOKCONTACTS];
            break;
            
        case ADDRESSBOOKCONTACTS:
        default:
            // switch to my talking groups and its attendees view
            [self setContentView:MYTALKINGGROUPS];
            break;
    }
    
    // update navigation title and left bar button item
    [self setNavigationTitle7LeftBarButtonItem:_mContentViewType];
}

- (void)setContentView:(SIMContentViewMode)contentViewType{
    // save content view tpye
    _mContentViewType = contentViewType;
    
    // check content view type
    switch (contentViewType) {
        case MYTALKINGGROUPS:
            // show my talking groups and its attendees view and hide contacts select view
            if ([_mMyTalkingGroups7AttendeesContentView isHidden]) {
                _mMyTalkingGroups7AttendeesContentView.hidden = NO;
            }
            if (![_mContactsSelectContentView isHidden]) {
                _mContactsSelectContentView.hidden = YES;
            }
            break;
            
        case ADDRESSBOOKCONTACTS:
        default:
            // show contacts select view and hide my talking groups and its attendees view
            if ([_mContactsSelectContentView isHidden]) {
                _mContactsSelectContentView.hidden = NO;
            }
            if (![_mMyTalkingGroups7AttendeesContentView isHidden]) {
                _mMyTalkingGroups7AttendeesContentView.hidden = YES;
            }
            break;
    }
}

@end
