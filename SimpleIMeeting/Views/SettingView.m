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

// content alert view content view margin and padding
#define CONTENTALERTVIEWCONTENTVIEW_MARGIN  8.0
#define CONTENTALERTVIEWCONTENTVIEW_PADDING 16.0

// content alert view content view tip label width
#define CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH   76.0

// content alert view content view tip label and text field height
#define CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT    30.0

// content alert view content view cancel and confirm button height
#define CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_HEIGHT  34.0

// get phone bind verification code button width
#define PHONEBINDCONTENTALERTVIEWGETVERIFICATIONCODEBUTTON_WIDTH    98.0

// seconds per minute
#define SECONDS_PER_MINUTE  60

// phone bind and binded account login content alert view height
#define PHONEBINDCONTENTALERTVIEW_HEIGHT    234.0
#define BINDEDACCOUNTLOGINCONTENTALERTVIEW_HEIGHT   142.0

// set content alert view tip label attributes with text
#define SetContentAlertViewLabelAttributes(label, labelText)    \
    {   \
        label.text = labelText; \
        label.font = [UIFont systemFontOfSize:15.0];    \
        label.textColor = [UIColor darkGrayColor];  \
        label.lineBreakMode = NSLineBreakByTruncatingMiddle;    \
        label.backgroundColor = [UIColor clearColor];   \
    }

// set content alert view text field attributes with keyboard type, placeholder and text field delegate
#define SetContentAlertViewTextFieldAttributes(textField, textFieldKeyboardType, textFieldPlaceholder)  \
    {   \
        textField.borderStyle = UITextBorderStyleRoundedRect;   \
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;   \
        textField.returnKeyType = UIReturnKeyDone;  \
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;    \
        textField.keyboardType = textFieldKeyboardType;    \
        textField.font = [UIFont systemFontOfSize:15.0];    \
        textField.placeholder = textFieldPlaceholder;   \
        textField.delegate = self;  \
    }

// content alert view content view cancal and confirm button width value
#define CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_WIDTHVALUE  [NSValue valueWithCString:[[NSString stringWithFormat:@"(%s-2*%d-%d)/2", FILL_PARENT_STRING, (int)CONTENTALERTVIEWCONTENTVIEW_MARGIN, (int)CONTENTALERTVIEWCONTENTVIEW_PADDING] cStringUsingEncoding:NSUTF8StringEncoding]]

// content alert view content view confirm button origin x value
#define CONTENTALERTVIEWCONTENTVIEWCONFIRMBUTTON_ORIGINXVALUE   [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%@", FILL_PARENT_STRING, (int)CONTENTALERTVIEWCONTENTVIEW_MARGIN, CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_WIDTHVALUE.stringValue] cStringUsingEncoding:NSUTF8StringEncoding]]

// phone bind and binded account login alert view toast
#define ALERTVIEWTOASTMAKER(toast) [[iToast makeText:toast] setGravity:iToastGravityBottom]

@interface SettingView ()

// update my account and contacts info bind group UI
- (void)updateMyAccount7ContactsInfoBindGroupUI;

// binded account logout
- (void)bindedAccountLogout;

// phone bind button on clicked
- (void)phoneBindButtonOnClicked;

// get phone bind verification code
- (void)getPhoneBindVerificationCode;

// get phone bind verification code http request did finished selector
- (void)getPhoneBindVerificationCodeHttpRequestDidFinished:(ASIHTTPRequest *)pRequest;

// update get phone bind verification code button title and state
- (void)updateGetPhoneBindVerificationCodeButtonTitle7State;

// phone bind or binded account login canceled
- (void)phoneBind6bindedAccountLoginCanceled;

// phone bind confirm bind
- (void)registerUser;

// user register http request did finished selector
- (void)userRegisterHttpRequestDidFinished:(ASIHTTPRequest *)pRequest;

// binded account login button on clicked
- (void)bindedAccountLoginButtonOnClicked;

// binded account login confirm login
- (void)bindedAccountLogin;

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

// IHttpReqRespProtocol
- (void)httpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send http request succeed - request url = %@", pRequest.url);
    
    // hide asynchronous http request progress view
    [_mPhoneBind7BindedAccountLoginAlertView.window hideMBProgressHUD];
    
    // check the request url string
    if ([pRequest.url.absoluteString hasPrefix:[NSString stringWithFormat:NSUrlString(@"retrieve phone bind authentication code url format string", nil), NSUrlString(@"remote background server root url string", nil)]]) {
        // get phone bind verification code http request
        [self getPhoneBindVerificationCodeHttpRequestDidFinished:pRequest];
    }
    else if ([pRequest.url.absoluteString hasPrefix:[NSString stringWithFormat:NSUrlString(@"user register url format string", nil), NSUrlString(@"remote background server root url string", nil)]]) {
        // user register http request
        [self userRegisterHttpRequestDidFinished:pRequest];
    }
    else {
        NSLog(@"Warning: the request not recognized");
    }
}

