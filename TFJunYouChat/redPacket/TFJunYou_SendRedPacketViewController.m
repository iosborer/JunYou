#import "TFJunYou_SendRedPacketViewController.h"
#import "TFJunYou_TopSiftJobView.h"
#import "TFJunYou_RedInputView.h"
#import "TFJunYou_RechargeViewController.h"
#import "TFJunYou_VerifyPayVC.h"
#import "TFJunYou_PayPasswordVC.h"
#import "TFJunYou_PayServer.h"
#import "WXApi.h"
#define TopHeight 40
@interface TFJunYou_SendRedPacketViewController ()<UITextFieldDelegate,UIScrollViewDelegate,RechargeDelegate>
@property (nonatomic, strong) TFJunYou_TopSiftJobView * topSiftView;
@property (nonatomic, strong) TFJunYou_RedInputView * luckyView;
@property (nonatomic, strong) TFJunYou_RedInputView * nomalView;
@property (nonatomic, strong) TFJunYou_RedInputView * orderView;
@property (nonatomic, strong) TFJunYou_VerifyPayVC * verVC;
@property (nonatomic, strong) memberData * user;
@property (nonatomic, copy) NSString * moneyText;
@property (nonatomic, copy) NSString * countText;
@property (nonatomic, copy) NSString * greetText;
@property (nonatomic, assign) NSInteger indexInt;
@end
@implementation TFJunYou_SendRedPacketViewController
-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; 
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightFooter = 0;
    self.heightHeader = 0;
    [self createHeadAndFoot];
    [self createHeaderView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit:)];
    [self.tableBody addGestureRecognizer:tap];
    if (_isRoom) {
        self.tableBody.contentSize = CGSizeMake(TFJunYou__SCREEN_WIDTH *3, self.tableBody.frame.size.height);
    }else{
        self.tableBody.contentSize = CGSizeMake(TFJunYou__SCREEN_WIDTH *2, self.tableBody.frame.size.height);
    }
    self.tableBody.delegate = self;
    self.tableBody.pagingEnabled = YES;
    self.tableBody.showsHorizontalScrollIndicator = NO;
    self.tableBody.backgroundColor = HEXCOLOR(0xEFEFEF);
    [self.view addSubview:self.topSiftView];
    if(_isRoom){
        [self.tableBody addSubview:self.luckyView];
        [_luckyView.sendButton addTarget:self action:@selector(sendRedPacket:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.tableBody addSubview:self.nomalView];
    [self.tableBody addSubview:self.orderView];
    [_nomalView.sendButton addTarget:self action:@selector(sendRedPacket:) forControlEvents:UIControlEventTouchUpInside];
    [_orderView.sendButton addTarget:self action:@selector(sendRedPacket:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)createHeaderView{
    int heightHeader = TFJunYou__SCREEN_TOP;
    UIView *  tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, heightHeader)];
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, heightHeader)];
    iv.image = [[UIImage imageNamed:@"navBarBackground"] imageWithTintColor:HEXCOLOR(0xFA585E)];
    iv.userInteractionEnabled = YES;
    [tableHeader addSubview:iv];
    TFJunYou_Label* p = [[TFJunYou_Label alloc]initWithFrame:CGRectMake(60, TFJunYou__SCREEN_TOP -15- 17, TFJunYou__SCREEN_WIDTH-60*2, 20)];
    p.center = CGPointMake(tableHeader.center.x, p.center.y);
    p.backgroundColor = [UIColor clearColor];
    p.textAlignment   = NSTextAlignmentCenter;
    p.textColor       = [UIColor whiteColor];
    p.font = [UIFont systemFontOfSize:18.0];
    p.text = Localized(@"JX_SendGift");
    p.userInteractionEnabled = YES;
    p.didTouch = @selector(actionTitle:);
    p.delegate = self;
    p.changeAlpha = NO;
    [tableHeader addSubview:p];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP - 46, 46, 46)];
    [btn setBackgroundImage:[[UIImage imageNamed:@"title_back_black_big"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionQuit) forControlEvents:UIControlEventTouchUpInside];
    [tableHeader addSubview:btn];
    [self.view addSubview:tableHeader];
}
-(TFJunYou_RedInputView *)luckyView{
    if (!_luckyView) {
        _luckyView = [[TFJunYou_RedInputView alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP+40, TFJunYou__SCREEN_WIDTH, self.tableBody.contentSize.height-TFJunYou__SCREEN_TOP-40) type:2 isRoom:_isRoom delegate:self];
    }
    return _luckyView;
}
-(TFJunYou_RedInputView *)nomalView{
    if (!_nomalView) {
        _nomalView = [[TFJunYou_RedInputView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_luckyView.frame), TFJunYou__SCREEN_TOP+40, TFJunYou__SCREEN_WIDTH, self.tableBody.contentSize.height-TFJunYou__SCREEN_TOP-40) type:1 isRoom:_isRoom delegate:self];
    }
    return _nomalView;
}
-(TFJunYou_RedInputView *)orderView{
    if (!_orderView) {
        _orderView = [[TFJunYou_RedInputView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nomalView.frame), TFJunYou__SCREEN_TOP+40, TFJunYou__SCREEN_WIDTH, self.tableBody.contentSize.height-TFJunYou__SCREEN_TOP-40) type:3 isRoom:_isRoom delegate:self];
    }
    return _orderView;
}
-(TFJunYou_TopSiftJobView *)topSiftView{
    if (!_topSiftView) {
        _topSiftView = [[TFJunYou_TopSiftJobView alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP, TFJunYou__SCREEN_WIDTH, 40)];
        _topSiftView.delegate = self;
        _topSiftView.isShowMoreParaBtn = NO;
        _topSiftView.preferred = 0;
        _topSiftView.backgroundColor = HEXCOLOR(0xFA585E);
        _topSiftView.titleNormalColor = HEXCOLOR(0xFCB3B4);
        _topSiftView.titleSelectedColor = [UIColor whiteColor];
        _topSiftView.isShowBottomLine = NO;
        NSArray * itemsArray;
        if (_isRoom) {
            itemsArray = [[NSArray alloc] initWithObjects:Localized(@"JX_LuckGift"),Localized(@"JX_UsualGift"),Localized(@"JX_MesGift"), nil];
        }else{
            itemsArray = [[NSArray alloc] initWithObjects:Localized(@"JX_UsualGift"),Localized(@"JX_MesGift"), nil];
        }
        _topSiftView.dataArray = itemsArray;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - LINE_WH, TFJunYou__SCREEN_WIDTH, LINE_WH)];
        line.backgroundColor = HEXCOLOR(0xFC1454);
        [_topSiftView addSubview:line];
    }
    return _topSiftView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)topItemBtnClick:(UIButton *)btn{
    [self checkAfterScroll:(btn.tag-100)];
}
- (void)checkAfterScroll:(CGFloat)offsetX{
    [self.tableBody setContentOffset:CGPointMake(offsetX*TFJunYou__SCREEN_WIDTH, 0) animated:YES];
    [self endEdit:nil];
}
-(void)endEdit:(UIGestureRecognizer *)ges{
    [_luckyView stopEdit];
    [_nomalView stopEdit];
    [_orderView stopEdit];
}
#pragma mark -------------ScrollDelegate----------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self endEdit:nil];
    int page = (int)(scrollView.contentOffset.x/TFJunYou__SCREEN_WIDTH);
    switch (page) {
        case 0:
            [_topSiftView resetItemBtnWith:0];
            [_topSiftView moveBottomSlideLine:0];
            break;
        case 1:
            [_topSiftView resetItemBtnWith:TFJunYou__SCREEN_WIDTH];
            [_topSiftView moveBottomSlideLine:TFJunYou__SCREEN_WIDTH];
            break;
        case 2:
            [_topSiftView resetItemBtnWith:TFJunYou__SCREEN_WIDTH*2];
            [_topSiftView moveBottomSlideLine:TFJunYou__SCREEN_WIDTH*2];
            break;
        default:
            break;
    }
}
-(void)sendRedPacket:(UIButton *)button{
    if (button.tag == 1) {
        _moneyText = _nomalView.moneyTextField.text;
        _countText = _nomalView.countTextField.text;
        _greetText = _nomalView.greetTextField.text;
    }else if(button.tag == 2){
        _moneyText = _luckyView.moneyTextField.text;
        _countText = _luckyView.countTextField.text;
        _greetText = _luckyView.greetTextField.text;
    }else if(button.tag == 3){
        _moneyText = _orderView.moneyTextField.text;
        _countText = _orderView.countTextField.text;
        _greetText = _orderView.greetTextField.text;
    }
    if (_moneyText == nil || [_moneyText isEqualToString:@""]) {
        [g_App showAlert:Localized(@"JX_InputGiftCount")];
        return;
    }
    
    double money = _moneyText.doubleValue;
    double minRed = [[NSUserDefaults standardUserDefaults] doubleForKey:@"kMinRedPacket"];
    if (money - minRed < 0.000001) {
        [g_App showAlert:[NSString stringWithFormat:@"红包金额不能小于%.2f元", minRed]];
        return;
    }
    if (!_isRoom) {
        _countText = @"1";
    }
    if (_isRoom && (_countText == nil|| [_countText isEqualToString:@""] || [_countText intValue] <= 0)) {
        [g_App showAlert:Localized(@"JXGiftForRoomVC_InputGiftCount")];
        return;
    }
    if (([_moneyText doubleValue]/[_countText intValue]) < 0.01) {
        [g_App showAlert:Localized(@"JXRedPaket_001")];
        return;
    }
    if (500 >= [_moneyText floatValue]&&[_moneyText floatValue] > 0) {
        if (button.tag == 3) {
            if ([_greetText isEqualToString:@""]) {
                [g_App showAlert:Localized(@"JXGiftForRoomVC_InputGiftWord")];
                return;
            }
            _greetText = [_greetText stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([_greetText isEqualToString:@""]) {
                [TFJunYou_MyTools showTipView:@"请输入有效口令"];
                return;
            }
        }
        if (button.tag == 1) {
            if ((int)([_moneyText floatValue] * 100) % [_countText integerValue] != 0) {
                [TFJunYou_MyTools showTipView:@"普通红包需要均分金额"];
                return;
            }
        }
        if ([_greetText isEqualToString:@""]) {
            _greetText = Localized(@"JX_GiftText");
        }
        self.indexInt = button.tag;
        if ([g_server.myself.isPayPassword boolValue]) {
            self.verVC = [TFJunYou_VerifyPayVC alloc];
            self.verVC.type = TFJunYou_VerifyTypeSendReadPacket;
            self.verVC.RMB = _moneyText;
            self.verVC.delegate = self;
            self.verVC.didDismissVC = @selector(dismissVerifyPayVC);
            self.verVC.didVerifyPay = @selector(didVerifyPay:);
            self.verVC = [self.verVC init];
            [self.view addSubview:self.verVC.view];
        } else {
            TFJunYou_PayPasswordVC *payPswVC = [TFJunYou_PayPasswordVC alloc];
            payPswVC.type = TFJunYou_PayTypeSetupPassword;
            payPswVC.enterType = TFJunYou_EnterTypeSendRedPacket;
            payPswVC = [payPswVC init];
            [g_navigation pushViewController:payPswVC animated:YES];
        }
    }else{
        [g_App showAlert:Localized(@"JX_InputMoneyCount")];
    }
}
- (void)didVerifyPay:(NSString *)sender {
    long time = (long)[[NSDate date] timeIntervalSince1970];
    time = (time *1000 + g_server.timeDifference)/1000;
    NSString *secret = [self getSecretWithText:sender time:time];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"type",[NSString stringWithFormat:@"%ld",self.indexInt],@"moneyStr",_moneyText,@"count",_countText,@"greetings",_greetText, nil];
    if (self.roomJid.length > 0) {
        [arr addObject:@"roomJid"];
        [arr addObject:self.roomJid];
    }else {
        [arr addObject:@"toUserId"];
        [arr addObject:self.toUserId];
    }
    [g_payServer payServerWithAction:act_sendRedPacketV2 param:arr payPassword:sender time:time toView:self];
}
- (void)dismissVerifyPayVC {
    [self.verVC.view removeFromSuperview];
}

