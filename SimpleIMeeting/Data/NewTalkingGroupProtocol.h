//
//  NewTalkingGroupProtocol.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-25.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewTalkingGroupProtocol <NSObject>

@required

// generate new talking group
- (void)generateNewTalkingGroup;

// cancel generate new talking group
- (void)cancelGenNewTalkingGroup;

@end
