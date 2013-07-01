//
//  ContactsSelectView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ContactsSelectView.h"

#import "ContactListView.h"
#import "SelectedContactListView.h"

#import "ContactBean+ContactsSelect.h"

// new talking group started time select popup window present content view and its subview height
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING    6.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWTITLELABEL_HEIGHT  30.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABEL6COPYBUTTON_HEIGHT  58.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWDATEPICKER_HEIGHT  180.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWCONTROLLERBUTTON_HEIGHT    34.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_HEIGHT    320.0

// new talking group started time select popup window present content view title and invite note label text font size
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWTITLELABELTEXTFONTSIZE 18.0
#define NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABELTEXTFONTSIZE    15.0

@interface ContactsSelectView ()

// generate contact list view draw rectangle
- (CGRect)genContactListViewDrawRect;

// generate new talking group invite note
- (NSString *)genNewTalkingGroupInviteNote;

// copy new talking group invite note to system clipboard
- (void)copyNewTalkingGroupInviteNote2SystemClipboard;

// new talking group started time select date picker date changed
- (void)newTalkingGroupStartedTimeSelectDatePickerDateChanged;

// schedule new talking group
- (void)scheduleNewTalkingGroup;

// cancel schedule new talking group
- (void)cancelScheduleNewTalkingGroup;

@end

