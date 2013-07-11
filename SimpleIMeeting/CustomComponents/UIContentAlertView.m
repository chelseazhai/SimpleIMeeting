//
//  UIContentAlertView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-7-1.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "UIContentAlertView.h"

#import <CommonToolkit/CommonToolkit.h>

// content alert view title
#define CONTENTALERTVIEW_TITLE  @"`1234 title ~!@#$"

// content alert view margin top and bottom
#define CONTENTALERTVIEW_MARGONTB   3.0

@implementation UIContentAlertViewContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

@end


@implementation UIContentAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title contentView:(UIView *)contentView{
    self = [super initWithTitle:CONTENTALERTVIEW_TITLE message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    if (self) {
        // Initialization code
        // save title
        _mTitle = title;
        
        // save content view
        _mContentView = contentView;
        
        // set alert view delegate
        self.delegate = self;
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

- (void)dismissAnimated:(BOOL)animated{
    // dismiss content alert view with animation
    [self dismissWithClickedButtonIndex:0 animated:animated];
}

// UIAlertViewDelegate
- (void)willPresentAlertView:(UIAlertView *)alertView{
    // define content alert view title label
    UILabel *_titleLabel;
    
    // define frame size height remain value(except title label)
    CGFloat _remainHeight;
    
    // process all subviews of content alert view
    for (UIView *_subview in [self subviews]) {
        // process content alert view background image view
        if ([_subview isMemberOfClass:[UIImageView class]]) {
            // clear content alert view background image
            ((UIImageView *)_subview).image = nil;
            _subview.backgroundColor = [UIColor blackColor];
        }
        // process title
        else if ([_subview isMemberOfClass:[UILabel class]] && [CONTENTALERTVIEW_TITLE isEqualToString:((UILabel *)_subview).text]) {
            // update title frame
            [_subview setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + CONTENTALERTVIEW_MARGONTB, _subview.frame.size.width + 2 * _subview.frame.origin.x, _subview.frame.size.height + _subview.frame.origin.y - CONTENTALERTVIEW_MARGONTB)];
            
            // set title label background image
            _subview.backgroundImg = [UIImage imageNamed:@"img_contentalertview_titlelabel_bg"];
            
            // set content alert view real title as text of title label
            (_titleLabel = (UILabel *)_subview).text = _mTitle;
            
            // set remain height
            _remainHeight = self.frame.size.height - _subview.frame.size.height - 2 * CONTENTALERTVIEW_MARGONTB;
        }
    }
    
    // get content alert view increase height
    CGFloat _increaseHeight = _mContentView.frame.size.height - _remainHeight;
    
    // update content view frame
    [_mContentView setFrame:CGRectMake(self.bounds.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height, self.frame.size.width, _mContentView.frame.size.height)];
    
    // FIXME: This is a workaround. By uncomment below, UITextFields in content view will show characters when typing (possible keyboard reponder issue)
    // check content view has text field subview
    for (UIView *_subView in [_mContentView subviews]) {
        if ([_subView isKindOfClass:[UITextField class]]) {
            // add fake text field to content alert view
            [self addSubview:[[UITextField alloc] initWithFrame:CGRectMake(CGPointZero.x, CGPointZero.y, CGSizeZero.width, CGSizeZero.height)]];
            
            break;
        }
    }
    
    // add content view as subview of content alert view
    [self addSubview:_mContentView];
    
    // update content alert view frame
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - _increaseHeight / 2, self.frame.size.width, self.frame.size.height + _increaseHeight)];
}

@end
