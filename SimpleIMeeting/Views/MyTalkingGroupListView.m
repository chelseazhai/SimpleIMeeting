//
//  MyTalkingGroupListView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "MyTalkingGroupListView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "SimpleIMeetingTableViewTipView.h"

@implementation MyTalkingGroupListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init my talking groups head tip view
        SimpleIMeetingTableViewTipView *_myTalkingGroupsHeadTipView = [[SimpleIMeetingTableViewTipView alloc] initWithTipViewMode:LeftAlign_TipView andParentView:self];
        
        // set my talking groups head tip view text
        [_myTalkingGroupsHeadTipView setTipViewText:NSLocalizedString(@"my talking groups head tip view text", nil)];
        
        // init my talking groups table view
        _mMyTalkingGroupsTableView = [_mMyTalkingGroupsTableView = [UITableView alloc] initWithFrame:CGRectMakeWithFormat(_mMyTalkingGroupsTableView, [NSNumber numberWithFloat:self.bounds.origin.x], [NSNumber numberWithFloat:self.bounds.origin.y + _myTalkingGroupsHeadTipView.height], [NSNumber numberWithFloat:FILL_PARENT], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)_myTalkingGroupsHeadTipView.height] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // set my talking groups table view dataSource and delegate
        _mMyTalkingGroupsTableView.dataSource = self;
        _mMyTalkingGroupsTableView.delegate = self;
        
        // add my talking groups head tip view and my talking groups table view as subviews of my talking groups view
        [self addSubview:_myTalkingGroupsHeadTipView];
        [self addSubview:_mMyTalkingGroupsTableView];
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
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"My talking group cell";
    
    // get contact list table view cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    _cell.textLabel.text = @"会议";
    
    return _cell;
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"my talking groups did select row at index path = %@", indexPath);
    
    //
}

@end
