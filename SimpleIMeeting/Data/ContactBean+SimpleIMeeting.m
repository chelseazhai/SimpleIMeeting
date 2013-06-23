//
//  ContactBean+SimpleIMeeting.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-23.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ContactBean+SimpleIMeeting.h"

// selected flag key of extension dictionary
#define SELECTEDFLAG_KEY    @"selected flag"
// selected phone number key of extension dictionary
#define SELECTEDPHONENUMBER_KEY @"selected phone number"

@implementation ContactBean (SimpleIMeeting)

- (void)setIsSelected:(BOOL)isSelected{
    [[self extensionDic] setObject:[NSNumber numberWithBool:isSelected] forKey:SELECTEDFLAG_KEY];
}

- (BOOL)isSelected{
    return ((NSNumber *)[[self extensionDic] objectForKey:SELECTEDFLAG_KEY]).boolValue;
}

- (void)setSelectedPhoneNumber:(NSString *)selectedPhoneNumber{
    [[self extensionDic] setObject:selectedPhoneNumber forKey:SELECTEDPHONENUMBER_KEY];
}

- (NSString *)selectedPhoneNumber{
    return [[self extensionDic] objectForKey:SELECTEDPHONENUMBER_KEY];
}

@end
