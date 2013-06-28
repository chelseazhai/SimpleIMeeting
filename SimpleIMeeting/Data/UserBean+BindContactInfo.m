//
//  UserBean+BindContactInfo.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "UserBean+BindContactInfo.h"

// user bind contact info, nickname, contacts info and its type be binded extension storage key
#define EXT_USERBINDCONTACTINFO_KEY @"user bind contact info extension key"
#define EXT_USERNICKNAME_KEY    @"user nickname extension key"
#define EXT_USERCONTACTSINFOTYPEBEBINDED_KEY    @"user contacts info type be binded extension key"
#define EXT_USERCONTACTSINFOBEBINDED_KEY    @"user contacts info be binded extension key"

@implementation UserBean (BindContactInfo)

- (void)setBindContactInfo:(NSString *)bindContactInfo{
    // set user bind contact info to user bean extension dictionary
    [self.extensionDic setObject:bindContactInfo forKey:EXT_USERBINDCONTACTINFO_KEY];
}

- (NSString *)bindContactInfo{
    // return user bind contact info be storage in user bean extension dictionary
    return [self.extensionDic objectForKey:EXT_USERBINDCONTACTINFO_KEY];
}

- (void)setNickname:(NSString *)nickname{
    // set user nickname to user bean extension dictionary
    [self.extensionDic setObject:nickname forKey:EXT_USERNICKNAME_KEY];
}

- (NSString *)nickname{
    // return user nickname be storage in user bean extension dictionary
    return [self.extensionDic objectForKey:EXT_USERNICKNAME_KEY];
}

- (void)setContactsInfoTypeBeBinded:(NSString *)contactsInfoTypeBeBinded{
    // set user contacts info type be binded to user bean extension dictionary
    [self.extensionDic setObject:contactsInfoTypeBeBinded forKey:EXT_USERCONTACTSINFOTYPEBEBINDED_KEY];
}

- (NSString *)contactsInfoTypeBeBinded{
    // return user contacts info type be binded be storage in user bean extension dictionary
    return [self.extensionDic objectForKey:EXT_USERCONTACTSINFOTYPEBEBINDED_KEY];
}

- (void)setContactsInfoBeBinded:(NSString *)contactsInfoBeBinded{
    // set user contacts info be binded to user bean extension dictionary
    [self.extensionDic setObject:contactsInfoBeBinded forKey:EXT_USERCONTACTSINFOBEBINDED_KEY];
}

- (NSString *)contactsInfoBeBinded{
    // return user contacts info be binded be storage in user bean extension dictionary
    return [self.extensionDic objectForKey:EXT_USERCONTACTSINFOBEBINDED_KEY];
}

@end