@implementation ContactsSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init addressbook contact list view
        _mABContactListView = [[ContactListView alloc] initWithFrame:[self genContactListViewDrawRect]];
        
        // init selected contact list view
        _mSelectedContactListView = [[SelectedContactListView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + FILL_PARENT * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), self.bounds.origin.y, FILL_PARENT * (RIGHTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT), FILL_PARENT)];
        
        // hidden first
        _mSelectedContactListView.hidden = YES;
        
        // add addressBook contact list view and selected contact list view as subviews of contacts select view
        [self addSubview:_mABContactListView];
        [self addSubview:_mSelectedContactListView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setInTalkingGroupAttendeesPhoneArray:(NSArray *)inTalkingGroupAttendeesPhoneArray{
    // clear in talking group attendees phone array if needed
    if (0 < [_mSelectedContactListView.inTalkingGroupAttendeesPhoneArray count]) {
        [_mSelectedContactListView.inTalkingGroupAttendeesPhoneArray removeAllObjects];
    }
    
    // set new in talking group attendees phone array if not nil
    if (nil != inTalkingGroupAttendeesPhoneArray) {
        [_mSelectedContactListView.inTalkingGroupAttendeesPhoneArray addObjectsFromArray:inTalkingGroupAttendeesPhoneArray];
    }
}

- (NSArray *)inTalkingGroupAttendeesPhoneArray{
    return _mSelectedContactListView.inTalkingGroupAttendeesPhoneArray;
}

- (NSMutableArray *)preinTalkingGroupContactsInfoArray{
    return _mSelectedContactListView.preinTalkingGroupContactsInfoArray;
}

- (void)addContact2SelectedContactListView{
    // add contact to in or prein talking group contact list table view prein talking group section
    [_mSelectedContactListView addContact2PreinTalkingGroupSection];
}

- (void)removeSelectedContactFromSelectedContactListView:(NSInteger)index{
    // get the selected contact index which is in addressBook contact list table view all contacts info array  and present contacts info array
    NSInteger _indexOfAllContactsInfoArray, _indexOfPresentContactsInfoArray = _indexOfAllContactsInfoArray = -1;
    for (NSInteger _index = 0; _index < [_mABContactListView.allContactsInfoArrayInABRef count]; _index++) {
        // compare contact id which is in addressBook contact list table view all contacts info array with the selected contact id
        if (((ContactBean *)[_mABContactListView.allContactsInfoArrayInABRef objectAtIndex:_index]).id == ((ContactBean *)[self.preinTalkingGroupContactsInfoArray objectAtIndex:index]).id) {
            // update index of all contacts info array
            _indexOfAllContactsInfoArray = _index;
            
            // update index of present contacts info array
            if ([_mABContactListView.presentContactsInfoArrayRef containsObject:[_mABContactListView.allContactsInfoArrayInABRef objectAtIndex:_index]]) {
                _indexOfPresentContactsInfoArray = [_mABContactListView.presentContactsInfoArrayRef indexOfObject:[_mABContactListView.allContactsInfoArrayInABRef objectAtIndex:_index]];
            }
            
            break;
        }
    }
    
    // check index of all contacts info array
    if (0 <= _indexOfAllContactsInfoArray) {
        // check index of present contacts info array
        if (0 <= _indexOfPresentContactsInfoArray) {
            // recover selected address book contact which is in present contacts info array cell is selected flag
            [_mABContactListView recoverSelectedContactCellIsSelectedFlag:_indexOfPresentContactsInfoArray];
        }
        
        // get the selected contact contactBean
        ContactBean *_selectedContactBean = [_mABContactListView.allContactsInfoArrayInABRef objectAtIndex:_indexOfAllContactsInfoArray];
        
        // recover the selected contact is selected flag and selected phone
        _selectedContactBean.isSelected = NO;
        _selectedContactBean.selectedPhoneNumber = @"";
    }
    else {
        NSLog(@"Info: temp added contact, needn't to recover original contact attributes");
    }
    
    // remove the selected contact from prein talking group contacts info array
    [self.preinTalkingGroupContactsInfoArray removeObjectAtIndex:index];
    
    // remove the selected contact from in or prein talking group contact list table view prein talking group section
    [_mSelectedContactListView removeSelectedContactFromPreinTalkingGroupSection:index];
}

- (void)showNewTalkingGroupStartedTimeSelectView:(NSString *)newTalkingGroupId{
    // save new talking group id
    _mNew6SelectedContactsAddingTalkingGroupId = newTalkingGroupId;
    
    // check new talking group started time select popup window
    if (nil == _mNewTalkingGroupStartedTimeSelectPopupWindow) {
        // init new talking group started time select popup window
        _mNewTalkingGroupStartedTimeSelectPopupWindow = [[UIPopupWindow alloc] init];
        
        // define new talking group started time select popup window present content view
        UIView *_presentContentView;
        
        // init new talking group started time select popup window present content view
        _presentContentView = [_presentContentView = [UIView alloc] initWithFrame:CGRectMakeWithFormat(_presentContentView, [NSNumber numberWithFloat:_mNewTalkingGroupStartedTimeSelectPopupWindow.bounds.origin.x], [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+(%s-%d)", (int)_mNewTalkingGroupStartedTimeSelectPopupWindow.bounds.origin.y, FILL_PARENT_STRING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:FILL_PARENT], [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEW_HEIGHT])];
        
        // set its background color
        _presentContentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        
        // init new talking group started time select popup window present content view date picker
        _mNewTalkingGroupStartedTimeSelectDatePicker = [[UIDatePicker alloc] init];
        
        // init new talking group started time select popup window present content view title label
        UILabel *_presentContentViewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_presentContentView.bounds.origin.x, _presentContentView.bounds.origin.y, FILL_PARENT, NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWTITLELABEL_HEIGHT)];
        
        // set its attributes
        _presentContentViewTitleLabel.text = NSLocalizedString(@"new talking group started time select popup window title label text", nil);
        _presentContentViewTitleLabel.textColor = [UIColor whiteColor];
        _presentContentViewTitleLabel.textAlignment = NSTextAlignmentCenter;
        _presentContentViewTitleLabel.font = [UIFont boldSystemFontOfSize:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWTITLELABELTEXTFONTSIZE];
        _presentContentViewTitleLabel.backgroundColor = [UIColor clearColor];
        
        // init new talking group started time select popup window present content view invite note label
        _mNewTalkingGroupInviteNoteLabel = [_mNewTalkingGroupInviteNoteLabel = [UILabel alloc] initWithFrame:CGRectMakeWithFormat(_mNewTalkingGroupInviteNoteLabel, [NSNumber numberWithFloat:_presentContentView.bounds.origin.x + NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING], [NSNumber numberWithFloat:_presentContentView.bounds.origin.y + _presentContentViewTitleLabel.frame.size.height], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-4*%d-%d", FILL_PARENT_STRING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABEL6COPYBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABEL6COPYBUTTON_HEIGHT])];
        
        // set its attributes
        _mNewTalkingGroupInviteNoteLabel.text = [self genNewTalkingGroupInviteNote];
        _mNewTalkingGroupInviteNoteLabel.textColor = [UIColor whiteColor];
        _mNewTalkingGroupInviteNoteLabel.font = [UIFont systemFontOfSize:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABELTEXTFONTSIZE];
        _mNewTalkingGroupInviteNoteLabel.numberOfLines = 0;
        _mNewTalkingGroupInviteNoteLabel.backgroundColor = [UIColor clearColor];
        
        // init new talking group invite note copy button
        UIButton *_copyNewTalkingGroupInviteNoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_copyNewTalkingGroupInviteNoteButton setFrame:CGRectMakeWithFormat(_copyNewTalkingGroupInviteNoteButton, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%s-%d-%d", (int)_presentContentView.bounds.origin.x, FILL_PARENT_STRING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABEL6COPYBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:_presentContentView.bounds.origin.y + _presentContentViewTitleLabel.frame.size.height], [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABEL6COPYBUTTON_HEIGHT], [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWINVITENOTELABEL6COPYBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_copyNewTalkingGroupInviteNoteButton setTitle:NSLocalizedString(@"new talking group invite note copy button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_copyNewTalkingGroupInviteNoteButton addTarget:self action:@selector(copyNewTalkingGroupInviteNote2SystemClipboard) forControlEvents:UIControlEventTouchUpInside];
        
        // set new talking group started time select popup window present content view date picker frame
        [_mNewTalkingGroupStartedTimeSelectDatePicker setFrame:CGRectMake(_presentContentView.bounds.origin.x, _presentContentView.bounds.origin.y + _presentContentViewTitleLabel.frame.size.height + _mNewTalkingGroupInviteNoteLabel.frame.size.height + NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING, FILL_PARENT, NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWDATEPICKER_HEIGHT)];
        
        // add its date changed target and action selector
        [_mNewTalkingGroupStartedTimeSelectDatePicker addTarget:self action:@selector(newTalkingGroupStartedTimeSelectDatePickerDateChanged) forControlEvents:UIControlEventValueChanged];
        
        // new talking group started time select popup window present content view controller button origin y number and width value
        NSNumber *_newTalkingGroupStartedTimeSelectPopupWindowControllerButtonOriginYNumber = [NSNumber numberWithFloat:_presentContentView.bounds.origin.y + _presentContentViewTitleLabel.frame.size.height + _mNewTalkingGroupInviteNoteLabel.frame.size.height + _mNewTalkingGroupStartedTimeSelectDatePicker.frame.size.height + 2 * NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING];
        NSValue *_newTalkingGroupStartedTimeSelectPopupWindowControllerButtonWidthValue = [NSValue valueWithCString:[[NSString stringWithFormat:@"(%s-4*%d)/2", FILL_PARENT_STRING, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING] cStringUsingEncoding:NSUTF8StringEncoding]];
        
        // init schedule new talking group controller button
        UIButton *_scheduleNewTalkingGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_scheduleNewTalkingGroupButton setFrame:CGRectMakeWithFormat(_scheduleNewTalkingGroupButton, [NSNumber numberWithFloat:_presentContentView.bounds.origin.x + NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING], _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonOriginYNumber, _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonWidthValue, [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWCONTROLLERBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_scheduleNewTalkingGroupButton setTitle:NSLocalizedString(@"schedule new talking group button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_scheduleNewTalkingGroupButton addTarget:self action:@selector(scheduleNewTalkingGroup) forControlEvents:UIControlEventTouchUpInside];
        
        // init cancel schedule new talking group controller button
        UIButton *_cancelScheduleNewTalkingGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_cancelScheduleNewTalkingGroupButton setFrame:CGRectMakeWithFormat(_cancelScheduleNewTalkingGroupButton, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%@+3*%d", (int)_presentContentView.bounds.origin.x, _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonWidthValue.stringValue, (int)NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWPADDING] cStringUsingEncoding:NSUTF8StringEncoding]], _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonOriginYNumber, _newTalkingGroupStartedTimeSelectPopupWindowControllerButtonWidthValue, [NSNumber numberWithFloat:NEWTALKINGGROUPSTARTEDTIMESELECTPOPUPWINDOWPRESENTCONTENTVIEWCONTROLLERBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_cancelScheduleNewTalkingGroupButton setTitle:NSLocalizedString(@"cancel schedule new talking group button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_cancelScheduleNewTalkingGroupButton addTarget:self action:@selector(cancelScheduleNewTalkingGroup) forControlEvents:UIControlEventTouchUpInside];
        
        // add title, new talking group invite note label, copy new talking group invite note button, new talking group started time select date picker, schedule and cancel schedule new talking group button as subviews of new talking group started time select present content view
        [_presentContentView addSubview:_presentContentViewTitleLabel];
        [_presentContentView addSubview:_mNewTalkingGroupInviteNoteLabel];
        [_presentContentView addSubview:_copyNewTalkingGroupInviteNoteButton];
        [_presentContentView addSubview:_mNewTalkingGroupStartedTimeSelectDatePicker];
        [_presentContentView addSubview:_scheduleNewTalkingGroupButton];
        [_presentContentView addSubview:_cancelScheduleNewTalkingGroupButton];
        
        // set its present content view
        _mNewTalkingGroupStartedTimeSelectPopupWindow.presentContentView = _presentContentView;
    }
    else {
        // update new talking group started time select date picker
        _mNewTalkingGroupStartedTimeSelectDatePicker.date = [NSDate date];
        
        // update new talking group invite note label text
        _mNewTalkingGroupInviteNoteLabel.text = [self genNewTalkingGroupInviteNote];
    }
    
//    // set current date as new talking goup started time select date picker minimum date
//    _mNewTalkingGroupStartedTimeSelectDatePicker.minimumDate = [NSDate date];
    
    // show new talking group started time select popup window
    [_mNewTalkingGroupStartedTimeSelectPopupWindow showAtLocation:self];
}

- (void)cancel6finishContactsSelecting{
    // clear in talking group attendees phone array if needed
    if (0 < [self.inTalkingGroupAttendeesPhoneArray count]) {
        [self setInTalkingGroupAttendeesPhoneArray:nil];
    }
    
    // clear prein talking group contacts info array if needed
    while (0 < [self.preinTalkingGroupContactsInfoArray count]) {
        // get the will be removed prein talking group contact index
        NSInteger _index = [self.preinTalkingGroupContactsInfoArray count] - 1;
        
        // remove each contact extension dictionary and contact from prein talking group contacts info array
        [((ContactBean *)[self.preinTalkingGroupContactsInfoArray objectAtIndex:_index]).extensionDic removeAllObjects];
        
        // remove selected contact from selected contact list view
        [self removeSelectedContactFromSelectedContactListView:_index];
    }
    
    // clear contact list view contact search text field text and selected address book contact cell index
    [_mABContactListView clearContactSearchTextFieldText7SelectedABContactCellIndex];
}

// NewTalkingGroupProtocol
- (void)generateNewTalkingGroup{
    // set it is ready for adding selected contact for inviting
    _mReady4AddingSelectedContact4Inviting = YES;
    
    // update address book contact list view
    [_mABContactListView setFrame:[self genContactListViewDrawRect]];
    
    // show selected contact list view
    if ([_mSelectedContactListView isHidden]) {
        _mSelectedContactListView.hidden = NO;
    }
}

- (void)cancelGenNewTalkingGroup{
    // set it is not ready for adding selected contact for inviting
    _mReady4AddingSelectedContact4Inviting = NO;
    
    // update address book contact list view
    [_mABContactListView setFrame:[self genContactListViewDrawRect]];
    
    // hide selected contact list view
    if (![_mSelectedContactListView isHidden]) {
        _mSelectedContactListView.hidden = YES;
    }
    
    // cancel contacts selecting
    [self cancel6finishContactsSelecting];
}

// inner extension
- (CGRect)genContactListViewDrawRect{
    CGRect _contactListViewDrawRectangle;
    
    // check address book contact list view if or not init
    if (nil == _mABContactListView) {
        _contactListViewDrawRectangle = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT);
    }
    else {
        // get address book contact list view frame
        _contactListViewDrawRectangle = _mABContactListView.frame;
        
        // check is ready for adding selected contact for inviting to the new talking group and update address book contact list view draw rectangle width
        if (_mReady4AddingSelectedContact4Inviting) {
            // compare address book contact list view frame size width with its parent view frame size width
            if (self.frame.size.width == _mABContactListView.frame.size.width) {
                _contactListViewDrawRectangle.size.width = _mABContactListView.frame.size.width * (LEFTSEPARATESUBVIEW_WEIGHT / TOTAL_WEIGHT);
            }
        }
        else {
            // recover as parent view frame size width
            _contactListViewDrawRectangle.size.width = self.frame.size.width;
        }
    }
    
    return _contactListViewDrawRectangle;
}

- (NSString *)genNewTalkingGroupInviteNote{
    // define date format
    NSDateFormatter *_dateFormat = [[NSDateFormatter alloc] init];
    
    // set time zone and date format
    [_dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    [_dateFormat setDateFormat:NSLocalizedString(@"new talking group started time select date picker date format string", nil)];
    
    return [NSString stringWithFormat:NSLocalizedString(@"new talking group invite note label text format string", nil), [_dateFormat stringFromDate:_mNewTalkingGroupStartedTimeSelectDatePicker.date], _mNew6SelectedContactsAddingTalkingGroupId];
}

- (void)copyNewTalkingGroupInviteNote2SystemClipboard{
    NSLog(@"copy new talking group invite note = %@ to system clipboard", _mNewTalkingGroupInviteNoteLabel.text);
    
    //
}

- (void)newTalkingGroupStartedTimeSelectDatePickerDateChanged{
    // update new talking group invite note label text
    _mNewTalkingGroupInviteNoteLabel.text = [self genNewTalkingGroupInviteNote];
}

- (void)scheduleNewTalkingGroup{
    // define gregorian calendar and used unit flags
    NSCalendar *_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger _unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    // define new talking group started time unix date
    NSDate *_newTalkingGroupStartedTimeUnixDate;
    
    // compare new talking group started time with current date
    switch ([_newTalkingGroupStartedTimeUnixDate = [_calendar dateFromComponents:[_calendar components:_unitFlags fromDate:_mNewTalkingGroupStartedTimeSelectDatePicker.date]] compare:[_calendar dateFromComponents:[_calendar components:_unitFlags fromDate:[NSDate date]]]]) {
        case NSOrderedAscending:
            // selected time has been passed
            NSLog(@"Error: the selected started time for new talking group has been passed");
            
            // show toast
            [[iToast makeText:NSToastLocalizedString(@"toast new talking group started time selected is too early", nil)] show:iToastTypeError];
            break;
            
        case NSOrderedSame:
            // create and start an new talking group immediately
            NSLog(@"create and start new talking group immediately");
            
            //
            break;
            
        case NSOrderedDescending:
        default:
            // schedule an new talking group at selected started time
            NSLog(@"schedule an new talking group at selected time = %@", _newTalkingGroupStartedTimeUnixDate);
            
            //
            break;
    }
}

- (void)cancelScheduleNewTalkingGroup{
    // dismiss new talking group started time select popup window
    [_mNewTalkingGroupStartedTimeSelectPopupWindow dismiss];
}

@end
