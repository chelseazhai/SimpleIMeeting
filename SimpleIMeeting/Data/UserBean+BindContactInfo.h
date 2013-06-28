//
//  UserBean+BindContactInfo.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <CommonToolkit/CommonToolkit.h>

@interface UserBean (BindContactInfo)

// user bind contact info
@property (nonatomic, retain) NSString *bindContactInfo;

// user nickname
@property (nonatomic, retain) NSString *nickname;

// user contacts info type be binded
@property (nonatomic, retain) NSString *contactsInfoTypeBeBinded;

// user contacts info be binded
@property (nonatomic, retain) NSString *contactsInfoBeBinded;

@end
