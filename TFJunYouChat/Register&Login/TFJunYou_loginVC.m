#import "TFJunYou_loginVC.h"
#import "TFJunYou_forgetPwdVC.h"
#import "TFJunYou_inputPhoneVC.h"
#import "TFJunYou_MainViewController.h"
#import "TFJunYou_TelAreaListVC.h"
#import "QCheckBox.h"
#import "webpageVC.h"
#import "TFJunYou_Location.h"
#import "UIView+Frame.h"
#import "UIView+LK.h"
#import "WKWebViewViewController.h"
#define HEIGHT 56
#define tyCurrentWindow [[UIApplication sharedApplication].windows firstObject]
@interface TFJunYou_loginVC ()<UITextFieldDelegate, QCheckBoxDelegate, TFJunYou_LocationDelegate, TFJunYou_LocationDelegate> {
    UIButton *_areaCodeBtn;
    QCheckBox * _checkProtocolBtn;
    UIButton *_forgetBtn;
    BOOL _isFirstLocation;
    NSString *_myToken;
    UIButton *_switchLogin; 
    UIImageView * _imgCodeImg;
    UITextField *_imgCode;   
    UIButton *_send;   
    UIButton * _graphicButton;
    NSString* _smsCode;
    int _seconds;
    NSTimer *_timer;
    NSInteger setServerNum;
}
@property(nonatomic,strong)dispatch_source_t authTimer;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)UIView *waitAuthView;
@property (nonatomic,weak) UIView *backView;

