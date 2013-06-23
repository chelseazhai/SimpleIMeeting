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
    // subview selected contacts table view
    UITableView *_mSelectedContactsTableView;
}

@property (nonatomic, retain) NSMutableArray *inTalkingGroupAttendeesPhoneArray;

@property (nonatomic, retain) NSMutableArray *preinTalkingGroupContactsInfoArray;

@end