- (void)httpRequestDidFailed:(ASIHTTPRequest *)pRequest{
    NSLog(@"send http request failed - request url = %@", pRequest.url);
    
    // hide asynchronous http request progress view
    [_mPhoneBind7BindedAccountLoginAlertView.window hideMBProgressHUD];
    
    // show toast
    [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil))  show:iToastTypeError];
}

// UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textField = %@ - textFieldDidBeginEditing", textField);
    
    // save last editing text field
    _mLastEditingTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField = %@ - textFieldDidEndEditing", textField);
    
    // dismiss soft input keyboard
    [textField resignFirstResponder];
    
    // clear last editing text field
    _mLastEditingTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // dismiss soft input keyboard
    [textField resignFirstResponder];
    [_mPhoneBind7BindedAccountLoginAlertView resignFirstResponder];
    
    return YES;
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
    // init phone bind alert view content view
    UIContentAlertViewContentView *_phoneBindAlertViewContentView = [[UIContentAlertViewContentView alloc] initWithFrame:CGRectMake(CGPointZero.x, CGPointZero.y, CGSizeZero.width, PHONEBINDCONTENTALERTVIEW_HEIGHT)];
    
    // set its background color
    _phoneBindAlertViewContentView.backgroundColor = [UIColor whiteColor];
    
    // define phone bind alert view content view text field(except verification code text field) width value
    NSValue *_textFieldWidthValue = [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d-%d", FILL_PARENT_STRING, (int)CONTENTALERTVIEWCONTENTVIEW_MARGIN, (int)CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH] cStringUsingEncoding:NSUTF8StringEncoding]];
    
    // init phone bind alert view content view subview phone number label
    UILabel *_phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_phoneBindAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN, _phoneBindAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN, CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH, CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT)];
    
    // set its attributes
    SetContentAlertViewLabelAttributes(_phoneNumberLabel, NSLocalizedString(@"phone bind alertview content view bind phone label text", nil));
    
    // init phone bind alert view content view subview phone number text field
    _mPhoneBindPhoneNumberTextField = [_mPhoneBindPhoneNumberTextField = [UITextField alloc] initWithFrame:CGRectMakeWithFormat(_mPhoneBindPhoneNumberTextField, [NSNumber numberWithFloat:_phoneBindAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN + CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH], [NSNumber numberWithFloat:_phoneBindAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN], _textFieldWidthValue, [NSNumber numberWithFloat:CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT])];
    
    // set its attributes
    SetContentAlertViewTextFieldAttributes(_mPhoneBindPhoneNumberTextField, UIKeyboardTypePhonePad, @"");
    
    // init phone bind alert view content view subview verification code label
    UILabel *_verificationCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_phoneBindAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN, _phoneBindAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN + CONTENTALERTVIEWCONTENTVIEW_PADDING + CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT, CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH, CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT)];
    
    // set its attributes
    SetContentAlertViewLabelAttributes(_verificationCodeLabel, NSLocalizedString(@"phone bind alertview content view verification code label text", nil));
    
    // init phone bind alert view content view subview verification code text field
    _mPhoneBindVerificationCodeTextField = [_mPhoneBindVerificationCodeTextField = [UITextField alloc] initWithFrame:CGRectMakeWithFormat(_mPhoneBindVerificationCodeTextField, [NSNumber numberWithFloat:_phoneBindAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN + CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH], [NSNumber numberWithFloat:_phoneBindAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN + CONTENTALERTVIEWCONTENTVIEW_PADDING + CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT], [NSValue valueWithCString:[[NSString stringWithFormat:@"%@-(%d+%d/2)", _textFieldWidthValue.stringValue, (int)PHONEBINDCONTENTALERTVIEWGETVERIFICATIONCODEBUTTON_WIDTH, (int)CONTENTALERTVIEWCONTENTVIEW_PADDING] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT])];
    
    // set its attributes
    SetContentAlertViewTextFieldAttributes(_mPhoneBindVerificationCodeTextField, UIKeyboardTypeNumberPad, @"");
    
    // init phone bind alert view content view subview get verification code button
    _mPhoneBindGetVerificationCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // set its frame
    [_mPhoneBindGetVerificationCodeButton setFrame:CGRectMakeWithFormat(_mPhoneBindGetVerificationCodeButton, [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%s-%d-%d", (int)_phoneBindAlertViewContentView.bounds.origin.x, FILL_PARENT_STRING, (int)CONTENTALERTVIEWCONTENTVIEW_MARGIN, (int)PHONEBINDCONTENTALERTVIEWGETVERIFICATIONCODEBUTTON_WIDTH] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:_phoneBindAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN + CONTENTALERTVIEWCONTENTVIEW_PADDING + CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT], [NSNumber numberWithFloat:PHONEBINDCONTENTALERTVIEWGETVERIFICATIONCODEBUTTON_WIDTH], [NSNumber numberWithFloat:CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT])];
    
    // set its title for normal state
    [_mPhoneBindGetVerificationCodeButton setTitle:NSLocalizedString(@"phone bind alertview content view get verification code button normal title", nil) forState:UIControlStateNormal];
    
    // add action selector and its response target for event
    [_mPhoneBindGetVerificationCodeButton addTarget:self action:@selector(getPhoneBindVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    
    // init phone bind alert view content view subview password label
    UILabel *_passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(_phoneBindAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN, _phoneBindAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN + 2 * (CONTENTALERTVIEWCONTENTVIEW_PADDING + CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT), CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH, CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT)];
    
    // set its attributes
    SetContentAlertViewLabelAttributes(_passwordLabel, NSLocalizedString(@"phone bind alertview content view password label text", nil));
    
    // init phone bind alert view content view subview password text field
    _mPhoneBindPasswordTextField = [_mPhoneBindPasswordTextField = [UITextField alloc] initWithFrame:CGRectMakeWithFormat(_mPhoneBindPasswordTextField, [NSNumber numberWithFloat:_phoneBindAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN + CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH], [NSNumber numberWithFloat:_phoneBindAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN + 2 * (CONTENTALERTVIEWCONTENTVIEW_PADDING + CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT)], _textFieldWidthValue, [NSNumber numberWithFloat:CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT])];
    
    // set its attributes
    SetContentAlertViewTextFieldAttributes(_mPhoneBindPasswordTextField, UIKeyboardTypeASCIICapable, @"");
    
    // set using secure text
    _mPhoneBindPasswordTextField.secureTextEntry = YES;
    
    // init phone bind alert view content view subview confirm password label
    UILabel *_confirmPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(_phoneBindAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN, _phoneBindAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN + 3 * (CONTENTALERTVIEWCONTENTVIEW_PADDING + CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT), CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH, CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT)];
    
    // set its attributes
    SetContentAlertViewLabelAttributes(_confirmPwdLabel, NSLocalizedString(@"phone bind alertview content view confirm password label text", nil));
    
    // init phone bind alert view content view subview confirm password text field
    _mPhoneBindConfirmPwdTextField = [_mPhoneBindConfirmPwdTextField = [UITextField alloc] initWithFrame:CGRectMakeWithFormat(_mPhoneBindConfirmPwdTextField, [NSNumber numberWithFloat:_phoneBindAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN + CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH], [NSNumber numberWithFloat:_phoneBindAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN + 3 * (CONTENTALERTVIEWCONTENTVIEW_PADDING + CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT)], _textFieldWidthValue, [NSNumber numberWithFloat:CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT])];
    
    // set its attributes
    SetContentAlertViewTextFieldAttributes(_mPhoneBindConfirmPwdTextField, UIKeyboardTypeASCIICapable, @"");
    
    // set using secure text
    _mPhoneBindConfirmPwdTextField.secureTextEntry = YES;
    
    // init phone bind alert view content view subview cancel bind button
    UIButton *_cancelBindButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // set its frame
    [_cancelBindButton setFrame:CGRectMakeWithFormat(_cancelBindButton, [NSNumber numberWithFloat:_phoneBindAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN], [NSNumber numberWithFloat:_phoneBindAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN + 4 * (CONTENTALERTVIEWCONTENTVIEW_PADDING + CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT)], CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_WIDTHVALUE, [NSNumber numberWithFloat:CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_HEIGHT])];
    
    // set its title for normal state
    [_cancelBindButton setTitle:NSLocalizedString(@"phone bind alertview content view cancel bind button title", nil) forState:UIControlStateNormal];
    
    // add action selector and its response target for event
    [_cancelBindButton addTarget:self action:@selector(phoneBind6bindedAccountLoginCanceled) forControlEvents:UIControlEventTouchUpInside];
    
    // init phone bind alert view content view subview confirm bind button
    UIButton *_confirmBindButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // set its frame
    [_confirmBindButton setFrame:CGRectMakeWithFormat(_confirmBindButton, CONTENTALERTVIEWCONTENTVIEWCONFIRMBUTTON_ORIGINXVALUE, [NSNumber numberWithFloat:PHONEBINDCONTENTALERTVIEW_HEIGHT - CONTENTALERTVIEWCONTENTVIEW_MARGIN - CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_HEIGHT], CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_WIDTHVALUE, [NSNumber numberWithFloat:CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_HEIGHT])];
    
    // set its title for normal state
    [_confirmBindButton setTitle:NSLocalizedString(@"phone bind alertview content view confirm bind button title", nil) forState:UIControlStateNormal];
    
    // add action selector and its response target for event
    [_confirmBindButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    
    // add phone bind phone number, verification code, password, confirm password label, text field, get verification code, cancel and confirm bind button as subviews of phone bind alert view content view
    [_phoneBindAlertViewContentView addSubview:_phoneNumberLabel];
    [_phoneBindAlertViewContentView addSubview:_mPhoneBindPhoneNumberTextField];
    [_phoneBindAlertViewContentView addSubview:_verificationCodeLabel];
    [_phoneBindAlertViewContentView addSubview:_mPhoneBindVerificationCodeTextField];
    [_phoneBindAlertViewContentView addSubview:_mPhoneBindGetVerificationCodeButton];
    [_phoneBindAlertViewContentView addSubview:_passwordLabel];
    [_phoneBindAlertViewContentView addSubview:_mPhoneBindPasswordTextField];
    [_phoneBindAlertViewContentView addSubview:_confirmPwdLabel];
    [_phoneBindAlertViewContentView addSubview:_mPhoneBindConfirmPwdTextField];
    [_phoneBindAlertViewContentView addSubview:_cancelBindButton];
    [_phoneBindAlertViewContentView addSubview:_confirmBindButton];
    
    // init phone bind alert view
    _mPhoneBind7BindedAccountLoginAlertView = [[UIContentAlertView alloc] initWithTitle:NSLocalizedString(@"phone bind alertview title", nil) contentView:_phoneBindAlertViewContentView];
    
    // set phone bind alert view height as tag of phone bind alert view tag
    _mPhoneBind7BindedAccountLoginAlertView.tag = PHONEBINDCONTENTALERTVIEW_HEIGHT;
    
    // int get phone bind verification code again remain seconds
    _mGetPhoneBindVerificationCodeAgainRemainSeconds = SECONDS_PER_MINUTE;
    // stop get phone bind verification code again timer if needed
    if (nil != _mGetPhoneBindVerificationCodeAgainTimer && _mGetPhoneBindVerificationCodeAgainTimer.isValid) {
        [_mGetPhoneBindVerificationCodeAgainTimer invalidate];
    }
    
    // show phone bind alert view
    [_mPhoneBind7BindedAccountLoginAlertView show];
}

- (void)getPhoneBindVerificationCode{
    // force make last editing text field end editing
    [_mLastEditingTextField endEditing:YES];
    
    // get and check phone bind phone number
    NSString *_phoneBindPhoneNumber = _mPhoneBindPhoneNumberTextField.text;
    if (nil == _phoneBindPhoneNumber || [@"" isEqualToString:_phoneBindPhoneNumber]) {
        NSLog(@"Warning: phone bind phone number is nil, phone number = %@", _phoneBindPhoneNumber);
        
        // show toast
        [ALERTVIEWTOASTMAKER(NSToastLocalizedString(@"toast phone bind phone number is null", nil)) show:iToastTypeWarning];
    }
    else {
        // show asynchronous http request progress view
        [_mPhoneBind7BindedAccountLoginAlertView.window showMBProgressHUD];
        
        // get phone bind verification code
        // generate get phone bind verification code param map
        NSMutableDictionary *_getPhoneBindVerificationCodeParamMap = [[NSMutableDictionary alloc] init];
        
        // set some params
        [_getPhoneBindVerificationCodeParamMap setObject:_phoneBindPhoneNumber forKey:NSRBGServerFieldString(@"remote background server http request get phone bind verification code or user register phone number", nil)];
        
        // post the http request
        [HttpUtils postRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"retrieve phone bind authentication code url format string", nil), NSUrlString(@"remote background server root url string", nil)] andPostFormat:urlEncoded andParameter:_getPhoneBindVerificationCodeParamMap andUserInfo:nil andRequestType:asynchronous andProcessor:self andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
    }
}

- (void)getPhoneBindVerificationCodeHttpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send get phone bind verification code http request succeed - request url = %@, response status code = %d and data string = %@", pRequest.url, [pRequest responseStatusCode], pRequest.responseString);
    
    // check status code
    if (200 == [pRequest responseStatusCode]) {
        // get response data json format
        NSDictionary *_respDataJSONFormat = [pRequest.responseString objectFromJSONString];
        
        // get and check response data result
        NSString *_respDataResult = nil != _respDataJSONFormat ? [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request response result", nil)] : nil;
        if (nil != _respDataResult) {
            // check response data result again
            switch (_respDataResult.intValue) {
                case 0:
                    // scheduled get phone bind verification code again timer
                    _mGetPhoneBindVerificationCodeAgainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateGetPhoneBindVerificationCodeButtonTitle7State) userInfo:nil repeats:YES];
                    break;
                    
                case 1:
                    NSLog(@"Error: get phone bined verification code failed, the being binded phone number = %@ is empty", _mPhoneBindPhoneNumberTextField.text);
                    
                    // show toast
                    [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast phone bind phone number is null", nil)) show:iToastTypeError];
                    break;
                    
                case 2:
                    NSLog(@"Error: get phone bined verification code failed, the being binded phone number = %@ is invalid", _mPhoneBindPhoneNumberTextField.text);
                    
                    // show toast
                    [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast phone bind phone number is invalid", nil)) show:iToastTypeError];
                    break;
                    
                case 3:
                    NSLog(@"Error: get phone bind verification code failed, the being bined phone number = %@ has been binded with other device", _mPhoneBindPhoneNumberTextField.text);
                    
                    // show toast
                    [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast phone bind phone number has be binded with other device", nil)) show:iToastTypeError];
                    break;
                    
                default:
                    NSLog(@"Warning: the response result not recognized");
                    
                    // show toast
                    [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil))  show:iToastTypeError];
                    break;
            }
        }
        else {
            NSLog(@"Warning: the response result not recognized");
            
            // show toast
            [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil))  show:iToastTypeError];
        }
    }
    else {
        // show toast
        [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil))  show:iToastTypeError];
    }
}

