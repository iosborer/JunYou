#import "TFJunYou_inputPhoneVC.h"
#import "TFJunYou_inputPwdVC.h"
#import "TFJunYou_TelAreaListVC.h"
#import "TFJunYou_UserObject.h"
#import "TFJunYou_PSRegisterBaseVC.h"
#import "webpageVC.h"
#import "TFJunYou_loginVC.h"
#import "WKWebViewViewController.h"
#import "UIView+LK.h"
#define HEIGHT 56
@interface TFJunYou_inputPhoneVC ()<UITextFieldDelegate>
{
    NSTimer *_timer;
    UIButton *_areaCodeBtn;
    TFJunYou_UserObject *_user;
    UIImageView * _imgCodeImg;
    UITextField *_imgCode;
    UIButton * _graphicButton;
    UIButton* _skipBtn;
    BOOL _isSkipSMS;
    BOOL _isSendFirst;
    UIImageView * _agreeImgV;
}
@property (nonatomic, assign) BOOL isSmsRegister;
@property (nonatomic, assign) BOOL isCheckToSMS;
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) UIView *knowBackView;

@property(nonatomic,strong) UIButton *protocalBtn; // 去登录

@property(nonatomic,strong) UILabel *readLabel; // 去登录
@property(nonatomic,strong) UILabel *yiJiLabel; // 去登录

@property(nonatomic,strong) UIButton *selectProtocalBtn; //yonghuxieyi

@property(nonatomic,strong) UIButton *ProctProtocalBtn; // yingsi zhengce

@property (nonatomic, weak) UIButton *toLoginBtn;
@end
@implementation TFJunYou_inputPhoneVC