@end
@implementation TFJunYou_loginVC
-(UIView *)launchView {
    if (!_launchView) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
        UIViewController *vc = sb.instantiateInitialViewController;
        _launchView = vc.view;
        [self.view addSubview:_launchView];
    }
    return _launchView;
}
- (id)init{
    self = [super init];
    if (self) {
        _user = [[TFJunYou_UserObject alloc] init];
        self.title = Localized(@"JX_Login");
        self.heightFooter = 0;
        self.heightHeader = TFJunYou__SCREEN_TOP;
        if (_isThirdLogin) {
            self.title = Localized(@"JX_BindExistingAccount");
        }
        if (self.isSMSLogin) {
            self.title = Localized(@"JX_SMSLogin");
            self.isGotoBack = YES;
        }
        
        [g_server getAppResource:@"0" ToView:self];
        [g_server customerLinkList:self];
        g_server.isManualLogin = NO;
        [self createHeadAndFoot];
        self.tableBody.backgroundColor = [UIColor whiteColor];
        _myToken = [g_default objectForKey:kMY_USER_TOKEN];
        [g_default setObject:nil forKey:kMyPayPrivateKey];
        int n = INSETS;
        g_server.isLogin = NO;
        g_navigation.lastVC = nil;
#if IS_SetupServer
        UIButton* btn = [UIFactory createButtonWithTitle:@"" titleFont:[UIFont systemFontOfSize:15] titleColor:[UIColor whiteColor] normal:nil highlight:nil];
        [btn setTitleColor:THESIMPLESTYLE ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(onSetting) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-88, TFJunYou__SCREEN_TOP - 38, 83, 30);
        btn.hidden = _isThirdLogin || self.isSMSLogin;
        [self.tableHeader addSubview:btn];
        setServerNum = 0;
#endif
        n += 50;
        UIImageView * kuliaoIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ALOGO_120"]];
        kuliaoIconView.frame = CGRectMake((TFJunYou__SCREEN_WIDTH-100)/2, n, 100, 100);
        [self.tableBody addSubview:kuliaoIconView];
        NSString * titleStr;
#if TAR_IM
        titleStr = APP_NAME;
#endif
        n += 143;
        if (!_phone) {
            if ([g_config.regeditPhoneOrName intValue] != 1) {
                _phone = [UIFactory createTextFieldWith:CGRectMake(40, n, TFJunYou__SCREEN_WIDTH-40*2, HEIGHT) delegate:self returnKeyType:UIReturnKeyNext secureTextEntry:NO placeholder:Localized(@"JX_InputPhone") font:g_factory.font16];
                _phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"JX_InputPhone") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _phone.keyboardType = UIKeyboardTypeDefault;
            }else {
                _phone = [UIFactory createTextFieldWith:CGRectMake(40, n, TFJunYou__SCREEN_WIDTH-40*2, HEIGHT) delegate:self returnKeyType:UIReturnKeyNext secureTextEntry:NO placeholder:Localized(@"JX_InputUserAccount") font:g_factory.font16];
                _phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"JX_InputUserAccount") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                 _phone.keyboardType = UIKeyboardTypeDefault;
            }
            _phone.borderStyle = UITextBorderStyleNone;
            _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
            [self.tableBody addSubview:_phone];
            [_phone addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, HEIGHT)];
            _phone.leftView = leftView;
            _phone.leftViewMode = UITextFieldViewModeAlways;
            UIImageView *phIgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, HEIGHT/2-11, 22, 22)];
            phIgView.image = [UIImage imageNamed:@"account"];
            phIgView.contentMode = UIViewContentModeScaleAspectFit;
            [leftView addSubview:phIgView];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-LINE_WH, _phone.frame.size.width, LINE_WH)];
            line.backgroundColor = THE_LINE_COLOR;
            [_phone addSubview:line];
            UIView *riPhView = [[UIView alloc] initWithFrame:CGRectMake(_phone.frame.size.width-44, 0, HEIGHT, HEIGHT)];
            _phone.rightView = riPhView;
            _phone.rightViewMode = UITextFieldViewModeAlways;
            [_phone addTarget:self action:@selector(longLimit:) forControlEvents:UIControlEventEditingChanged];
            NSString *areaStr;
            if (![g_default objectForKey:kMY_USER_AREACODE]) {
                areaStr = @"+86";
            } else {
                areaStr = [NSString stringWithFormat:@"+%@",[g_default objectForKey:kMY_USER_AREACODE]];
            }
            _areaCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, HEIGHT/2-11, HEIGHT-5, 22)];
            [_areaCodeBtn setTitle:areaStr forState:UIControlStateNormal];
            _areaCodeBtn.titleLabel.font = SYSFONT(16);
            [_areaCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _areaCodeBtn.custom_acceptEventInterval = 1.0f;
            [_areaCodeBtn addTarget:self action:@selector(areaCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self resetBtnEdgeInsets:_areaCodeBtn];
            [riPhView addSubview:_areaCodeBtn];
         }
        n = n+HEIGHT;
        if (self.isSMSLogin) {
            _imgCode = [UIFactory createTextFieldWith:CGRectMake(40, n, TFJunYou__SCREEN_WIDTH-40*2-70-INSETS-35-4, HEIGHT) delegate:self returnKeyType:UIReturnKeyNext secureTextEntry:NO placeholder:Localized(@"JX_inputImgCode") font:g_factory.font16];
            _imgCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"JX_inputImgCode") attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
            _imgCode.borderStyle = UITextBorderStyleNone;
            _imgCode.clearButtonMode = UITextFieldViewModeWhileEditing;
            [self.tableBody addSubview:_imgCode];
            UIView *imCView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, HEIGHT)];
            _imgCode.leftView = imCView;
            _imgCode.leftViewMode = UITextFieldViewModeAlways;
            UIImageView *imCIView = [[UIImageView alloc] initWithFrame:CGRectMake(2, HEIGHT/2-11, 22, 22)];
            imCIView.image = [UIImage imageNamed:@"verify"];
            imCIView.contentMode = UIViewContentModeScaleAspectFit;
            [imCView addSubview:imCIView];
            UIView *imCLine = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-LINE_WH, _phone.frame.size.width, LINE_WH)];
            imCLine.backgroundColor = THE_LINE_COLOR;
            [_imgCode addSubview:imCLine];
            _imgCodeImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgCode.frame)+INSETS, 0, 70, 35)];
            _imgCodeImg.center = CGPointMake(_imgCodeImg.center.x, _imgCode.center.y);
            _imgCodeImg.userInteractionEnabled = YES;
            [self.tableBody addSubview:_imgCodeImg];
            UIView *imgCodeLine = [[UIView alloc] initWithFrame:CGRectMake(_imgCodeImg.frame.size.width, 3, LINE_WH, _imgCodeImg.frame.size.height-6)];
            imgCodeLine.backgroundColor = THE_LINE_COLOR;
            [_imgCodeImg addSubview:imgCodeLine];
            _graphicButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _graphicButton.frame = CGRectMake(CGRectGetMaxX(_imgCodeImg.frame)+6, 7, 26, 26);
            _graphicButton.center = CGPointMake(_graphicButton.center.x,_imgCode.center.y);
            [_graphicButton setBackgroundImage:[UIImage imageNamed:@"refreshGraphic"] forState:UIControlStateNormal];
            [_graphicButton setBackgroundImage:[UIImage imageNamed:@"refreshGraphic"] forState:UIControlStateHighlighted];
            [_graphicButton addTarget:self action:@selector(refreshGraphicAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.tableBody addSubview:_graphicButton];
            n = n+HEIGHT;
        }
        _pwd = [[UITextField alloc] initWithFrame:CGRectMake(40, n, TFJunYou__SCREEN_WIDTH-40*2, HEIGHT)];
        _pwd.delegate = self;
        _pwd.font = g_factory.font16;
        _pwd.autocorrectionType = UITextAutocorrectionTypeNo;
        _pwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _pwd.enablesReturnKeyAutomatically = YES;
        _pwd.returnKeyType = UIReturnKeyDone;
        _pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"JX_InputPassWord") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        _pwd.secureTextEntry = !self.isSMSLogin;
        _pwd.userInteractionEnabled = YES;
        [self.tableBody addSubview:_pwd];
        if (self.isSMSLogin) {
            _pwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"JX_InputMessageCode") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
            _send = [UIFactory createButtonWithTitle:Localized(@"JX_Send")
                                           titleFont:g_factory.font16
                                          titleColor:[UIColor whiteColor]
                                              normal:nil
                                           highlight:nil ];
            _send.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-70-40-11, n+HEIGHT/2-15, 70, 30);
            [_send addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
            _send.backgroundColor = g_theme.themeColor;
            _send.layer.masksToBounds = YES;
            _send.layer.cornerRadius = 7.f;
            [self.tableBody addSubview:_send];
        }else {
            UIView *eyeView = [[UIView alloc]initWithFrame:CGRectMake(_pwd.frame.size.width-HEIGHT, 0, HEIGHT, HEIGHT)];
            _pwd.rightView = eyeView;
            _pwd.rightViewMode = UITextFieldViewModeAlways;
            UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(HEIGHT/2-10.5+5, HEIGHT/2-6.5, 21, 13)];
            [rightBtn setBackgroundImage:[UIImage imageNamed:@"ic_password_hide"] forState:UIControlStateNormal];
            [rightBtn setBackgroundImage:[UIImage imageNamed:@"ic_password_display"] forState:UIControlStateSelected];
            [rightBtn addTarget:self action:@selector(passWordRightViewClicked:) forControlEvents:UIControlEventTouchUpInside];
            [eyeView addSubview:rightBtn];
        }
        
        n = n+HEIGHT+INSETS;
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, HEIGHT)];
        _pwd.leftView = rightView;
        _pwd.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *riIgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, HEIGHT/2-11, 22, 22)];
        riIgView.image = [UIImage imageNamed:@"password"];
        riIgView.contentMode = UIViewContentModeScaleAspectFit;
        [rightView addSubview:riIgView];
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-LINE_WH, _pwd.frame.size.width, LINE_WH)];
        verticalLine.backgroundColor = THE_LINE_COLOR;
        [_pwd addSubview:verticalLine];
        n += 6;
        
        UIButton *lbUser = [[UIButton alloc]initWithFrame:CGRectMake(40, n, 100, 20)];
        [lbUser setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [lbUser setTitle:Localized(@"JX_ForgetPassWord") forState:UIControlStateNormal];
        lbUser.titleLabel.font = g_factory.font16;
        lbUser.custom_acceptEventInterval = 1.0f;
        [lbUser addTarget:self action:@selector(onForget) forControlEvents:UIControlEventTouchUpInside];
        lbUser.titleEdgeInsets = UIEdgeInsetsMake(0, -27, 0, 0);
        [self.tableBody addSubview:lbUser];
        lbUser.hidden = self.isSMSLogin;
        _forgetBtn = lbUser;
        CGSize size =[Localized(@"JX_Register") boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:g_factory.font16} context:nil].size;
        UIButton *lb = [[UIButton alloc]initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-40-(140 - (140 - size.width) / 2), n, 140, 20)];
        lb.titleLabel.font = g_factory.font16;
        [lb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [lb setTitle:Localized(@"JX_Register") forState:UIControlStateNormal];
        lb.custom_acceptEventInterval = 1.0f;
        [lb addTarget:self action:@selector(onRegister) forControlEvents:UIControlEventTouchUpInside];
        lb.hidden = self.isSMSLogin;
        [self.tableBody addSubview:lb];
        if (!self.isSMSLogin) {
            n = n+36;
        }
        n+=20;
        _btn = [UIFactory createCommonButton:Localized(@"JX_LoginNow") target:self action:@selector(onClick)];
        _btn.custom_acceptEventInterval = 1.0f;
        [_btn.titleLabel setFont:g_factory.font16];
        _btn.layer.cornerRadius = 7.f;
        _btn.clipsToBounds = YES;
        _btn.frame = CGRectMake(40, n, TFJunYou__SCREEN_WIDTH-40*2, 40);
        _btn.userInteractionEnabled = NO;
        [self.tableBody addSubview:_btn];
        n = n+HEIGHT+INSETS;
        CGFloat wxWidth = 48;
        BOOL isSmall = TFJunYou__SCREEN_HEIGHT-TFJunYou__SCREEN_TOP - wxWidth - 30 <= CGRectGetMaxY(_btn.frame)+30;
        CGFloat loginY = isSmall ? CGRectGetMaxY(_btn.frame)+30 : TFJunYou__SCREEN_HEIGHT-TFJunYou__SCREEN_TOP - wxWidth - 60;
        UIImageView *wxLogin = [[UIImageView alloc] initWithFrame:CGRectMake((TFJunYou__SCREEN_WIDTH-wxWidth*3)/4, loginY, wxWidth, wxWidth)];
        wxLogin.image = [UIImage imageNamed:@"wechat_icon"];
        wxLogin.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didWechatToLogin:)];
        [wxLogin addGestureRecognizer:tap];
        wxLogin.hidden = (_isThirdLogin || self.isSMSLogin);
        if (isSmall) {
            self.tableBody.contentSize = CGSizeMake(0, CGRectGetMaxY(wxLogin.frame)+20);
        }
        UIImageView *qqLogin = [[UIImageView alloc] initWithFrame:CGRectMake((TFJunYou__SCREEN_WIDTH-wxWidth*3)/4*2+wxWidth, loginY, wxWidth, wxWidth)];
        qqLogin.image = [UIImage imageNamed:@"qq_login"];
        qqLogin.userInteractionEnabled = YES;
        qqLogin.hidden = (_isThirdLogin || self.isSMSLogin);
        UITapGestureRecognizer *qqTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didQQToLogin:)];
        [qqLogin addGestureRecognizer:qqTap];
        UIImageView *smsLogin = [[UIImageView alloc] initWithFrame:CGRectMake((TFJunYou__SCREEN_WIDTH-wxWidth*3)/4*3+wxWidth*2, loginY, wxWidth, wxWidth)];
        smsLogin.image = [UIImage imageNamed:@"sms_login"];
        smsLogin.userInteractionEnabled = YES;
        smsLogin.hidden = (_isThirdLogin || self.isSMSLogin);
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchLoginWay)];
        [smsLogin addGestureRecognizer:tap1];
        if ([g_default objectForKey:kMY_USER_NICKNAME])
            _user.userNickname = MY_USER_NAME;
        if ([g_default objectForKey:kMY_USER_ID])
            _user.userId = [g_default objectForKey:kMY_USER_ID];
        if ([g_default objectForKey:kMY_USER_COMPANY_ID])
            _user.companyId = [g_default objectForKey:kMY_USER_COMPANY_ID];
        if ([g_default objectForKey:kMY_USER_LoginName]) {
            [_phone setText:[g_default objectForKey:kMY_USER_LoginName]];
            _user.telephone = _phone.text;
        }
        if ([g_default objectForKey:kMY_USER_PASSWORD]) {
            _user.password = _pwd.text;
        }
        if ([g_default objectForKey:kLocationLogin]) {
            NSDictionary *dict = [g_default objectForKey:kLocationLogin];
            g_server.longitude = [[dict objectForKey:@"longitude"] doubleValue];
            g_server.latitude = [[dict objectForKey:@"latitude"] doubleValue];
        }
        [g_notify addObserver:self selector:@selector(onRegistered:) name:kRegisterNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(authRespNotification:) name:kWxSendAuthRespNotification object:nil];
        if(!self.isAutoLogin || IsStringNull(_myToken)) {
            _btn.userInteractionEnabled = YES;
            self.launchView.hidden = YES;
        }
        
        if(self.isAutoLogin && !IsStringNull(_myToken))
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self->_wait startWithClearColor];
            });
        if (!_isThirdLogin) {
           [g_server getSetting:self];
        }
    }
    return self;
}
 
