#import "TFJunYou_RechargeViewController.h"
#import "TFJunYou_WebCustomer.h"
#import "TFJunYou_RechargeCell.h"
#import "UIImage+Color.h"
#import  "WXApi.h"
@interface TFJunYou_RechargeViewController ()<UIAlertViewDelegate,UITextFieldDelegate,WXApiDelegate>
@property (nonatomic, assign) NSInteger checkIndex;
@property (atomic, assign) NSInteger payType;
@property (nonatomic, strong) NSArray * rechargeMoneyArray;
@property (nonatomic, strong) UILabel * totalMoney;
@property (nonatomic, strong) UIButton * wxPayBtn;
@property (nonatomic, strong) UIButton * aliPayBtn;
@property (atomic, assign) NSInteger btnIndex;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UITextField *moneyTextField;
@end
static NSString * TFJunYou_RechargeCellID = @"TFJunYou_RechargeCellID";
@implementation TFJunYou_RechargeViewController
-(instancetype)init{
    if (self = [super init]) {
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.isGotoBack = YES;
        self.title = Localized(@"JXLiveVC_Recharge");
        self.rechargeMoneyArray = @[@30,
                                    @50,
                                    @100,
                                    @200];
        _checkIndex = -1;
        [g_notify addObserver:self selector:@selector(receiveWXPayFinishNotification:) name:kWxPayFinishNotification object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHeadAndFoot];
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH,1*2)];
    [self.tableBody addSubview:self.baseView];
   // [self setupViews]; CGRectGetMaxY(self.baseView.frame)+20
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,1 , TFJunYou__SCREEN_WIDTH-0, LINE_WH)];
    line.backgroundColor =   THE_LINE_COLOR;
    [self.tableBody addSubview:line];
    UILabel *tinLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(line.frame)+20, 130, 14)];
    tinLabel.textColor = HEXCOLOR(0x999999);
    tinLabel.font = SYSFONT(14);
    tinLabel.text = @"请输入您充值金额";
    [self.tableBody addSubview:tinLabel];
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 16)];
    leftLab.font = SYSFONT(16);
    leftLab.text = @"合计: ";
    UILabel *rigLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    rigLab.font = SYSFONT(24);
    rigLab.textColor = THEMECOLOR;
    rigLab.text = @"元";
    
    
    self.moneyTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tinLabel.frame)+24, TFJunYou__SCREEN_WIDTH-30, 44)];
    self.moneyTextField.placeholder = @"请输入";
    self.moneyTextField.textColor = THEMECOLOR;
    self.moneyTextField.backgroundColor= THE_LINE_COLOR;
    self.moneyTextField.font = SYSFONT(24);
    self.moneyTextField.leftView = leftLab;
    self.moneyTextField.leftViewMode = UITextFieldViewModeAlways;
    //self.moneyTextField.rightView = rigLab;
    self.moneyTextField.rightViewMode = UITextFieldViewModeAlways;
    self.moneyTextField.delegate = self;
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    //[self.rechargeMoneyArray[self.btnIndex] doubleValue]
    self.moneyTextField.placeholder = [NSString stringWithFormat:@"%.2f",0.00];
    [self.moneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tableBody addSubview:self.moneyTextField];
    //[self setTextFieldWidth:self.moneyTextField.text];
    self.wxPayBtn = [self payTypeBtn:CGRectMake(0, CGRectGetMaxY(self.moneyTextField.frame)+30, TFJunYou__SCREEN_WIDTH, 56) title:@"微信支付" image:@"weixin_logo" drawTop:NO drawBottom:YES action:@selector(wxPayBtnAction:)];
