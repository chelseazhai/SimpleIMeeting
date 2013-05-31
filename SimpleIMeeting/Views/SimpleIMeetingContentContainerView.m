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

@interface SimpleIMeetingContentContainerView ()

// set navigation title and left bar button item
- (void)setNavigationTitle7LeftBarButtonItem;

// more menu bar button item action selector
- (void)moreMenuBarBtnItemClicked;

// switch content view
- (void)switchContentView;

// set one subview as content view
- (void)setContentViewWithMode:(SIMContentViewMode)contentViewType;

@end

@implementation SimpleIMeetingContentContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set more menu as right bar button item
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_moremenu_barbuttonitem"] bgImage:[UIImage imageNamed:@"img_right_barbtnitem_bg"] target:self action:@selector(moreMenuBarBtnItemClicked)];
        
        // get UIScreen bounds
        CGRect _screenBounds = [[UIScreen mainScreen] bounds];
        
        // update contacts select container view frame
        self.frame = CGRectMake(_screenBounds.origin.x, _screenBounds.origin.y, _screenBounds.size.width, _screenBounds.size.height - /*statusBar height*/[DisplayScreenUtils statusBarHeight] - /*navigationBar default height*/[DisplayScreenUtils navigationBarHeight]);
        
        // create and init subviews and switch one as content view
        _mContactsSelectContentView = [[ContactsSelectView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT)];
        _mMyTalkingGroups7AttendeesContentView = [[MyTalkingGroups7AttendeesView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT)];
        
        // set content view, contacts select as default
        [self setContentViewWithMode:_mContentViewType = AddressBookContacts];
        
        // set navigation title and left bar button item
        [self setNavigationTitle7LeftBarButtonItem];
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
        _mTap2GenNewTalkingGroupTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, [DisplayScreenUtils navigationBarHeight])];
        
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
        
        // ??
    }
}

// inner extension
- (void)setNavigationTitle7LeftBarButtonItem{
    // set title
    self.titleView = self.tap2GenNewTalkingGroupTitleView;
    
    // define left bar button item
    UIBarButtonItem *_leftBarBtnItem;
    
    // check content view type and set left bar button item
    switch (_mContentViewType) {
        case MyTalkingGroups:
            // check my talking groups bar button item
            if (nil == _mMyTalkingGroupsBarBtnItem) {
                _mMyTalkingGroupsBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"my talking group list left bar button item title", nil) bgImage:[UIImage imageNamed:@"img_right_barbtnitem_bg"] target:self action:@selector(switchContentView)];
            }
            
            _leftBarBtnItem = _mMyTalkingGroupsBarBtnItem;
            break;
            
        case AddressBookContacts:
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
    
    // ??
}

- (void)switchContentView{
    // set content view
    switch (_mContentViewType) {
        case MyTalkingGroups:
            // set content view
            [self setContentViewWithMode:(AddressBookContacts)];
            break;
            
        case AddressBookContacts:
        default:
            // set content view
            [self setContentViewWithMode:(MyTalkingGroups)];
            break;
    }
    
    // set navigation title and left bar button item
    [self setNavigationTitle7LeftBarButtonItem];
}

- (void)setContentViewWithMode:(SIMContentViewMode)contentViewType{
    // save content view type
    _mContentViewType = contentViewType;
    
    // get, check and remove old content view first
    if (nil != _mContentView) {
        [_mContentView removeFromSuperview];
    }
    
    // check content view type
    switch (contentViewType) {
        case MyTalkingGroups:
            _mContentView = _mMyTalkingGroups7AttendeesContentView;
            break;
            
        case AddressBookContacts:
        default:
            _mContentView = _mContactsSelectContentView;
            break;
    }
    
    // add content view as subview
    [self addSubview:_mContentView];
}

@end
