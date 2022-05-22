//
//  TFJunYou_FreezeNoCodeSendVc.m
//  TFJunYouChat
//
//  Created by os on 2021/2/6.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_FreezeNoCodeSendVc.h"
#import "TFJunYou_loginVC.h"
#import "TFJunYou_securityCenterVC.h"

#define HEIGHT 50

@interface TFJunYou_FreezeNoCodeSendVc ()<UITextFieldDelegate>
@property(nonatomic, strong) NSLayoutConstraint *constraintHHH;
@property(nonatomic, strong) UIButton *areaNoBtn;
@property(nonatomic, strong) UITextField *tf_phone;

@property(nonatomic, strong) UITextField *tf_name;
@property(nonatomic, strong) UIButton *nextBtn;
@property(nonatomic, strong) UIButton *getCodeBtn;

@property(nonatomic, strong) UITextField *imgCode;
@property(nonatomic, strong) UITextField *code;

@property(nonatomic, strong) UIImageView * imgCodeImg;

@property(nonatomic, strong) UIButton *graphicButton;

@property(nonatomic, strong) UIButton *send;
@property (nonatomic, assign) BOOL isCheckToSMS;
@property (nonatomic, strong) TFJunYou_UserObject *user;

@property (nonatomic, strong) NSString *smsCode;
@property (nonatomic, strong) NSString *phoneStr;
@property (nonatomic, strong) NSString *imgCodeStr;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int seconds;

@property (nonatomic, assign) BOOL isSendFirst;
@end

@implementation TFJunYou_FreezeNoCodeSendVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    
    [self createHeadAndFoot];
    self.title = _type == FreezeTypeBlocking ? @"冻结book号" :  @"解冻book号";
//    self.tableBody.frame = CGRectZero;
//    self.view.backgroundColor = RGB(229, 229, 234);
//    _constraintHHH.constant = 44;
//    _getCodeBtn.layer.cornerRadius = 4;
//    _getCodeBtn.layer.masksToBounds = YES;
//    _getCodeBtn.layer.borderWidth = 1;
//    _getCodeBtn.layer.borderColor = RGB(51, 51, 51).CGColor;
//    _nextBtn.layer.cornerRadius = 5;
    self.tableBody.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self_width, 50)];
    tipsLabel.font = [UIFont systemFontOfSize:14];
    tipsLabel.backgroundColor = [UIColor whiteColor];
    tipsLabel.text = @"   我们将发送短信验证码到您的手机";
    [self.tableBody addSubview:tipsLabel];
    
    UIView *cotainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tipsLabel.frame), self_width, 160)];
    cotainerView.backgroundColor = [UIColor whiteColor];
    [self.tableBody addSubview:cotainerView];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 50)];
    phoneLabel.font = [UIFont systemFontOfSize:16];
    phoneLabel.backgroundColor = [UIColor whiteColor];
    phoneLabel.text = @"手机号+86";
    [cotainerView addSubview:phoneLabel];
    
    
    _tf_phone = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame), 10, self_width - CGRectGetMaxX(phoneLabel.frame), 50)];
    _tf_phone.keyboardType = UIKeyboardTypePhonePad;
    _tf_phone.font = [UIFont systemFontOfSize:16];
    _tf_phone.placeholder = @"在这里输入手机号";
    _tf_phone.delegate = self;
    [cotainerView addSubview:_tf_phone];
    
    UIView *tf_phoneCLine = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(phoneLabel.frame), self_width, LINE_WH)];
    tf_phoneCLine.backgroundColor = THE_LINE_COLOR;
    [cotainerView addSubview:tf_phoneCLine];
    
    
    
    //图片验证码
    _imgCode = [UIFactory createTextFieldWith:CGRectMake(10, CGRectGetMaxY(tf_phoneCLine.frame), self_width-10*2-70-INSETS-35-4, 50) delegate:self returnKeyType:UIReturnKeyNext secureTextEntry:NO placeholder:Localized(@"JX_inputImgCode") font:g_factory.font16];
    _imgCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"JX_inputImgCode") attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    _imgCode.borderStyle = UITextBorderStyleNone;
    _imgCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cotainerView addSubview:_imgCode];
    