- (id)init
{
    self = [super init];
    if (self) {
        _seconds = 0;
        self.isGotoBack   = YES;
        self.title = Localized(@"JX_Register");
        self.heightFooter = 0;
        self.heightHeader = TFJunYou__SCREEN_TOP;
        //self.view.frame = g_window.bounds;
        [self createHeadAndFoot];
        self.tableBody.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardToView)];
        [self.tableBody addGestureRecognizer:tap];
        _isSendFirst = YES;  // 第一次发送短信
        int n = INSETS;
        int distance = 40; // 左右间距
        self.isSmsRegister = NO;
        //icon
        n += 40;

        UIImageView * kuliaoIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ALOGO_120"]];
        kuliaoIconView.frame = CGRectMake((TFJunYou__SCREEN_WIDTH-100)/2, n, 100, 100);
        [self.tableBody addSubview:kuliaoIconView];
        
        //手机号
        n += 30+95;
        if (!_phone) {
            NSString *placeHolder;
            if ([g_config.regeditPhoneOrName intValue] == 0) {
                placeHolder = Localized(@"JX_InputPhone");
            }else {
                placeHolder = Localized(@"JX_InputUserAccount");
            }
            _phone = [UIFactory createTextFieldWith:CGRectMake(distance, n, self_width-distance*2, HEIGHT) delegate:self returnKeyType:UIReturnKeyNext secureTextEntry:NO placeholder:placeHolder font:g_factory.font16];
            _phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
            _phone.borderStyle = UITextBorderStyleNone;
            if ([g_config.regeditPhoneOrName intValue] == 1) {
                _phone.keyboardType = UIKeyboardTypeDefault;  // 仅支持大小写字母数字
            }else {
                _phone.keyboardType = UIKeyboardTypeASCIICapable;  // 限制只能数字输入，使用数字键盘
            }
            _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
            [_phone addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
            [self.tableBody addSubview:_phone];
            
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
            NSString *areaStr;
            if (![g_default objectForKey:kMY_USER_AREACODE]) {
                areaStr = @"+86";
            } else {
                areaStr = [NSString stringWithFormat:@"+%@",[g_default objectForKey:kMY_USER_AREACODE]];
            }
            _areaCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, HEIGHT/2-8, HEIGHT-5, 22)];
            [_areaCodeBtn setTitle:areaStr forState:UIControlStateNormal];
            _areaCodeBtn.titleLabel.font = SYSFONT(15);
            _areaCodeBtn.hidden = [g_config.regeditPhoneOrName intValue] == 1;
            [_areaCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_areaCodeBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
            [_areaCodeBtn addTarget:self action:@selector(areaCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self resetBtnEdgeInsets:_areaCodeBtn];
            [riPhView addSubview:_areaCodeBtn];
        }
        n = n+HEIGHT;
        //密码
        _pwd = [[UITextField alloc] initWithFrame:CGRectMake(distance, n, TFJunYou__SCREEN_WIDTH-distance*2, HEIGHT)];
        _pwd.delegate = self;
        _pwd.font = g_factory.font16;
        _pwd.autocorrectionType = UITextAutocorrectionTypeNo;
        _pwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _pwd.enablesReturnKeyAutomatically = YES;
        _pwd.returnKeyType = UIReturnKeyDone;
        _pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"JX_InputPassWord") attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        _pwd.secureTextEntry = YES;
        _pwd.userInteractionEnabled = YES;

        [_pwd addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
       [self.tableBody addSubview:_pwd];

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
        
        n = n+HEIGHT;
        
        if ([g_config.registerInviteCode intValue] != 0) {
            //邀请码
            _inviteCode = [[UITextField alloc] initWithFrame:CGRectMake(distance, n, TFJunYou__SCREEN_WIDTH-distance*2, HEIGHT)];
            _inviteCode.delegate = self;
            _inviteCode.font = g_factory.font16;
            _inviteCode.autocorrectionType = UITextAutocorrectionTypeNo;
            _inviteCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
            _inviteCode.enablesReturnKeyAutomatically = YES;
            _inviteCode.returnKeyType = UIReturnKeyDone;
            _inviteCode.clearButtonMode = UITextFieldViewModeWhileEditing;
            _inviteCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"JX_EnterInvitationCode") attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
            _inviteCode.secureTextEntry = YES;
            _inviteCode.userInteractionEnabled = YES;
            [self.tableBody addSubview:_inviteCode];
            
            UIView *inviteRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, HEIGHT)];
            _inviteCode.leftView = inviteRightView;
            _inviteCode.leftViewMode = UITextFieldViewModeAlways;
            UIImageView *inviteRiIgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, HEIGHT/2-11, 22, 22)];
            inviteRiIgView.image = [UIImage imageNamed:@"password"];
            inviteRiIgView.contentMode = UIViewContentModeScaleAspectFit;
            [inviteRightView addSubview:inviteRiIgView];
            
            verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(inviteRightView.frame)-4, _inviteCode.frame.size.width, 0.5)];
            verticalLine.backgroundColor = HEXCOLOR(0xD6D6D6);
            [inviteRightView addSubview:verticalLine];
            
            n = n+HEIGHT;
        }
        
        //图片验证码
        _imgCode = [UIFactory createTextFieldWith:CGRectMake(distance, n, self_width-distance*2-70-INSETS-35-4, HEIGHT) delegate:self returnKeyType:UIReturnKeyNext secureTextEntry:NO placeholder:Localized(@"JX_inputImgCode") font:g_factory.font16];
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
        if ([g_config.isOpenSMSCode boolValue] && [g_config.regeditPhoneOrName intValue] != 1) {
            n = n+HEIGHT;
        }else {
            n = n+INSETS;
        }