-(void)tuningWxWith:(NSDictionary *)dict{
     
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = [dict objectForKey:@"partnerId"];
    req.prepayId = [dict objectForKey:@"prepayId"];
    req.nonceStr = [dict objectForKey:@"nonceStr"];
    req.timeStamp = [[dict objectForKey:@"timeStamp"] intValue];
    req.package = @"Sign=WXPay";//[dict objectForKey:@"package"];
    req.sign = [dict objectForKey:@"sign"];
    //  [WXApi sendReq:req];
   [WXApi sendReq:req completion:^(BOOL success) {  }];
     
}


-(void)receiveWXPayFinishNotification:(NSNotification *)notifi{
  
    PayResp *resp = notifi.object;
    switch (resp.errCode) {
        case WXSuccess:{
            [g_App showAlert:Localized(@"JXMoney_PaySuccess") delegate:self tag:1001 onlyConfirm:YES];
            [self actionQuit];
//            if (_isQuitAfterSuccess) {
//                [self actionQuit];
//            }
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

-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_getUserMoeny]) {
        g_App.myMoney = [dict[@"balance"] doubleValue];
        if (g_App.myMoney <= 0) {
            [g_App showAlert:Localized(@"JX_NotEnough") delegate:self tag:2000 onlyConfirm:NO];
        }
    }
    if ([aDownload.action isEqualToString:act_sendRedPacket] || [aDownload.action isEqualToString:act_sendRedPacketV2]) {
        NSMutableDictionary * muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [muDict setObject:_greetText forKey:@"greet"];
        
        NSDictionary *typeStr = [muDict objectForKey:@"packet"];
        NSString *type=typeStr[@"type"];
        //if (type.intValue == 4) {
            NSString *userNickName = _user.userNickName;
            if (userNickName == nil) {
                userNickName = @"所有人";
            }else {
                if (!self.room.showMember) {
                    NSString *tempDisplayName = [userNickName substringToIndex:[userNickName length]-1];
                    userNickName = [tempDisplayName stringByAppendingString:@"*"];
                }
            }
            NSArray *assignUserIds = muDict[@"packet"][@"assignUserIds"];
            NSNumber *assignUserId = assignUserIds.firstObject;
            if (assignUserIds!=nil) {
            
                [muDict setObject:assignUserId.stringValue forKey:@"toId"];
            }
            [muDict setObject:userNickName forKey:@"toUserName"];
        if ([[dict objectForKey:@"package"] isEqualToString:@"Sign=WXPay"]) {
             [self tuningWxWith:dict];
         }
        
        
        [self dismissVerifyPayVC];  
        if (_delegate && [_delegate respondsToSelector:@selector(sendRedPacketDelegate:)]) {
            [_delegate performSelector:@selector(sendRedPacketDelegate:) withObject:muDict];
        }
        
       
        
        [self actionQuit];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_sendRedPacket] || [aDownload.action isEqualToString:act_sendRedPacketV2] || [aDownload.action isEqualToString:act_TransactionGetCode]) {
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
#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000){
        if (buttonIndex == 1) {
            [self rechargeButtonAction];
        }
    }
}
-(void)rechargeButtonAction{
    TFJunYou_RechargeViewController * rechargeVC = [[TFJunYou_RechargeViewController alloc]init];
    rechargeVC.rechargeDelegate = self;
    rechargeVC.isQuitAfterSuccess = YES;
    [g_navigation pushViewController:rechargeVC animated:YES];
}
#pragma mark - RechargeDelegate
-(void)rechargeSuccessed{
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    TFJunYou_RedInputView * inputView = (TFJunYou_RedInputView *)textField.superview.superview;
    if (textField.returnKeyType == UIReturnKeyDone) {
        [inputView stopEdit];
    }
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    TFJunYou_RedInputView * inputView = (TFJunYou_RedInputView *)textField.superview.superview;
    if (textField == inputView.countTextField && [textField.text intValue] > 1000) {
        return NO;
    }
    if (textField == inputView.greetTextField && textField.text.length >= 20) {
        return NO;
    }
    if (textField == inputView.moneyTextField) {
        NSRange range = [textField.text rangeOfString:@"."];
        if (range.location != NSNotFound) {
            NSString *firstStr = [textField.text substringFromIndex:range.location + 1];
            if (firstStr.length > 1) {
                return NO;
            }
        }
    }
    if (textField == inputView.countTextField) {
        if ([textField.text rangeOfString:@"."].location != NSNotFound) {
            return NO;
        }
        NSMutableString *str = [NSMutableString string];
        [str appendString:textField.text];
        [str appendString:string];
        if ([str integerValue] > self.size) {
            textField.text = [NSString stringWithFormat:@"%ld", self.size];
            [TFJunYou_MyTools showTipView:@"红包个数不能超过群人数"];
            return NO;
        }
    }
    return YES;
}
- (NSString *)getSecretWithText:(NSString *)text time:(long)time {
    NSString *md5 = [g_server getMD5String:text];
    
    NSString *ret = [NSString stringWithFormat:@"%@%ld%@", APIKEY, time, _moneyText];
    ret = [g_server getMD5String:ret];
    
    ret = [ret stringByAppendingFormat:@"%@%@%@", g_myself.userId, g_server.access_token, md5];
    return [g_server getMD5String:ret];
}
@end