//    UIView *imCView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    _imgCode.leftView = imCView;
//    _imgCode.leftViewMode = UITextFieldViewModeAlways;
//    UIImageView *imCIView = [[UIImageView alloc] initWithFrame:CGRectMake(2, HEIGHT/2-11, 22, 22)];
//    imCIView.image = [UIImage imageNamed:@"verify"];
//    imCIView.contentMode = UIViewContentModeScaleAspectFit;
//    [imCView addSubview:imCIView];
    
    UIView *imCLine = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-LINE_WH, _tf_phone.frame.size.width, LINE_WH)];
    imCLine.backgroundColor = THE_LINE_COLOR;
    [_imgCode addSubview:imCLine];
    
    _imgCodeImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgCode.frame)+INSETS, CGRectGetMidY(_imgCode.frame)-17, 70, 35)];
    _imgCodeImg.userInteractionEnabled = YES;
    [cotainerView addSubview:_imgCodeImg];
    
    UIView *imgCodeLine = [[UIView alloc] initWithFrame:CGRectMake(_imgCodeImg.frame.size.width, 3, LINE_WH, _imgCodeImg.frame.size.height-6)];
    imgCodeLine.backgroundColor = THE_LINE_COLOR;
    [_imgCodeImg addSubview:imgCodeLine];
    
    // 刷新图形验证码
    _graphicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _graphicButton.frame = CGRectMake(CGRectGetMaxX(_imgCodeImg.frame)+6, 7, 26, 26);
    _graphicButton.center = CGPointMake(_graphicButton.center.x,_imgCode.center.y);
    [_graphicButton setBackgroundImage:[UIImage imageNamed:@"refreshGraphic"] forState:UIControlStateNormal];
    [_graphicButton setBackgroundImage:[UIImage imageNamed:@"refreshGraphic"] forState:UIControlStateHighlighted];
    [_graphicButton addTarget:self action:@selector(getImgCodeImg) forControlEvents:UIControlEventTouchUpInside];
    [cotainerView addSubview:_graphicButton];
    
    
    _code = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_imgCode.frame), TFJunYou__SCREEN_WIDTH-75-10*2, HEIGHT)];
    _code.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"JX_InputMessageCode") attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    _code.font = g_factory.font16;
    _code.delegate = self;
    _code.autocorrectionType = UITextAutocorrectionTypeNo;
    _code.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _code.enablesReturnKeyAutomatically = YES;
    _code.borderStyle = UITextBorderStyleNone;
    _code.returnKeyType = UIReturnKeyDone;
    _code.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, HEIGHT)];
    _code.leftView = codeView;
    _code.leftViewMode = UITextFieldViewModeAlways;
    UILabel *codeIView = [[UILabel alloc] initWithFrame:CGRectMake(2, HEIGHT/2-11, 100, 22)];
    codeIView.text = @"验证码";
    codeIView.contentMode = UIViewContentModeScaleAspectFit;
    [codeView addSubview:codeIView];
    
    UIView *codeILine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_code.frame),self_width, LINE_WH)];
    codeILine.backgroundColor = THE_LINE_COLOR;
    [cotainerView addSubview:codeILine];

    
    [cotainerView addSubview:_code];
    
    _send = [UIFactory createButtonWithTitle:Localized(@"JX_Send")
                                   titleFont:g_factory.font16
                                  titleColor:[UIColor whiteColor]
                                      normal:nil
                                   highlight:nil ];
    _send.frame = CGRectMake(CGRectGetMaxX(_code.frame), CGRectGetMidY(_code.frame)-15 , 70, 30);
    [_send addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    _send.backgroundColor = g_theme.themeColor;
    _send.layer.masksToBounds = YES;
    _send.layer.cornerRadius = 7.f;
    [cotainerView addSubview:_send];
    
    
    // 冻结按钮
    UIButton * _btn = [UIFactory createCommonButton:@"冻结book号" target:self action:@selector(nextBtnClick:)];
    [_btn.titleLabel setFont:g_factory.font16];
    _btn.frame = CGRectMake(40, CGRectGetMaxY(cotainerView.frame) + 50,TFJunYou__SCREEN_WIDTH-40*2, 40);
    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = 7.f;
    [self.tableBody addSubview:_btn];
    
}


- (void)sendSMS{
    [_tf_phone resignFirstResponder];
    [_imgCode resignFirstResponder];
    [_code resignFirstResponder];
    if([self isMobileNumber:_tf_phone.text]){
        if (_imgCode.text.length < 3) {
            [g_App showAlert:Localized(@"JX_inputImgCode")];
        }else{
            [self onSend];
        }
    }
}

-(void)onSend{
    if (!_send.selected) {
        [_wait start:Localized(@"JX_Testing")];
        NSString *areaCode = @"86";
        _user = [TFJunYou_UserObject sharedInstance];
        _user.areaCode = areaCode;
        [g_server sendSMS:[NSString stringWithFormat:@"%@",_tf_phone.text] areaCode:areaCode isRegister:NO imgCode:_imgCode.text toView:self];
        [_send setTitle:Localized(@"JX_Sending") forState:UIControlStateNormal];
    }
}


