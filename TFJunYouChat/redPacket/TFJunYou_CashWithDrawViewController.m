#import "TFJunYou_CashWithDrawViewController.h"
#import "UIImage+Color.h"
#import "TFJunYou_VerifyPayVC.h"
#import "TFJunYou_PayPasswordVC.h"
#import  "WXApi.h"


#define drawMarginX 20
#define bgWidth TFJunYou__SCREEN_WIDTH-15*2
#define drawHei 60
@interface TFJunYou_CashWithDrawViewController ()<UITextFieldDelegate,WXApiDelegate>
@property (nonatomic, strong) UIButton * helpButton;
@property (nonatomic, strong) UIControl * hideControl;
@property (nonatomic, strong) UIControl * bgView;
@property (nonatomic, strong) UIView * targetView;
@property (nonatomic, strong) UIView * inputView;
@property (nonatomic, strong) UIView * balanceView;
@property (nonatomic, strong) UIButton * cardButton;
@property (nonatomic, strong) UITextField * countTextField;
@property (nonatomic, strong) UILabel * balanceLabel;
@property (nonatomic, strong) UIButton * drawAllBtn;
@property (nonatomic, strong) UIButton * withdrawalsBtn;
@property (nonatomic, strong) UIButton * aliwithdrawalsBtn;
@property (nonatomic, strong) ATMHud *loading;
@property (nonatomic, strong) TFJunYou_VerifyPayVC *verVC;
@property (nonatomic, strong) NSString *payPassword;
@property (nonatomic, assign) BOOL isAlipay;
@property (nonatomic, strong) NSString *aliUserId;
@end
@implementation TFJunYou_CashWithDrawViewController
-(instancetype)init{
    if (self = [super init]) {
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.isGotoBack = YES;
        self.title = Localized(@"JXMoney_withdrawals");
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(TFJunYou__SCREEN_WIDTH, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
    [self createHeadAndFoot];
    self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
    [self.tableBody addSubview:self.hideControl];
    [self.tableBody addSubview:self.bgView];
    [self.bgView addSubview:self.inputView];
    [self.bgView addSubview:self.balanceView];
    self.bgView.frame = CGRectMake(15, 20, bgWidth, CGRectGetMaxY(_balanceView.frame));
    _loading = [[ATMHud alloc] init];
   // [g_notify addObserver:self selector:@selector(authRespNotification:) name:kWxSendAuthRespNotification object:nil];
    
   [g_notify addObserver:self selector:@selector(authRespNotification:) name:@"wxBandId" object:nil];

}
-(UIButton *)helpButton{
    if(!_helpButton){
        _helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _helpButton.frame = CGRectMake(TFJunYou__SCREEN_WIDTH -15-18, TFJunYou__SCREEN_TOP -15-18, 18, 18);
        NSString *image = THESIMPLESTYLE ? @"im_003_more_button_black" : @"im_003_more_button_normal";
        [_helpButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [_helpButton setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
        [_helpButton addTarget:self action:@selector(helpButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpButton;
}
-(UIControl *)hideControl{
    if (!_hideControl) {
        _hideControl = [[UIControl alloc] init];
        _hideControl.frame = self.tableBody.bounds;
        [_hideControl addTarget:self action:@selector(hideControlAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideControl;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIControl alloc] init];
        _bgView.frame = CGRectMake(15, 20, bgWidth, 400);
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}
-(UIView *)targetView{
    if (!_targetView) {
        _targetView = [[UIView alloc] init];
        _targetView.frame = CGRectMake(0, 0, bgWidth, drawHei);
        _targetView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
        UILabel * targetLabel = [UIFactory createLabelWith:CGRectMake(drawMarginX, 0, 120, drawHei) text:Localized(@"JXMoney_withDrawalsTarget")];
        [_targetView addSubview:targetLabel];
        CGRect btnFrame = CGRectMake(CGRectGetMaxX(targetLabel.frame)+20, 0, bgWidth-CGRectGetMaxX(targetLabel.frame)-20-drawMarginX, drawHei);
        _cardButton = [UIFactory createButtonWithRect:btnFrame title:@"微信号(8868)" titleFont:g_factory.font15 titleColor:HEXCOLOR(0x576b95) normal:nil selected:nil selector:@selector(cardButtonAction:) target:self];
        [_targetView addSubview:_cardButton];
    }
    return _targetView;
}
-(UIView *)inputView{
    if (!_inputView) {
        _inputView = [[UIView alloc] init];
        _inputView.frame = CGRectMake(0, 0, bgWidth, 126);
        _inputView.backgroundColor = [UIColor whiteColor];
        UILabel * cashTitle = [UIFactory createLabelWith:CGRectMake(drawMarginX, drawMarginX, 120, 15) text:Localized(@"JXMoney_withDAmount")];
        cashTitle.font = SYSFONT(15);
        cashTitle.textColor = HEXCOLOR(0x999999);
        [_inputView addSubview:cashTitle];
        UILabel * rmbLabel = [UIFactory createLabelWith:CGRectMake(drawMarginX, CGRectGetMaxY(cashTitle.frame)+36, 18, 30) text:@"¥"];
        rmbLabel.font = SYSFONT(30);
        rmbLabel.textAlignment = NSTextAlignmentLeft;
        [_inputView addSubview:rmbLabel];
        _countTextField = [UIFactory createTextFieldWithRect:CGRectMake(CGRectGetMaxX(rmbLabel.frame)+15, CGRectGetMaxY(cashTitle.frame)+31, bgWidth-CGRectGetMaxX(rmbLabel.frame)-drawMarginX-15, 40) keyboardType:UIKeyboardTypeDecimalPad secure:NO placeholder:nil font:[UIFont boldSystemFontOfSize:40] color:[UIColor blackColor] delegate:self];
        _countTextField.borderStyle = UITextBorderStyleNone;
        [_inputView addSubview:_countTextField];
        UIView * line = [[UIView alloc] init];
        line.frame = CGRectMake(drawMarginX, CGRectGetMaxY(_countTextField.frame)+15, bgWidth-drawMarginX*2, LINE_WH);
        line.backgroundColor = THE_LINE_COLOR;
        [_inputView addSubview:line];
    }
    return _inputView;
}
-(UIView *)balanceView{
    if (!_balanceView) {
        _balanceView = [[UIView alloc] init];
        _balanceView.frame = CGRectMake(0, CGRectGetMaxY(_inputView.frame), bgWidth, 186);
        _balanceView.backgroundColor = [UIColor whiteColor];
        NSString * moneyStr = [NSString stringWithFormat:@"%@¥%.2f，",Localized(@"JXMoney_blance"),g_App.myMoney];
        _balanceLabel = [UIFactory createLabelWith:CGRectZero text:moneyStr font:g_factory.font14 textColor:[UIColor lightGrayColor] backgroundColor:nil];
        CGFloat blanceWidth = [moneyStr sizeWithAttributes:@{NSFontAttributeName:_balanceLabel.font}].width;
        _balanceLabel.frame = CGRectMake(drawMarginX, drawMarginX, blanceWidth, 14);
        [_balanceView addSubview:_balanceLabel];
        _drawAllBtn = [UIFactory createButtonWithRect:CGRectZero title:Localized(@"JXMoney_withDAll") titleFont:_balanceLabel.font titleColor:HEXCOLOR(0x576b95) normal:nil selected:nil selector:@selector(drawAllBtnAction) target:self];
        CGFloat drawWidth = [_drawAllBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_drawAllBtn.titleLabel.font}].width;
        _drawAllBtn.frame = CGRectMake(CGRectGetMaxX(_balanceLabel.frame)+10, CGRectGetMinY(_balanceLabel.frame), drawWidth, 14);
        [_balanceView addSubview:_drawAllBtn];
//        _withdrawalsBtn = [UIFactory createButtonWithRect:CGRectZero title:Localized(@"JXMoney_wechatWithdrawals") titleFont:g_factory.font16 titleColor:[UIColor whiteColor] normal:nil selected:nil selector:@selector(withdrawalsBtnAction:) target:self];
//        _withdrawalsBtn.tag = 1000;
//        _withdrawalsBtn.frame = CGRectMake(drawMarginX, CGRectGetMaxY(_balanceLabel.frame)+30, bgWidth-drawMarginX*2, 40);
//        [_withdrawalsBtn setImage:[UIImage imageNamed:@"withdrawal_weixin"] forState:UIControlStateNormal];
//        [_withdrawalsBtn setBackgroundImage:[UIImage createImageWithColor:HEXCOLOR(0x22CC06)] forState:UIControlStateNormal];
//        _withdrawalsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
//        _withdrawalsBtn.layer.cornerRadius = 7;
//        _withdrawalsBtn.clipsToBounds = YES;
//        [_balanceView addSubview:_withdrawalsBtn];
        _aliwithdrawalsBtn = [UIFactory createButtonWithRect:CGRectZero title:Localized(@"JXMoney_Aliwithdrawals") titleFont:g_factory.font16 titleColor:[UIColor whiteColor] normal:nil selected:nil selector:@selector(withdrawalsBtnAction:) target:self];
        _aliwithdrawalsBtn.tag = 1011;
        _aliwithdrawalsBtn.frame = CGRectMake(drawMarginX, CGRectGetMaxY(_balanceLabel.frame)+50, bgWidth-drawMarginX*2, 40);
        [_aliwithdrawalsBtn setImage:[UIImage imageNamed:@"withdrawal_aliPay"] forState:UIControlStateNormal];
        [_aliwithdrawalsBtn setBackgroundImage:[UIImage createImageWithColor:HEXCOLOR(0x3E98FF)] forState:UIControlStateNormal];
        _aliwithdrawalsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _aliwithdrawalsBtn.layer.cornerRadius = 7;
        _aliwithdrawalsBtn.clipsToBounds = YES;
        [_balanceView addSubview:_aliwithdrawalsBtn];
        UILabel *noticeLabel = [UIFactory createLabelWith:CGRectMake(drawMarginX, CGRectGetMaxY(_aliwithdrawalsBtn.frame)+20, bgWidth-drawMarginX*2, 13) text:Localized(@"JXMoney_withDNotice") font:g_factory.font13 textColor:HEXCOLOR(0x999999) backgroundColor:nil];
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        [_balanceView addSubview:noticeLabel];
    }
    return _balanceView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _countTextField) {
        NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toString.length > 0) {
            NSString *stringRegex = @"(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,4}(([.]\\d{0,2})?)))?";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
            if (![predicate evaluateWithObject:toString]) {
                return NO;
            }
        }
    }
    return YES;
}
#pragma mark Action
-(void)cardButtonAction:(UIButton *)button{
}
-(void)drawAllBtnAction{
    NSString * allMoney = [NSString stringWithFormat:@"%.2f",g_App.myMoney];
    _countTextField.text = allMoney;
}
-(void)withdrawalsBtnAction:(UIButton *)button{
    double money = [_countTextField.text doubleValue];
    double minCash = [[NSUserDefaults standardUserDefaults] doubleForKey:@"kMinCash"];
    if (money - minCash < 0.000001) {
        NSString *msg = [NSString stringWithFormat:@"每次最少提现@%.2f元", minCash];
        [g_App showAlert:msg];
        return;
    }
    if ([g_server.myself.isPayPassword boolValue]) {
        self.isAlipay = button.tag == 1011;
        self.verVC = [TFJunYou_VerifyPayVC alloc];
        self.verVC.type = TFJunYou_VerifyTypeWithdrawal;
        self.verVC.RMB = self.countTextField.text;
        self.verVC.delegate = self;
        self.verVC.didDismissVC = @selector(dismissVerifyPayVC);
        self.verVC.didVerifyPay = @selector(didVerifyPay:);
        self.verVC = [self.verVC init];
        [self.view addSubview:self.verVC.view];
    } else {
        TFJunYou_PayPasswordVC *payPswVC = [TFJunYou_PayPasswordVC alloc];
        payPswVC.type = TFJunYou_PayTypeSetupPassword;
        payPswVC.enterType = TFJunYou_EnterTypeWithdrawal;
        payPswVC = [payPswVC init];
        [g_navigation pushViewController:payPswVC animated:YES];
    }
}
- (void)didVerifyPay:(NSString *)sender {
    self.payPassword = [NSString stringWithString:sender];
    if (self.isAlipay) {
        [g_server getAliPayAuthInfoToView:self];
    }else {
        
        // 绑定微信
        SendAuthReq* req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app名称
        NSString *titleStr = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        req.state = titleStr;
        req.openID = g_App.config.appleId;
       [WXApi sendAuthReq:req viewController:self delegate:self completion:^(BOOL success) {}];
        // [WXApi sendAuthReq:req viewController:self delegate:self];
        
        
    }
}
- (void)dismissVerifyPayVC {
    [self.verVC.view removeFromSuperview];
}
- (void)authRespNotification:(NSNotification *)notif {
    
    SendAuthResp *resp = notif.object;
    [self getWeChatTokenThenGetUserInfoWithCode:resp.code];
    
}
- (void)getWeChatTokenThenGetUserInfoWithCode:(NSString *)code {
    long time = (long)[[NSDate date] timeIntervalSince1970];
    time = (time *1000 + g_server.timeDifference)/1000;
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"code",code, nil];
    [g_payServer payServerWithAction:act_UserBindWXCodeV1 param:arr payPassword:self.payPassword time:time toView:self];
}
-(void)hideControlAction{
    [_countTextField resignFirstResponder];
}
-(void)actionQuit{
    [_countTextField resignFirstResponder];
    [super actionQuit];
}
-(void)helpButtonAction{
}
- (void)alipayGetUserId:(NSNotification *)noti {
    long time = (long)[[NSDate date] timeIntervalSince1970];
    time = (time *1000 + g_server.timeDifference)/1000;
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"aliUserId",noti.object, nil];
    [g_payServer payServerWithAction:act_aliPayUserIdV1 param:arr payPassword:self.payPassword time:time toView:self];
}
- (void)didServerResultSucces:(TFJunYou_Connection *)aDownload dict:(NSDictionary *)dict array:(NSArray *)array1{
    if ([aDownload.action isEqualToString:act_UserBindWXCode] || [aDownload.action isEqualToString:act_UserBindWXCodeV1]) {
        NSString *amount = _countTextField.text;
        long time = (long)[[NSDate date] timeIntervalSince1970];
        time = (time *1000 + g_server.timeDifference)/1000;
        NSString *secret = [self secretEncryption:dict[@"openid"] amount:amount time:time payPassword:self.payPassword];
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"amount",amount, nil];
        [g_payServer payServerWithAction:act_TransferWXPayV1 param:arr payPassword:self.payPassword time:time toView:self];
    }else if ([aDownload.action isEqualToString:act_TransferWXPay] || [aDownload.action isEqualToString:act_TransferWXPayV1]) {
        [_loading stop];
        [self dismissVerifyPayVC];  
        [g_App showAlert:Localized(@"JX_WithdrawalSuccess")];
        _countTextField.text = nil;
        [g_server getUserMoenyToView:self];
    }
    if ([aDownload.action isEqualToString:act_getUserMoeny]) {
        g_App.myMoney = [dict[@"balance"] doubleValue];
        _balanceLabel.text = [NSString stringWithFormat:@"%@¥%.2f，",Localized(@"JXMoney_blance"),g_App.myMoney];
        [g_notify postNotificationName:kUpdateUserNotifaction object:nil];
    }
    if ([aDownload.action isEqualToString:act_aliPayUserId] || [aDownload.action isEqualToString:act_aliPayUserIdV1]) {
        long time = (long)[[NSDate date] timeIntervalSince1970];
        time = (time *1000 + g_server.timeDifference)/1000;
        NSString *secret = [self secretEncryption:self.aliUserId amount:_countTextField.text time:time payPassword:self.payPassword];
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"amount",self.countTextField.text, nil];
        [g_payServer payServerWithAction:act_alipayTransferV1 param:arr payPassword:self.payPassword time:time toView:self];
    }
    if ([aDownload.action isEqualToString:act_alipayTransfer] || [aDownload.action isEqualToString:act_alipayTransferV1]) {
        [g_server showMsg:Localized(@"JX_WithdrawalSuccess")];
        [g_navigation dismissViewController:self animated:YES];
    }
    if ([aDownload.action isEqualToString:act_getAliPayAuthInfo]) {
        NSString *aliId = [dict objectForKey:@"aliUserId"];
        NSString *authInfo = [dict objectForKey:@"authInfo"];
        if (IsStringNull(aliId)) {
          NSString *appScheme = @"shikuimapp";
            
        
        }else {
            long time = (long)[[NSDate date] timeIntervalSince1970];
            time = (time *1000 + g_server.timeDifference)/1000;
           NSString *secret = [self secretEncryption:aliId amount:_countTextField.text time:time payPassword:self.payPassword];
            NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"amount",self.countTextField.text, nil];
            [g_payServer payServerWithAction:act_alipayTransferV1 param:arr payPassword:self.payPassword time:time toView:self];
        }
    }
}
- (int)didServerResultFailed:(TFJunYou_Connection *)aDownload dict:(NSDictionary *)dict{
    [_loading stop];
    if ([aDownload.action isEqualToString:act_alipayTransfer] || [aDownload.action isEqualToString:act_alipayTransferV1]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.verVC clearUpPassword];
        });
    }
    return show_error;
}
- (int)didServerConnectError:(TFJunYou_Connection *)aDownload error:(NSError *)error{
    [_loading stop];
    return hide_error;
}
- (NSString *)secretEncryption:(NSString *)openId amount:(NSString *)amount time:(long)time payPassword:(NSString *)payPassword {
    NSString *secret = [NSString string];
    NSMutableString *str1 = [NSMutableString string];
    [str1 appendString:APIKEY];
    [str1 appendString:openId];
    [str1 appendString:MY_USER_ID];
    NSMutableString *str2 = [NSMutableString string];
    [str2 appendString:g_server.access_token];
    [str2 appendString:amount];
    [str2 appendString:[NSString stringWithFormat:@"%ld",time]];
    str2 = [[g_server getMD5String:str2] mutableCopy];
    [str1 appendString:str2];
    NSMutableString *str3 = [NSMutableString string];
    str3 = [[g_server getMD5String:payPassword] mutableCopy];
    [str1 appendString:str3];
    secret = [g_server getMD5String:str1];
    return secret;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
}
@end
