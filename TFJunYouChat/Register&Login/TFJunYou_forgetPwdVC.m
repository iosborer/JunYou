#import "TFJunYou_forgetPwdVC.h"
#import "TFJunYou_TelAreaListVC.h"
#import "TFJunYou_UserObject.h"
#import "TFJunYou_loginVC.h"
#import "MD5Util.h"
#define HEIGHT 50
@interface TFJunYou_forgetPwdVC () <UITextFieldDelegate>
{
   UIButton *_areaCodeBtn;
   NSTimer* timer;
   TFJunYou_UserObject *_user;
   UIImageView * _imgCodeImg;
   UITextField *_imgCode;   
   UIButton * _graphicButton;
}
@end
@implementation TFJunYou_forgetPwdVC
- (id)init
{
   self = [super init];
   if (self) {
   }
   return self;
}
- (void)viewDidLoad
{
   [super viewDidLoad];
   if (self.isModify) {
      self.title = Localized(@"JX_UpdatePassWord");
   }else{
      self.title = Localized(@"JX_ForgetPassWord");
   }
   _user = [TFJunYou_UserObject sharedInstance];
   _seconds = 0;
   self.isGotoBack   = YES;
   self.heightFooter = 0;
   self.heightHeader = TFJunYou__SCREEN_TOP;
   [self createHeadAndFoot];
   self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
   UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, TFJunYou__SCREEN_WIDTH-30, 300)];
   baseView.backgroundColor = [UIColor whiteColor];
   baseView.layer.cornerRadius = 7.f;
   baseView.layer.masksToBounds = YES;
   [self.tableBody addSubview:baseView];
   CGFloat W = baseView.frame.size.width;
   int n = INSETS;
   if (!_phone) {
      _phone = [UIFactory createTextFieldWith:CGRectMake(15, n, W-30, HEIGHT) delegate:self returnKeyType:UIReturnKeyNext secureTextEntry:NO placeholder:Localized(@"JX_InputPhone") font:g_factory.font16];
      _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
      _phone.borderStyle = UITextBorderStyleNone;
      [baseView addSubview:_phone];
      [self showLine:_phone];
      UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 67, HEIGHT)];
      _phone.leftView = leftView;
      _phone.leftViewMode = UITextFieldViewModeAlways;
      NSString *areaStr;
      if (![g_default objectForKey:kMY_USER_AREACODE]) {
         areaStr = @"+86";
      } else {
         areaStr = [NSString stringWithFormat:@"+%@",[g_default objectForKey:kMY_USER_AREACODE]];
      }
      _areaCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 41, HEIGHT)];
      [_areaCodeBtn setTitle:areaStr forState:UIControlStateNormal];
      _areaCodeBtn.titleLabel.font = SYSFONT(15);
      [_areaCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [_areaCodeBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
      _areaCodeBtn.custom_acceptEventInterval = 1.0f;
      [_areaCodeBtn addTarget:self action:@selector(areaCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
      [self resetBtnEdgeInsets:_areaCodeBtn];
      [leftView addSubview:_areaCodeBtn];
      UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(_areaCodeBtn.frame.size.width+7, HEIGHT/2 - 8, LINE_WH, 16)];
      verticalLine.backgroundColor = THE_LINE_COLOR;
      [leftView addSubview:verticalLine];
   }
   n = n+HEIGHT;
   if (!self.isModify) {
      _imgCode = [UIFactory createTextFieldWith:CGRectMake(15, n, W-30-70-15-35-4, HEIGHT) delegate:self returnKeyType:UIReturnKeyNext secureTextEntry:NO placeholder:Localized(@"JX_inputImgCode") font:g_factory.font16];
      _imgCode.clearButtonMode = UITextFieldViewModeWhileEditing;
      _imgCode.borderStyle = UITextBorderStyleNone;
      [baseView addSubview:_imgCode];
      [self showLine:_imgCode];
      _imgCode.layer.masksToBounds = YES;
      _imgCode.layer.cornerRadius = 4;
      [self createLeftViewWithImage:[UIImage imageNamed:@"verify"] superView:_imgCode];
      _imgCodeImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgCode.frame)+INSETS, 0, 70, 35)];
      _imgCodeImg.center = CGPointMake(_imgCodeImg.center.x, _imgCode.center.y);
      _imgCodeImg.userInteractionEnabled = YES;
      [baseView addSubview:_imgCodeImg];
      _graphicButton = [UIButton buttonWithType:UIButtonTypeCustom];
      _graphicButton.frame = CGRectMake(CGRectGetMaxX(_imgCodeImg.frame)+4, 7, 35, 35);
      _graphicButton.center = CGPointMake(_graphicButton.center.x,_imgCode.center.y);
      [_graphicButton setBackgroundImage:[UIImage imageNamed:@"refreshGraphic"] forState:UIControlStateNormal];
      [_graphicButton setBackgroundImage:[UIImage imageNamed:@"refreshGraphic"] forState:UIControlStateHighlighted];
      [_graphicButton addTarget:self action:@selector(refreshGraphicAction:) forControlEvents:UIControlEventTouchUpInside];
      [baseView addSubview:_graphicButton];
      n = n+HEIGHT;
      _code = [[UITextField alloc] initWithFrame:CGRectMake(15, n, W-110-30, HEIGHT)];
      _code.delegate = self;
      _code.autocorrectionType = UITextAutocorrectionTypeNo;
      _code.autocapitalizationType = UITextAutocapitalizationTypeNone;
      _code.enablesReturnKeyAutomatically = YES;
      _code.font = g_factory.font16;
      _code.returnKeyType = UIReturnKeyDone;
      _code.clearButtonMode = UITextFieldViewModeWhileEditing;
      _code.placeholder = Localized(@"JX_InputMessageCode");
      [baseView addSubview:_code];
      [self showLine:_code];
      [self createLeftViewWithImage:[UIImage imageNamed:@"code"] superView:_code];
      _send = [UIFactory createButtonWithTitle:Localized(@"JX_Send")
                                     titleFont:g_factory.font16
                                    titleColor:[UIColor whiteColor]
                                        normal:nil
                                     highlight:nil ];
      [_send addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
      _send.backgroundColor = g_theme.themeColor;
      _send.titleLabel.font = SYSFONT(16);
      _send.frame = CGRectMake(W-105-15, n+HEIGHT/2-20, 105, 40);
      _send.layer.cornerRadius = 7.f;
      _send.layer.masksToBounds = YES;
      [baseView addSubview:_send];
      n = n+HEIGHT;
   }
   if (self.isModify) {
      _oldPwd = [[UITextField alloc] initWithFrame:CGRectMake(15,n,W-30,HEIGHT)];
      _oldPwd.delegate = self;
      _oldPwd.autocorrectionType = UITextAutocorrectionTypeNo;
      _oldPwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
      _oldPwd.enablesReturnKeyAutomatically = YES;
      _oldPwd.returnKeyType = UIReturnKeyDone;
      _oldPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
      _oldPwd.placeholder = Localized(@"JX_InputOldPassWord");
      _oldPwd.secureTextEntry = YES;
      _oldPwd.font = g_factory.font16;
      [baseView addSubview:_oldPwd];
      [self showLine:_oldPwd];
      [self createLeftViewWithImage:[UIImage imageNamed:@"password"] superView:_oldPwd];
      n = n+HEIGHT;
   }
   if (!self.isPayPWD) {
      _pwd = [[UITextField alloc] initWithFrame:CGRectMake(15,n,W-30,HEIGHT)];
      _pwd.delegate = self;
      _pwd.autocorrectionType = UITextAutocorrectionTypeNo;
      _pwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
      _pwd.enablesReturnKeyAutomatically = YES;
      _pwd.returnKeyType = UIReturnKeyDone;
      _pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
      _pwd.placeholder = Localized(@"JX_InputNewPassWord");
      _pwd.secureTextEntry = YES;
      _pwd.font = g_factory.font16;
      [baseView addSubview:_pwd];
      [self showLine:_pwd];
      [self createLeftViewWithImage:[UIImage imageNamed:@"password"] superView:_pwd];
      n = n+HEIGHT;
      _repeat = [[UITextField alloc] initWithFrame:CGRectMake(15,n,W-30,HEIGHT)];
      _repeat.delegate = self;
      _repeat.autocorrectionType = UITextAutocorrectionTypeNo;
      _repeat.autocapitalizationType = UITextAutocapitalizationTypeNone;
      _repeat.enablesReturnKeyAutomatically = YES;
      _repeat.returnKeyType = UIReturnKeyDone;
      _repeat.clearButtonMode = UITextFieldViewModeWhileEditing;
      _repeat.placeholder = Localized(@"JX_ConfirmNewPassWord");
      _repeat.secureTextEntry = YES;
      _repeat.font = g_factory.font16;
      [self createLeftViewWithImage:[UIImage imageNamed:@"password"] superView:_repeat];
      [baseView addSubview:_repeat];
      [self showLine:_repeat];
      n = n+HEIGHT;
   }
   n += 30;
   UIButton* _btn = [UIFactory createCommonButton:Localized(@"JX_UpdatePassWord") target:self action:@selector(onClick:)];
   [_btn.titleLabel setFont:g_factory.font16];
   _btn.layer.masksToBounds = YES;
   _btn.layer.cornerRadius = 7.f;
   _btn.frame = CGRectMake(15, n, W-30, 40);
   [baseView addSubview:_btn];
   CGRect frame = baseView.frame;
   frame.size.height = CGRectGetMaxY(_btn.frame)+30;
   baseView.frame = frame;
   _phone.text = g_myself.phone;
   if (self.isModify) {
      _phone.enabled = NO;
   }else{
      if (_phone.text.length > 0) {
         [self getImgCodeImg];
      }
   }
}
- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
}
-(void)refreshGraphicAction:(UIButton *)button{
   [self getImgCodeImg];
}
-(void)getImgCodeImg{
   if(_phone.text.length > 0){
      NSString *areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
      NSString * codeUrl = [g_server getImgCode:_phone.text areaCode:areaCode];
      NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:codeUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
      [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
         if (!connectionError) {
            UIImage * codeImage = [UIImage imageWithData:data];
            if (codeImage != nil) {
               _imgCodeImg.image = codeImage;
            }else{
               [g_App showAlert:Localized(@"JX_ImageCodeFailed")];
            }
         }else{
            NSLog(@"%@",connectionError);
            [g_App showAlert:connectionError.localizedDescription];
         }
      }];
   }else{
   }
}
#pragma mark------验证
-(void)onClick:(UIButton *)btn{
   btn.enabled = NO;
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      btn.enabled = YES;
   });
   if([_phone.text length]<= 0){
      [g_App showAlert:Localized(@"JX_InputPhone")];
      return;
   }
   if (!self.isModify) {
      if([_code.text length]<4){
         [g_App showAlert:Localized(@"JX_InputMessageCode")];
         return;
      }
   }
   if (self.isModify && [_oldPwd.text length] <= 0){
      [g_App showAlert:Localized(@"JX_InputPassWord")];
      return;
   }
   if (!self.isPayPWD) {
      if([_pwd.text length]<=0){
         [g_App showAlert:Localized(@"JX_InputPassWord")];
         return;
      }
      if ([_pwd.text length] < 6) {
         [g_App showAlert:Localized(@"JX_TurePasswordAlert")];
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
      if ([_pwd.text isEqualToString:_oldPwd.text]) {
         [g_App showAlert:Localized(@"JX_PasswordOriginal")];
         return;
      }
   }
   [self.view endEditing:YES];
   NSString *areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
   if (self.isModify){
      [_wait start];
#ifdef IS_MsgEncrypt
      [g_server userGetRandomStr:self];
#else
      [g_server updatePwd:_phone.text areaCode:areaCode oldPwd:_oldPwd.text newPwd:_pwd.text checkCode:nil toView:self];
#endif
   }else{
      [_wait start];
      if (self.isPayPWD) {
         long time = (long)[[NSDate date] timeIntervalSince1970];
         time = time *1000 + g_server.timeDifference;
         NSString *salt = [NSString stringWithFormat:@"%ld",time];
         NSString *mac = [self getResetPayPWDMacWithSalt:salt];
         [g_server authkeysResetPayPasswordWithSalt:salt mac:mac toView:self];
      }else {
         [g_server resetPwd:_phone.text areaCode:areaCode randcode:_code.text newPwd:_pwd.text toView:self];
      }
   }
}
- (NSString *)getResetPayPWDMacWithSalt:(NSString *)salt {
   NSMutableString *str = [NSMutableString string];
   [str appendString:APIKEY];
   [str appendString:g_myself.userId];
   [str appendString:g_server.access_token];
   [str appendString:salt];
   NSData *key = [MD5Util getMD5DataWithString:_code.text];
   NSData *macData = [g_securityUtil getHMACMD5:[str dataUsingEncoding:NSUTF8StringEncoding] key:key];
   NSString *mac = [macData base64EncodedStringWithOptions:0];
   return mac;
}
- (void)sendSMS{
   [_phone resignFirstResponder];
   [_imgCode resignFirstResponder];
   [_code resignFirstResponder];
   _send.enabled = NO;
   if (_imgCode.text.length < 3) {
      [g_App showAlert:Localized(@"JX_inputImgCode")];
      _send.enabled = YES;
      return;
   }
   [self onSend];
}
- (BOOL)isMobileNumber:(NSString *)number{
   if ([_phone.text length] == 0) {
      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localized(@"JX_Tip") message:Localized(@"JX_InputPhone") delegate:nil cancelButtonTitle:Localized(@"JX_Confirm") otherButtonTitles:nil, nil];
      [alert show];
      return NO;
   }
   if ([_areaCodeBtn.titleLabel.text isEqualToString:@"+86"]) {
      NSString *regex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
      NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
      BOOL isMatch = [pred evaluateWithObject:number];
      if (!isMatch) {
         [g_App showAlert:Localized(@"inputPhoneVC_InputTurePhone")];
         return NO;
      }
   }
   return YES;
}
-(void)onSend{
   if (!_send.selected) {
      [_wait start];
      NSString *areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
      _user.areaCode = areaCode;
      [g_server sendSMS:[NSString stringWithFormat:@"%@",_phone.text] areaCode:areaCode isRegister:NO imgCode:_imgCode.text toView:self];
   }
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
   [_wait stop];
   if([aDownload.action isEqualToString:act_SendSMS]){
      _send.enabled = YES;
      _send.selected = YES;
      _send.userInteractionEnabled = NO;
      _send.backgroundColor = [UIColor grayColor];
      _smsCode = [[dict objectForKey:@"code"] copy];
      [_send setTitle:@"60s" forState:UIControlStateSelected];
      _seconds = 60;
      timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTime:) userInfo:_send repeats:YES];
   }
   if([aDownload.action isEqualToString:act_PwdUpdate] || [aDownload.action isEqualToString:act_PwdUpdateV1]){
      [g_App showAlert:Localized(@"JX_UpdatePassWordOK")];
      g_myself.password = [g_server getMD5String:_pwd.text];
      [g_default setObject:[g_server getMD5String:_pwd.text] forKey:kMY_USER_PASSWORD];
      [g_default synchronize];
      [self actionQuit];
      [self relogin];
   }
   if([aDownload.action isEqualToString:act_PwdReset] || [aDownload.action isEqualToString:act_PwdResetV1]){
      [g_App showAlert:Localized(@"JX_UpdatePassWordOK")];
      g_myself.password = [g_server getMD5String:_pwd.text];
      [g_default setObject:[g_server getMD5String:_pwd.text] forKey:kMY_USER_PASSWORD];
      [g_default synchronize];
      [self actionQuit];
   }
   if ([aDownload.action isEqualToString:act_UserGetRandomStr]) {
      NSString *checkCode = nil;
#ifdef IS_MsgEncrypt
      NSString *userRandomStr = [dict objectForKey:@"userRandomStr"];
      SecKeyRef privateKey = [g_securityUtil getRSAKeyWithBase64Str:g_msgUtil.rsaPrivateKey isPrivateKey:YES];
      NSData *randomData = [[NSData alloc] initWithBase64EncodedString:userRandomStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
      NSData *codeData = [g_securityUtil decryptMessageRSA:randomData withPrivateKey:privateKey];
      checkCode = [[NSString alloc] initWithData:codeData encoding:NSUTF8StringEncoding];
#endif
      NSString *areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
      [g_server updatePwd:_phone.text areaCode:areaCode oldPwd:_oldPwd.text newPwd:_pwd.text checkCode:checkCode toView:self];
   }
   if ([aDownload.action isEqualToString:act_AuthkeysResetPayPassword]) {
      if ([self.delegate respondsToSelector:@selector(forgetPwdSuccess)]) {
         [self actionQuit];
         [self.delegate forgetPwdSuccess];
      }
   }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
   if([aDownload.action isEqualToString:act_SendSMS]){
      [_send setTitle:Localized(@"JX_SendAngin") forState:UIControlStateNormal];
      _send.enabled = YES;
   }else if ([aDownload.action isEqualToString:act_PwdUpdate] || [aDownload.action isEqualToString:act_PwdUpdateV1]) {
      NSString *error = [dict objectForKey:@"resultMsg"];
      [g_App showAlert:[NSString stringWithFormat:@"%@",error]];
      return hide_error;
   }
   [_wait stop];
   return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
   [_wait stop];
   _send.enabled = YES;
   return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
   [_wait stop];
}
-(void)showTime:(NSTimer*)sender{
   UIButton *but = (UIButton*)[timer userInfo];
   _seconds--;
   [but setTitle:[NSString stringWithFormat:@"%ds",_seconds] forState:UIControlStateSelected];
   if(_seconds<=0){
      but.selected = NO;
      but.userInteractionEnabled = YES;
      but.backgroundColor = g_theme.themeColor;
      [_send setTitle:Localized(@"JX_SendAngin") forState:UIControlStateNormal];
      if (timer) {
         timer = nil;
         [sender invalidate];
      }
      _seconds = 60;
   }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
   if (textField == _phone) {
      [self getImgCodeImg];
   }
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
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
-(void)relogin{
   [g_default removeObjectForKey:kMY_USER_PASSWORD];
   [g_default removeObjectForKey:kMY_USER_TOKEN];
   [share_defaults removeObjectForKey:kMY_ShareExtensionToken];
   g_server.access_token = nil;
   [g_notify postNotificationName:kSystemLogoutNotifaction object:nil];
   [[TFJunYou_XMPP sharedInstance] logout];
   NSLog(@"XMPP ---- forgetPwdVC relogin");
   TFJunYou_loginVC* vc = [TFJunYou_loginVC alloc];
   vc.isAutoLogin = NO;
   vc.isSwitchUser= NO;
   vc = [vc init];
   [g_mainVC.view removeFromSuperview];
   g_mainVC = nil;
   [self.view removeFromSuperview];
   self.view = nil;
   g_navigation.rootViewController = vc;
   [_wait stop];
#if TAR_IM
#ifdef Meeting_Version
   [g_meeting stopMeeting];
#endif
#endif
}
- (void)createLeftViewWithImage:(UIImage *)image superView:(UITextField *)textField {
   UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 27, HEIGHT)];
   textField.leftView = leftView;
   textField.leftViewMode = UITextFieldViewModeAlways;
   UIImageView *leIgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT/2-10, 20, 20)];
   leIgView.image = image;
   leIgView.contentMode = UIViewContentModeScaleAspectFit;
   [leftView addSubview:leIgView];
}
- (void)showLine:(UIView *)view {
   UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-LINE_WH, view.frame.size.width, LINE_WH)];
   line.backgroundColor = THE_LINE_COLOR;
   [view addSubview:line];
}
@end