- (void)updateGetPhoneBindVerificationCodeButtonTitle7State{
    // check get phone bind verification code again remain seconds
    if (0 < --_mGetPhoneBindVerificationCodeAgainRemainSeconds) {
        // update get phone bind verification code button title for disabled state
        [_mPhoneBindGetVerificationCodeButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"phone bind alertview content view get verification code button disabled title format string", nil), _mGetPhoneBindVerificationCodeAgainRemainSeconds] forState:UIControlStateDisabled];
        
        // set get phone bind verification code button disabled if needed
        if ([_mPhoneBindGetVerificationCodeButton isEnabled]) {
            _mPhoneBindGetVerificationCodeButton.enabled = NO;
        }
    }
    else {
        // stop get phone bind verification code again timer
        [_mGetPhoneBindVerificationCodeAgainTimer invalidate];
        
        // reset get phone bind verification code again remain seconds
        _mGetPhoneBindVerificationCodeAgainRemainSeconds = SECONDS_PER_MINUTE;
        
        // set get phone bind verification code button normal
        _mPhoneBindGetVerificationCodeButton.enabled = YES;
    }
}

- (void)phoneBind6bindedAccountLoginCanceled{
    // dismiss phone bind or binded account login alert view animated
    [_mPhoneBind7BindedAccountLoginAlertView dismissAnimated:YES];
}

