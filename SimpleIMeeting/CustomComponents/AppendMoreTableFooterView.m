//
//  AppendMoreTableFooterView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-7-17.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "AppendMoreTableFooterView.h"

#import <CommonToolkit/CommonToolkit.h>

// append more table footer view min height
#define APPENDMORETABLEFOOTERVIEW_MINHEIGHT 44.0

// append more table footer view margin and padding
#define APPENDMORETABLEFOOTERVIEW_MARGINLR  12.0
#define APPENDMORETABLEFOOTERVIEW_MARGINTB  6.0
#define APPENDMORETABLEFOOTERVIEW_PADDING   6.0

// append more table footer view subview height
#define APPENDMORETABLEFOOTERVIEWSUBVIEW_HEIGHT 32.0

// append more table footer view append more indicator view width
#define APPENDMORETABLEFOOTERVIEWAPPENDMOREINDICATORVIEW_WIDTH  32.0

// set label attributes with text
#define SetLabelAttributesWithText(label, labelText)    \
    {   \
        label.text = labelText; \
        label.textColor = [UIColor darkGrayColor];   \
        label.font = [UIFont systemFontOfSize:14.0];    \
        label.textAlignment = NSTextAlignmentCenter;    \
        label.backgroundColor = [UIColor clearColor];   \
    }

@implementation AppendMoreTableFooterView

@synthesize hasMoreData = _mHasMoreData;;

