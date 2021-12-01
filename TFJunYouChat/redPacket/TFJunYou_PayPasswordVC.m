#import "TFJunYou_PayPasswordVC.h"
#import "UIImage+Color.h"
#import "TFJunYou_MoneyMenuViewController.h"
#import "TFJunYou_TextField.h"
#import "TFJunYou_UserObject.h"
#import "TFJunYou_SendRedPacketViewController.h"
#import "TFJunYou_CashWithDrawViewController.h"
#import "TFJunYou_TransferViewController.h"
#import "TFJunYou_InputMoneyVC.h"
#import "webpageVC.h"
#import "TFJunYou_PayViewController.h"
#define kDotSize CGSizeMake (10, 10) 
#define kDotCount 6  
#define K_Field_Height 45  
@interface TFJunYou_PayPasswordVC () <UITextFieldDelegate>
@property (nonatomic, strong) TFJunYou_TextField *textField;
@property (nonatomic, strong) NSMutableArray *dotArray; 
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UIButton *nextBtn;
@end
@implementation TFJunYou_PayPasswordVC
- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self setupViews];
        [self initPwdTextField];
        [self setupTitle];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField becomeFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)setupViews {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP - 46, 46, 46)];
    [btn setBackgroundImage:[UIImage imageNamed:@"title_back_black_big"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didDissVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.titleLab.frame = CGRectMake(0, 160, TFJunYou__SCREEN_WIDTH, 30);
    self.detailLab.frame = CGRectMake(0, CGRectGetMaxY(self.titleLab.frame)+30, TFJunYou__SCREEN_WIDTH, 17);
    self.textField.frame = CGRectMake(30, CGRectGetMaxY(self.detailLab.frame)+70, TFJunYou__SCREEN_WIDTH - 30*2, K_Field_Height);
    self.nextBtn.frame = CGRectMake(self.textField.frame.origin.x, CGRectGetMaxY(self.textField.frame)+25, TFJunYou__SCREEN_WIDTH-30*2, 40);
    [self.view addSubview:self.textField];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.detailLab];
    [self.view addSubview:self.nextBtn];
}
- (void)didDissVC {
    if (self.type == TFJunYou_PayTypeInputPassword) {
        [self goBackToVC];
    }else {
        [g_App showAlert:Localized(@"JX_CancelPayPsw") delegate:self];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self goBackToVC];
    }
}
- (void)setupTitle {
    if (self.type == TFJunYou_PayTypeSetupPassword) {  
        [self.nextBtn setHidden:YES];
        self.titleLab.text = Localized(@"JX_SetPayPsw");
        self.detailLab.text = Localized(@"JX_SetPayPswNo.1");
    } else if (self.type == TFJunYou_PayTypeRepeatPassword) { 
        [self.nextBtn setHidden:NO];
        self.titleLab.text = Localized(@"JX_SetPayPsw");
        self.detailLab.text = Localized(@"JX_SetPayPswNo.2");
    } else if (self.type == TFJunYou_PayTypeInputPassword) { 
        [self.nextBtn setHidden:YES];
        self.titleLab.text = Localized(@"JX_UpdatePassWord");
        self.detailLab.text = Localized(@"JX_EnterToVerify");
    }
}
- (void)didNextButton {
    if ([self.textField.text length] < 6) {
        [g_App showAlert:Localized(@"JX_PswError")];
        [self clearUpPassword];
        return;
    }
    if (![self.textField.text isEqualToString:self.lastPsw]) {
        [g_App showAlert:Localized(@"JX_NotMatch")];
        [self goToSetupTypeVCWithOld:NO];
        return;
    }
    if ([self.textField.text isEqualToString:self.oldPsw]) {
        [g_App showAlert:Localized(@"JX_NewEqualOld")];
        [self goToSetupTypeVCWithOld:NO];
        return;
    }
    if(self.type == TFJunYou_PayTypeRepeatPassword) {
        TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
        user.payPassword = self.textField.text;
        user.oldPayPassword = self.oldPsw;
        [g_server updatePayPasswordWithUser:user toView:self];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)initPwdTextField {
    CGFloat width = (TFJunYou__SCREEN_WIDTH - 30*2) / kDotCount;
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, CGRectGetMinY(self.textField.frame), 0.5, K_Field_Height)];
        lineView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:lineView];
    }
    self.dotArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; 
        [self.view addSubview:dotView];
        [self.dotArray addObject:dotView];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        return YES;
    }
    else if(textField.text.length >= kDotCount) {
        return NO;
    } else {
        return YES;
    }
}
- (void)clearUpPassword {
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}
- (void)textFieldDidChange:(UITextField *)textField {
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length >= kDotCount) {
        if (self.type == TFJunYou_PayTypeSetupPassword) {
            TFJunYou_PayPasswordVC *payVC = [TFJunYou_PayPasswordVC alloc];
            payVC.delegate = self.delegate;
            payVC.type = TFJunYou_PayTypeRepeatPassword;
            payVC.enterType = self.enterType;
            payVC.lastPsw = self.textField.text;
            payVC.oldPsw = self.oldPsw;
            payVC = [payVC init];
            [g_navigation pushViewController:payVC animated:YES];
        }else if(self.type == TFJunYou_PayTypeRepeatPassword) {
            [self.nextBtn setUserInteractionEnabled:YES];
            [_nextBtn setBackgroundColor:THEMECOLOR];
        } else if(self.type == TFJunYou_PayTypeInputPassword) {
            TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
            user.payPassword = self.textField.text;
            [g_server checkPayPasswordWithUser:user toView:self];
        }
    }else {
        [self.nextBtn setUserInteractionEnabled:NO];
        [_nextBtn setBackgroundColor:[THEMECOLOR colorWithAlphaComponent:0.5]];
    }
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if([aDownload.action isEqualToString:act_UpdatePayPassword]){
        [self.textField resignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(updatePayPasswordSuccess:)]) {
            [self.delegate updatePayPasswordSuccess:self.textField.text];
        }
        [self clearUpPassword];
        [g_App showAlert:Localized(@"JX_SetUpSuccess")];
        g_server.myself.isPayPassword = [dict objectForKey:@"payPassword"];
        [self goBackToVC];
    }
    if([aDownload.action isEqualToString:act_CheckPayPassword]){
        [self goToSetupTypeVCWithOld:YES];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait stop];
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}
- (void)goBackToVC {
    if (self.enterType == TFJunYou_EnterTypeDefault) {
        [g_navigation popToViewController:[TFJunYou_MoneyMenuViewController class] animated:YES];
    }
    else if (self.enterType == TFJunYou_EnterTypeWithdrawal){
        [g_navigation popToViewController:[TFJunYou_CashWithDrawViewController class] animated:YES];
    }
    else if (self.enterType == TFJunYou_EnterTypeTransfer){
        [g_navigation popToViewController:[TFJunYou_TransferViewController class] animated:YES];
    }
    else if (self.enterType == TFJunYou_EnterTypeQr){
        [g_navigation popToViewController:[TFJunYou_InputMoneyVC class] animated:YES];
    }
    else if (self.enterType == TFJunYou_EnterTypeSkPay){
        [g_navigation popToViewController:[webpageVC class] animated:YES];
    }
    else if (self.enterType == TFJunYou_EnterTypePayQr){
        [g_navigation popToViewController:[TFJunYou_PayViewController class] animated:YES];
    }
    else {
        [g_navigation popToViewController:[TFJunYou_SendRedPacketViewController class] animated:YES];
    }
}
- (void)goToSetupTypeVCWithOld:(BOOL)isOld {
    TFJunYou_PayPasswordVC *payVC = [TFJunYou_PayPasswordVC alloc];
    payVC.delegate = self.delegate;
    payVC.type = TFJunYou_PayTypeSetupPassword;
    payVC.enterType = self.enterType;
    payVC.lastPsw = self.textField.text;
    payVC.oldPsw = isOld ? self.textField.text : self.oldPsw;
    payVC = [payVC init];
    [g_navigation pushViewController:payVC animated:YES];
}
#pragma mark - init
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[TFJunYou_TextField alloc] init];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.textColor = [UIColor whiteColor];
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.layer.borderColor = [[UIColor blackColor] CGColor];
        _textField.layer.borderWidth = 0.5;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = SYSFONT(26);
    }
    return _titleLab;
}
- (UILabel *)detailLab {
    if (!_detailLab) {
        _detailLab = [[UILabel alloc] init];
        _detailLab.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLab;
}
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn setTitle:Localized(@"JX_Finish") forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:[THEMECOLOR colorWithAlphaComponent:0.6]];
        _nextBtn.userInteractionEnabled = NO;
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 4.f;
        [self.nextBtn setHidden:YES];
        [_nextBtn addTarget:self action:@selector(didNextButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
@end
