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

#import "KxMenu.h"

#import "SettingViewController.h"

#import "SupportViewController.h"

#import "AssistantCommonViewController.h"
#import "AboutView.h"

// tap to generate new talking group title view width
#define TAP2GENNEWTALKINGGROUPTITLEVIEW_WIDTH   100.0

// tap to generate new talking group title view text font size
#define TAP2GENNEWTALKINGGROUPTITLEVIEW_TEXTFONTSIZE    20.0

@interface SimpleIMeetingContentContainerView ()

// set navigation title and left bar button item with content view type and is ready for adding selected contact for inviting flag
- (void)setNavigationTitle7LeftBarButtonItem:(SIMContentViewMode)contentViewType ready4AddingSelectedContact4InvitingFlag:(BOOL)isReady4AddingSelectedContact4Inviting;

// more menu bar button item action selector
- (void)moreMenuBarBtnItemClicked:(UIButton *)moreMenuBarBtnItem;

// more menu setting, support and about item action selector
- (void)moreMenuItemActionSelector:(KxMenuItem *)moreMenuItem;

// back to my talking groups and selected talking group attendees or contacts select content view
- (void)back2MyTalkingGroups7Attendees6ContactsSelectContentView;

// set contacts select or my talking groups and selected talking group attednees subview as content view
- (void)setContentView:(SIMContentViewMode)contentViewType;

// switch content view
- (void)switchContentView;

@end

@implementation SimpleIMeetingContentContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set navigation title and left bar button item with default contacts select as content view
        [self setNavigationTitle7LeftBarButtonItem:_mContentViewType = ADDRESSBOOKCONTACTS ready4AddingSelectedContact4InvitingFlag:NO];
        
        // set more menu as right bar button item
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_moremenu_barbuttonitem"] bgImage:[UIImage imageNamed:@"img_right_barbtnitem_bg"] target:self action:@selector(moreMenuBarBtnItemClicked:)];
        
        // create and init subviews and switch one as content view
        // init contacts select content view
        _mContactsSelectContentView = [[ContactsSelectView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT)];
        
        // init my talking groups and selected talking group attendees content view
        _mMyTalkingGroups7AttendeesContentView = [[MyTalkingGroups7AttendeesView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT)];
        
        // set my talking groups need to refresh
        _mMyTalkingGroups7AttendeesContentView.myTalkingGroupsNeed2Refresh = YES;
        
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

- (void)generateTalkingGroup:(UIResponder *)responder{
    // update navigation title and left bar button item
    [self setNavigationTitle7LeftBarButtonItem:_mContentViewType ready4AddingSelectedContact4InvitingFlag:YES];
    
    // check generate talking group responder
    if ([responder isKindOfClass:[UIButton class]]) {
        // update existed talking group attendees using its implementation
        [_mTalkingGroupGeneratorProtocolImpl updateTalkingGroupAttendees];
    }
    else if ([responder isKindOfClass:[UILabel class]] || [responder isKindOfClass:[UITableViewCell class]]) {
        // generate new talking group using its implementation
        [_mTalkingGroupGeneratorProtocolImpl generateNewTalkingGroup];
    }
}

- (void)switch2ContactsSelectContentView4AddingSelectedContact4Inviting:(NSArray *)selectedContacts4Adding2TalkingGroupId7StartedTimestampAndAddedContactsPhones{
    // set conatcts select content view as content view of simple imeeting content container view
    [self setContentView:ADDRESSBOOKCONTACTS];
    
    // check selected contacts for adding to the talking group id, started time timestamp and added contacts phones
    if (nil == selectedContacts4Adding2TalkingGroupId7StartedTimestampAndAddedContactsPhones) {
        // set had been added contacts phone array as contacts select content view in talking group attendees phone array
        _mContactsSelectContentView.inTalkingGroupAttendeesPhoneArray = selectedContacts4Adding2TalkingGroupId7StartedTimestampAndAddedContactsPhones;
    }
    else if (nil != selectedContacts4Adding2TalkingGroupId7StartedTimestampAndAddedContactsPhones && 2 <= [selectedContacts4Adding2TalkingGroupId7StartedTimestampAndAddedContactsPhones count]) {
        // set selected contacts for adding to the talking group id and started time timestamp
        [_mContactsSelectContentView setSelectedContacts4Adding2TalkingGroupId:[selectedContacts4Adding2TalkingGroupId7StartedTimestampAndAddedContactsPhones objectAtIndex:0] startedTimestamp:[selectedContacts4Adding2TalkingGroupId7StartedTimestampAndAddedContactsPhones objectAtIndex:1]];
        
        // set had been added contacts phone array as contacts select content view in talking group attendees phone array
        _mContactsSelectContentView.inTalkingGroupAttendeesPhoneArray = [selectedContacts4Adding2TalkingGroupId7StartedTimestampAndAddedContactsPhones subarrayWithRange:NSMakeRange(2, [selectedContacts4Adding2TalkingGroupId7StartedTimestampAndAddedContactsPhones count] - 2)];
    }
    else {
        NSLog(@"Error: set contacts select content view in talking group attendees phone array error, selected contacts for adding to the talking group id, started time timestamp and added contacts phones = %@", selectedContacts4Adding2TalkingGroupId7StartedTimestampAndAddedContactsPhones);
    }
    
    // set contacts select content view is ready for adding selected contact for inviting to talking group
    [_mTalkingGroupGeneratorProtocolImpl generateNewTalkingGroup];
    
    // recover new talking group protocol implementation
    _mTalkingGroupGeneratorProtocolImpl = _mMyTalkingGroups7AttendeesContentView;
}

