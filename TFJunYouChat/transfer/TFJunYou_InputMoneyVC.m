#import "TFJunYou_InputMoneyVC.h"
#import "UIImage+Color.h"
#import "TFJunYou_VerifyPayVC.h"
#import "TFJunYou_PayPasswordVC.h"
#define drawMarginX 20
#define bgWidth TFJunYou__SCREEN_WIDTH-15*2
#define drawHei 60
@interface TFJunYou_InputMoneyVC () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField * countTextField;
@property (nonatomic, strong) UIButton *transferBtn;
@property (nonatomic, strong) UILabel *addDscLab;
@property (nonatomic, strong) UILabel *dscLab;
@property (nonatomic, strong) NSString *desContent;
@property (nonatomic, strong) TFJunYou_VerifyPayVC *verVC;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *replayTitle;
@property (nonatomic, strong) UITextField *replayTextField;
@end
@implementation TFJunYou_InputMoneyVC
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == TFJunYou_InputMoneyTypePayment) {
        self.title = Localized(@"JX_Payment");
    }else if(self.type == TFJunYou_InputMoneyTypeCollection) {
        self.title = Localized(@"JX_CollectionMoney");
    }else {
        self.title = Localized(@"JX_SetTheAmount");
    }
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack = YES;
    [self createHeadAndFoot];
    [self setupViews];
    [self setupReplayView];
    [g_notify addObserver:self selector:@selector(notifyPaymentGet:) name:kXMPPMessageQrPaymentNotification object:nil];
}
- (void)notifyPaymentGet:(NSNotification *)noti {
    TFJunYou_MessageObject *msg = noti.object;
    if ([msg.type intValue] == kWCMessageTypePaymentGet) {
        [g_server showMsg:Localized(@"JX_PaymentReceived")];
    }else if ([msg.type intValue] == kWCMessageTypeReceiptOut) {
        [g_server showMsg:Localized(@"JX_PaymentToFriend")];
    }
}
- (void)notifyReceiptOut {
}
- (void)setupViews {
    self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
    int n = 0;
    if (self.type == TFJunYou_InputMoneyTypePayment) {
        UILabel *payTit = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 17)];
        payTit.text = Localized(@"JX_PaymentToIndividual");
        payTit.font = SYSFONT(16);
        [self.tableBody addSubview:payTit];
        CGSize size = [_userName sizeWithAttributes:@{NSFontAttributeName:SYSFONT(14)}];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(payTit.frame)+5, size.width, size.height)];
        _nameLabel.font = SYSFONT(14);
        _nameLabel.textColor = [UIColor lightGrayColor];
        _nameLabel.text = _userName;
        [self.tableBody addSubview:_nameLabel];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-20-40, 20, 40, 40)];
        icon.layer.masksToBounds = YES;
        icon.layer.cornerRadius = icon.frame.size.width/2;
        [g_server getHeadImageLarge:_userId userName:_userName imageView:icon];
        [self.tableBody addSubview:icon];
        n = 10;
    }
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_nameLabel.frame)+n+15, TFJunYou__SCREEN_WIDTH-30, 244)];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.layer.masksToBounds = YES;
    baseView.layer.cornerRadius = 3.f;
    [self.tableBody addSubview:baseView];
    UILabel * cashTitle = [UIFactory createLabelWith:CGRectMake(drawMarginX, 0, 120, drawHei) text:self.title];
    cashTitle.font = SYSFONT(14);
    cashTitle.textColor = HEXCOLOR(0x999999);
    if (self.type == TFJunYou_InputMoneyTypeCollection) {
        cashTitle.text = Localized(@"JX_GetMoney");
    }else if (self.type == TFJunYou_InputMoneyTypeSetMoney) {
        cashTitle.text = @"????????????";
    }else {
        cashTitle.text = self.desStr;
    }
    [baseView addSubview:cashTitle];
    UILabel * rmbLabel = [UIFactory createLabelWith:CGRectMake(drawMarginX, CGRectGetMaxY(cashTitle.frame), 35, 35) text:@"??"];
    rmbLabel.font = g_factory.font28b;
    rmbLabel.textAlignment = NSTextAlignmentLeft;
    [baseView addSubview:rmbLabel];
    _countTextField = [UIFactory createTextFieldWithRect:CGRectMake(CGRectGetMaxX(rmbLabel.frame), CGRectGetMinY(rmbLabel.frame), bgWidth-CGRectGetMaxX(rmbLabel.frame)-drawMarginX, drawHei) keyboardType:UIKeyboardTypeDecimalPad secure:NO placeholder:nil font:[UIFont boldSystemFontOfSize:45] color:[UIColor blackColor] delegate:self];
    _countTextField.borderStyle = UITextBorderStyleNone;
    [baseView addSubview:_countTextField];
    [_countTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (self.money.length > 0) {
        _countTextField.text = self.money;
        _countTextField.enabled = NO;
    }
    UIView * line = [[UIView alloc] init];
    line.frame = CGRectMake(drawMarginX, CGRectGetMaxY(_countTextField.frame)+5, bgWidth-drawMarginX*2, LINE_WH);
    line.backgroundColor = THE_LINE_COLOR;
    [baseView addSubview:line];
    _dscLab = [[UILabel alloc] initWithFrame:CGRectMake(drawMarginX, CGRectGetMaxY(line.frame)+15, 0, 0)];
    _dscLab.font = SYSFONT(14);
    [baseView addSubview:_dscLab];
    _addDscLab = [[UILabel alloc] initWithFrame:CGRectMake(drawMarginX, CGRectGetMaxY(line.frame)+15, 120, 18)];
    _addDscLab.text = Localized(@"JX_AddDescriptions");
    _addDscLab.textColor = HEXCOLOR(0x6E7B8F);
    _addDscLab.userInteractionEnabled = YES;
    _addDscLab.font = SYSFONT(14);
    _addDscLab.hidden = self.type == TFJunYou_InputMoneyTypeCollection;
    [baseView addSubview:_addDscLab];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSendTransferDsc)];
    [_addDscLab addGestureRecognizer:tap];
    _transferBtn = [UIFactory createButtonWithRect:CGRectZero title:self.type ==TFJunYou_InputMoneyTypeSetMoney ? Localized(@"JX_Confirm") : self.title titleFont:g_factory.font17 titleColor:[UIColor whiteColor] normal:nil selected:nil selector:@selector(transferBtnAction:) target:self];
    _transferBtn.tag = 1000;
    _transferBtn.frame = CGRectMake(drawMarginX, CGRectGetMaxY(_addDscLab.frame)+20, baseView.frame.size.width-drawMarginX*2, 40);
    [_transferBtn setBackgroundImage:[UIImage createImageWithColor:THEMECOLOR] forState:UIControlStateNormal];
    [_transferBtn setBackgroundImage:[UIImage createImageWithColor:[THEMECOLOR colorWithAlphaComponent:0.5f]] forState:UIControlStateDisabled];
    [_transferBtn.titleLabel setFont:SYSFONT(16)];
    _transferBtn.layer.cornerRadius = 7;
    _transferBtn.clipsToBounds = YES;
    _transferBtn.enabled = self.money.length > 0;
    [baseView addSubview:_transferBtn];
}
- (void)setupReplayView {
    int height = 44;
    self.bigView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bigView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.bigView.hidden = YES;
    [g_App.window addSubview:self.bigView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.bigView addGestureRecognizer:tap];
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(40, TFJunYou__SCREEN_HEIGHT/4-.5, TFJunYou__SCREEN_WIDTH-80, 162.5)];
    self.baseView.backgroundColor = [UIColor whiteColor];
    self.baseView.layer.masksToBounds = YES;
    self. baseView.layer.cornerRadius = 4.0f;
    [self.bigView addSubview:self.baseView];
    int n = 20;
    _replayTitle = [[UILabel alloc] initWithFrame:CGRectMake(INSETS, n, self.baseView.frame.size.width - INSETS*2, 20)];
    _replayTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    _replayTitle.textAlignment = NSTextAlignmentCenter;
    _replayTitle.textColor = HEXCOLOR(0x333333);
    _replayTitle.font = [UIFont boldSystemFontOfSize:17];
    _replayTitle.text = self.title;
    [self.baseView addSubview:_replayTitle];
    n = n + height;
    self.replayTextField = [self createTextField:self.baseView default:nil hint:nil];
    self.replayTextField.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    self.replayTextField.frame = CGRectMake(10, n, self.baseView.frame.size.width - INSETS*2, 35.5);
    self.replayTextField.delegate = self;
    self.replayTextField.textColor = HEXCOLOR(0x595959);
    self.replayTextField.placeholder = Localized(@"JX_10WordsAtMost");
    [self.replayTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    n = n + INSETS + height;
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, n, self.baseView.frame.size.width, 44)];
    [self.baseView addSubview:self.topView];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.baseView.frame.size.width, LINE_WH)];
    topLine.backgroundColor = THE_LINE_COLOR;
    [self.topView addSubview:topLine];
    UIView *botLine = [[UIView alloc] initWithFrame:CGRectMake(self.baseView.frame.size.width/2, 0, LINE_WH, self.topView.frame.size.height)];
    botLine.backgroundColor = THE_LINE_COLOR;
    [self.topView addSubview:botLine];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topLine.frame), self.baseView.frame.size.width/2, botLine.frame.size.height)];
    [cancelBtn setTitle:Localized(@"JX_Cencal") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:SYSFONT(15)];
    [cancelBtn addTarget:self action:@selector(hideBigView) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:cancelBtn];
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.baseView.frame.size.width/2, CGRectGetMaxY(topLine.frame), self.baseView.frame.size.width/2, botLine.frame.size.height)];
    [sureBtn setTitle:Localized(@"JX_Confirm") forState:UIControlStateNormal];
    [sureBtn setTitleColor:HEXCOLOR(0x55BEB8) forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:SYSFONT(15)];
    [sureBtn addTarget:self action:@selector(onRelease) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:sureBtn];
}
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == _countTextField) {
        if ([textField.text doubleValue] > 0) {
            _transferBtn.enabled = YES;
        }else {
            _transferBtn.enabled = NO;
        }
    }
}
#pragma mark - ????????????????????????
- (void)transferBtnAction:(UIButton *)button {
    if (self.type == TFJunYou_InputMoneyTypeSetMoney) {
        NSMutableDictionary *dict = @{@"type":[NSNumber numberWithInt:self.type]}.mutableCopy;
        if (self.countTextField.text.length > 0) {
            [dict addEntriesFromDictionary:@{@"money":self.countTextField.text}];
        }
        if (self.desContent.length > 0) {
            [dict addEntriesFromDictionary:@{@"desc":self.desContent}];
        }
        if (self.delegate && [self.delegate respondsToSelector:self.onInputMoney]) {
            [self.delegate performSelectorOnMainThread:self.onInputMoney withObject:dict waitUntilDone:NO];
            [self actionQuit];
        }
    }else if (self.type == TFJunYou_InputMoneyTypeCollection) {
        long time = (long)[[NSDate date] timeIntervalSince1970];
        time = (time *1000 + g_server.timeDifference)/1000;
        NSString *secret = [self getSecretWithPaymentCode:self.paymentCode time:time];
        [g_server codePaymentV1:self.paymentCode money:self.countTextField.text desc:self.desContent toView:self];
    }
    else {
        if ([g_server.myself.isPayPassword boolValue]) {
            self.verVC = [TFJunYou_VerifyPayVC alloc];
            self.verVC.type = TFJunYou_VerifyTypeQr;
            self.verVC.RMB = self.countTextField.text;
            self.verVC.delegate = self;
            self.verVC.didDismissVC = @selector(dismissVerifyPayVC);
            self.verVC.didVerifyPay = @selector(didVerifyPay:);
            self.verVC = [self.verVC init];
            [self.view addSubview:self.verVC.view];
        } else {
            TFJunYou_PayPasswordVC *payPswVC = [TFJunYou_PayPasswordVC alloc];
            payPswVC.type = TFJunYou_PayTypeSetupPassword;
            payPswVC.enterType = TFJunYou_EnterTypeQr;
            payPswVC = [payPswVC init];
            [g_navigation pushViewController:payPswVC animated:YES];
        }
    }
}
- (void)didVerifyPay:(NSString *)sender {
    long time = (long)[[NSDate date] timeIntervalSince1970];
    time = (time *1000 + g_server.timeDifference)/1000;
    NSString *secret = [self getSecretWithtime:time];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"toUserId",self.userId,@"money",self.countTextField.text,@"desc",self.desContent, nil];
    [g_payServer payServerWithAction:act_codeReceiptV1 param:arr payPassword:sender time:time toView:self];
}
- (void)dismissVerifyPayVC {
    [self.verVC.view removeFromSuperview];
}
- (void)showSendTransferDsc{
    self.bigView.hidden = NO;
    [self.replayTextField becomeFirstResponder];
}
- (void)hideBigView {
    [self resignKeyBoard];
}
- (void)onRelease {
    [self resignKeyBoard];
    self.desContent = _replayTextField.text;
    _dscLab.text = self.desContent;
    _addDscLab.text = self.desContent.length > 0 ? Localized(@"JX_Modify") : Localized(@"JX_AddDescriptions");
    CGSize size = [self.desContent sizeWithAttributes:@{NSFontAttributeName:SYSFONT(17)}];
    _dscLab.frame = CGRectMake(drawMarginX, _dscLab.frame.origin.y, size.width, 18);
    _addDscLab.frame = CGRectMake(CGRectGetMaxX(_dscLab.frame)+5, _addDscLab.frame.origin.y, 120, 18);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _countTextField) {
        if (IsStringNull(textField.text) && [string isEqualToString:@"."]) {
            return NO;
        }
        if ([textField.text rangeOfString:@"."].location != NSNotFound) {
            if (toBeString.length > [toBeString rangeOfString:@"."].location+3) {
                return NO;
            }
            if ([string isEqualToString:@"."]) {
                return NO;
            }
        }
        if ([textField.text isEqualToString:@"0"]) {
            if (![string isEqualToString:@"."] && ![string isEqualToString:@""]) {
                return NO;
            }
        }
        NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
        NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    if (textField == self.replayTextField) {
        if (toBeString.length > 10) {
            return NO;
        }
    }
    return YES;
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if( [aDownload.action isEqualToString:act_codeReceipt] || [aDownload.action isEqualToString:act_codeReceiptV1]){
        [self dismissVerifyPayVC];  
        [self actionQuit];
    }
    if( [aDownload.action isEqualToString:act_codePayment] || [aDownload.action isEqualToString:act_codePaymentV1]){
        [self actionQuit];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_codeReceipt] || [aDownload.action isEqualToString:act_codeReceiptV1]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.verVC clearUpPassword];
        });
    }
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait stop];
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}
-(UITextField*)createTextField:(UIView*)parent default:(NSString*)s hint:(NSString*)hint{
    UITextField* p = [[UITextField alloc] initWithFrame:CGRectMake(0,INSETS,TFJunYou__SCREEN_WIDTH,54)];
    p.delegate = self;
    p.autocorrectionType = UITextAutocorrectionTypeNo;
    p.autocapitalizationType = UITextAutocapitalizationTypeNone;
    p.enablesReturnKeyAutomatically = YES;
    p.textAlignment = NSTextAlignmentLeft;
    p.userInteractionEnabled = YES;
    p.backgroundColor = [UIColor whiteColor];
    p.text = s;
    p.font = g_factory.font16;
    [parent addSubview:p];
    return p;
}
- (void)resignKeyBoard {
    self.bigView.hidden = YES;
    [self hideKeyBoard];
    [self resetBigView];
}
- (void)resetBigView {
    self.replayTextField.frame = CGRectMake(10, 64, self.baseView.frame.size.width - INSETS*2, 35.5);
    self.baseView.frame = CGRectMake(40, TFJunYou__SCREEN_HEIGHT/4-.5, TFJunYou__SCREEN_WIDTH-80, 162.5);
    self.topView.frame = CGRectMake(0, 118, self.baseView.frame.size.width, 40);
}
- (void)hideKeyBoard {
    if (self.replayTextField.isFirstResponder) {
        [self.replayTextField resignFirstResponder];
    }
}
- (NSString *)getSecretWithPaymentCode:(NSString *)paymentCode time:(long)time {
    NSMutableString *str1 = [NSMutableString string];
    [str1 appendString:APIKEY];
    [str1 appendString:[NSString stringWithFormat:@"%ld",time]];
    [str1 appendString:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:[_countTextField.text doubleValue]]]];
    [str1 appendString:paymentCode];
    str1 = [[g_server getMD5String:str1] mutableCopy];
    [str1 appendString:g_myself.userId];
    [str1 appendString:g_server.access_token];
    str1 = [[g_server getMD5String:str1] mutableCopy];
    return [str1 copy];
}
- (NSString *)getSecretWithtime:(long)time {
    NSMutableString *str1 = [NSMutableString string];
    [str1 appendString:APIKEY];
    [str1 appendString:[NSString stringWithFormat:@"%ld",time]];
    [str1 appendString:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:[_countTextField.text doubleValue]]]];
    [str1 appendString:[self.verVC getMD5Password]];
    str1 = [[g_server getMD5String:str1] mutableCopy];
    [str1 appendString:g_myself.userId];
    [str1 appendString:g_server.access_token];
    str1 = [[g_server getMD5String:str1] mutableCopy];
    return [str1 copy];
}
@end
