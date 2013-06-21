//
//  SelectedContactsView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SelectedContactsView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "SimpleIMeetingTableViewTipView.h"

@implementation SelectedContactsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init selected contacts head tip view
        SimpleIMeetingTableViewTipView *_selectedContactsHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:RightAlign_TipView andParentView:self];
        
        // set selected contacts head tip view text
        [_selectedContactsHeadTipView setTipViewText:NSLocalizedString(@"contacts select selected contacts head tip view text", nil)];
        
        // init selected contacts table view
        _mSelectedContactsTableView = [_mSelectedContactsTableView = [UITableView alloc] initWithFrame:CGRectMakeWithFormat(_mSelectedContactsTableView, [NSNumber numberWithFloat:self.bounds.origin.x], [NSNumber numberWithFloat:self.bounds.origin.y + _selectedContactsHeadTipView.height], [NSNumber numberWithFloat:FILL_PARENT], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)_selectedContactsHeadTipView.height] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // set selected contacts table view dataSource and delegate
        _mSelectedContactsTableView.dataSource = self;
        _mSelectedContactsTableView.delegate = self;
        
        // add selected contacts head tip view and selected contacts table view as subviews of selected contacts view
        [self addSubview:_selectedContactsHeadTipView];
        [self addSubview:_mSelectedContactsTableView];
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
    return 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Selected Contact cell";
    
    // get contact list table view cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    _cell.textLabel.text = @"小新";
    
    return _cell;
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected contacs did select row at index path = %@", indexPath);
    
    //
}

@end
