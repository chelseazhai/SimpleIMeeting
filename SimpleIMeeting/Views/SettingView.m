//
//  SettingView.m
//  SimpleIMeeting
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SettingView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "UserBean+BindContactInfo.h"

#import "RegAndLoginWithDeviceIdHttpRequestProcessor.h"

#import "BindedAccountLoginHttpRequestProcessor.h"

#import "UIWindow+AsyncHttpReqMBProgressHUD.h"

// margin and padding
#define MARGIN  10.0
#define PADDING 20.0

// my account, bind contact info group view height weight and them total weight
#define MYACCOUNTGROUPVIEW_HEIGHTWEIGHT 1
#define BINDCONTACTINFOGROUPVIEW_HEIGHTWEIGHT   2
#define MYACCOUNT7BINDCONTACTINFOGROUPVIEW_TOTALSUMWEIGHT   3

// my account or bind contact info group view height value
#define MYACCOUNT6BINDCONTACTINFOGROUPVIEW_HEIGHTVALUE(selfWeight, totalWeight)  [NSValue valueWithCString:[[NSString stringWithFormat:@"((%d+%s)-2*(%d+%d)-%d)*%d/%d", (int)self.bounds.origin.y, FILL_PARENT_STRING, (int)MARGIN, (int)PADDING, (int)BINDEDACCOUNTLOGINBUTTON_HEIGHT, selfWeight, totalWeight] cStringUsingEncoding:NSUTF8StringEncoding]]

// my account group view subview height
#define MYACCOUNTGROUPVIEWSUBVIEW_HEIGHT    34.0

// my account group view binded account logout button padding left
#define MYACCOUNTGROUPVIEWBINDEDACCOUNTLOGOUTBUTTON_PADDINGLEFT 10.0

// device id or contacts info be binded or account tip label width
#define DEVICEID6CONTACTSINFOBEBINDED6ACCOUNTTIPLABEL_WIDTH 76.0

// device id or contacts info be binded or account label and its tip label text font size
#define DEVICEID6CONTACTSINFOBEBINDED6ACCOUNTLABEL7TIPLABELTEXTFONTSIZE 15.0

// binded account logout button width
#define BINDEDACCOUNTLOGOUTBUTTON_WIDTH 60.0

// bind contact info group view bind description label and contacts info type be binded button weight and total weight
#define BINDCONTACTINFODESCRIPTIONLABEL_WEIGHT  2
#define CONTACTINFOTYPEBEBINDEDBUTTON_WEIGHT    3
#define BINDCONTACTINFOGROUPVIEW_TOTALSUMWEIGHT 5.0

// bind contact info description label text font size
#define BINDCONTACTINFODESCRIPTIONLABELTEXTFONTSIZE 15.0

// contact info bind button width and height
#define CONTACTINFOBINDBUTTON_WIDTH 72.0
#define CONTACTINFOBINDBUTTON_HEIGHT    96.0

// binded account login button height
#define BINDEDACCOUNTLOGINBUTTON_HEIGHT 40.0

@interface SettingView ()

// update my account and contacts info bind group UI
- (void)updateMyAccount7ContactsInfoBindGroupUI;

// binded account logout
- (void)bindedAccountLogout;

// phone bind button on clicked
- (void)phoneBindButtonOnClicked;

// binded account login button on clicked
- (void)bindedAccountLoginButtonOnClicked;

@end

