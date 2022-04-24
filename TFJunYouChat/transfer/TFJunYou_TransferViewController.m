#import "TFJunYou_TransferViewController.h"
#import "UIImage+Color.h"
#import "TFJunYou_VerifyPayVC.h"
#import "TFJunYou_PayPasswordVC.h"
#define drawMarginX 25
#define bgWidth TFJunYou__SCREEN_WIDTH-15*2
#define drawHei 60
@interface TFJunYou_TransferViewController () <UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UITextField * countTextField;
@property (nonatomic, strong) UIButton *transferBtn;
@property (nonatomic, strong) UILabel *addDscLab;
@property (nonatomic, strong) UILabel *dscLab;
@property (nonatomic, strong) NSString *desContent;
@property (nonatomic, strong) TFJunYou_VerifyPayVC *verVC;
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *replayTitle;
@property (nonatomic, strong) UITextField *replayTextField;
@end
@implementation TFJunYou_TransferViewController
- (instancetype)init {
    if (self = [super init]) {
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.isGotoBack = YES;
        [self createHeadAndFoot];
        [self setupViews];
        [self setupReplayView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"JX_Transfer");
}
- (void)setupViews {
   self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
   UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, TFJunYou__SCREEN_WIDTH-30, 275)];
   baseView.backgroundColor = [UIColor whiteColor];
   baseView.layer.cornerRadius = 3.f;
   baseView.layer.masksToBounds = YES;
   [self.tableBody addSubview:baseView];
   UILabel *trLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 60, 16)];
   trLab.text =@"转账给";
   trLab.font = SYSFONT(16);
   [baseView addSubview:trLab];
   UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(baseView.frame.size.width-20-20, 10, 20, 20)];
   icon.layer.masksToBounds = YES;
   icon.layer.cornerRadius = icon.frame.size.width/2;
   [baseView addSubview:icon];
   NSString *name = _user.remarkName.length > 0 ? _user.remarkName : _user.userNickname;
   [g_server getHeadImageLarge:_user.userId userName:name imageView:icon];
   CGSize size = [name sizeWithAttributes:@{NSFontAttributeName:SYSFONT(15)}];
   UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(baseView.frame.size.width-40-15-size.width, 12, size.width, size.height)];
   nameLabel.font = SYSFONT(15);
   nameLabel.text = name;
   [baseView addSubview:nameLabel];
   UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(trLab.frame)+15, baseView.frame.size.width-20, LINE_WH)];
   topLine.backgroundColor = THE_LINE_COLOR;
   [baseView addSubview:topLine];
   UILabel * cashTitle = [UIFactory createLabelWith:CGRectMake(20, CGRectGetMaxY(topLine.frame)+19, 120, 15) text:Localized(@"JX_TransferAmount")];
   cashTitle.font = SYSFONT(15);
   [baseView addSubview:cashTitle];
   UILabel * rmbLabel = [UIFactory createLabelWith:CGRectMake(20, CGRectGetMaxY(cashTitle.frame)+54, 17, 22) text:@"¥"];
   rmbLabel.font = SYSFONT(22);
   rmbLabel.textAlignment = NSTextAlignmentLeft;
   [baseView addSubview:rmbLabel];
   _countTextField = [UIFactory createTextFieldWithRect:CGRectMake(CGRectGetMaxX(rmbLabel.frame)+15, CGRectGetMaxY(cashTitle.frame)+46, TFJunYou__SCREEN_WIDTH-95, 32) keyboardType:UIKeyboardTypeDecimalPad secure:NO placeholder:nil font:[UIFont boldSystemFontOfSize:45] color:[UIColor blackColor] delegate:self];
   _countTextField.borderStyle = UITextBorderStyleNone;
   _countTextField.font = SYSFONT(30);
   [_countTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
   [baseView addSubview:_countTextField];
   UIView * line = [[UIView alloc] init];
   line.frame = CGRectMake(drawMarginX, CGRectGetMaxY(_countTextField.frame)+5, bgWidth-drawMarginX*2, LINE_WH);
   line.backgroundColor = THE_LINE_COLOR;
   [baseView addSubview:line];
   _transferBtn = [UIFactory createButtonWithRect:CGRectZero title:Localized(@"JX_Transfer") titleFont:g_factory.font15 titleColor:[UIColor whiteColor] normal:nil selected:nil selector:@selector(transferBtnAction:) target:self];
   _transferBtn.tag = 1000;
   _transferBtn.frame = CGRectMake(20, CGRectGetMaxY(rmbLabel.frame)+30, baseView.frame.size.width-40, 43);
   [_transferBtn setBackgroundImage:[UIImage createImageWithColor:THEMECOLOR] forState:UIControlStateNormal];
   [_transferBtn setBackgroundImage:[UIImage createImageWithColor:[THEMECOLOR colorWithAlphaComponent:0.8f]] forState:UIControlStateDisabled];
   _transferBtn .layer.cornerRadius = 7;
   _transferBtn.clipsToBounds = YES;
   _transferBtn.enabled = NO;
   _dscLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_transferBtn.frame)+15, 0, 0)];
   _dscLab.font = SYSFONT(13);
   [baseView addSubview:_dscLab];
   _addDscLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_transferBtn.frame)+15, 120, 18)];
   _addDscLab.text = Localized(@"JX_AddTransferInstructions");
   _addDscLab.textColor = HEXCOLOR(0x6E7B8F);
   _addDscLab.userInteractionEnabled = YES;
   _addDscLab.font = SYSFONT(13);
   [baseView addSubview:_addDscLab];
   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSendTransferDsc)];
   [_addDscLab addGestureRecognizer:tap];
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
    _replayTitle.text = Localized(@"JX_TransferInstructions");
    [self.baseView addSubview:_replayTitle];
    n = n + height;
    self.replayTextField = [self createTextField:self.baseView default:nil hint:nil];
    self.replayTextField.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    self.replayTextField.frame = CGRectMake(10, n, self.baseView.frame.size.width - INSETS*2, 35.5);
    self.replayTextField.delegate = self;
    self.replayTextField.textColor = HEXCOLOR(0x595959);
    self.replayTextField.placeholder = Localized(@"JX_Maximum10Words");
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
- (void)hideBigView {
    [self resignKeyBoard];
}
- (void)onRelease {
    [self resignKeyBoard];
    self.desContent = _replayTextField.text;
    _dscLab.text = self.desContent;
   _addDscLab.text = self.desContent.length > 0 ? Localized(@"JX_Modify") : Localized(@"JX_AddTransferInstructions");
    CGSize size = [self.desContent sizeWithAttributes:@{NSFontAttributeName:SYSFONT(17)}];
    _dscLab.frame = CGRectMake(drawMarginX, _dscLab.frame.origin.y, size.width, 18);
    _addDscLab.frame = CGRectMake(CGRectGetMaxX(_dscLab.frame)+5, _addDscLab.frame.origin.y, 120, 18);
}
#pragma mark - 转账
- (void)transferBtnAction:(UIButton *)button {
   if ([g_server.myself.isPayPassword boolValue]) {
      self.verVC = [TFJunYou_VerifyPayVC alloc];
      self.verVC.type = TFJunYou_VerifyTypeTransfer;
      self.verVC.RMB = self.countTextField.text;
      self.verVC.delegate = self;
      self.verVC.didDismissVC = @selector(dismissVerifyPayVC);
      self.verVC.didVerifyPay = @selector(didVerifyPay:);
      self.verVC = [self.verVC init];
      [self.view addSubview:self.verVC.view];
   } else {
      TFJunYou_PayPasswordVC *payPswVC = [TFJunYou_PayPasswordVC alloc];
      payPswVC.type = TFJunYou_PayTypeSetupPassword;
      payPswVC.enterType = TFJunYou_EnterTypeTransfer;
      payPswVC = [payPswVC init];
      [g_navigation pushViewController:payPswVC animated:YES];
   }
}
- (void)didVerifyPay:(NSString *)sender {
   long time = (long)[[NSDate date] timeIntervalSince1970];
   time = (time *1000 + g_server.timeDifference)/1000;
   NSString *secret = [self getSecretWithText:sender time:time];
   NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"toUserId",_user.userId,@"money",_countTextField.text,@"remark",_replayTextField.text, nil];
   [g_payServer payServerWithAction:act_sendTransferV1 param:arr payPassword:sender time:time toView:self];
}
- (void)dismissVerifyPayVC {
   [self.verVC.view removeFromSuperview];
}
- (void)showSendTransferDsc{
    self.bigView.hidden = NO;
    [self.replayTextField becomeFirstResponder];
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
   if( [aDownload.action isEqualToString:act_sendTransfer] || [aDownload.action isEqualToString:act_sendTransferV1]){
      [self dismissVerifyPayVC];  
      if (self.delegate && [self.delegate respondsToSelector:@selector(transferToUser:)]) {
         [self.delegate performSelector:@selector(transferToUser:) withObject:dict];
      }
      [self actionQuit];
   }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
   [_wait stop];
   if ([aDownload.action isEqualToString:act_TransactionGetCode] || [aDownload.action isEqualToString:act_sendTransferV1]) {
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
- (NSString *)getSecretWithText:(NSString *)text time:(long)time {
    NSString *str1 = [NSString stringWithFormat:@"%@%ld%@", APIKEY, time, _countTextField.text];
    str1 = [g_server getMD5String:str1];
    str1 = [str1 stringByAppendingFormat:@"%@%@", g_myself.userId, g_server.access_token];
    str1 = [str1 stringByAppendingString:[g_server getMD5String:text]];

   return [g_server getMD5String:str1];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   if (scrollView == self.tableBody) {
      if ([self.countTextField isFirstResponder]) {
         [self.countTextField resignFirstResponder];
      }
   }
}
@end