#ifdef IS_TEST_VERSION
#else
#endif
        
        _code = [[UITextField alloc] initWithFrame:CGRectMake(distance, n, TFJunYou__SCREEN_WIDTH-75-distance*2, HEIGHT)];
        _code.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"JX_InputMessageCode") attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        _code.font = g_factory.font16;
        _code.delegate = self;
        _code.autocorrectionType = UITextAutocorrectionTypeNo;
        _code.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _code.enablesReturnKeyAutomatically = YES;
        _code.borderStyle = UITextBorderStyleNone;
        _code.returnKeyType = UIReturnKeyDone;
        _code.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, HEIGHT)];
        _code.leftView = codeView;
        _code.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *codeIView = [[UIImageView alloc] initWithFrame:CGRectMake(2, HEIGHT/2-11, 22, 22)];
        codeIView.image = [UIImage imageNamed:@"code"];
        codeIView.contentMode = UIViewContentModeScaleAspectFit;
        [codeView addSubview:codeIView];
        
        UIView *codeILine = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-LINE_WH, _phone.frame.size.width, LINE_WH)];
        codeILine.backgroundColor = THE_LINE_COLOR;
        [_code addSubview:codeILine];

        
        [self.tableBody addSubview:_code];
        
        _send = [UIFactory createButtonWithTitle:Localized(@"JX_Send")
                                       titleFont:g_factory.font16
                                      titleColor:[UIColor whiteColor]
                                          normal:nil
                                       highlight:nil ];
        _send.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-70-distance-11, n+HEIGHT/2-15, 70, 30);
        [_send addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
        _send.backgroundColor = g_theme.themeColor;
        _send.layer.masksToBounds = YES;
        _send.layer.cornerRadius = 7.f;
        [self.tableBody addSubview:_send];
        
        //测试版隐藏了短信验证
        if ([g_config.isOpenSMSCode boolValue] && [g_config.regeditPhoneOrName intValue] != 1) {
            n = n+HEIGHT+INSETS+INSETS;
        }else {
            _send.hidden = YES;
            _code.hidden = YES;
            _imgCode.hidden = YES;
            _imgCodeImg.hidden = YES;
            _graphicButton.hidden = YES;
        }
#ifdef IS_TEST_VERSION
#else
#endif
        
        // 返回登录
        CGSize size = [Localized(@"JX_HaveAccountLogin") boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:g_factory.font16} context:nil].size;
        UIButton *goLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(distance, n, size.width+4, size.height)];
        [goLoginBtn setTitle:Localized(@"JX_HaveAccountLogin") forState:UIControlStateNormal];
        goLoginBtn.titleLabel.font = g_factory.font16;
        [goLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [goLoginBtn addTarget:self action:@selector(goToLoginVC) forControlEvents:UIControlEventTouchUpInside];
        [self.tableBody addSubview:goLoginBtn];
#ifdef IS_Skip_SMS
            // 跳过当前界面进入下个界面
            CGSize skipSize = [Localized(@"JX_NotGetSMSCode") boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:g_factory.font16} context:nil].size;
            _skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-distance-skipSize.width, n, skipSize.width+4, skipSize.height)];
            [_skipBtn setTitle:Localized(@"JX_NotGetSMSCode") forState:UIControlStateNormal];
            _skipBtn.titleLabel.font = g_factory.font16;
            _skipBtn.hidden = YES;
            [_skipBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_skipBtn addTarget:self action:@selector(enterNextPage) forControlEvents:UIControlEventTouchUpInside];
            [self.tableBody addSubview:_skipBtn];
#else
        
#endif
        //弃用手机验证
        //#ifdef IS_TEST_VERSION
        //        UIButton* _btn = [UIFactory createCommonButton:@"下一步" target:self action:@selector(onTest)];
        //#else
        //        UIButton* _btn = [UIFactory createCommonButton:@"下一步" target:self action:@selector(onClick)];
        //#endif
        //新添加的手机验证（注册）
        n = n+HEIGHT+INSETS;
       
        UIButton * _btn = [UIFactory createCommonButton:Localized(@"REGISTERS") target:self action:@selector(checkPhoneNumber)];
        [_btn.titleLabel setFont:g_factory.font16];
        _btn.frame = CGRectMake(40, n,TFJunYou__SCREEN_WIDTH-40*2, 40);
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 7.f;
        [self.tableBody addSubview:_btn];
        n = n+HEIGHT+INSETS;
        
        UILabel *agreeLab = [[UILabel alloc] init];
        agreeLab.font = SYSFONT(13);
        agreeLab.text = @"我已阅读并同意";//Localized(@"JX_ByRegisteringYouAgree");
        agreeLab.textColor = [UIColor blackColor];
        agreeLab.userInteractionEnabled = YES;
        [self.tableBody addSubview:agreeLab];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAgree)];
        [agreeLab addGestureRecognizer:tap1];
        
        UILabel*termsLab = [[UILabel alloc] init];
        termsLab.text =@"《用户协议》";// Localized(@"《Privacy Policy and Terms of Service》");
        termsLab.font = SYSFONT(13);
        termsLab.textColor = [UIColor redColor];
        termsLab.userInteractionEnabled = YES;
        [self.tableBody addSubview:termsLab];
        UITapGestureRecognizer *tapT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkTerms)];
        [termsLab addGestureRecognizer:tapT];
        CGSize sizeA = [agreeLab.text sizeWithAttributes:@{NSFontAttributeName:agreeLab.font}];
        CGSize sizeT = [termsLab.text sizeWithAttributes:@{NSFontAttributeName:termsLab.font}];
        
        UILabel*toLabel = [[UILabel alloc] init];
        toLabel.text =@"以及";// Localized(@"《Privacy Policy and Terms of Service》");
        toLabel.font = SYSFONT(13);
        toLabel.textColor = [UIColor blackColor];
        toLabel.userInteractionEnabled = YES;
        [self.tableBody addSubview:toLabel];
        
        
        UIImageView *agreeNotImgV = [[UIImageView alloc] initWithFrame:CGRectMake(32, n-6, 25, 25)];
        agreeNotImgV.image = [UIImage imageNamed:@"registered_not_agree"];
        agreeNotImgV.userInteractionEnabled = YES;
        [self.tableBody addSubview:agreeNotImgV];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAgree)];
        [agreeNotImgV addGestureRecognizer:tap2];
        agreeLab.frame = CGRectMake(CGRectGetMaxX(agreeNotImgV.frame), n, sizeA.width, sizeA.height);
        termsLab.frame = CGRectMake(CGRectGetMaxX(agreeLab.frame), n, sizeT.width, sizeT.height);
        
        toLabel.frame = CGRectMake(CGRectGetMaxX(termsLab.frame), n, 30, sizeT.height);
        
        UILabel*yinSLabel = [[UILabel alloc] init];
        yinSLabel.text =@"《隐私政策》";// Localized(@"《Privacy Policy and Terms of Service》");
        yinSLabel.font = SYSFONT(13);
        yinSLabel.textColor = [UIColor redColor];
        yinSLabel.userInteractionEnabled = YES;
        [self.tableBody addSubview:yinSLabel];
        yinSLabel.frame = CGRectMake(CGRectGetMaxX(toLabel.frame), n, sizeA.width, sizeT.height);
        
        UITapGestureRecognizer *rightBtnLView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftIMClick)];
        [yinSLabel addGestureRecognizer:rightBtnLView];
        
        _agreeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(agreeNotImgV.frame), n-10, 25, 30)];
        _agreeImgV.image = [UIImage imageNamed:@"registered_agree"];
        _agreeImgV.userInteractionEnabled = YES;
        [self.tableBody addSubview:_agreeImgV];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAgree)];
        [_agreeImgV addGestureRecognizer:tap3];
        
        //添加提示
