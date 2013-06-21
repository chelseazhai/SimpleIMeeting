//
//  ContactListView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ContactListView.h"

#import "SimpleIMeetingTableViewTipView.h"

// contact operate view height
#define CONTACTOPERATEVIEW_HEIGHT   38.0

@implementation ContactListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init contact list head tip view
        SimpleIMeetingTableViewTipView *_contactListHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:LeftAlign_TipView andParentView:self];
        
        // set contact list head tip view text
        [_contactListHeadTipView setTipViewText:NSLocalizedString(@"contacts select contact list head tip view text", nil)];
        
        // define contacts container view
        UIView *_contactsContainerView;
        
        // init contacts container view
        _contactsContainerView = [_contactsContainerView = [UIView alloc] initWithFrame:CGRectMakeWithFormat(_contactsContainerView, [NSNumber numberWithFloat:self.bounds.origin.x], [NSNumber numberWithFloat:self.bounds.origin.y + _contactListHeadTipView.height], [NSNumber numberWithFloat:FILL_PARENT], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)_contactListHeadTipView.height] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // set contacts container view background image
        _contactsContainerView.backgroundImg = nil;
        
        // init contact operate view
        UIView *_contactOperateView = [[UIView alloc] initWithFrame:CGRectMake(_contactsContainerView.bounds.origin.x, _contactsContainerView.bounds.origin.y, FILL_PARENT, CONTACTOPERATEVIEW_HEIGHT)];
        
        // set contact operate view background color
        _contactOperateView.backgroundColor = [UIColor clearColor];
        
        // init addressbook contact list table view
        _mABContactListTableView = [_mABContactListTableView = [UITableView alloc] initWithFrame:CGRectMakeWithFormat(_mABContactListTableView, [NSNumber numberWithFloat:_contactsContainerView.bounds.origin.x], [NSNumber numberWithFloat:_contactsContainerView.bounds.origin.y + CONTACTOPERATEVIEW_HEIGHT], [NSNumber numberWithFloat:FILL_PARENT], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d", FILL_PARENT_STRING, (int)_contactsContainerView.bounds.origin.y, (int)CONTACTOPERATEVIEW_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // set contact list table view dataSource and delegate
        _mABContactListTableView.dataSource = self;
        _mABContactListTableView.delegate = self;
        
        // add contact operate view and contact list table view as subviews of contacts container view
        [_contactsContainerView addSubview:_contactOperateView];
        [_contactsContainerView addSubview:_mABContactListTableView];
        
        // add contact list head tip view and contacts container view as subviews of contact list view
        [self addSubview:_contactListHeadTipView];
        [self addSubview:_contactsContainerView];
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

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"AB Contact cell";
    
    // get contact list table view cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    _cell.textLabel.text = @"张山";
    
    return _cell;
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"contact list did select row at index path = %@", indexPath);
    
    //
}

// AddressBookChangedDelegate
- (void)addressBookChanged:(ABAddressBookRef)pAddressBook info:(NSDictionary *)pInfo observer:(id)pObserver{
    //
}

@end