- (void)sendSMS{
    if (!_send.selected) {
        NSString *areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
        _user = [TFJunYou_UserObject sharedInstance];
        _user.areaCode = areaCode;
        [g_server sendSMS:[NSString stringWithFormat:@"%@",_phone.text] areaCode:areaCode isRegister:NO imgCode:_imgCode.text toView:self];
        [_send setTitle:Localized(@"JX_Sending") forState:UIControlStateNormal];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _imgCode) {
        if (!_imgCodeImg.image) {
            [self refreshGraphicAction:nil];
        }
    }
}
- (void)switchLoginWay {
    if (self.isSMSLogin) {
        [self actionQuit];
    }else {
        TFJunYou_loginVC *vc = [TFJunYou_loginVC alloc];
        vc.isSMSLogin = YES;
        vc = [vc init];
        [g_navigation pushViewController:vc animated:YES];
    }
}
-(void)refreshGraphicAction:(UIButton *)button{
    NSString *areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    [g_server checkPhone:_phone.text areaCode:areaCode verifyType:1 toView:self];
}
-(void)getImgCodeImg{
    if([self isMobileNumber:_phone.text]){
        NSString *areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
        NSString * codeUrl = [g_server getImgCode:_phone.text areaCode:areaCode];
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
    }
}
- (BOOL)isMobileNumber:(NSString *)number{
    if ([g_config.isOpenSMSCode boolValue] && [g_config.regeditPhoneOrName intValue] != 1) {
        if ([_phone.text length] == 0) {
            [g_App showAlert:Localized(@"JX_InputPhone")];
            return NO;
        }
    }
    return YES;
}
#pragma mark - 微信登录
- (void)didWechatToLogin:(UITapGestureRecognizer *)tap {
    self.type = TFJunYou_LoginWX;
}
- (void)authRespNotification:(NSNotification *)notif {
}
#pragma mark - QQ登录
- (void)didQQToLogin:(UITapGestureRecognizer *)tap {
    self.type = TFJunYou_LoginQQ;
}
- (void)tencentDidLogin {
}
- (NSMutableArray *)getPermissions {
    NSMutableArray * g_permissions = [[NSMutableArray alloc] init];
    return g_permissions;
}
- (void)agrBtnAction:(UIButton *)btn {
    _checkProtocolBtn.selected = !_checkProtocolBtn.selected;
    [self didSelectedCheckBox:_checkProtocolBtn checked:_checkProtocolBtn.selected];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_phone == textField) {
        return [self validateNumber:string];
    }
    return YES;
}
- (BOOL)validateNumber:(NSString*)number {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet];
        NSString *filtered = [[number componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [number isEqualToString:filtered];
}
-(void)location:(TFJunYou_Location *)location getLocationWithIp:(NSDictionary *)dict {
    if (_isFirstLocation) {
        return;
    }
    NSString *area = [NSString stringWithFormat:@"%@,%@,%@",dict[@"country"],dict[@"region"],dict[@"city"]];
    [g_default setObject:area forKey:kLocationArea];
    [g_default synchronize];
    if(self.isAutoLogin && !IsStringNull(_myToken))
        [_wait start:Localized(@"JX_Logining")];
    if (!_isThirdLogin) {
        [g_server getSetting:self];
    }
}
- (void)location:(TFJunYou_Location *)location getLocationError:(NSError *)error {
    if (_isFirstLocation) {
        return;
    }
    [g_default setObject:nil forKey:kLocationArea];
    [g_default synchronize];
    if(self.isAutoLogin && !IsStringNull(_myToken))
        [_wait start:Localized(@"JX_Logining")];
    if (!_isThirdLogin) {
        [g_server getSetting:self];
    }
}
-(void)longLimit:(UITextField *)textField
{
}
-(void)dealloc{
    [g_notify  removeObserver:self name:kRegisterNotifaction object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.launchView.frame = self.view.bounds;
    [self.view bringSubviewToFront:self.launchView];
}
- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (void) textFieldDidChange:(UITextField *) TextField{
    if ([TextField.text isEqualToString:@""]) {
        _pwd.text = @"";
    }
}
-(void)onClick{
    if(_phone.text.length <=0){
        if ([g_config.regeditPhoneOrName intValue] == 1) {
            [g_App showAlert:Localized(@"JX_InputUserAccount")];
        }else {
            [g_App showAlert:Localized(@"JX_InputPhone")];
        }
        return;
    }
    if(_pwd.text.length <=0){
        [g_App showAlert:self.isSMSLogin ? Localized(@"JX_InputMessageCode") : Localized(@"JX_InputPassWord")];
        return;
    }
    [self.view endEditing:YES];
    if (self.isSMSLogin) {
        _user.verificationCode = _pwd.text;
    }else {
        _user.password  = [g_server getMD5String:_pwd.text];
    }
    
    _user.telephone = _phone.text;
    _user.areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    self.isAutoLogin = NO;
    self.launchView.hidden = YES;
    
    //等待指示器开始转
    [_wait start:Localized(@"JX_Logining")];
    
    [g_server getSetting:self];
}
- (void)actionConfig {
    _myToken = [g_default objectForKey:kMY_USER_TOKEN];
    if ([g_config.regeditPhoneOrName intValue] == 1) {
        _areaCodeBtn.hidden = YES;
        _forgetBtn.hidden = YES;
        _phone.placeholder = Localized(@"JX_InputUserAccount");
    }else {
        _areaCodeBtn.hidden = NO;
        _phone.placeholder = Localized(@"JX_InputPhone");
        _forgetBtn.hidden = self.isSMSLogin;
    }
    if ([g_config.isOpenPositionService intValue] == 0) {
        _isFirstLocation = YES;
        _location = [[TFJunYou_Location alloc] init];
        _location.delegate = self;
        g_server.location = _location;
        [g_server locate];
    }
    if((self.isAutoLogin && !IsStringNull(_myToken)) || _isThirdLogin) {
        if (_isThirdLogin) {
            [g_loginServer thirdLoginV1:_user password:_pwd.text type:self.type openId:g_server.openId isLogin:NO toView:self];
        }else {
            [self performSelector:@selector(autoLogin) withObject:nil afterDelay:.5];
        }
    } else if (IsStringNull(_myToken) && !IsStringNull(_phone.text) && !IsStringNull(_pwd.text)) {
        g_server.isManualLogin = YES;
        NSString *areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
        if (self.isSMSLogin) {
            [g_loginServer smsLoginWithUser:_user areaCode:areaCode account:_phone.text toView:self];
        }else {
            g_server.temporaryPWD = _pwd.text;
            [g_loginServer loginWithUser:_user password:_pwd.text areaCode:areaCode account:_phone.text toView:self];
        }
    } else {
        [_wait stop];
        self.launchView.hidden = YES;
    }
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    if ([aDownload.action isEqualToString:act_customerLinkList]) {
        g_App.customerLinkListArray = array1;
    }
    if( [aDownload.action isEqualToString:act_Config]){
        [g_config didReceive:dict];
        [self actionConfig];
    }
    if([aDownload.action isEqualToString:act_CheckPhone]){
        [self getImgCodeImg];
    }
    if([aDownload.action isEqualToString:act_SendSMS]){
        [TFJunYou_MyTools showTipView:Localized(@"JXAlert_SendOK")];
        _send.selected = YES;
        _send.userInteractionEnabled = NO;
        _send.backgroundColor = [UIColor grayColor];
        _smsCode = [[dict objectForKey:@"code"] copy];
        [_send setTitle:@"60s" forState:UIControlStateSelected];
        _seconds = 60;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTime:) userInfo:_send repeats:YES];
    }
    if( [aDownload.action isEqualToString:act_UserLogin] || [aDownload.action isEqualToString:act_thirdLogin] || [aDownload.action isEqualToString:act_thirdLoginV1] || [aDownload.action isEqualToString:act_sdkLogin] || [aDownload.action isEqualToString:act_sdkLoginV1] || [aDownload.action isEqualToString:act_UserLoginV1] || [aDownload.action isEqualToString:act_UserSMSLogin]){
        if ([dict.allKeys containsObject:@"authKey"]) {
            [_wait stop];
            [self createWaitAuthView];
            [self startAuthDevice:[dict objectForKey:@"authKey"]];
            return;
        }
        if ([aDownload.action isEqualToString:act_thirdLogin] || [aDownload.action isEqualToString:act_thirdLoginV1] || [aDownload.action isEqualToString:act_sdkLogin] || [aDownload.action isEqualToString:act_sdkLoginV1] ) {
            g_server.openId = nil;
            [g_default setBool:YES forKey:kTHIRD_LOGIN_AUTO];
        }else {
            [g_default setBool:NO forKey:kTHIRD_LOGIN_AUTO];
        }
        [g_server doLoginOK:dict user:_user];
        if(self.isSwitchUser){
            [g_notify postNotificationName:kXmppClickLoginNotifaction object:nil];
            [g_notify postNotificationName:kUpdateUserNotifaction object:nil];
        }
        else
            [g_App showMainUI];
        [self actionQuit];
        [_wait stop];
       
     
    }
    if([aDownload.action isEqualToString:act_userLoginAuto] || [aDownload.action isEqualToString:act_userLoginAutoV1]){
        [g_server getAppResource:@"2" ToView:self];
        [g_server doLoginOK:dict user:_user];
        [g_App showMainUI];
        [self actionQuit];
     
     
        [_wait stop];
    }
    if ([aDownload.action isEqualToString:act_GetWxOpenId]) {
        g_server.openId = [dict objectForKey:@"openid"];
        [g_loginServer wxSdkLoginV1:_user type:2 openId:g_server.openId toView:self];
    }
    if ([aDownload.action isEqualToString:act_getAppResource]) {
        NSMutableArray *tempArray0 = [NSMutableArray array];
        NSMutableArray *tempArray2 = [NSMutableArray array];
        for (NSDictionary *resourceDict in array1) {
            NSString *code = resourceDict[@"code"];
            if ([code isEqualToString:@"0"]) {
                [tempArray0 addObject:resourceDict];
            }else if ([code isEqualToString:@"2"]) {
                [tempArray2 addObject:resourceDict];
            }
        }
        if (tempArray0.count>0) {
            g_App.linkArray = tempArray0;
            g_App.imgUrl = tempArray0[0][@"imgUrl"];
        }
        if (tempArray2.count>0) {
            NSDictionary *adDict = tempArray2.firstObject;
            [g_App setupLunchADUrl:adDict[@"imgUrl"] link:adDict[@"link"]];
        }
    }
    _btn.userInteractionEnabled = YES;
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    _btn.userInteractionEnabled = YES;
    
    if ([aDownload.action isEqualToString:act_UserDeviceIsAuth]) {
        if ([[dict objectForKey:@"resultCode"] intValue] == 101987) {
            [self changeAccount];
            [g_server getSetting:self];
        }
        return hide_error;
    }
    if ([aDownload.action isEqualToString:act_Config]) {
        NSString *url = [g_default stringForKey:kLastApiUrl];
        g_config.apiUrl = url;
        [self actionConfig];
        return hide_error;
    }
    [_wait stop];
    if (([aDownload.action isEqualToString:act_sdkLogin] || [aDownload.action isEqualToString:act_sdkLoginV1]) && [[dict objectForKey:@"resultCode"] intValue] == 1040305) {
        TFJunYou_inputPhoneVC *vc = [[TFJunYou_inputPhoneVC alloc] init];
        vc.isThirdLogin = YES;
        vc.type = self.type;
        [g_navigation pushViewController:vc animated:YES];
        return show_error;
    }
    if (([aDownload.action isEqualToString:act_thirdLogin] || [aDownload.action isEqualToString:act_thirdLoginV1]) && [[dict objectForKey:@"resultCode"] intValue] == 1040306) {
        TFJunYou_inputPhoneVC *vc = [[TFJunYou_inputPhoneVC alloc] init];
        vc.isThirdLogin = YES;
        vc.type = self.type;
        [g_navigation pushViewController:vc animated:YES];
        return show_error;
    }
    if([aDownload.action isEqualToString:act_userLoginAuto] || [aDownload.action isEqualToString:act_userLoginAutoV1]){
        [g_default removeObjectForKey:kMY_USER_TOKEN];
        [share_defaults removeObjectForKey:kMY_ShareExtensionToken];
        
        [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
            self.launchView.alpha = 0;
        } completion:^(BOOL finished) {
            self.launchView.hidden = YES;
            self.launchView.alpha = 1;
        }];
    }
    if ([aDownload.action isEqualToString:act_thirdLogin] || [aDownload.action isEqualToString:act_thirdLoginV1]) {
    }
    if ([aDownload.action isEqualToString:act_SendSMS]) {
        [_send setTitle:Localized(@"JX_Send") forState:UIControlStateNormal];
    }
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    _btn.userInteractionEnabled = YES;
    
    if ([aDownload.action isEqualToString:act_Config]) {
        NSString *url = [g_default stringForKey:kLastApiUrl];
        g_config.apiUrl = url;
        [self actionConfig];
        return hide_error;
    }
    if([aDownload.action isEqualToString:act_userLoginAuto] || [aDownload.action isEqualToString:act_userLoginAutoV1]){
        [g_default removeObjectForKey:kMY_USER_TOKEN];
        [share_defaults removeObjectForKey:kMY_ShareExtensionToken];
        
        [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
            self.launchView.alpha = 0;
        } completion:^(BOOL finished) {
            self.launchView.hidden = YES;
            self.launchView.alpha = 1;
        }];
    }
    if ([aDownload.action isEqualToString:act_thirdLogin] || [aDownload.action isEqualToString:act_thirdLoginV1]) {
    }
    if ([aDownload.action isEqualToString:act_SendSMS]) {
        [_send setTitle:Localized(@"JX_Send") forState:UIControlStateNormal];
    }
    [_wait stop];
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    if([aDownload.action isEqualToString:act_thirdLogin] || [aDownload.action isEqualToString:act_thirdLoginV1] || [aDownload.action isEqualToString:act_sdkLogin]|| [aDownload.action isEqualToString:act_sdkLoginV1]){
        [_wait start];
    }
}
//注册
-(void)onRegister{
    TFJunYou_inputPhoneVC* vc = [[TFJunYou_inputPhoneVC alloc]init];
    [g_navigation pushViewController:vc animated:YES];
}
-(void)onForget{
    TFJunYou_forgetPwdVC* vc = [[TFJunYou_forgetPwdVC alloc] init];
    vc.isModify = NO;
    [g_navigation pushViewController:vc animated:YES];
}
-(void)autoLogin{
    NSString * token = [[NSUserDefaults standardUserDefaults] stringForKey:kMY_USER_TOKEN];
    _btn.userInteractionEnabled = token.length > 0;
    if (token.length > 0) {
        [g_loginServer autoLoginWithToView:self];
    }else {
        self.launchView.hidden = YES;
    }
}
-(void)onRegistered:(NSNotification *)notifacation{
    [self actionQuit];
    if(!self.isSwitchUser)
        [g_App showMainUI];
}
-(void)actionQuit{
    [super actionQuit];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _phone) {
        [_pwd becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    return YES;
}
- (void)areaCodeBtnClick:(UIButton *)but{
    [self.view endEditing:YES];
    TFJunYou_TelAreaListVC *telAreaListVC = [[TFJunYou_TelAreaListVC alloc] init];
    telAreaListVC.telAreaDelegate = self;
    telAreaListVC.didSelect = @selector(didSelectTelArea:);
    [g_navigation pushViewController:telAreaListVC animated:YES];
}
- (void)didSelectTelArea:(NSString *)areaCode{
    [_areaCodeBtn setTitle:[NSString stringWithFormat:@"+%@",areaCode] forState:UIControlStateNormal];
    [self resetBtnEdgeInsets:_areaCodeBtn];
}
- (void)resetBtnEdgeInsets:(UIButton *)btn{
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.frame.size.width-2, 0, btn.imageView.frame.size.width+2)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.frame.size.width+2, 0, -btn.titleLabel.frame.size.width-2)];
}
- (void)passWordRightViewClicked:(UIButton *)but{
    [_pwd resignFirstResponder];
    but.selected = !but.selected;
    _pwd.secureTextEntry = !but.selected;
}
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    [g_default setObject:[NSNumber numberWithBool:checked] forKey:@"agreement"];
    [g_default synchronize];
}
-(void)catUserProtocol{
    webpageVC * webVC = [webpageVC alloc];
    webVC.url = [self protocolUrl];
    webVC.isSend = NO;
    webVC = [webVC init];
    [g_navigation.navigationView addSubview:webVC.view];
}
-(NSString *)protocolUrl{
    NSString * protocolStr = g_config.privacyPolicyPrefix;
    NSString * lange = g_constant.sysLanguage;
    if (![lange isEqualToString:ZHHANTNAME] && ![lange isEqualToString:NAME]) {
        lange = ENNAME;
    }
    return [NSString stringWithFormat:@"%@%@.html",protocolStr,lange];
}
- (NSString *)getLaunchImageName {
    NSString *viewOrientation = @"Portrait";
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewOrientation = @"Landscape";
    }
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    NSArray* imagesDict2 = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"LaunchImage"];
    
 
    
    CGSize viewSize = tyCurrentWindow.bounds.size;
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
}
#pragma mark TFJunYou_LocationDelegate
- (void)location:(TFJunYou_Location *)location CountryCode:(NSString *)countryCode CityName:(NSString *)cityName CityId:(NSString *)cityId Address:(NSString *)address Latitude:(double)lat Longitude:(double)lon{
    g_server.countryCode = countryCode;
    g_server.cityName = cityName;
    g_server.cityId = [cityId intValue];
    g_server.address = address;
    g_server.latitude = lat;
    g_server.longitude = lon;
    NSDictionary *dict = @{@"latitude":@(lat),@"longitude":@(lon)};
    [g_default setObject:dict forKey:kLocationLogin];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)createWaitAuthView{
    self.waitAuthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH,TFJunYou__SCREEN_HEIGHT)];
    self.waitAuthView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAccount)];
    [self.waitAuthView addGestureRecognizer:ges];
    [self.view addSubview:self.waitAuthView];
    UIView *authView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH - 80, TFJunYou__SCREEN_HEIGHT / 3)];
    authView.backgroundColor = [UIColor whiteColor];
    authView.layer.cornerRadius = 10;
    authView.layer.masksToBounds = YES;
    CGPoint center = authView.center;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 95, 95)];
    imgV.image = [UIImage imageNamed:@"ALOGO_120"];
    [authView addSubview:imgV];
    imgV.center = CGPointMake(center.x, 20 + 95/2);
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH - 200, 50)];
    lab.text = Localized(@"JX_WaitingForAuthorization");
    lab.font = [UIFont systemFontOfSize:17];
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [authView addSubview:lab];
    lab.center = CGPointMake(center.x, CGRectGetMaxY(imgV.frame) + 30);
    UIButton *btn = [UIFactory createCommonButton:Localized(@"JX_SwitchAccount") target:self action:@selector(changeAccount)];
    btn.custom_acceptEventInterval = 1.0f;
    [btn.titleLabel setFont:g_factory.font17];
    btn.layer.cornerRadius = 20;
    btn.clipsToBounds = YES;
    btn.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH-100*2, 40);
    [authView addSubview:btn];
    btn.center = CGPointMake(center.x, CGRectGetMaxY(authView.frame) - 40);
    btn.userInteractionEnabled = NO;
    [self.waitAuthView addSubview:authView];
    authView.center = self.waitAuthView.center;
}
- (void)changeAccount{
    [self.waitAuthView removeFromSuperview];
    dispatch_cancel(_authTimer);
    _authTimer = nil;
}
- (void)startAuthDevice:(NSString *)str{
    if (_authTimer) {
        dispatch_cancel(_authTimer);
        _authTimer = nil;
    }
    dispatch_queue_t queue = dispatch_get_main_queue();
    _authTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = DISPATCH_TIME_NOW;
    dispatch_time_t interval = 1.0 * NSEC_PER_SEC;
    dispatch_source_set_timer(_authTimer, start, interval, 0);
    dispatch_source_set_event_handler(_authTimer, ^{
        _count ++;
        [g_server loginIsAuthKey:str toView:self];
        if (_count == 300 ) {
            _count = 0;
            [self changeAccount];
        }
    });
    dispatch_resume(_authTimer);
}