//    self.aliPayBtn = [self payTypeBtn:CGRectMake(0, CGRectGetMaxY(self.moneyTextField.frame)+30, TFJunYou__SCREEN_WIDTH, 56) title:@"支付宝" image:@"aliPay_logo" drawTop:NO drawBottom:NO action:@selector(aliPayBtnAction:)];

    
   [g_notify addObserver:self selector:@selector(receiveWXPayFinishNotification:) name:@"wxBandId" object:nil];

}
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.moneyTextField) {
        if ([textField.text doubleValue] >= 10000) {
            textField.text = @"10000";
        }
    }
   // [self setTextFieldWidth:textField.text];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.moneyTextField) {
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
    return YES;
}
- (void)setupViews {
    UIButton *btn;
    CGFloat w = 89;
    int inset = (TFJunYou__SCREEN_WIDTH-w*3)/4;
    for (int i = 0; i < self.rechargeMoneyArray.count; i++) {
        CGFloat x = (w+inset)*(i % 3)+inset;
        int m = i / 3;
        btn = [self createButtonWihtFrame:CGRectMake(x, m*41+(15 * (m +1)), w, 41) title:[NSString stringWithFormat:@"%.2f元",[self.rechargeMoneyArray[i] doubleValue]] index:i];
    }
}
- (void)onDidMoney:(UIButton *)button {
    if ([self.moneyTextField isFirstResponder]) {
        [self.moneyTextField resignFirstResponder];
    }
    self.btnIndex = button.tag;
    self.moneyTextField.text = [NSString stringWithFormat:@"%.2f",[self.rechargeMoneyArray[self.btnIndex] doubleValue]];
   // [self setTextFieldWidth:self.moneyTextField.text];
    for (UIView *view in self.baseView.subviews) {
        [view removeFromSuperview];
    }
   // [self setupViews];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.btnIndex = self.rechargeMoneyArray.count+1;
    textField.text = @"";
   // [self setTextFieldWidth:textField.text];
    for (UIView *view in self.baseView.subviews) {
        [view removeFromSuperview];
    }
   // [self setupViews];
    return YES;
}
- (void)setTextFieldWidth:(NSString *)s {
    CGSize size = [s sizeWithAttributes:@{NSFontAttributeName:SYSFONT(24)}];
    CGRect frame = self.moneyTextField.frame;
    if (s.length > 0) {
        frame.size.width = size.width+48+24;
    }else {
        frame.size.width = 130+48+24;
    }
    self.moneyTextField.frame = frame;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text doubleValue] > 0) {
        self.moneyTextField.text = [NSString stringWithFormat:@"%.2f元",[textField.text doubleValue]];
    }
    return YES;
}
-(void)dealloc{
    [g_notify removeObserver:self];
}
-(void)setTotalMoneyText:(NSString *)money{
    NSString * totalMoneyStr = [NSString stringWithFormat:@"¥%@",money];
    CGFloat moneyWidth = [totalMoneyStr sizeWithAttributes:@{NSFontAttributeName:_totalMoney.font}].width;
    CGRect frame = _totalMoney.frame;
    frame.size.width = moneyWidth;
    _totalMoney.frame = frame;
    _totalMoney.text = totalMoneyStr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark Action
-(void)wxPayBtnAction:(UIButton *)button{
    
   
    if ([self.moneyTextField.text doubleValue] > 0) {
        _payType = 2;
        [g_server getSign:self.moneyTextField.text payType:2 toView:self];
    }else{
        [SVProgressHUD showInfoWithStatus:@"金额必须大于0"];
    }
}
-(void)aliPayBtnAction:(UIButton *)button{
    if ([self.moneyTextField.text doubleValue] > 0) {
        _payType = 1;
        [g_server getSign:self.moneyTextField.text payType:1 toView:self];
    }
}
-(void)tuningWxWith:(NSDictionary *)dict{
    
    
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = [NSString stringWithFormat:@"%@",dict[@"userName"]];  //拉起的小程序的username-原始ID  
    launchMiniProgramReq.path = [NSString stringWithFormat:@"%@",dict[@"path"]];    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    //0 [WXApi sendReq:launchMiniProgramReq];
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {  }];
    
    /**
     {
         path = "pages/index/index?name=商品名称&fee=金额（金额单位为【分】，参数值不能带小数）&outTradeNo=订单号&callback_url=回掉地址（url编码）&appid=畅联支付appid&key=畅联支付key";
         userName = "gh_bec380e5e574";
     }
     */
    return;
    WXVideoObject *videoObject = [WXVideoObject object];
    videoObject.videoUrl =@"https://junyoukuxin.oss-cn-zhangjiakou.aliyuncs.com/video/10007912/1607657933441.mp4";
    //videoObject.videoLowBandUrl = @"低分辨率视频url";
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"APP_NAME";
    message.description = [NSString stringWithFormat:@"这个城市应有尽有，跟我一样的人，应该也有。\n ——来自%@用户的短视频分享～",APP_NAME];
    [message setThumbImage:[UIImage imageNamed:@"ALOGO_1200"]];
    message.mediaObject = videoObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
    
    return;
    TFJunYou_WebCustomer *vc=[[TFJunYou_WebCustomer alloc]init];
    vc.titleName=@"充值";
    vc.link=dict[@"url"];
    [g_navigation pushViewController:vc animated:YES];
    
//    PayReq *req = [[PayReq alloc] init];
//    req.partnerId = [dict objectForKey:@"partnerId"];
//    req.prepayId = [dict objectForKey:@"prepayId"];
//    req.nonceStr = [dict objectForKey:@"nonceStr"];
//    req.timeStamp = [[dict objectForKey:@"timeStamp"] intValue];
//    req.package = @"Sign=WXPay";//[dict objectForKey:@"package"];
//    req.sign = [dict objectForKey:@"sign"];
//    // [WXApi sendReq:req];
//   [WXApi sendReq:req completion:^(BOOL success) {  }];
    
}
- (void)tuningAlipayWithOrder:(NSString *)signedString {
    if (signedString != nil) {
      NSString *appScheme = @"shikuimapp";
      
    }
}
-(void)receiveWXPayFinishNotification:(NSNotification *)notifi{
    
    PayResp *resp = notifi.object;
    
    if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]])
       {
            NSString *string = resp.errStr;
            // 对应JsApi navigateBackApplication中的extraData字段数据
       }
    
    return;
    switch (resp.errCode) {
        case WXSuccess:{
            [g_App showAlert:Localized(@"JXMoney_PaySuccess") delegate:self tag:1001 onlyConfirm:YES];
            if (self.rechargeDelegate && [self.rechargeDelegate respondsToSelector:@selector(rechargeSuccessed)]) {
                [self.rechargeDelegate performSelector:@selector(rechargeSuccessed)];
            }
            if (_isQuitAfterSuccess) {
                [self actionQuit];
            }
            break;
        }
        case WXErrCodeUserCancel:{
            //取消了支付
            break;
        }
        default:{
            //支付错误
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"支付失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            break;
        }
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [g_server getUserMoenyToView:self];
        });
    }
}
- (void)didServerResultSucces:(TFJunYou_Connection *)aDownload dict:(NSDictionary *)dict array:(NSArray *)array1{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_getSign]) {
        if ([[dict objectForKey:@"package"] isEqualToString:@"Sign=WXPay"]|| _payType==2) {
            [self tuningWxWith:dict];
        }else {
            [self tuningAlipayWithOrder:[dict objectForKey:@"orderInfo"]];
        }
    }else if ([aDownload.action isEqualToString:act_getUserMoeny]) {
        g_App.myMoney = [dict[@"balance"] doubleValue];
        [g_notify postNotificationName:kUpdateUserNotifaction object:nil];
        [self actionQuit];
    }
}
- (int)didServerResultFailed:(TFJunYou_Connection *)aDownload dict:(NSDictionary *)dict{
    [_wait stop];
    return show_error;
}
- (int)didServerConnectError:(TFJunYou_Connection *)aDownload error:(NSError *)error{
    [_wait stop];
    return hide_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}
