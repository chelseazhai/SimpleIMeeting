//
//  SelectedContactsView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedContactsView : UIView <UITableViewDataSource, UITableViewDelegate> {
    // in talking group attendees phone array
    NSMutableArray *_mInTalkingGroupAttendeesPhoneArray;
    
    // prein talking group contacts info array
    NSMutableArray *_mPreinTalkingGroupContactsInfoArray;
    
    // present subviews
    // subview in or prein talking group contacts table view
    UITableView *_mIn6PreinTalkingGroupContactsTableView;
}

@property (nonatomic, readonly) NSMutableArray *inTalkingGroupAttendeesPhoneArray;

@property (nonatomic, readonly) NSMutableArray *preinTalkingGroupContactsInfoArray;

// add contact to in or prein talking group contacts table view prein talking group section
- (void)addContact2PreinTalkingGroupSection;

// remove the selected contact from in or prein talking group contacts table view prein talking group section
- (void)removeSelectedContactFromPreinTalkingGroupSection:(NSInteger)index;

@end