- (void)CloseView{
    [_backView removeFromSuperview];
}
-(void)iniframe{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.userInteractionEnabled=YES;
    backView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    self.backView=backView;
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CloseView)]];
    
    
    UIView *leftIM=[[UIView alloc]init];
    leftIM.backgroundColor=[UIColor whiteColor];
    leftIM.userInteractionEnabled=YES;
    [backView addSubview:leftIM];
    leftIM.frame=CGRectMake(20, SCREEN_WIDTH/2, SCREEN_WIDTH-40, SCREEN_WIDTH-40);
    leftIM.layer.cornerRadius=15;
    leftIM.layer.masksToBounds=YES;
    [backView addSubview:leftIM];
    
    UILabel *titleLable=[[UILabel alloc]init];
    titleLable.text=@"隐私政策";
    titleLable.font=[UIFont boldSystemFontOfSize:20];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.frame=CGRectMake(10, 30, SCREEN_WIDTH-60, 20);
    [leftIM addSubview:titleLable];
    
    UILabel *subtitle=[[UILabel alloc]init];
    subtitle.text=@"        欢迎使用eBay免费聊天，为了更好地保护您的隐私和个人信息安全，根据国家相关法律规定拟定了";
    subtitle.numberOfLines=3;
    subtitle.frame=CGRectMake(10, 64, SCREEN_WIDTH-60,66);
    [leftIM addSubview:subtitle];
     
    
    UIButton *leftBtn=[[UIButton alloc]init];
    [leftBtn setTitle:@"《隐私政策》" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    leftBtn.layer.cornerRadius=5;
    leftBtn.layer.masksToBounds=YES;
    [leftIM addSubview:leftBtn];
    leftBtn.frame=CGRectMake(10, subtitle.bottom+5, 111, 15);
    [leftBtn addTarget:self action:@selector(leftIMClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *heLabel=[[UILabel alloc]init];
    heLabel.text=@"和";
    heLabel.textAlignment=NSTextAlignmentCenter;
    heLabel.frame=CGRectMake(leftBtn.right+5, subtitle.bottom+5, 30,15);
    [leftIM addSubview:heLabel];
    
    UIButton *rightBtn=[[UIButton alloc]init];
    [rightBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    rightBtn.layer.cornerRadius=5;
    rightBtn.layer.masksToBounds=YES;
    [leftIM addSubview:rightBtn];
    rightBtn.frame=CGRectMake(heLabel.right+5,subtitle.bottom+5, 111, 15);
    [rightBtn addTarget:self action:@selector(rightBtnL) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *contentLabel=[[UILabel alloc]init];
    contentLabel.text=@"请在使用前仔细阅读并同意";
    contentLabel.frame=CGRectMake(10, leftBtn.bottom+10,SCREEN_WIDTH-60 ,15);
    [leftIM addSubview:contentLabel];
    
    
       UIButton *cancelBtn=[[UIButton alloc]init];
       [cancelBtn setTitle:@"同意协议" forState:UIControlStateNormal];
       [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       cancelBtn.backgroundColor=[UIColor redColor];
       cancelBtn.layer.cornerRadius=20;
       cancelBtn.layer.masksToBounds=YES;
       [leftIM addSubview:cancelBtn];
       cancelBtn.frame=CGRectMake(20, contentLabel.bottom+44, leftIM.width-40, 40);
       [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
       
       UIButton *sureBtn=[[UIButton alloc]init];
       [sureBtn setTitle:@"不同意" forState:UIControlStateNormal];
       [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       sureBtn.backgroundColor=[UIColor lightGrayColor];
       sureBtn.layer.cornerRadius=20;
       sureBtn.layer.masksToBounds=YES;
       [leftIM addSubview:sureBtn];
       sureBtn.frame=CGRectMake(20, cancelBtn.bottom+5, leftIM.width-40, 40);;
       [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *tongyStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"tongyi"];
    if (tongyStr.length>0) {

    }else{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
           // [self iniframe];
        });
    }
    
    _phone.keyboardType = UIKeyboardTypeASCIICapable;
    self.launchView.hidden = !self.isAutoLogin;
}

//用户协议
 - (void)rightBtnL{

     [self.backView removeFromSuperview];
     WKWebViewViewController *vc=[WKWebViewViewController new];
     vc.titleStr=@"";
     [g_navigation pushViewController:vc animated:YES];
 }
//隐私协议
 - (void)leftIMClick{

     [self.backView removeFromSuperview];
     WKWebViewViewController *vc=[WKWebViewViewController new];
     vc.titleStr=@"10000";
     [g_navigation pushViewController:vc animated:YES];
 }
//b
- (void)sureBtnClick{
    
    exit(0);
}
- (void)cancelBtnClick{
    [[NSUserDefaults standardUserDefaults] setObject:@"tongyi" forKey:@"tongyi"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.backView removeFromSuperview];
}

@end
