//
//  SelectedContactsView.h
//  SimpleIMeeting
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedContactsView : UIView <UITableViewDataSource, UITableViewDelegate> {
    // present subviews
    // subview selected contacts table view
    UITableView *_mSelectedContactsTableView;
}

@end