- (UIButton *)createButtonWihtFrame:(CGRect)frame title:(NSString *)title index:(NSInteger)index {
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTag:index];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:btn.bounds];
    imgV.image = [[UIImage imageNamed:@"Recharge_normal"] imageWithTintColor:THEMECOLOR];
    [btn addSubview:imgV];
    UILabel *label = [[UILabel alloc] initWithFrame:btn.bounds];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = THEMECOLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = SYSFONT(14);
    [btn addSubview:label];
    if (self.btnIndex == index) {
        imgV.image = [[UIImage imageNamed:@"Recharge_seleted"] imageWithTintColor:THEMECOLOR];
        label.textColor = [UIColor whiteColor];
    }
    [btn addTarget:self action:@selector(onDidMoney:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:btn];
    return btn;
}
- (UIButton *)payTypeBtn:(CGRect)frame title:(NSString *)title image:(NSString *)image drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom action:(SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-19-36, (frame.size.height-19)/2, 19, 19)];
    imgV.image = [UIImage imageNamed:image];
    [btn addSubview:imgV];
    if (action == @selector(wxPayBtnAction:)) {
        imgV.frame = CGRectMake(frame.size.width-20-36, (frame.size.height-16)/2, 20, 16);
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, frame.size.height)];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = HEXCOLOR(0x222222);
    label.font = SYSFONT(16);
    [btn addSubview:label];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.tableBody addSubview:btn];
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(15,0,TFJunYou__SCREEN_WIDTH-15,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    if(drawBottom){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(15, frame.size.height-LINE_WH,TFJunYou__SCREEN_WIDTH-15,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, frame.size.height/2-13/2, 7, 13)];
    iv.image = [UIImage imageNamed:@"new_icon_>"];
    [btn addSubview:iv];
    return btn;
}
@end