- (void)registerUser{
    // force make last editing text field end editing
    [_mLastEditingTextField endEditing:YES];
    
    // get phone bind phone number, verification code, password and confirm password
    NSString *_phoneBindPhoneNumber = _mPhoneBindPhoneNumberTextField.text;
    NSString *_phoneBindVerificationCode = _mPhoneBindVerificationCodeTextField.text;
    NSString *_phoneBindPassword = _mPhoneBindPasswordTextField.text;
    NSString *_phoneBindConfirmPwd = _mPhoneBindConfirmPwdTextField.text;
    
    // check phone bind phone number, verification code, password and confirm password
    if (nil == _phoneBindPhoneNumber || [@"" isEqualToString:_phoneBindPhoneNumber]) {
        NSLog(@"Warning: phone bind phone number is nil, phone number = %@", _phoneBindPhoneNumber);
        
        // show toast
        [ALERTVIEWTOASTMAKER(NSToastLocalizedString(@"toast phone bind phone number is null", nil)) show:iToastTypeWarning];
    }
    else if (nil == _phoneBindVerificationCode || [@"" isEqualToString:_phoneBindVerificationCode]) {
        NSLog(@"Warning: phone bind verification code is nil, verification code = %@", _phoneBindVerificationCode);
        
        // show toast
        [ALERTVIEWTOASTMAKER(NSToastLocalizedString(@"toast phone bind verification code is null", nil)) show:iToastTypeWarning];
    }
    else if (nil == _phoneBindPassword || [@"" isEqualToString:_phoneBindPassword]) {
        NSLog(@"Warning: phone bind password is nil, password = %@", _phoneBindPassword);
        
        // show toast
        [ALERTVIEWTOASTMAKER(NSToastLocalizedString(@"toast phone bind password is null", nil)) show:iToastTypeWarning];
    }
    else if (nil == _phoneBindConfirmPwd || [@"" isEqualToString:_phoneBindConfirmPwd]) {
        NSLog(@"Warning: phone bind confirm password is nil, confirm password = %@", _phoneBindConfirmPwd);
        
        // show toast
        [ALERTVIEWTOASTMAKER(NSToastLocalizedString(@"toast phone bind confirm password is null", nil)) show:iToastTypeWarning];
    }
    else if (![_phoneBindPassword isEqualToString:_phoneBindConfirmPwd]) {
        NSLog(@"Warning: phone bind password not matched with confirm password, password = %@ and confirm password = %@", _phoneBindPassword, _phoneBindConfirmPwd);
        
        // show toast
        [ALERTVIEWTOASTMAKER(NSToastLocalizedString(@"toast phone bind password not matched with confirm password", nil)) show:iToastTypeWarning];
    }
    else {
        // phone bind confirm, register user
        // generate user register param map
        NSMutableDictionary *_userRegisterParamMap = [[NSMutableDictionary alloc] init];
        
        // set some params
        [_userRegisterParamMap setObject:_phoneBindPhoneNumber forKey:NSRBGServerFieldString(@"remote background server http request get phone bind verification code or user register phone number", nil)];
        [_userRegisterParamMap setObject:_phoneBindVerificationCode forKey:NSRBGServerFieldString(@"remote background server http request user register verification code", nil)];
        [_userRegisterParamMap setObject:_phoneBindPassword forKey:NSRBGServerFieldString(@"remote background server http request user register password", nil)];
        [_userRegisterParamMap setObject:_phoneBindConfirmPwd forKey:NSRBGServerFieldString(@"remote background server http request user register confirm password", nil)];
        [_userRegisterParamMap setObject:[[UIDevice currentDevice] combinedUniqueId] forKey:NSRBGServerFieldString(@"remote background server http request register and login with device id or contact info bind device id", nil)];
        
        // post the http request
        [HttpUtils postRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"user register url format string", nil), NSUrlString(@"remote background server root url string", nil)] andPostFormat:urlEncoded andParameter:_userRegisterParamMap andUserInfo:nil andRequestType:asynchronous andProcessor:self andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
    }
}

