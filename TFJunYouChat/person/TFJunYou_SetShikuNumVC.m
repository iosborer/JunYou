#import "TFJunYou_SetShikuNumVC.h"
#define HEIGHT 50
@interface TFJunYou_SetShikuNumVC () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *baseView;
@end
@implementation TFJunYou_SetShikuNumVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isGotoBack   = YES;
    self.title = [NSString stringWithFormat:@"%@%@",Localized(@"JXSettingVC_Set"),Localized(@"JX_Communication")];
    self.heightFooter = 0;
    self.heightHeader = TFJunYou__SCREEN_TOP;
    [self createHeadAndFoot];
    self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
    self.tableBody.scrollEnabled = YES;
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, TFJunYou__SCREEN_WIDTH-30, 270)];
    self.baseView.backgroundColor = [UIColor whiteColor];
    self.baseView.layer.masksToBounds = YES;
    self.baseView.layer.cornerRadius = 7.f;
    [self.tableBody addSubview:self.baseView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 44, 44)];
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.layer.masksToBounds = YES;
    [g_server getHeadImageLarge:g_myself.userId userName:g_myself.userNickname imageView:imageView];
    [self.baseView addSubview:imageView];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 15, imageView.frame.origin.y, 200, imageView.frame.size.height)];
    name.font = [UIFont systemFontOfSize:15.0];
    name.text = g_myself.userNickname;
    [self.baseView addSubview:name];
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imageView.frame) + 30, self.baseView.frame.size.width - 30, 40)];
    _textField.delegate = self;
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 7.f;
    [_textField becomeFirstResponder];
    _textField.backgroundColor = HEXCOLOR(0xF6F7F9);
    _textField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.baseView addSubview:_textField];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_textField.frame)+10, _textField.frame.size.width, 13)];
    tip.font = [UIFont systemFontOfSize:13.0];
    tip.textColor = HEXCOLOR(0x999999);
    tip.text = Localized(@"JX_CommunicationOnlySetOne");
    [self.baseView addSubview:tip];
    UIButton* _btn = [UIFactory createCommonButton:Localized(@"JX_Confirm") target:self action:@selector(onConfirm)];
    _btn.layer.cornerRadius = 7;
    _btn.clipsToBounds = YES;
    _btn.custom_acceptEventInterval = 1.0f;
    _btn.titleLabel.font = SYSFONT(16);
    _btn.frame = CGRectMake(15, CGRectGetMaxY(tip.frame) + 30, self.baseView.frame.size.width - 30, 40);
    [self.baseView addSubview:_btn];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.tableBody addGestureRecognizer:tap];
}
- (void)tapAction{
    [self.view endEditing:YES];
}
- (void)onConfirm {
    self.user.account = _textField.text;
    g_myself.account = self.user.account;
    [g_server updateShikuNum:self.user toView:self];
}
-(BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    NSUInteger lengthOfString = string.length;
    for(NSInteger loopIndex =0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex];
        if(character <48) return NO;
        if(character >57&& character <65) return NO;
        if(character >90&& character <97) return NO;
        if(character >122) return NO;
    }
    return YES;
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if( [aDownload.action isEqualToString:act_UserUpdate] ){
        self.user.setAccountCount = [NSString stringWithFormat:@"%ld",([g_myself.setAccountCount integerValue] + 1)];
        g_myself.setAccountCount = self.user.setAccountCount;
        if ([self.delegate respondsToSelector:@selector(setShikuNum:updateSuccessWithAccount:)]) {
            [self.delegate setShikuNum:self updateSuccessWithAccount:self.user.account];
            [self actionQuit];
        }
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
@end