@implementation SettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background color
        self.backgroundColor = [UIColor whiteColor];
        
        // set title
        self.title = NSLocalizedString(@"setting view title", nil);
        
        // create and init subviews
        // define subview origin x number and width value
        NSNumber *_subviewOriginXNumber = [NSNumber numberWithFloat:self.bounds.origin.x + MARGIN];
        NSValue *_subviewWidthValue = [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d", FILL_PARENT_STRING, (int)MARGIN] cStringUsingEncoding:NSUTF8StringEncoding]];
        
        // define my account group view
        UIGroupView *_myAccountGroupView;
        
        // init my account group view
        _myAccountGroupView = [_myAccountGroupView = [UIGroupView alloc] initWithFrame:CGRectMakeWithFormat(_myAccountGroupView, _subviewOriginXNumber, [NSNumber numberWithFloat:self.bounds.origin.y + MARGIN], _subviewWidthValue, MYACCOUNT6BINDCONTACTINFOGROUPVIEW_HEIGHTVALUE(MYACCOUNTGROUPVIEW_HEIGHTWEIGHT, MYACCOUNT7BINDCONTACTINFOGROUPVIEW_TOTALSUMWEIGHT))];
        
        // set its attributes
        [_myAccountGroupView setTipLabelText:NSLocalizedString(@"my account group view tip", nil)];
        _myAccountGroupView.backgroundColor = [UIColor whiteColor];
        
        // my account group view subview origin y value and height number
        NSValue *_myAccountGroupViewSubviewOriginYValue = [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+(%s-%d)/2", (int)_myAccountGroupView.bounds.origin.y, FILL_PARENT_STRING, (int)MYACCOUNTGROUPVIEWSUBVIEW_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]];
        
        // init device id or contacts info be binded or account tip label
        _mDeviceId6ContactsInfoBeBinded6AccountTipLabel = [_mDeviceId6ContactsInfoBeBinded6AccountTipLabel = [UILabel alloc] initWithFrame:CGRectMakeWithFormat(_mDeviceId6ContactsInfoBeBinded6AccountTipLabel, [NSNumber numberWithFloat:_myAccountGroupView.bounds.origin.x], _myAccountGroupViewSubviewOriginYValue, [NSNumber numberWithFloat:DEVICEID6CONTACTSINFOBEBINDED6ACCOUNTTIPLABEL_WIDTH], [NSNumber numberWithFloat:MYACCOUNTGROUPVIEWSUBVIEW_HEIGHT])];
        
        // set its attributes
        _mDeviceId6ContactsInfoBeBinded6AccountTipLabel.textAlignment = NSTextAlignmentCenter;
        _mDeviceId6ContactsInfoBeBinded6AccountTipLabel.font = [UIFont systemFontOfSize:DEVICEID6CONTACTSINFOBEBINDED6ACCOUNTLABEL7TIPLABELTEXTFONTSIZE];
        _mDeviceId6ContactsInfoBeBinded6AccountTipLabel.backgroundColor = [UIColor clearColor];
        
        // init device id or contacts info be binded or account label
        // get user bind contact info which in user manager
        NSString *_userBindContactInfo = [UserManager shareUserManager].userBean.bindContactInfo;
        _mDeviceId6ContactsInfoBeBinded6AccountLabel = [_mDeviceId6ContactsInfoBeBinded6AccountLabel = [UILabel alloc] initWithFrame:CGRectMakeWithFormat(_mDeviceId6ContactsInfoBeBinded6AccountLabel, [NSNumber numberWithFloat:_myAccountGroupView.bounds.origin.x + DEVICEID6CONTACTSINFOBEBINDED6ACCOUNTTIPLABEL_WIDTH], _myAccountGroupViewSubviewOriginYValue, [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d", FILL_PARENT_STRING, (int)DEVICEID6CONTACTSINFOBEBINDED6ACCOUNTTIPLABEL_WIDTH, nil != _userBindContactInfo && ![@"" isEqualToString:_userBindContactInfo] ? (int)(BINDEDACCOUNTLOGOUTBUTTON_WIDTH + MYACCOUNTGROUPVIEWBINDEDACCOUNTLOGOUTBUTTON_PADDINGLEFT) : 0] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:MYACCOUNTGROUPVIEWSUBVIEW_HEIGHT])];
        
        // set its attributes
        _mDeviceId6ContactsInfoBeBinded6AccountLabel.font = [UIFont systemFontOfSize:DEVICEID6CONTACTSINFOBEBINDED6ACCOUNTLABEL7TIPLABELTEXTFONTSIZE];
        _mDeviceId6ContactsInfoBeBinded6AccountLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _mDeviceId6ContactsInfoBeBinded6AccountLabel.backgroundColor = [UIColor clearColor];
        
        // init binded account logout button
        _mBindedAccountLogoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_mBindedAccountLogoutButton setFrame:CGRectMakeWithFormat(_mBindedAccountLogoutButton, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%s-%d", (int)_myAccountGroupView.bounds.origin.x, FILL_PARENT_STRING, (int)BINDEDACCOUNTLOGOUTBUTTON_WIDTH] cStringUsingEncoding:NSUTF8StringEncoding]], _myAccountGroupViewSubviewOriginYValue, [NSNumber numberWithFloat:BINDEDACCOUNTLOGOUTBUTTON_WIDTH], [NSNumber numberWithFloat:MYACCOUNTGROUPVIEWSUBVIEW_HEIGHT])];
        
        // set its title for normal state
        [_mBindedAccountLogoutButton setTitle:NSLocalizedString(@"binded account logout button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_mBindedAccountLogoutButton addTarget:self action:@selector(bindedAccountLogout) forControlEvents:UIControlEventTouchUpInside];
        
        // hidden first
        _mBindedAccountLogoutButton.hidden = YES;
        
        // add device id or contacts info be binded or account label and its tip label and binded account logout button as subviews of my account group view
        [_myAccountGroupView.contentView addSubview:_mDeviceId6ContactsInfoBeBinded6AccountTipLabel];
        [_myAccountGroupView.contentView addSubview:_mDeviceId6ContactsInfoBeBinded6AccountLabel];
        [_myAccountGroupView.contentView addSubview:_mBindedAccountLogoutButton];
        
        // define bind contact info goup view
        UIGroupView *_bindContactInfoGroupView;
        
        // init bind contact info goup view
        _bindContactInfoGroupView = [_bindContactInfoGroupView = [UIGroupView alloc] initWithFrame:CGRectMakeWithFormat(_bindContactInfoGroupView, _subviewOriginXNumber, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%d+%d+%@", (int)self.bounds.origin.y, (int)MARGIN, (int)PADDING, MYACCOUNT6BINDCONTACTINFOGROUPVIEW_HEIGHTVALUE(MYACCOUNTGROUPVIEW_HEIGHTWEIGHT, MYACCOUNT7BINDCONTACTINFOGROUPVIEW_TOTALSUMWEIGHT).stringValue] cStringUsingEncoding:NSUTF8StringEncoding]], _subviewWidthValue, MYACCOUNT6BINDCONTACTINFOGROUPVIEW_HEIGHTVALUE(BINDCONTACTINFOGROUPVIEW_HEIGHTWEIGHT, MYACCOUNT7BINDCONTACTINFOGROUPVIEW_TOTALSUMWEIGHT))];
        
        // set its attributes
        [_bindContactInfoGroupView setTipLabelText:NSLocalizedString(@"bind contact info group tip", nil)];
        _bindContactInfoGroupView.backgroundColor = [UIColor whiteColor];
        
        // init bind contact info description label
        UILabel *_bindContactInfoDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bindContactInfoGroupView.bounds.origin.x, _bindContactInfoGroupView.bounds.origin.y, FILL_PARENT, FILL_PARENT * (BINDCONTACTINFODESCRIPTIONLABEL_WEIGHT / BINDCONTACTINFOGROUPVIEW_TOTALSUMWEIGHT))];
        
        // set its attributes
        _bindContactInfoDescriptionLabel.text = NSLocalizedString(@"bind contact info description label text", nil);
        _bindContactInfoDescriptionLabel.font = [UIFont systemFontOfSize:BINDCONTACTINFODESCRIPTIONLABELTEXTFONTSIZE];
        _bindContactInfoDescriptionLabel.numberOfLines = 0;
        _bindContactInfoDescriptionLabel.backgroundColor = [UIColor clearColor];
        
        // init phone bind button
        _mPhoneBindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        [_mPhoneBindButton setFrame:CGRectMakeWithFormat(_mPhoneBindButton, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+(%s-%d)/2", (int)_bindContactInfoGroupView.bounds.origin.x, FILL_PARENT_STRING, (int)CONTACTINFOBINDBUTTON_WIDTH] cStringUsingEncoding:NSUTF8StringEncoding]], [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%s*(%d/%d)+(%s*(%d/%d)-%d)/2", (int)_bindContactInfoGroupView.bounds.origin.y, FILL_PARENT_STRING, BINDCONTACTINFODESCRIPTIONLABEL_WEIGHT, (int)BINDCONTACTINFOGROUPVIEW_TOTALSUMWEIGHT, FILL_PARENT_STRING, CONTACTINFOTYPEBEBINDEDBUTTON_WEIGHT, (int)BINDCONTACTINFOGROUPVIEW_TOTALSUMWEIGHT, (int)CONTACTINFOBINDBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:CONTACTINFOBINDBUTTON_WIDTH], [NSNumber numberWithFloat:CONTACTINFOBINDBUTTON_HEIGHT])];
        
        // set background image for normal, highlighted and disable state
        [_mPhoneBindButton setBackgroundImage:[UIImage imageNamed:@"img_phonebind_normal_bg"] forState:UIControlStateNormal];
        [_mPhoneBindButton setBackgroundImage:[UIImage imageNamed:@"img_phonebind_highlighted_bg"] forState:UIControlStateHighlighted];
        [_mPhoneBindButton setBackgroundImage:[UIImage imageNamed:@"img_phonebind_disabled_bg"] forState:UIControlStateDisabled];
        
        // add action selector and its response target for event
        [_mPhoneBindButton addTarget:self action:@selector(phoneBindButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        // add bind contact info description label and phone bind button as subviews of bind contact info group view
        [_bindContactInfoGroupView.contentView addSubview:_mPhoneBindButton];
        [_bindContactInfoGroupView.contentView addSubview:_bindContactInfoDescriptionLabel];
        
        // init binded account login button
        UIButton *_bindedAccountLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_bindedAccountLoginButton setFrame:CGRectMakeWithFormat(_bindedAccountLoginButton, _subviewOriginXNumber, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%s-%d-%d", (int)self.bounds.origin.y, FILL_PARENT_STRING, (int)MARGIN, (int)BINDEDACCOUNTLOGINBUTTON_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], _subviewWidthValue, [NSNumber numberWithFloat:BINDEDACCOUNTLOGINBUTTON_HEIGHT])];
        
        // set its title for normal state
        [_bindedAccountLoginButton setTitle:NSLocalizedString(@"binded account login button title", nil) forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_bindedAccountLoginButton addTarget:self action:@selector(bindedAccountLoginButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        // update my account and contacts info bind group UI
        [self updateMyAccount7ContactsInfoBindGroupUI];
        
        // add my account, bind contact info group view and binded account login button as subviews of setting view
        [self addSubview:_myAccountGroupView];
        [self addSubview:_bindContactInfoGroupView];
        [self addSubview:_bindedAccountLoginButton];
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

- (BOOL)check7clearMyAccountIsChangedFlag{
    BOOL _isMyAccountChanged = _mIsMyAccountChanged;
    
    // check my account is or not changed
    if (_mIsMyAccountChanged) {
        // recover my account is changed flag
        _mIsMyAccountChanged = NO;
    }
    
    return _isMyAccountChanged;
}

// inner extension
- (void)updateMyAccount7ContactsInfoBindGroupUI{
    // get login user
    UserBean *_loginUser = [UserManager shareUserManager].userBean;
    
    // get login user bind contact info and contacts info be binded and its type
    NSString *_loginUserBindContactInfo = _loginUser.bindContactInfo;
    NSString *_loginUserContactsInfoTypeBeBinded = _loginUser.contactsInfoTypeBeBinded;
    NSString *_loginUserContactsInfoBeBinded = _loginUser.contactsInfoBeBinded;
    
    // check login user bind contact info
    if (nil != _loginUserBindContactInfo && ![@"" isEqualToString:_loginUserBindContactInfo]) {
        // set device id or contacts info be binded or account label and its tip label text
        _mDeviceId6ContactsInfoBeBinded6AccountTipLabel.text = NSLocalizedString(@"my account tip", nil);
        _mDeviceId6ContactsInfoBeBinded6AccountLabel.text = _loginUserBindContactInfo;
        
        // show binded account logout button if needed
        if ([_mBindedAccountLogoutButton isHidden]) {
            _mBindedAccountLogoutButton.hidden = NO;
            
            // update device id or contacts info be binded or account label size width
            [_mDeviceId6ContactsInfoBeBinded6AccountLabel setFrame:CGRectMake(_mDeviceId6ContactsInfoBeBinded6AccountLabel.frame.origin.x, _mDeviceId6ContactsInfoBeBinded6AccountLabel.frame.origin.y, _mDeviceId6ContactsInfoBeBinded6AccountLabel.frame.size.width - BINDEDACCOUNTLOGOUTBUTTON_WIDTH - MYACCOUNTGROUPVIEWBINDEDACCOUNTLOGOUTBUTTON_PADDINGLEFT, _mDeviceId6ContactsInfoBeBinded6AccountLabel.frame.size.height)];
        }
    }
    else {
        // check login user contacts info be binded
        if (nil != _loginUserContactsInfoBeBinded && ![@"" isEqualToString:_loginUserContactsInfoBeBinded]) {
            // set device id or contacts info be binded or account label and its tip label text
            _mDeviceId6ContactsInfoBeBinded6AccountTipLabel.text = NSLocalizedString(@"contacts info be binded tip", nil);
            _mDeviceId6ContactsInfoBeBinded6AccountLabel.text = _loginUserContactsInfoBeBinded;
        }
        else {
            // set device id or contacts info be binded or account label and its tip label text
            _mDeviceId6ContactsInfoBeBinded6AccountTipLabel.text = NSLocalizedString(@"device id tip", nil);
            _mDeviceId6ContactsInfoBeBinded6AccountLabel.text = [[UIDevice currentDevice] combinedUniqueId];
        }
        
        // hide binded account logout button if needed
        if (![_mBindedAccountLogoutButton isHidden]) {
            _mBindedAccountLogoutButton.hidden = YES;
            
            // update device id or contacts info be binded or account label size width
            [_mDeviceId6ContactsInfoBeBinded6AccountLabel setFrame:CGRectMake(_mDeviceId6ContactsInfoBeBinded6AccountLabel.frame.origin.x, _mDeviceId6ContactsInfoBeBinded6AccountLabel.frame.origin.y, _mDeviceId6ContactsInfoBeBinded6AccountLabel.frame.size.width + BINDEDACCOUNTLOGOUTBUTTON_WIDTH + MYACCOUNTGROUPVIEWBINDEDACCOUNTLOGOUTBUTTON_PADDINGLEFT, _mDeviceId6ContactsInfoBeBinded6AccountLabel.frame.size.height)];
        }
    }
    
    // test by ares
    _mDeviceId6ContactsInfoBeBinded6AccountLabel.backgroundColor = [UIColor orangeColor];
    
    // check login user contacts info type be binded and set phone bind button enable or disable
    if (nil != _loginUserContactsInfoTypeBeBinded && [NSRBGServerFieldString(@"remote background server http request login or register and login with device id or phone bind response phone binded status", nil) isEqualToString:_loginUserContactsInfoTypeBeBinded]) {
        _mPhoneBindButton.enabled = NO;
    }
    else {
        _mPhoneBindButton.enabled = YES;
    }
}

- (void)bindedAccountLogout{
    // show asynchronous http request progress view
    [self.window showMBProgressHUD];
    
    // revert to register and login with device combined unique id
    // generate register and login with device combined unique id param map
    NSMutableDictionary *_reg7LoginWithDeviceIdParamMap = [[NSMutableDictionary alloc] init];
    
    // set some params
    [_reg7LoginWithDeviceIdParamMap setObject:[[UIDevice currentDevice] combinedUniqueId] forKey:NSRBGServerFieldString(@"remote background server http request register and login with device id or contact info bind device id", nil)];
    [_reg7LoginWithDeviceIdParamMap addEntriesFromDictionary:REQUESTPARAMWITHDEVICEINFOIDC];
    
    // define register and login with device combined unique id http request processor
    RegAndLoginWithDeviceIdHttpRequestProcessor *_regAndLoginWithDeviceIdLoginHttpRequestProcessor = [[RegAndLoginWithDeviceIdHttpRequestProcessor alloc] init];
    
    // set register and login with device combined unique id http request processor register and login with device id type and completion
    [_regAndLoginWithDeviceIdLoginHttpRequestProcessor setReg7LoginWithDeviceIdType:BINDEDACCOUNTLOGOUT_REG7LOGINWITHDEVICEID];
    [_regAndLoginWithDeviceIdLoginHttpRequestProcessor setReg7LoginWithDeviceIdCompletion:^(NSInteger result) {
        // hide asynchronous http request progress view
        [self.window hideMBProgressHUD];
        
        // check register and login with device combined unique id request response result
        if (0 == result) {
            // my account is changed
            _mIsMyAccountChanged = YES;
            
            // register and login with device combined unique id succeed, update my account and contacts info bind group UI
            [self updateMyAccount7ContactsInfoBindGroupUI];
        }
        else {
            // register and login with device combined unique id failed, show binded account logout error toast
            [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast binded account logout error", nil)) show:iToastTypeError];
        }
    }];
    
    // post register and login with device combined unique id http request
    [HttpUtils postRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"register and login with device id url format string", nil), NSUrlString(@"remote background server root url string", nil)] andPostFormat:urlEncoded andParameter:_reg7LoginWithDeviceIdParamMap andUserInfo:nil andRequestType:asynchronous andProcessor:_regAndLoginWithDeviceIdLoginHttpRequestProcessor andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
}

- (void)phoneBindButtonOnClicked{
    NSLog(@"phone bind button on clicked");
    
    //
}

- (void)bindedAccountLoginButtonOnClicked{
    NSLog(@"binded account login button on clicked");
    
    // test by ares
    UIAlertView *_alertView = [[UIAlertView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 200.0)];
    UILabel *_l = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 60.0, 260.0, 125.0)];
    _l.backgroundColor = [UIColor redColor];
    //[_alertView addSubview:_l];
    [_alertView show];
    NSLog(@"show alertView frame = %@", NSStringFromCGRect(_alertView.frame));
    
    //
}

@end
