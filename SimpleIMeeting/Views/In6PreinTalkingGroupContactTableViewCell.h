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
    // contact in talking gruop flag
    BOOL _mContactIsInTalkingGroupFlag;
    // contact display name label text
    NSString *_mDisplayName;
    
    // contact indicate photo imageView
    UIImageView *_mIndicatePhotoImgView;
    // contact display name label
    UILabel *_mDisplayNameLabel;
}

@property (nonatomic, assign) BOOL contactIsInTalkingGroupFlag;
@property (nonatomic, retain) NSString *displayName;

// get the height of the in or prein talking group contacts tableViewCell
+ (CGFloat)cellHeight;

@end