- (void)back2MyTalkingGroups7AttendeesContentView4EndingAddSelectedContact4Inviting:(MyTalkingGroups7AttendeesViewRefreshType)myTalkingGroups7AttendeesViewRefreshType{
    // set contacts select content view is not ready for adding selected contact for inviting to talking group
    [_mContactsSelectContentView cancelGenTalkingGroup];
    
    // check my talking groups and selected talking group attendees view needed to refresh type
    switch (myTalkingGroups7AttendeesViewRefreshType) {
        case REFRESH_TALKINGGROUPS:
            // set my talking groups needed to refresh
            _mMyTalkingGroups7AttendeesContentView.myTalkingGroupsNeed2Refresh = YES;
            break;
            
        case REFRESH_SELECTEDTALKINGGROUP_ATTENDEES:
            // refresh the selected talking group attendees
            [_mMyTalkingGroups7AttendeesContentView refreshSelectedTalkingGroupAttendees];
            break;
            
        case NOREFRESH:
        default:
            // needn't to refresh my talking groups and selected talking group attendees
            break;
    }
    
    // set my talking groups and selected talking group attendees content view as content view of simple imeeting content container view
    [self switchContentView];
}

- (void)setMyTalkingGroupsNeed2Refresh{
    // check content view type
    if (ADDRESSBOOKCONTACTS == _mContentViewType) {
        // set my talking groups need to refresh
        _mMyTalkingGroups7AttendeesContentView.myTalkingGroupsNeed2Refresh = YES;
    }
    else {
        // refresh my talking groups
        [_mMyTalkingGroups7AttendeesContentView refreshMyTalkingGroups];
    }
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
        // tap to generate new talking group
        [self generateTalkingGroup:pView];
    }
}

// inner extension
- (void)setNavigationTitle7LeftBarButtonItem:(SIMContentViewMode)contentViewType ready4AddingSelectedContact4InvitingFlag:(BOOL)isReady4AddingSelectedContact4Inviting{
    // set title
    // check is ready for adding selected contact for inviting flag
    if (isReady4AddingSelectedContact4Inviting) {
        // set title
        self.titleView = nil;
        self.title = NSLocalizedString(@"ready for adding selected contact for inviting to talking group title", nil);
    }
    else {
        // check tap to generate new talking group title view
        if (nil == _mTap2GenNewTalkingGroupTitleView) {
            // create and init tap to generate new talking group title view
            _mTap2GenNewTalkingGroupTitleView = [[UILabel alloc] initWithFrame:CGRectMake(CGPointZero.x, CGPointZero.y, TAP2GENNEWTALKINGGROUPTITLEVIEW_WIDTH, [DisplayScreenUtils navigationBarHeight])];
            
            // set its attributes
            _mTap2GenNewTalkingGroupTitleView.text = NSLocalizedString(@"tap to generate new talking group title view title", nil);
            _mTap2GenNewTalkingGroupTitleView.textColor = [UIColor whiteColor];
            _mTap2GenNewTalkingGroupTitleView.shadowColor = [UIColor darkGrayColor];
            _mTap2GenNewTalkingGroupTitleView.font = [UIFont boldSystemFontOfSize:TAP2GENNEWTALKINGGROUPTITLEVIEW_TEXTFONTSIZE];
            _mTap2GenNewTalkingGroupTitleView.textAlignment = NSTextAlignmentCenter;
            _mTap2GenNewTalkingGroupTitleView.backgroundColor = [UIColor clearColor];
            
            // set tap to generate new talking group title view tap gesture recognizer
            _mTap2GenNewTalkingGroupTitleView.userInteractionEnabled = YES;
            _mTap2GenNewTalkingGroupTitleView.viewGestureRecognizerDelegate = self;
        }
        
        // set title view
        self.titleView = _mTap2GenNewTalkingGroupTitleView;
    }
    
    // define left bar button item
    UIBarButtonItem *_leftBarBtnItem;
    
    // check is ready for adding selected contact for inviting flag again
    if (isReady4AddingSelectedContact4Inviting) {
        // check back to my talking groups and selected talking group attendees or contacts select content view bar button item
        if (nil == _mBack2MyTalkingGroups7Attendees6ContactsSelectContentViewBarBtnItem) {
            _mBack2MyTalkingGroups7Attendees6ContactsSelectContentViewBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back to content view bar button item title", nil) bgImage:[UIImage imageNamed:@"img_left_barbtnitem_bg"] target:self action:@selector(back2MyTalkingGroups7Attendees6ContactsSelectContentView)];
        }
        
        _leftBarBtnItem = _mBack2MyTalkingGroups7Attendees6ContactsSelectContentViewBarBtnItem;
    }
    else {
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
    }
    
    // set left bar button item
    self.leftBarButtonItem = _leftBarBtnItem;
}

