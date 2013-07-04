//
//  In6PreinTalkingGroupContactTableViewCell.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

@interface In6PreinTalkingGroupContactTableViewCell : UITableViewCell {
    // prein talking group contact in talking gruop flag
    BOOL _mContactIsInTalkingGroupFlag;
    // prein talking group contact display name
    NSString *_mDisplayName;
    
    // prein talking group contact indicate imageview
    UIImageView *_mIndicateImgView;
    // prein talking group contact display name label
    UILabel *_mDisplayNameLabel;
}

@property (nonatomic, assign) BOOL contactIsInTalkingGroupFlag;
@property (nonatomic, retain) NSString *displayName;

// get the height of the in or prein talking group contact list tableViewCell
+ (CGFloat)cellHeight;

@end
