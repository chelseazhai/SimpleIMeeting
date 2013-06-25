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

#import "MyTalkingGroupListTableViewCell.h"

@implementation MyTalkingGroupListView

@synthesize myTalkingGroupsInfoArray = _mMyTalkingGroupsInfoArray;

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
        
        // init my talking group list table view
        _mMyTalkingGroupListTableView = [_mMyTalkingGroupListTableView = [UITableView alloc] initWithFrame:CGRectMakeWithFormat(_mMyTalkingGroupListTableView, [NSNumber numberWithFloat:self.bounds.origin.x], [NSNumber numberWithFloat:self.bounds.origin.y + _myTalkingGroupsHeadTipView.height], [NSNumber numberWithFloat:FILL_PARENT], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d", FILL_PARENT_STRING, (int)self.bounds.origin.y, (int)_myTalkingGroupsHeadTipView.height] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // init my talking groups info array
        _mMyTalkingGroupsInfoArray = [[NSMutableArray alloc] init];
        
        // set its background color
        _mMyTalkingGroupListTableView.backgroundColor = [UIColor clearColor];
        
        // set separator style UITableViewCellSeparatorStyleNone
        _mMyTalkingGroupListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // set my talking group list table view dataSource and delegate
        _mMyTalkingGroupListTableView.dataSource = self;
        _mMyTalkingGroupListTableView.delegate = self;
        
        // add my talking groups head tip view and my talking group list table view as subviews of my talking group list view
        [self addSubview:_myTalkingGroupsHeadTipView];
        [self addSubview:_mMyTalkingGroupListTableView];
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
    // Return the number of rows in the section.
    return [_mMyTalkingGroupsInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"My talking group cell";
    
    // get my talking group list table view cell
    MyTalkingGroupListTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[MyTalkingGroupListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