//        UIImageView * careImage = [[UIImageView alloc]initWithFrame:CGRectMake(INSETS, n+HEIGHT+INSETS+3, INSETS, INSETS)];
//        careImage.image = [UIImage imageNamed:@"noread"];
//
//        UILabel * careTitle = [[UILabel alloc]initWithFrame:CGRectMake(INSETS*2+2, n+HEIGHT+INSETS, 100, HEIGHT/3)];
//        careTitle.font = [UIFont fontWithName:@"Verdana" size:13];
//        careTitle.text = Localized(@"inputPhoneVC_BeCareful");
//
//        n = n+HEIGHT+INSETS;
//        UILabel * careFirst = [[UILabel alloc]initWithFrame:CGRectMake(INSETS*2+2, n+HEIGHT/3+INSETS, JX_SCREEN_WIDTH-12-INSETS*2, HEIGHT/3)];
//        careFirst.font = [UIFont fontWithName:@"Verdana" size:11];
//        careFirst.text = Localized(@"inputPhoneVC_NotNeedCode");
//
//        n = n+HEIGHT/3+INSETS;
//        UILabel * careSecond = [[UILabel alloc]initWithFrame:CGRectMake(INSETS*2+2, n+HEIGHT/3+INSETS, JX_SCREEN_WIDTH-INSETS*2-12, HEIGHT/3+15)];
//        careSecond.font = [UIFont fontWithName:@"Verdana" size:11];
//        careSecond.text = Localized(@"inputPhoneVC_NoReg");
//        careSecond.numberOfLines = 0;
        
        //测试版隐藏了短信验证
#ifdef IS_TEST_VERSION
#else
//        careFirst.hidden = YES;
//        careSecond.hidden = YES;
//        careImage.hidden = YES;
//        careTitle.hidden = YES;
#endif
//        [self.tableBody addSubview:careImage];
//        [self.tableBody addSubview:careTitle];
//        [self.tableBody addSubview:careFirst];
//        [self.tableBody addSubview:careSecond];
        
    }
    return self;
}

- (void)didAgree {
    _agreeImgV.hidden = !_agreeImgV.hidden;
}
- (void)rightBtnL {
    self.knowBackView.hidden=YES;

    WKWebViewViewController *vc=[WKWebViewViewController new];
    vc.titleStr=@"10000";
    [g_navigation pushViewController:vc animated:YES];
}

