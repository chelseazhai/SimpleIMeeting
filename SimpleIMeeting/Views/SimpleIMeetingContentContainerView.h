//
//  SimpleIMeetingContentContainerView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

@class ContactsSelectView;
@class MyTalkingGroups7AttendeesView;

// simple imeeting content view mode
typedef NS_ENUM(NSInteger, SIMContentViewMode) {
    // adress book contacts and my talking groups
    ADDRESSBOOKCONTACTS,
    MYTALKINGGROUPS
};




@interface SimpleIMeetingContentContainerView : UIView <UIViewGestureRecognizerDelegate> {
    // tap to generate new talking group title view
    UILabel *_mTap2GenNewTalkingGroupTitleView;
    
    // my talking groups and contacts select bar button item
    UIBarButtonItem *_mMyTalkingGroupsBarBtnItem;
    UIBarButtonItem *_mContactsSelectBarBtnItem;
    
    // content view type
    SIMContentViewMode _mContentViewType;
    
    // content present subviews
    // subview contacts select view
    ContactsSelectView *_mContactsSelectContentView;
    // subview my talking group and attendee list
    MyTalkingGroups7AttendeesView *_mMyTalkingGroups7AttendeesContentView;
}

@property (nonatomic, readonly) UILabel *tap2GenNewTalkingGroupTitleView;

@end
