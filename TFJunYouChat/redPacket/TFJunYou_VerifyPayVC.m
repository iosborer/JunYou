#import "TFJunYou_VerifyPayVC.h"
#import "TFJunYou_TextField.h"
#define kDotSize CGSizeMake (10, 10) 
#define kDotCount 6  
#define K_Field_Height 45  
@interface TFJunYou_VerifyPayVC () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *RMBLab;
@property (nonatomic, strong) TFJunYou_TextField *textField;
@property (nonatomic, strong) NSMutableArray *dotArray; 
@property (nonatomic, strong) UIButton *disBtn;
@end
@implementation TFJunYou_VerifyPayVC
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
        [self initPwdTextField];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.modalPresentationStyle = UIModalPresentationCustom;
    [self.textField becomeFirstResponder];
}
- (void)setupViews {
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(30, 160, TFJunYou__SCREEN_WIDTH-60, 232)];
    self.baseView.backgroundColor = [UIColor whiteColor];
    self.baseView.layer.masksToBounds = YES;
    self.baseView.layer.cornerRadius = 6.f;
    [self.view addSubview:self.baseView];
    self.disBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];    
    [self.disBtn addTarget:self action:@selector(didDismissVerifyPayVC) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:self.disBtn];
    UIImageView *dis = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35/2, 18, 18)];
    dis.image = [UIImage imageNamed:@"pay_cha"];
    [self.disBtn addSubview:dis];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.baseView.frame.size.width, 22)];
    titleLab.text = Localized(@"JX_EnterPayPsw");
    titleLab.font = [UIFont boldSystemFontOfSize:19];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.baseView addSubview:titleLab];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame)+15, self.baseView.frame.size.width, LINE_WH)];
    line.backgroundColor = THE_LINE_COLOR;
    [self.baseView addSubview:line];
    self.typeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+15, self.baseView.frame.size.width, 20)];
    self.typeLab.textAlignment = NSTextAlignmentCenter;
    self.typeLab.font = SYSFONT(17);
    self.typeLab.text = [self getTypeTitle];
    [self.baseView addSubview:self.typeLab];
    if (self.type != TFJunYou_VerifyTypePaymentCode) {
        self.RMBLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.typeLab.frame)+11, self.baseView.frame.size.width, 50)];
        self.RMBLab.textAlignment = NSTextAlignmentCenter;
        self.RMBLab.font = SYSFONT(46);
        self.RMBLab.text = [NSString stringWithFormat:@"¥%.2f",[self.RMB doubleValue]];
        [self.baseView addSubview:self.RMBLab];
        self.textField.frame = CGRectMake(16, CGRectGetMaxY(self.RMBLab.frame)+20, self.baseView.frame.size.width - 32, K_Field_Height);
    }else {
        self.textField.frame = CGRectMake(16, CGRectGetMaxY(self.typeLab.frame)+20, self.baseView.frame.size.width - 32, K_Field_Height);
        self.baseView.frame = CGRectMake(self.baseView.frame.origin.x, self.baseView.frame.origin.y, self.baseView.frame.size.width, CGRectGetMaxY(self.textField.frame) + 20);
    }
    if (self.type == TFJunYou_VerifyTypeUserCancel) {
        self.RMBLab.hidden = YES;
    }
    
    [self.baseView addSubview:self.textField];
}
- (NSString *)getTypeTitle {
    NSString *string;
    if (self.type == TFJunYou_VerifyTypeWithdrawal) {
        string = Localized(@"JXMoney_withdrawals");
    }
    if (self.type == TFJunYou_VerifyTypeUserCancel) {
        string = @"注销账号";
    }
    else if (self.type == TFJunYou_VerifyTypeTransfer) {
        string = Localized(@"JX_Transfer");
    }
    else if (self.type == TFJunYou_VerifyTypeQr) {
        string = Localized(@"JX_Payment");
    }
    else if (self.type == TFJunYou_VerifyTypeSkPay) {
        string = self.titleStr;
    }
    else if (self.type == TFJunYou_VerifyTypePaymentCode) {
        string = @"开启付款码";
    }
    else {
        string = Localized(@"JX_ShikuRedPacket");
    }
    return string;
}
- (void)didDismissVerifyPayVC {
    if (self.delegate && [self.delegate respondsToSelector:self.didDismissVC]) {
        [self.delegate performSelectorOnMainThread:self.didDismissVC withObject:self waitUntilDone:NO];
    }
}
- (void)initPwdTextField
{
    CGFloat width = (self.baseView.frame.size.width - 32) / kDotCount;
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, CGRectGetMinY(self.textField.frame), LINE_WH, K_Field_Height)];
        lineView.backgroundColor = [UIColor blackColor];
        [self.baseView addSubview:lineView];
    }
    self.dotArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; 
        [self.baseView addSubview:dotView];
        [self.dotArray addObject:dotView];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
- (void)clearUpPassword
{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}
- (NSString *)getMD5Password {
    return [g_server getMD5String:self.textField.text];
}
- (void)textFieldDidChange:(UITextField *)textField
{
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == kDotCount) {
        if (self.delegate && [self.delegate respondsToSelector:self.didDismissVC]) {
            [self.delegate performSelectorOnMainThread:self.didVerifyPay withObject:self.textField.text waitUntilDone:NO];
        }
    }
}
#pragma mark - init
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[TFJunYou_TextField alloc] init];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.textColor = [UIColor whiteColor];
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.layer.borderColor = [[UIColor blackColor] CGColor];
        _textField.layer.borderWidth = LINE_WH;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
@end
