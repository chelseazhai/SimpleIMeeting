//
//  ContactBean+ContactsSelect.h
//  SimpleIMeeting
//
//  Created by Ares on 13-6-23.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <CommonToolkit/CommonToolkit.h>

@interface ContactBean (ContactsSelect)

// conatct selected flag
@property (nonatomic, assign) BOOL isSelected;
// contact selected phone number
@property (nonatomic, retain) NSString *selectedPhoneNumber;

@end