-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if([aDownload.action isEqualToString:act_SendSMS]){
        [TFJunYou_MyTools showTipView:Localized(@"JXAlert_SendOK")];
        _send.selected = YES;
        _send.userInteractionEnabled = NO;
        _send.backgroundColor = [UIColor grayColor];
        if ([dict objectForKey:@"code"]) {
            _smsCode = [[dict objectForKey:@"code"] copy];
        }else {
            _smsCode = @"-1";
        }
        [_send setTitle:@"60s" forState:UIControlStateSelected];
        _seconds = 60;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTime:) userInfo:_send repeats:YES];
        _phoneStr = _tf_phone.text;
        _imgCodeStr = _imgCode.text;
    }
    
    if ([aDownload.action isEqualToString:act_ApiFreezeApply]) {
        if (_type == FreezeTypeBlocking) {
            [g_App showAlert:@"冻结成功"];
            //        退出登录
            [self doSwitch];
        }else {
            [g_App showAlert:@"解冻成功"];
            [g_navigation popToViewController:[TFJunYou_securityCenterVC class] animated:YES];
        }
    }
    
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if([aDownload.action isEqualToString:act_SendSMS]){
        [_send setTitle:Localized(@"JX_Send") forState:UIControlStateNormal];
        [g_App showAlert:dict[@"resultMsg"]];
        [self getImgCodeImg];
        return hide_error;
    }
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait stop];
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait stop];
}
-(void)showTime:(NSTimer*)sender{
    UIButton *but = (UIButton*)[_timer userInfo];
    _seconds--;
    [but setTitle:[NSString stringWithFormat:@"%ds",_seconds] forState:UIControlStateSelected];
    if(_seconds<=0){
        but.selected = NO;
        but.userInteractionEnabled = YES;
        but.backgroundColor = g_theme.themeColor;
        [_send setTitle:Localized(@"JX_SendAngin") forState:UIControlStateNormal];
        if (_timer) {
            _timer = nil;
            [sender invalidate];
        }
        _seconds = 60;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([g_config.isOpenSMSCode boolValue] && [g_config.regeditPhoneOrName intValue] != 1) {
        if (textField == _tf_phone) {
            [self getImgCodeImg];
        }
    }
#ifndef IS_TEST_VERSION
#endif
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)getImgCodeImg{
    if([self isMobileNumber:_tf_phone.text]){
        NSString *areaCode = @"86";
        NSString * codeUrl = [g_server getImgCode:_tf_phone.text areaCode:areaCode];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:codeUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (!connectionError) {
                UIImage * codeImage = [UIImage imageWithData:data];
                _imgCodeImg.image = codeImage;
            }else{
                NSLog(@"%@",connectionError);
                [g_App showAlert:connectionError.localizedDescription];
            }
        }];
    }else{
    }
}

- (BOOL)isMobileNumber:(NSString *)number{
    if ([g_config.isOpenSMSCode boolValue] && [g_config.regeditPhoneOrName intValue] != 1) {
        if ([_tf_phone.text length] == 0) {
            [g_App showAlert:Localized(@"JX_InputPhone")];
            return NO;
        }
    }
#ifdef IS_TEST_VERSION
#else
#endif
    return YES;
}


- (void)textDidChange:(UITextField *)textName{
    
    if (textName.text.length>1) {
        
        _nextBtn.backgroundColor = RGB(69, 129, 246);
        
    }else{
        _nextBtn.backgroundColor = [UIColor grayColor];
    }
}

 

- (void)nextBtnClick:(UIButton *)sender {
    
    if (![_smsCode isEqualToString:_code.text]) {
        [g_App showAlert:@"验证码错误"];
        return;
    }
    
    NSString *type = (_type == FreezeTypeBlocking ? @"0" : @"1");
    
    
    [g_server get_act_ApiFreezeApply:type phone:_phone idCard:_IDCard name:_name toView:self];
}



-(void)doSwitch{
    [g_default removeObjectForKey:kMY_USER_PASSWORD];
    [g_default removeObjectForKey:kMY_USER_TOKEN];
    NSLog(@"TTT(移除):");
    [g_notify postNotificationName:kSystemLogoutNotifaction object:nil];
    g_xmpp.isReconnect = NO;
    [[TFJunYou_XMPP sharedInstance] logout];
    NSLog(@"XMPP ---- TFJunYou_settingVC doSwitch");
    // 退出登录到登陆界面 隐藏悬浮窗
    g_App.subWindow.hidden = YES;
    
    TFJunYou_loginVC* vc = [TFJunYou_loginVC alloc];
    vc.isAutoLogin = NO;
    vc.isSwitchUser= NO;
    vc = [vc init];
    [g_mainVC.view removeFromSuperview];
    g_mainVC = nil;
    [self.view removeFromSuperview];
    self.view = nil;
    g_navigation.rootViewController = vc;
//    g_navigation.lastVC = nil;
//    [g_navigation.subViews removeAllObjects];
//    [g_navigation pushViewController:vc];
//    g_App.window.rootViewController = vc;
//    [g_App.window makeKeyAndVisible];

//    TFJunYou_loginVC* vc = [TFJunYou_loginVC alloc];
//    vc.isAutoLogin = NO;
//    vc.isSwitchUser= YES;
//    vc = [vc init];
//    [g_navigation.subViews removeAllObjects];
////    [g_window addSubview:vc.view];
//    [g_navigation pushViewController:vc];
//    [self actionQuit];
//    [_wait performSelector:@selector(stop) withObject:nil afterDelay:1];
//    [_wait stop];
#if TAR_IM
#ifdef Meeting_Version
    [g_meeting stopMeeting];
#endif
#endif
}
@end