- (void)userRegisterHttpRequestDidFinished:(ASIHTTPRequest *)pRequest{
    NSLog(@"send user register http request succeed - request url = %@, response status code = %d and data string = %@", pRequest.url, [pRequest responseStatusCode], pRequest.responseString);
    
    // check status code
    if (200 == [pRequest responseStatusCode]) {
        // get response data json format
        NSDictionary *_respDataJSONFormat = [pRequest.responseString objectFromJSONString];
        
        // get and check response data result
        NSString *_respDataResult = nil != _respDataJSONFormat ? [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request response result", nil)] : nil;
        if (nil != _respDataResult) {
            // check response data result again
            switch (_respDataResult.intValue) {
                case 0:
                    {
                        // get binded phone number and register user login password
                        NSString *_bindedPhone = _mPhoneBindPhoneNumberTextField.text;
                        NSString *_registerUserLoginPwd = _mPhoneBindPasswordTextField.text;
                        
                        // dismiss phone bind alert view
                        [_mPhoneBind7BindedAccountLoginAlertView dismissAnimated:YES];
                        
                        // add binded phone number and register user login password to local storage
                        [[NSUserDefaults standardUserDefaults] setObject:_bindedPhone forKey:BINDEDACCOUNT_LOGINNAME];
                        [[NSUserDefaults standardUserDefaults] setObject:_registerUserLoginPwd forKey:BINDEDACCOUNT_LOGINPWD];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        // get user register response response userId, userKey and bindStatus
                        NSString *_userRegisterRespUserId = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request login or contact info bind response user id", nil)];
                        NSString *_userRegisterRespUserKey = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request login or contact info bind response user key", nil)];
                        NSString *_userRegisterRespBindStatus = [_respDataJSONFormat objectForKey:NSRBGServerFieldString(@"remote background server http request login or register and login with device id or phone bind response bind status", nil)];
                        
                        NSLog(@"user register successful, response user id = %@, user key = %@ and bind status = %@", _userRegisterRespUserId, _userRegisterRespUserKey, _userRegisterRespBindStatus);
                        
                        // generate new register user bean and set other attributes
                        UserBean *_newRegisterUser = [[UserBean alloc] init];
                        _newRegisterUser.name = _userRegisterRespUserId;
                        _newRegisterUser.password = _registerUserLoginPwd;
                        _newRegisterUser.userKey = _userRegisterRespUserKey;
                        
                        _newRegisterUser.bindContactInfo = _bindedPhone;
                        _newRegisterUser.contactsInfoTypeBeBinded = _userRegisterRespBindStatus;
                        
                        // add it to user manager
                        [[UserManager shareUserManager] setUserBean:_newRegisterUser];
                        
                        // phone bind succeed, update my account and contacts info bind group UI
                        [self updateMyAccount7ContactsInfoBindGroupUI];
                    }
                    break;
                    
                case 1:
                    NSLog(@"Error: user register failed, the verification code = %@ is empty", _mPhoneBindVerificationCodeTextField.text);
                    
                    // show toast
                    [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast phone bind verification code is null", nil)) show:iToastTypeError];
                    break;
                    
                case 2:
                    NSLog(@"Error: user register failed, the verification code = %@ is wrong", _mPhoneBindVerificationCodeTextField.text);
                    
                    // show toast
                    [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast phone bind verification code wrong", nil)) show:iToastTypeError];
                    break;
                    
                case 5:
                    NSLog(@"Error: user register failed, the user register password = %@ not matched with confirm password = %@", _mPhoneBindPasswordTextField.text, _mPhoneBindConfirmPwdTextField.text);
                    
                    // show toast
                    [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast phone bind password not matched with confirm password", nil)) show:iToastTypeError];
                    break;
                    
                case 6:
                case 7:
                    NSLog(@"Error: user register failed, the verification code = %@ is timeout", _mPhoneBindVerificationCodeTextField.text);
                    
                    // show toast
                    [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast phone bind verification code timeout", nil)) show:iToastTypeError];
                    break;
                
                default:
                    NSLog(@"Warning: the response result not recognized");
                    
                    // show toast
                    [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil))  show:iToastTypeError];
                    break;
            }
        }
        else {
            NSLog(@"Warning: the response result not recognized");
            
            // show toast
            [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil))  show:iToastTypeError];
        }
    }
    else {
        // show toast
        [HTTPREQRESPRETTOASTMAKER(NSToastLocalizedString(@"toast http request response error", nil))  show:iToastTypeError];
    }
}

- (void)bindedAccountLoginButtonOnClicked{
    // init binded account login alert view content view
    UIContentAlertViewContentView *_bindedAccountLoginAlertViewContentView = [[UIContentAlertViewContentView alloc] initWithFrame:CGRectMake(CGPointZero.x, CGPointZero.y, CGSizeZero.width, BINDEDACCOUNTLOGINCONTENTALERTVIEW_HEIGHT)];
    
    // set its background color
    _bindedAccountLoginAlertViewContentView.backgroundColor = [UIColor whiteColor];
    
    // define binded account login alert view content view text field width value
    NSValue *_textFieldWidthValue = [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d-%d", FILL_PARENT_STRING, (int)CONTENTALERTVIEWCONTENTVIEW_MARGIN, (int)CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH] cStringUsingEncoding:NSUTF8StringEncoding]];
    
    // init binded account login alert view content view subview login name label
    UILabel *_loginNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bindedAccountLoginAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN, _bindedAccountLoginAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN, CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH, CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT)];
    
    // set its attributes
    SetContentAlertViewLabelAttributes(_loginNameLabel, NSLocalizedString(@"binded account login alertview content view name label text", nil));
    
    // init binded account login alert view content view subview login name text field
    _mBindedAccountLoginNameTextField = [_mBindedAccountLoginNameTextField = [UITextField alloc] initWithFrame:CGRectMakeWithFormat(_mBindedAccountLoginNameTextField, [NSNumber numberWithFloat:_bindedAccountLoginAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN + CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH], [NSNumber numberWithFloat:_bindedAccountLoginAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN], _textFieldWidthValue, [NSNumber numberWithFloat:CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT])];
    
    // set its attributes
    SetContentAlertViewTextFieldAttributes(_mBindedAccountLoginNameTextField, UIKeyboardTypeASCIICapable, @"");
    
    // init binded account login alert view content view subview login password label
    UILabel *_loginPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bindedAccountLoginAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN, _bindedAccountLoginAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN + CONTENTALERTVIEWCONTENTVIEW_PADDING + CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT, CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH, CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT)];
    
    // set its attributes
    SetContentAlertViewLabelAttributes(_loginPwdLabel, NSLocalizedString(@"binded account login alertview content view password label text", nil));
    
    // init binded account login alert view content view subview login password text field
    _mBindedAccountLoginPasswordTextField = [_mBindedAccountLoginPasswordTextField = [UITextField alloc] initWithFrame:CGRectMakeWithFormat(_mBindedAccountLoginPasswordTextField, [NSNumber numberWithFloat:_bindedAccountLoginAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN + CONTENTALERTVIEWCONTENTVIEWTIPLABEL_WIDTH], [NSNumber numberWithFloat:_bindedAccountLoginAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN + CONTENTALERTVIEWCONTENTVIEW_PADDING + CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT], _textFieldWidthValue, [NSNumber numberWithFloat:CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT])];
    
    // set its attributes
    SetContentAlertViewTextFieldAttributes(_mBindedAccountLoginPasswordTextField, UIKeyboardTypeASCIICapable, @"");
    
    // set using secure text
    _mBindedAccountLoginPasswordTextField.secureTextEntry = YES;
    
    // init binded account login alert view content view subview cancel login button
    UIButton *_cancelLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // set its frame
    [_cancelLoginButton setFrame:CGRectMakeWithFormat(_cancelLoginButton, [NSNumber numberWithFloat:_bindedAccountLoginAlertViewContentView.bounds.origin.x + CONTENTALERTVIEWCONTENTVIEW_MARGIN], [NSNumber numberWithFloat:_bindedAccountLoginAlertViewContentView.bounds.origin.y + CONTENTALERTVIEWCONTENTVIEW_MARGIN + 2 * (CONTENTALERTVIEWCONTENTVIEW_PADDING + CONTENTALERTVIEWCONTENTVIEWTIPLABEL7TEXTFIELD_HEIGHT)], CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_WIDTHVALUE, [NSNumber numberWithFloat:CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_HEIGHT])];
    
    // set its title for normal state
    [_cancelLoginButton setTitle:NSLocalizedString(@"binded account login alertview content view cancel login button title", nil) forState:UIControlStateNormal];
    
    // add action selector and its response target for event
    [_cancelLoginButton addTarget:self action:@selector(phoneBind6bindedAccountLoginCanceled) forControlEvents:UIControlEventTouchUpInside];
    
    // init binded account login alert view content view subview confirm login button
    UIButton *_confirmLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // set its frame
    [_confirmLoginButton setFrame:CGRectMakeWithFormat(_confirmLoginButton, CONTENTALERTVIEWCONTENTVIEWCONFIRMBUTTON_ORIGINXVALUE, [NSNumber numberWithFloat:BINDEDACCOUNTLOGINCONTENTALERTVIEW_HEIGHT - CONTENTALERTVIEWCONTENTVIEW_MARGIN - CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_HEIGHT], CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_WIDTHVALUE, [NSNumber numberWithFloat:CONTENTALERTVIEWCONTENTVIEWCANCEL7CONFIRMBUTTON_HEIGHT])];
    
    // set its title for normal state
    [_confirmLoginButton setTitle:NSLocalizedString(@"binded account login alertview content view confirm login button title", nil) forState:UIControlStateNormal];
    
    // add action selector and its response target for event
    [_confirmLoginButton addTarget:self action:@selector(bindedAccountLogin) forControlEvents:UIControlEventTouchUpInside];
    
    // add binded account login name, password label, text field, cancel and confirm login button as subviews of binded account login alert view content view
    [_bindedAccountLoginAlertViewContentView addSubview:_loginNameLabel];
    [_bindedAccountLoginAlertViewContentView addSubview:_mBindedAccountLoginNameTextField];
    [_bindedAccountLoginAlertViewContentView addSubview:_loginPwdLabel];
    [_bindedAccountLoginAlertViewContentView addSubview:_mBindedAccountLoginPasswordTextField];
    [_bindedAccountLoginAlertViewContentView addSubview:_cancelLoginButton];
    [_bindedAccountLoginAlertViewContentView addSubview:_confirmLoginButton];
    
    // init binded account login alert view
    _mPhoneBind7BindedAccountLoginAlertView = [[UIContentAlertView alloc] initWithTitle:NSLocalizedString(@"binded account login alertview title", nil) contentView:_bindedAccountLoginAlertViewContentView];
    
    // set binded account login alert view height as tag of binded account login alert view tag
    _mPhoneBind7BindedAccountLoginAlertView.tag = BINDEDACCOUNTLOGINCONTENTALERTVIEW_HEIGHT;
    
    // show binded account login alert view
    [_mPhoneBind7BindedAccountLoginAlertView show];
}

