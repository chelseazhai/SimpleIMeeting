//
//  ITalkingGroupGeneratorProtocol.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-25.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITalkingGroupGeneratorProtocol <NSObject>

@required

// generate new talking group
- (void)generateNewTalkingGroup;

// cancel generate talking group
- (void)cancelGenTalkingGroup;

@optional

// update talking group attendees
- (void)updateTalkingGroupAttendees;

@end
