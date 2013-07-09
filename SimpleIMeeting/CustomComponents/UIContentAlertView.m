//
//  UIContentAlertView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-7-1.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "UIContentAlertView.h"

#import <CommonToolkit/CommonToolkit.h>

// content alert view title and message
#define CONTENTALERTVIEW_TITLE  @"`1234 title ~!@#$"
#define CONTENTALERTVIEW_MESSAGE    @"`1234567890-= *** this is content alert view message *** +_)(*&^%$#@!~"

@implementation UIContentAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title contentView:(UIView *)contentView cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self = [super initWithTitle:CONTENTALERTVIEW_TITLE message:CONTENTALERTVIEW_MESSAGE delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        // Initialization code
        // save title
        _mTitle = title;
        
        // save content view
        _mContentView = contentView;
        
        // set alert view delegate
        self.delegate = self;
        
        //
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

// UIAlertViewDelegate
- (void)willPresentAlertView:(UIAlertView *)alertView{
//    // test by ares
//    for (UIView *_subview in [self subviews]) {
//        NSLog(@"_subview = %@", _subview);
//        
//        if ([_subview isMemberOfClass:[UILabel class]] && [((UILabel *)_subview).text isEqualToString:@"message"]) {
//            NSLog(@"_subview = %@", _subview);
//            
//            _subview.frame = CGRectMake(_subview.frame.origin.x / 2, _subview.frame.origin.y, _subview.frame.size.width + _subview.frame.origin.x, _subview.frame.size.height + 100.0 + [self viewWithTag:1].frame.size.height + 16.0);
//            
//            _subview.backgroundColor = [UIColor blackColor];
//        }
//    }
//    
//    alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y - 50.0, alertView.frame.size.width, alertView.frame.size.height + 100.0);
    
    // process all subviews of content alert view
    for (UIView *_subview in [self subviews]) {
        // process content alert view background image view
        if ([_subview isMemberOfClass:[UIImageView class]]) {
            // clear content alert view background image
            ((UIImageView *)_subview).image = nil;
            _subview.backgroundColor = [UIColor blackColor];
        }
        // process title and message
        else if ([_subview isMemberOfClass:[UILabel class]]) {
            // process title
            if ([CONTENTALERTVIEW_TITLE isEqualToString:((UILabel *)_subview).text]) {
                NSLog(@"before title = %@", NSStringFromCGRect(_subview.frame));
                
                // update title frame
                [_subview setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + 3.0, _subview.frame.size.width + 2 * _subview.frame.origin.x, _subview.frame.size.height + _subview.frame.origin.y - 3.0)];
                _subview.backgroundImg = [UIImage imageNamed:@"img_contentalertview_titlelabel_bg"];
                
                NSLog(@"after title = %@", NSStringFromCGRect(_subview.frame));
                
                // set content alert view real title
                ((UILabel *)_subview).text = _mTitle;
                
                // test by ares
                //_subview.backgroundColor = [UIColor redColor];
            }
            // process message
            else if ([CONTENTALERTVIEW_MESSAGE isEqualToString:((UILabel *)_subview).text]) {
                //
                _subview.backgroundColor = [UIColor greenColor];
            }
        }
        else {
            NSLog(@"other subview = %@", _subview);
        }
    }
    
}

@end