@synthesize delegate = _mAppendMoreTableFooterDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:APPENDMORETABLEFOOTERVIEW_MINHEIGHT > frame.size.height ? CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, APPENDMORETABLEFOOTERVIEW_MINHEIGHT) : frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init appending more data indicator view
        _mAppendingMoreDataIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        // set its frame
        [_mAppendingMoreDataIndicatorView setFrame:CGRectMake(self.bounds.origin.x + APPENDMORETABLEFOOTERVIEW_MARGINLR, self.bounds.origin.y + APPENDMORETABLEFOOTERVIEW_MARGINTB, APPENDMORETABLEFOOTERVIEWAPPENDMOREINDICATORVIEW_WIDTH, APPENDMORETABLEFOOTERVIEWSUBVIEW_HEIGHT)];
        
        // init appending more data tip label
        _mAppendingMoreDataTipLabel = [_mAppendingMoreDataTipLabel = [UILabel alloc] initWithFrame:CGRectMakeWithFormat(_mAppendingMoreDataTipLabel, [NSNumber numberWithFloat:self.bounds.origin.x + APPENDMORETABLEFOOTERVIEW_MARGINLR + APPENDMORETABLEFOOTERVIEWAPPENDMOREINDICATORVIEW_WIDTH + APPENDMORETABLEFOOTERVIEW_PADDING], [NSNumber numberWithFloat:self.bounds.origin.y + APPENDMORETABLEFOOTERVIEW_MARGINTB], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d-%d-%d", FILL_PARENT_STRING, (int)APPENDMORETABLEFOOTERVIEW_MARGINLR, (int)APPENDMORETABLEFOOTERVIEW_PADDING, (int)APPENDMORETABLEFOOTERVIEWAPPENDMOREINDICATORVIEW_WIDTH] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:APPENDMORETABLEFOOTERVIEWSUBVIEW_HEIGHT])];
        
        // set its attributes
        SetLabelAttributesWithText(_mAppendingMoreDataTipLabel, NSLocalizedString(@"Appending more...", @"Appending more..."));
        
        // hidden first
        _mAppendingMoreDataTipLabel.hidden = YES;
        
        // init no more data tip label
        _mNoMoreDataTipLabel = [_mNoMoreDataTipLabel = [UILabel alloc] initWithFrame:CGRectMakeWithFormat(_mNoMoreDataTipLabel, [NSNumber numberWithFloat:self.bounds.origin.x + APPENDMORETABLEFOOTERVIEW_MARGINLR], [NSNumber numberWithFloat:self.bounds.origin.y + APPENDMORETABLEFOOTERVIEW_MARGINTB], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d", FILL_PARENT_STRING, (int)APPENDMORETABLEFOOTERVIEW_MARGINLR] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:APPENDMORETABLEFOOTERVIEWSUBVIEW_HEIGHT])];
        
        // set its attributes
        SetLabelAttributesWithText(_mNoMoreDataTipLabel, NSLocalizedString(@"No more data", @"No more data"));
        
        // hidden first
        _mNoMoreDataTipLabel.hidden = YES;
        
        // add appending more data indocator view, tip label and no more data tip label as subviews of append more table footer view
        [self addSubview:_mAppendingMoreDataIndicatorView];
        [self addSubview:_mAppendingMoreDataTipLabel];
        [self addSubview:_mNoMoreDataTipLabel];
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

- (void)layoutSubviews{
    // resize all subviews
    [self resizesSubviews];
}

- (void)appendMoreScrollViewDidScroll:(UIScrollView *)scrollView{
    // scroll to bottom of the table view, judge if or not have more data
    if(scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height && ![_mAppendMoreTableFooterDelegate  appendMoreTableFooterDataSourceIsAppending:self]){
        // judge if or not have more data
        if(_mHasMoreData){
            NSLog(@"has more data, need to append more");
            
            // show append more data indicator view and tip label if needed
            if (!_mAppendingMoreDataIndicatorView.isAnimating) {
                [_mAppendingMoreDataIndicatorView startAnimating];
            }
            if ([_mAppendingMoreDataTipLabel isHidden]) {
                _mAppendingMoreDataTipLabel.hidden = NO;
            }
            
            // update appending more data tip label frame and indicator view center
            [_mAppendingMoreDataTipLabel setFrame:CGRectMake(self.bounds.origin.x + APPENDMORETABLEFOOTERVIEW_MARGINLR + APPENDMORETABLEFOOTERVIEWAPPENDMOREINDICATORVIEW_WIDTH + APPENDMORETABLEFOOTERVIEW_PADDING, self.bounds.origin.y + APPENDMORETABLEFOOTERVIEW_MARGINTB, self.bounds.size.width - 2 * APPENDMORETABLEFOOTERVIEW_MARGINLR - APPENDMORETABLEFOOTERVIEW_PADDING - APPENDMORETABLEFOOTERVIEWAPPENDMOREINDICATORVIEW_WIDTH, APPENDMORETABLEFOOTERVIEWSUBVIEW_HEIGHT)];
            _mAppendingMoreDataIndicatorView.center = CGPointMake(self.bounds.origin.x + APPENDMORETABLEFOOTERVIEW_MARGINLR + (_mAppendingMoreDataTipLabel.frame.size.width - [_mAppendingMoreDataTipLabel.text stringPixelLengthByFontSize:_mAppendingMoreDataTipLabel.font.pointSize andIsBold:NO] + APPENDMORETABLEFOOTERVIEWAPPENDMOREINDICATORVIEW_WIDTH) / 2.0, _mAppendingMoreDataIndicatorView.center.y);
        }
        else{
            NSLog(@"no more data");
            
            // show no more data tip label if needed
            if ([_mNoMoreDataTipLabel isHidden]) {
                _mNoMoreDataTipLabel.hidden = NO;
            }
            
            // update no more data tip label frame
            [_mNoMoreDataTipLabel setFrame:CGRectMake(self.bounds.origin.x + APPENDMORETABLEFOOTERVIEW_MARGINLR, self.bounds.origin.y + APPENDMORETABLEFOOTERVIEW_MARGINTB, self.bounds.size.width - 2 * APPENDMORETABLEFOOTERVIEW_MARGINLR, APPENDMORETABLEFOOTERVIEWSUBVIEW_HEIGHT)];
        }
        
        // show append more table footer view
        _mIsAppendMoreTableFooterViewVisiable = YES;
        
        // add append more table footer view as table footer view
        ((UITableView *)scrollView).tableFooterView = self;
    }
}

- (void)appendMoreScrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // check append more table footer view visibility and more data is appending
    if (_mIsAppendMoreTableFooterViewVisiable && ![_mAppendMoreTableFooterDelegate  appendMoreTableFooterDataSourceIsAppending:self]) {
        // judge if or not have more data
        if (_mHasMoreData) {
            // append more data
            [_mAppendMoreTableFooterDelegate appendMoreTableFooterDidScrollAppend:self];
        }
        else {
            // remove table footer view after 1 seconds
            [self performSelector:@selector(appendMoreScrollViewDataSourceDidFinishedAppending:) withObject:scrollView afterDelay:1.0];
        }
    }
}

- (void)appendMoreScrollViewDataSourceDidFinishedAppending:(UIScrollView *)scrollView{
    // hide append more table footer view all subviews if needed
    if (_mAppendingMoreDataIndicatorView.isAnimating) {
        [_mAppendingMoreDataIndicatorView stopAnimating];
    }
    if (![_mAppendingMoreDataTipLabel isHidden]) {
        _mAppendingMoreDataTipLabel.hidden = YES;
    }
    if (![_mNoMoreDataTipLabel isHidden]) {
        _mNoMoreDataTipLabel.hidden = YES;
    }
    
    // hide append more table footer view
    _mIsAppendMoreTableFooterViewVisiable = NO;
    
    // remove table footer view
    ((UITableView *)scrollView).tableFooterView = nil;
}

@end
