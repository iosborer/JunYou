#import "TFJunYou_JLApplyForWithdrawalVC.h"
#import "TFJunYou_JLWithdrawalRecordVC.h"
#import "GALCaptcha.h"
#define HEIGHT 50
@interface TFJunYou_JLApplyForWithdrawalVC ()
@property (nonatomic, strong) GALCaptcha *imgCodeImg;
@property (nonatomic, strong) UIButton *btn;
@end
@implementation TFJunYou_JLApplyForWithdrawalVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请提现";
    self.isGotoBack = YES;
     self.heightFooter = 0;
     self.heightHeader = TFJunYou__SCREEN_TOP;
     [self createHeadAndFoot];
     [self setupUI];
}
- (void)setupUI {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = @"提现记录";
    label.font = g_factory.font14;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:label];
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightButtonClick)]];
    label.userInteractionEnabled = YES;
    [self setRightBarButtonItem:item];
    [self createCustomView];
}
- (void)rightButtonClick {
    TFJunYou_JLWithdrawalRecordVC *vc = [[TFJunYou_JLWithdrawalRecordVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}
- (void)createCustomView {
    int h = 0;
    TFJunYou_ImageView* iv;
    iv = [[TFJunYou_ImageView alloc]init];
    iv.frame = self.tableBody.bounds;
    iv.delegate = self;
    iv.didTouch = @selector(hideKeyBoardToView);
    [self.tableBody addSubview:iv];
    iv = [self createButton:@"姓名:" drawTop:YES drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _platformName = [self createTextField:iv default:@"" hint:@"请输入姓名" keyboardType:(UIKeyboardTypeDefault)];
    h+=iv.frame.size.height;
    iv = [self createButton:@"银行卡号:" drawTop:YES drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _account = [self createTextField:iv default:@"" hint:@"银行卡号"keyboardType:(UIKeyboardTypeDefault)];
    h+=iv.frame.size.height;
    iv = [self createButton:@"提现金额:" drawTop:YES drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _amount = [self createTextField:iv default:@"" hint:@"请输入提现金额"keyboardType:(UIKeyboardTypeDecimalPad)];
    h+=iv.frame.size.height;
    iv = [self createButton:@"开户行:" drawTop:YES drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _reason = [self createTextField:iv default:@"" hint:@"请输入开户行"keyboardType:(UIKeyboardTypeDefault)];
    h+=iv.frame.size.height;
    iv = [self createButton:@"描述:" drawTop:YES drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _remark = [self createTextField:iv default:@"" hint:@"请输入描述"keyboardType:(UIKeyboardTypeDefault)];
    h+=iv.frame.size.height;
    iv = [self createButton:@"验证码:" drawTop:YES drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    h+=iv.frame.size.height+INSETS;
   _verifyCode = [UIFactory createTextFieldWith:CGRectMake(TFJunYou__SCREEN_WIDTH/2,INSETS,TFJunYou__SCREEN_WIDTH/4,HEIGHT-INSETS*2) delegate:self returnKeyType:UIReturnKeyNext secureTextEntry:NO placeholder:@"请输入验证码" font:g_factory.font15];
    _verifyCode.keyboardType = UIKeyboardTypeASCIICapable;
   _verifyCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
   _verifyCode.borderStyle = UITextBorderStyleNone;
   _verifyCode.clearButtonMode = UITextFieldViewModeWhileEditing;
   [iv addSubview:_verifyCode];
    _imgCodeImg = [[GALCaptcha alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_verifyCode.frame)+INSETS, 0, 70, 35)];
    _imgCodeImg.center = CGPointMake(_imgCodeImg.center.x, _verifyCode.center.y);
    _imgCodeImg.userInteractionEnabled = YES;
    [iv addSubview:_imgCodeImg];
    _btn = [UIFactory createCommonButton:@"提交" target:self action:@selector(submit)];
    [_btn.titleLabel setFont:g_factory.font16];
   _btn.frame = CGRectMake(10, h, TFJunYou__SCREEN_WIDTH-10*2, 40);
   _btn.layer.masksToBounds = YES;
   _btn.layer.cornerRadius = 5;
   [self.tableBody addSubview:_btn];
}
- (void)submit {
    _btn.userInteractionEnabled = NO;
    [_wait show];
    [self hideKeyBoardToView];
    if (![_imgCodeImg.CatString.lowercaseString isEqualToString:_verifyCode.text.lowercaseString]) {
        [g_App showAlert:@"验证码错误"];
       _btn.userInteractionEnabled = YES;
        [_wait stop];
        return;
    }
    if(_platformName.text.length<1 || _account.text.length<1 || _amount.text.length<1 || _reason.text.length<1 || _verifyCode.text.length<1){
        [g_App showAlert:@"请您填写完整的信息"];
        _btn.userInteractionEnabled = YES;
        [_wait stop];
        return;
    }
    NSString *userId = [g_default objectForKey:kMY_USER_ID];
    NSString *userName = [g_default objectForKey:kMY_USER_NICKNAME];
    [g_server addWithdrawlPlatformName:_platformName.text account:_account.text amount:_amount.text reason:_reason.text remark:_remark.text verifyCode:_verifyCode.text userId:userId userName:userName toView:self];
}
-(void)didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if([aDownload.action isEqualToString:act_addWithdrawl]){
        [TFJunYou_MyTools showTipView:@"提交成功"];
        _platformName.text = @"";
        _account.text = @"";
        _amount.text = @"";
        _reason.text = @"";
        _remark.text = @"";
        _verifyCode.text = @"";
        [_imgCodeImg refresh];
        _btn.userInteractionEnabled = YES;
        TFJunYou_JLWithdrawalRecordVC *vc = [[TFJunYou_JLWithdrawalRecordVC alloc] init];
        [g_App.navigation pushViewController:vc animated:YES];
    }
}
- (void)hideKeyBoardToView {
    [self.tableBody endEditing:YES];
}
-(TFJunYou_ImageView*)createButton:(NSString*)title drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom must:(BOOL)must click:(SEL)click{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    if(click)
        btn.didTouch = click;
    else
        btn.didTouch = @selector(hideKeyBoardToView);
    btn.delegate = self;
    [self.tableBody addSubview:btn];
    if(must){
        UILabel* p = [[UILabel alloc] initWithFrame:CGRectMake(INSETS, 5, 20, HEIGHT-5)];
        p.text = @"*";
        p.font = g_factory.font18;
        p.backgroundColor = [UIColor clearColor];
        p.textColor = [UIColor redColor];
        p.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:p];
    }
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(20, 0, 130, HEIGHT)];
    p.text = title;
    p.font = g_factory.font15;
    p.backgroundColor = [UIColor clearColor];
    p.textColor = [UIColor blackColor];
    [btn addSubview:p];
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0,0,TFJunYou__SCREEN_WIDTH,0.5)];
        line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [btn addSubview:line];
    }
    if(drawBottom){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT-0.5,TFJunYou__SCREEN_WIDTH,0.5)];
        line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [btn addSubview:line];
    }
    if(click){
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-INSETS-20-3, 15, 20, 20)];
        iv.image = [UIImage imageNamed:@"set_list_next"];
        [btn addSubview:iv];
    }
    return btn;
}
-(UITextField*)createTextField:(UIView*)parent default:(NSString*)s hint:(NSString*)hint keyboardType:(UIKeyboardType)keyboardType {
    UITextField* p = [[UITextField alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH/2,INSETS,TFJunYou__SCREEN_WIDTH/2,HEIGHT-INSETS*2)];
    p.delegate = self;
    p.autocorrectionType = UITextAutocorrectionTypeNo;
    p.autocapitalizationType = UITextAutocapitalizationTypeNone;
    p.enablesReturnKeyAutomatically = YES;
    p.borderStyle = UITextBorderStyleNone;
    p.returnKeyType = UIReturnKeyDone;
    p.clearButtonMode = UITextFieldViewModeAlways;
    p.textAlignment = NSTextAlignmentRight;
    p.userInteractionEnabled = YES;
    p.text = s;
    p.placeholder = hint;
    p.font = g_factory.font15;
    p.keyboardType = keyboardType;
    [parent addSubview:p];
    return p;
}
@end
