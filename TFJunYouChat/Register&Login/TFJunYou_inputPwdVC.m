#import "TFJunYou_inputPwdVC.h"
#import "TFJunYou_PSRegisterBaseVC.h"
#define HEIGHT 44
@interface TFJunYou_inputPwdVC ()<UITextFieldDelegate>
@end
@implementation TFJunYou_inputPwdVC
- (id)init
{
    self = [super init];
    if (self) {
        self.isGotoBack   = YES;
        self.title = [NSString stringWithFormat:@"%@",Localized(@"JX_PassWord")];
        self.heightFooter = 0;
        self.heightHeader = TFJunYou__SCREEN_TOP;
        [self createHeadAndFoot];
        self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
        int n = INSETS;
        _pwd = [[UITextField alloc] initWithFrame:CGRectMake(INSETS,n,WIDTH,HEIGHT)];
        _pwd.delegate = self;
        _pwd.autocorrectionType = UITextAutocorrectionTypeNo;
        _pwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _pwd.enablesReturnKeyAutomatically = YES;
        _pwd.borderStyle = UITextBorderStyleRoundedRect;
        _pwd.returnKeyType = UIReturnKeyDone;
        _pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwd.placeholder = Localized(@"JX_InputPassWord");
        _pwd.secureTextEntry = YES;
        [self.tableBody addSubview:_pwd];
        n = n+HEIGHT+INSETS;
        _repeat = [[UITextField alloc] initWithFrame:CGRectMake(INSETS,n,WIDTH,HEIGHT)];
        _repeat.delegate = self;
        _repeat.autocorrectionType = UITextAutocorrectionTypeNo;
        _repeat.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _repeat.enablesReturnKeyAutomatically = YES;
        _repeat.borderStyle = UITextBorderStyleRoundedRect;
        _repeat.returnKeyType = UIReturnKeyDone;
        _repeat.clearButtonMode = UITextFieldViewModeWhileEditing;
        _repeat.placeholder = Localized(@"JX_ConfirmPassWord");
        _repeat.secureTextEntry = YES;
        [self.tableBody addSubview:_repeat];
        n = n+HEIGHT+INSETS;
        UIButton* _btn = [UIFactory createCommonButton:Localized(@"JX_NextStep") target:self action:@selector(onClick)];
        _btn.custom_acceptEventInterval = .25f;
        _btn.frame = CGRectMake(INSETS, n, WIDTH, HEIGHT);
        [self.tableBody addSubview:_btn];
    }
    return self;
}
-(void)dealloc{
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)onClick{
    if([_pwd.text length]<=0){
        [g_App showAlert:Localized(@"JX_InputPassWord")];
        return;
    }
    if([_repeat.text length]<=0){
        [g_App showAlert:Localized(@"JX_ConfirmPassWord")];
        return;
    }
    if(![_pwd.text isEqualToString:_repeat.text]){
        [g_App showAlert:Localized(@"JX_PasswordFiled")];
        return;
    }
    TFJunYou_UserObject* user = [TFJunYou_UserObject sharedInstance];
    user.telephone = _telephone;
    user.password  = [g_server getMD5String:_pwd.text];
    user.companyId = [NSNumber numberWithInt:self.isCompany];
    TFJunYou_PSRegisterBaseVC* vc = [TFJunYou_PSRegisterBaseVC alloc];
    vc.password = _pwd.text;
    vc.isRegister = YES;
    vc.resumeId   = nil;
    vc.resumeModel     = [[resumeBaseData alloc]init];
    vc.user       = user;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
    [self actionQuit];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
@end