- (void)leftIMClick{

    self.knowBackView.hidden=YES;
    WKWebViewViewController *vc=[WKWebViewViewController new];
    vc.titleStr=@"";
    [g_navigation pushViewController:vc animated:YES];
    
    
}
- (void)checkTerms {
    
   self.knowBackView.hidden=YES;

   WKWebViewViewController *vc=[WKWebViewViewController new];
   vc.titleStr=@"10000";
   [g_navigation pushViewController:vc animated:YES];

    return;;
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_phone == textField) {
        return [self validateNumber:string];
    }
    return YES;
}
- (BOOL)validateNumber:(NSString*)number {
    if ([g_config.regeditPhoneOrName intValue] == 1) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet];
        NSString *filtered = [[number componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [number isEqualToString:filtered];
    }
    BOOL res = YES;
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString *string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i ++;
    }
    return res;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)enterNextPage {
    _isSkipSMS = YES;
    BOOL isMobile = [self isMobileNumber:_phone.text];
    if ([_pwd.text length] < 6) {
        [g_App showAlert:Localized(@"JX_TurePasswordAlert")];
        return;
    }
    if (isMobile) {
        NSString *areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
        [g_server checkPhone:_phone.text areaCode:areaCode verifyType:0 toView:self];
    }
}
- (void)textFieldDidChanged:(UITextField *)textField {
    if (textField == _phone) {
        if ([g_config.regeditPhoneOrName intValue] == 1) {
            if (_phone.text.length > 11) {
                _phone.text = [_phone.text substringToIndex:11];
            }
        }else {
            if (_phone.text.length > 11) {
                _phone.text = [_phone.text substringToIndex:11];
            }
        }
    }
    if (textField == _pwd) {
        if (_pwd.text.length > 17) {
            _pwd.text = [_pwd.text substringToIndex:17];
        }
    }
}
- (void)goToLoginVC {
    if (self.isThirdLogin) {
        TFJunYou_loginVC *login = [TFJunYou_loginVC alloc];
        login.isThirdLogin = YES;
        login.isAutoLogin = NO;
        login.isSwitchUser= NO;
        login.type = self.type;
        login = [login init];
        [g_navigation pushViewController:login animated:YES];
    }else {
        [self actionQuit];
    }
}
- (void)checkPhoneNumber{
    _isSkipSMS = NO;
    BOOL isMobile = [self isMobileNumber:_phone.text];
    if ([_pwd.text length] < 6) {
        [g_App showAlert:Localized(@"JX_TurePasswordAlert")];
        return;
    }
    if ([g_config.registerInviteCode intValue] == 1) {
        if ([_inviteCode.text length] <= 0) {
            [g_App showAlert:Localized(@"JX_EnterInvitationCode")];
            return;
        }
    }
    if (isMobile) {
        NSString *areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
        [g_server checkPhone:_phone.text areaCode:areaCode verifyType:0 toView:self];
    }
}
- (BOOL)isMobileNumber:(NSString *)number{
    if ([g_config.isOpenSMSCode boolValue] && [g_config.regeditPhoneOrName intValue] != 1) {
        if ([_phone.text length] == 0) {
            [g_App showAlert:Localized(@"JX_InputPhone")];
            return NO;
        }
    }
#ifdef IS_TEST_VERSION
#else
#endif
    return YES;
}
-(void)refreshGraphicAction:(UIButton *)button{
    [self getImgCodeImg];
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
    }else{
    }
}
#pragma mark----验证短信验证码
-(void)onClick{
    if([_phone.text length]<=0){
        [g_App showAlert:Localized(@"JX_InputPhone")];
        return;
    }
    if (!_isSkipSMS) {
        if([_code.text length]<6){
            if([_code.text length]<=0){
                [g_App showAlert:@"请输入短信验证码"];
                return;
            }
            [g_App showAlert:Localized(@"inputPhoneVC_MsgCodeNotOK")];
            return;
        }
        if([_smsCode length]<6 && ![_smsCode isEqualToString:@"-1"]){
            [g_App showAlert:Localized(@"inputPhoneVC_NoMegCode")];
            return;
        }
        if (!([_phoneStr isEqualToString:_phone.text] && [_imgCodeStr isEqualToString:_imgCode.text] && ([_smsCode isEqualToString:_code.text] || [_smsCode isEqualToString:@"-1"]))) {
            if (![_phoneStr isEqualToString:_phone.text]) {
                [g_App showAlert:Localized(@"JX_No.Changed,Again")];
            }else if (![_imgCodeStr isEqualToString:_imgCode.text]) {
                [g_App showAlert:Localized(@"JX_ImageCodeErrorGetAgain")];
            }else if (![_smsCode isEqualToString:_code.text]) {
                [g_App showAlert:Localized(@"inputPhoneVC_MsgCodeNotOK")];
            }
            return;
        }
    }
    [self.view endEditing:YES];
    if (!_isSkipSMS) {
        if([_code.text isEqualToString:_smsCode] || [_smsCode isEqualToString:@"-1"]){
            self.isSmsRegister = YES;
            [self setUserInfo];
        }
        else
            [g_App showAlert:Localized(@"inputPhoneVC_MsgCodeNotOK")];
    } else {
        self.isSmsRegister = NO;
        [self setUserInfo];
    }
}
- (void)setUserInfo {
    if (_agreeImgV.isHidden == YES) {
        [g_App showAlert:Localized(@"JX_NotAgreeProtocol")];
        return;
    }
    TFJunYou_UserObject* user = [TFJunYou_UserObject sharedInstance];
    user.telephone = _phone.text;
    user.password  = [g_server getMD5String:_pwd.text];
    TFJunYou_PSRegisterBaseVC* vc = [TFJunYou_PSRegisterBaseVC alloc];
    vc.password = _pwd.text;
    vc.isRegister = YES;
    vc.inviteCodeStr = _inviteCode.text;
    vc.smsCode = _code.text;
    vc.resumeId   = nil;
    vc.isSmsRegister = self.isSmsRegister;
    vc.resumeModel     = [[resumeBaseData alloc]init];
    vc.user       = user;
    vc.type = self.type;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
    [self actionQuit];
}
-(void)onTest{
    if (_agreeImgV.isHidden == YES) {
        [g_App showAlert:Localized(@"JX_NotAgreeProtocol")];
        return;
    }
    TFJunYou_UserObject* user = [TFJunYou_UserObject sharedInstance];
    user.telephone = _phone.text;
    user.password  = [g_server getMD5String:_pwd.text];
    user.areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];;
    TFJunYou_PSRegisterBaseVC* vc = [TFJunYou_PSRegisterBaseVC alloc];
    vc.password = _pwd.text;
    vc.isRegister = YES;
    vc.inviteCodeStr = _inviteCode.text;
    vc.smsCode = _code.text;
    vc.resumeId   = nil;
    vc.isSmsRegister = NO;
    vc.resumeModel     = [[resumeBaseData alloc]init];
    vc.user       = user;
    vc.type = self.type;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
    [self actionQuit];
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
        _phoneStr = _phone.text;
        _imgCodeStr = _imgCode.text;
    }
    if([aDownload.action isEqualToString:act_CheckPhone]){
        if (self.isCheckToSMS) {
            self.isCheckToSMS = NO;
            [self onSend];
            return;
        }
        if ([g_config.isOpenSMSCode boolValue] && [g_config.regeditPhoneOrName intValue] != 1) {
            [self onClick];
        }else {
            [self onTest];
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
    if (_isSendFirst) {
        _isSendFirst = NO;
        _skipBtn.hidden = YES;
    }
    if (_seconds <= 30) {
        _skipBtn.hidden = NO;
    }
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
- (void)sendSMS{
    [_phone resignFirstResponder];
    [_pwd resignFirstResponder];
    [_imgCode resignFirstResponder];
    [_code resignFirstResponder];
    if([self isMobileNumber:_phone.text]){
        if (_imgCode.text.length < 3) {
            [g_App showAlert:Localized(@"JX_inputImgCode")];
        }else{
            self.isCheckToSMS = YES;
            NSString *areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
            [g_server checkPhone:_phone.text areaCode:areaCode verifyType:0 toView:self];
        }
    }
}
-(void)onSend{
    if (!_send.selected) {
        [_wait start:Localized(@"JX_Testing")];
        NSString *areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
        _user = [TFJunYou_UserObject sharedInstance];
        _user.areaCode = areaCode;
        [g_server sendSMS:[NSString stringWithFormat:@"%@",_phone.text] areaCode:areaCode isRegister:NO imgCode:_imgCode.text toView:self];
        [_send setTitle:Localized(@"JX_Sending") forState:UIControlStateNormal];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([g_config.isOpenSMSCode boolValue] && [g_config.regeditPhoneOrName intValue] != 1) {
        if (textField == _phone) {
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
- (void)hideKeyBoardToView {
    [self.view endEditing:YES];
}




#pragma mark -- 协议条款
-(void)iniframeProtocal{
     
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.userInteractionEnabled=YES;
    backView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    self.backView=backView;
    
    
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
    subtitle.text = [NSString stringWithFormat:@"        欢迎使用%@免费聊天，为了更好地保护您的隐私和个人信息安全，根据国家相关法律规定拟定了", app_name];
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
       [sureBtn addTarget:self action:@selector(sureBtnClickaaa) forControlEvents:UIControlEventTouchUpInside];
}
- (void)sureBtnClick{
    exit(0);
}

//同意协议
- (void)cancelBtnClick{
    [self.backView removeFromSuperview];
}

- (void)sureBtnClickaaa{
    exit(0);
}


-(void)iniframeShow{
    
     
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.userInteractionEnabled=YES;
    backView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    self.knowBackView=backView;
    
    
    UIView *leftIM=[[UIView alloc]init];
    leftIM.backgroundColor=[UIColor whiteColor];
    leftIM.userInteractionEnabled=YES;
    [backView addSubview:leftIM];
    leftIM.frame=CGRectMake(40, SCREEN_WIDTH/2, SCREEN_WIDTH-80, SCREEN_WIDTH/1.8+60);
    leftIM.layer.cornerRadius=15;
    leftIM.layer.masksToBounds=YES;
    [backView addSubview:leftIM];
    
    UILabel *titleLable=[[UILabel alloc]init];
    titleLable.text=@"隐私政策";
    titleLable.font=[UIFont boldSystemFontOfSize:20];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.frame=CGRectMake(10, 30, SCREEN_WIDTH-100, 20);
    [leftIM addSubview:titleLable];
    
    UILabel *subtitle=[[UILabel alloc]init];
    subtitle.text=@"        为了更好地保护您的权益，请阅读并同意下方的";
    subtitle.numberOfLines=3;
    subtitle.frame=CGRectMake(10, 64, SCREEN_WIDTH-100,66);
    [leftIM addSubview:subtitle];
     
    
    UIButton *leftBtn=[[UIButton alloc]init];
    [leftBtn setTitle:@"《隐私政策》" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    leftBtn.layer.cornerRadius=5;
    leftBtn.layer.masksToBounds=YES;
    [leftIM addSubview:leftBtn];
    leftBtn.frame=CGRectMake(0, subtitle.bottom, 111, 15);
    [leftBtn addTarget:self action:@selector(leftIMClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *heLabel=[[UILabel alloc]init];
    heLabel.text=@"和";
    heLabel.textAlignment=NSTextAlignmentCenter;
    heLabel.frame=CGRectMake(leftBtn.right, subtitle.bottom, 30,15);
    [leftIM addSubview:heLabel];
    
    UIButton *rightBtn=[[UIButton alloc]init];
    [rightBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    rightBtn.layer.cornerRadius=5;
    rightBtn.layer.masksToBounds=YES;
    [leftIM addSubview:rightBtn];
    rightBtn.frame=CGRectMake(heLabel.right,subtitle.bottom, 111, 15);
    [rightBtn addTarget:self action:@selector(rightBtnL) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *contentLabel=[[UILabel alloc]init];
    contentLabel.text=@"后,再进行登录";
    contentLabel.frame=CGRectMake(8, rightBtn.bottom,SCREEN_WIDTH-60 ,22);
    [leftIM addSubview:contentLabel];
    
    
       UIButton *cancelBtn=[[UIButton alloc]init];
       [cancelBtn setTitle:@"知道了" forState:UIControlStateNormal];
       [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       cancelBtn.backgroundColor=[UIColor redColor];
       cancelBtn.layer.cornerRadius=20;
       cancelBtn.layer.masksToBounds=YES;
       [leftIM addSubview:cancelBtn];
      cancelBtn.frame=CGRectMake(20, contentLabel.bottom+44, leftIM.width-40, 40);
       [cancelBtn addTarget:self action:@selector(knowBtn) forControlEvents:UIControlEventTouchUpInside];
      
}
- (void)knowBtn{
    
    [self.knowBackView removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.knowBackView.hidden=NO;
}


@end