- (void)bindedAccountLogin{
    // force make last editing text field end editing
    [_mLastEditingTextField endEditing:YES];
    
    // get binded account login name and password
    NSString *_bindedAccountLoginName = _mBindedAccountLoginNameTextField.text;
    NSString *_bindedAccountLoginPwd = _mBindedAccountLoginPasswordTextField.text;
    
    // check binded account login name and password
    if (nil == _bindedAccountLoginName || [@"" isEqualToString:_bindedAccountLoginName]) {
        NSLog(@"Warning: binded account login name is nil, login name = %@", _bindedAccountLoginName);
        
        // show toast
        [ALERTVIEWTOASTMAKER(NSToastLocalizedString(@"toast binded account login user name is null", nil)) show:iToastTypeWarning];
    }
    else if (nil == _bindedAccountLoginPwd || [@"" isEqualToString:_bindedAccountLoginPwd]) {
        NSLog(@"Warning: binded account login password is nil, login password = %@", _bindedAccountLoginPwd);
        
        // show toast
        [ALERTVIEWTOASTMAKER(NSToastLocalizedString(@"toast binded account login password is null", nil)) show:iToastTypeWarning];
    }
    else {
        // show asynchronous http request progress view
        [_mPhoneBind7BindedAccountLoginAlertView.window showMBProgressHUD];
        
        // binded account user login
        // generate binded account login param map
        NSMutableDictionary *_bindedAccountLoginParamMap = [[NSMutableDictionary alloc] init];
        
        // set some params
        [_bindedAccountLoginParamMap setObject:_bindedAccountLoginName forKey:NSRBGServerFieldString(@"remote background server http request binded account login name", nil)];
        [_bindedAccountLoginParamMap setObject:[_bindedAccountLoginPwd md5] forKey:NSRBGServerFieldString(@"remote background server http request binded account login password", nil)];
        [_bindedAccountLoginParamMap addEntriesFromDictionary:REQUESTPARAMWITHDEVICEINFOIDC];
        
        // define binded account login http request processor
        BindedAccountLoginHttpRequestProcessor *_bindedAccountLoginHttpRequestProcessor = [[BindedAccountLoginHttpRequestProcessor alloc] init];
        
        // set binded account login http request processor login type, login name, password and completion
        [_bindedAccountLoginHttpRequestProcessor setLoginType:BINDEDACCOUNT_MANUALLOGIN];
        [_bindedAccountLoginHttpRequestProcessor setManualLoginUserName:_bindedAccountLoginName password:_bindedAccountLoginPwd];
        [_bindedAccountLoginHttpRequestProcessor setLoginCompletion:^(NSInteger result) {
            // check binded account login request response result
            if (0 == result) {
                // dismiss binded account login alert view
                [_mPhoneBind7BindedAccountLoginAlertView dismissAnimated:YES];
                
                // my account is changed
                _mIsMyAccountChanged = YES;
                
                // binded account login succeed, update my account and contacts info bind group UI
                [self updateMyAccount7ContactsInfoBindGroupUI];
            }
            else {
                // hide asynchronous http request progress view
                [_mPhoneBind7BindedAccountLoginAlertView.window hideMBProgressHUD];
            }
        }];
        
        // post binded account login http request
        [HttpUtils postRequestWithUrl:[NSString stringWithFormat:NSUrlString(@"binded account login url format string", nil), NSUrlString(@"remote background server root url string", nil)] andPostFormat:urlEncoded andParameter:_bindedAccountLoginParamMap andUserInfo:nil andRequestType:synchronous andProcessor:_bindedAccountLoginHttpRequestProcessor andFinishedRespSelector:@selector(httpRequestDidFinished:) andFailedRespSelector:@selector(httpRequestDidFailed:)];
    }
}

@end