- (void)moreMenuBarBtnItemClicked:(UIButton *)moreMenuBarBtnItem{
    // define more menu items
    NSArray *_moreMenuItems =
    @[
      [KxMenuItem menuItem:NSLocalizedString(@"more menu setting item title", nil) image:nil target:self action:@selector(moreMenuItemActionSelector:)], [KxMenuItem menuItem:NSLocalizedString(@"more menu support item title", nil) image:nil target:self action:@selector(moreMenuItemActionSelector:)], [KxMenuItem menuItem:NSLocalizedString(@"more menu about item title", nil) image:nil target:self action:@selector(moreMenuItemActionSelector:)]
      ];
    
    // show more menu as popup menu
    [KxMenu showMenuInView:self.window fromRect:CGRectMake(moreMenuBarBtnItem.frame.origin.x, moreMenuBarBtnItem.frame.size.height - moreMenuBarBtnItem.frame.origin.y / 2, moreMenuBarBtnItem.frame.size.width, moreMenuBarBtnItem.frame.size.height) menuItems:_moreMenuItems];
}

- (void)moreMenuItemActionSelector:(KxMenuItem *)moreMenuItem{
    // check more menu item title
    if ([NSLocalizedString(@"more menu setting item title", nil) isEqualToString:moreMenuItem.title]) {
        // go to setting view using setting view controller
        [self.viewControllerRef.navigationController pushViewController:[[SettingViewController alloc] initWithSponsorContentViewType:_mContentViewType] animated:YES];
    }
    else if ([NSLocalizedString(@"more menu support item title", nil) isEqualToString:moreMenuItem.title]) {
        // go to support view using assistant common view controller
        [self.viewControllerRef.navigationController pushViewController:[[SupportViewController alloc] initWithSponsorContentViewType:_mContentViewType] animated:YES];
    }
    else if ([NSLocalizedString(@"more menu about item title", nil) isEqualToString:moreMenuItem.title]) {
        // go to about view using assistant common view controller
        [self.viewControllerRef.navigationController pushViewController:[[AssistantCommonViewController alloc] initWithSponsorContentViewType:_mContentViewType presentView:[[AboutView alloc] init]] animated:YES];
    }
}

- (void)back2MyTalkingGroups7Attendees6ContactsSelectContentView{
    // update navigation title and left bar button item
    [self setNavigationTitle7LeftBarButtonItem:_mContentViewType ready4AddingSelectedContact4InvitingFlag:NO];
    
    // cancel generate talking group using its implementation
    [_mTalkingGroupGeneratorProtocolImpl cancelGenTalkingGroup];
}

- (void)setContentView:(SIMContentViewMode)contentViewType{
    // save content view tpye
    _mContentViewType = contentViewType;
    
    // check content view type
    switch (contentViewType) {
        case MYTALKINGGROUPS:
            // show my talking groups and selected talking group attendees view and hide contacts select view
            if ([_mMyTalkingGroups7AttendeesContentView isHidden]) {
                _mMyTalkingGroups7AttendeesContentView.hidden = NO;
            }
            if (![_mContactsSelectContentView isHidden]) {
                _mContactsSelectContentView.hidden = YES;
            }
            
            // check if or not my talking groups need to refresh
            if (_mMyTalkingGroups7AttendeesContentView.myTalkingGroupsNeed2Refresh) {
                // refresh my talking groups
                [_mMyTalkingGroups7AttendeesContentView refreshMyTalkingGroups];
            }
            
            // set my talking groups and selected talking group attendees content view as new talking group protocol implementation
            _mTalkingGroupGeneratorProtocolImpl = _mMyTalkingGroups7AttendeesContentView;
            
            break;
            
        case ADDRESSBOOKCONTACTS:
        default:
            // show contacts select view and hide my talking groups and selected talking group attendees view
            if ([_mContactsSelectContentView isHidden]) {
                _mContactsSelectContentView.hidden = NO;
            }
            if (![_mMyTalkingGroups7AttendeesContentView isHidden]) {
                _mMyTalkingGroups7AttendeesContentView.hidden = YES;
            }
            
            // set contacts select content view as new talking group protocol implementation
            _mTalkingGroupGeneratorProtocolImpl = _mContactsSelectContentView;
            
            break;
    }
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
            // switch to my talking groups and selected talking group attendees view
            [self setContentView:MYTALKINGGROUPS];
            break;
    }
    
    // update navigation title and left bar button item
    [self setNavigationTitle7LeftBarButtonItem:_mContentViewType ready4AddingSelectedContact4InvitingFlag:NO];
}

@end
