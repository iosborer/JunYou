#import "TFJunYou_PayViewController.h"
#import "TFJunYou_CollectMoneyVC.h"
#import "QRImage.h"
#import "TFJunYou_ScanQRViewController.h"
#import "TFJunYou_InputMoneyVC.h"
#import "TFJunYou_VerifyPayVC.h"
#import "TFJunYou_PayPasswordVC.h"
#define HEIGHT 50
@interface TFJunYou_PayViewController ()<TFJunYou_PayPasswordVCDelegate>
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UIButton *getBtn;
@property (nonatomic, strong) UIButton *scanBtn;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *btnBaseView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *barCode;
@property (nonatomic, strong) UIImageView *payQrCode;
@property (nonatomic, strong) NSString *codeStr;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *payBaseView;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *desStr;
@property (nonatomic, strong) UIImageView *getQrCode;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rigLabel;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UILabel *barCodeLab;
@property (nonatomic, strong) TFJunYou_VerifyPayVC * verVC;
@end
@implementation TFJunYou_PayViewController
static dispatch_source_t _timer;
- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightHeader = 0;
    self.heightFooter = 0;
    [self createHeadAndFoot];
    [self setupNav];
    [self setupViews];
    [self setupGetMoneyViews];
    [self setupFootView];
    [g_notify addObserver:self selector:@selector(notifyPaymentGet:) name:kXMPPMessageQrPaymentNotification object:nil];
    self.tableBody.scrollEnabled = !BIG_DEVICE;
}
- (void)notifyPaymentGet:(NSNotification *)noti {
    TFJunYou_MessageObject *msg = noti.object;
    if ([msg.type intValue] == kWCMessageTypePaymentOut) {
        [g_server showMsg:Localized(@"JX_PaymentToFriend")];
        [self updatePayQrCode];
    }
    if ([msg.type intValue] == kWCMessageTypeReceiptGet) {
        [g_server showMsg:Localized(@"JX_PaymentReceived")];
        [self updateGetQrCode];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopTimer];
}
- (void)setupFootView {
    CGFloat w = TFJunYou__SCREEN_WIDTH/3;
    CGFloat h = 48;
    CGFloat y = CGRectGetMaxY(_payBaseView.frame)+33;
    _payBtn = [self createButtonWithFrame:CGRectMake(0,y, w, h) title:@"?????????" icon:@"payment_code_icon" selected:@"payment_code_select_icon" click:@selector(onCurrentVC:)];
    _getBtn = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(_payBtn.frame), y, w, h) title:@"?????????" icon:@"collection_code_icon" selected:@"collection_code_selecet_icon" click:@selector(onCollectMoney:)];
    _scanBtn = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(_getBtn.frame),y, w, h) title:@"?????????" icon:@"sweep_code_icon" selected:@"sweep_code_selecet_icon" click:@selector(onScanQrCodeVC)];
    self.tableBody.backgroundColor = [UIColor clearColor];
    _backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backImageView.image = [UIImage imageNamed:@"background_green"];
    [self.view insertSubview:_backImageView belowSubview:self.tableBody];
    if (!BIG_DEVICE) {
        if (y > self.tableBody.frame.size.height) {
            self.tableBody.contentSize = CGSizeMake(0, y);
        }
    }
    [self onCurrentVC:_payBtn];
}
- (void)setupNav {
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_TOP)];
    nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nav];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP - 46, 46, 46)];
    [btn setBackgroundImage:[[UIImage imageNamed:@"title_back_black_big"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionQuit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    UILabel *p = [[UILabel alloc]initWithFrame:CGRectMake(40, TFJunYou__SCREEN_TOP - 32, TFJunYou__SCREEN_WIDTH-40*2, 20)];
    p.backgroundColor = [UIColor clearColor];
    p.textAlignment   = NSTextAlignmentCenter;
    p.textColor       = [UIColor whiteColor];
    p.text = Localized(@"JX_Receiving");
    p.font = SYSFONT(18);
    [nav addSubview:p];
    _titleLab = p;
}
- (void)setupViews {
    _payBaseView = [[UIView alloc] initWithFrame:CGRectMake(28, TFJunYou__SCREEN_TOP+60, TFJunYou__SCREEN_WIDTH-28*2, 440)];
    _payBaseView.backgroundColor = [UIColor whiteColor];
    _payBaseView.layer.masksToBounds = YES;
    _payBaseView.layer.cornerRadius = 7.f;
    _payBaseView.clipsToBounds = NO;
    [self.tableBody addSubview:_payBaseView];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((_payBaseView.frame.size.width-80)/2, -40, 80, 80)];
    [_payBaseView addSubview:icon];
    [g_server getHeadImageLarge:g_server.myself.userId userName:g_server.myself.userNickname imageView:icon];
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 80, 80)].CGPath;
    icon.layer.mask = circleShape;
    CAShapeLayer *circleBorder= [CAShapeLayer layer];
    circleBorder.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 80, 80)].CGPath;
    circleBorder.strokeColor = [UIColor whiteColor].CGColor;
    circleBorder.fillColor = [UIColor clearColor].CGColor;
    circleBorder.lineWidth = 7.f;
    [icon.layer addSublayer:circleBorder];
    _barCode = [[UIImageView alloc] initWithFrame:CGRectMake(18, 60, _payBaseView.frame.size.width- 36, 83)];
    [_payBaseView addSubview:_barCode];
    UILabel *barCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_barCode.frame)+15, _payBaseView.frame.size.width, 15)];
    barCodeLab.text = Localized(@"JX_PaymentBarCode");
    barCodeLab.textColor = HEXCOLOR(0x666666);
    barCodeLab.font = SYSFONT(14);
    barCodeLab.textAlignment = NSTextAlignmentCenter;
    [_payBaseView addSubview:barCodeLab];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(barCodeLab.frame)+25, _payBaseView.frame.size.width, LINE_WH)];
    [_payBaseView addSubview:line];
    [self addBorderToLayer2:line];
    int lRW = 30;
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(-lRW/2-5, CGRectGetMaxY(line.frame)-lRW/2, lRW, lRW)];
    leftV.backgroundColor = HEXCOLOR(0x5fcec7);
    leftV.layer.masksToBounds = YES;
    leftV.layer.cornerRadius = lRW/2;
    [_payBaseView addSubview:leftV];
    UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(_payBaseView.frame.size.width - lRW/2+5, CGRectGetMaxY(line.frame)-lRW/2, lRW, lRW)];
    rightV.backgroundColor = HEXCOLOR(0x5fcec7);
    rightV.layer.masksToBounds = YES;
    rightV.layer.cornerRadius = lRW/2;
    [_payBaseView addSubview:rightV];
    _payQrCode = [[UIImageView alloc] initWithFrame:CGRectMake((_payBaseView.frame.size.width - 190)/2, CGRectGetMaxY(line.frame)+25, 190, 190)];
    [_payBaseView addSubview:_payQrCode];
    NSData *qrKey = [g_default objectForKey:kMyQRKey];
    if (qrKey && qrKey.length > 0) {
        long time = (long)[[NSDate date] timeIntervalSince1970];
        time = (time *1000 + g_server.timeDifference);
        NSString *salt = [NSString stringWithFormat:@"%ld", time];
        NSMutableString *value = [NSMutableString string];
        [value appendString:APIKEY];
        [value appendString:g_myself.userId];
        [value appendString:g_server.access_token];
        [value appendString:salt];
        NSData *macData = [g_securityUtil getHMACMD5:[value dataUsingEncoding:NSUTF8StringEncoding] key:qrKey];
        NSString *mac = [macData base64EncodedStringWithOptions:0];
        [g_server payVerifyQrKeyWithSalt:salt mac:mac toView:self];
    }else {
        if ([g_server.myself.isPayPassword boolValue]) {
            self.verVC = [TFJunYou_VerifyPayVC alloc];
            self.verVC.type = TFJunYou_VerifyTypePaymentCode;
            self.verVC.RMB = @"";
            self.verVC.delegate = self;
            self.verVC.didDismissVC = @selector(dismissVerifyPayVC);
            self.verVC.didVerifyPay = @selector(didVerifyPay:);
            self.verVC = [self.verVC init];
            [self.view addSubview:self.verVC.view];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                TFJunYou_PayPasswordVC *payPswVC = [TFJunYou_PayPasswordVC alloc];
                payPswVC.delegate = self;
                payPswVC.type = TFJunYou_PayTypeSetupPassword;
                payPswVC.enterType = TFJunYou_EnterTypePayQr;
                payPswVC = [payPswVC init];
                [g_navigation pushViewController:payPswVC animated:YES];
            });
        }
    }
}
- (void)didVerifyPay:(NSString *)sender {
    long time = (long)[[NSDate date] timeIntervalSince1970];
    time = (time *1000 + g_server.timeDifference)/1000;
    NSMutableArray *arr =[NSMutableArray array];
    [g_payServer payServerWithAction:act_payGetQrKey param:arr payPassword:sender time:time toView:self];
}
- (void)dismissVerifyPayVC {
    [self.verVC.view removeFromSuperview];
}
#pragma mark - ??????
- (void)onCurrentVC:(UIButton *)button {
    if (button.selected) {
        return;
    }
    _baseView.hidden = YES;
    _btnBaseView.hidden = YES;
    _payBaseView.hidden = NO;
    [self selectedBtn:_payBtn normal:_getBtn];
    _backImageView.image = [UIImage imageNamed:@"background_green"];
    self.titleLab.text = @"?????????";
}
#pragma mark - ??????
- (void)onCollectMoney:(UIButton *)button {
    if (button.selected) {
        return;
    }
    _payBaseView.hidden = YES;
    _baseView.hidden = NO;
    _btnBaseView.hidden = NO;
    [self selectedBtn:_getBtn normal:_payBtn];
    _backImageView.image = [UIImage imageNamed:@"background_yellow"];
    self.titleLab.text = @"?????????";
}
- (void)selectedBtn:(UIButton *)sBtn normal:(UIButton *)nBtn {
    sBtn.selected = YES;
    nBtn.selected = NO;
    for (UIView *sub in sBtn.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)sub;
            lab.textColor = [UIColor whiteColor];
        }
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            btn.selected = YES;
        }
    }
    for (UIView *sub in nBtn.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)sub;
            lab.textColor = [HEXCOLOR(0xFFFFFF) colorWithAlphaComponent:0.5];
        }
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            btn.selected = NO;
        }
    }
}
#pragma mark - ?????????
- (void)onScanQrCodeVC {
    TFJunYou_ScanQRViewController *vc = [[TFJunYou_ScanQRViewController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}
#pragma mark - ?????? ?????? ????????? && ?????????
- (void)updatePayQrCode {
    [self dismissVerifyPayVC];
    self.codeStr = [self getPayQrCodeStr];
    _barCode.image = [QRImage barCodeWithString:self.codeStr BCSize:_barCode.frame.size];
    _payQrCode.image = [QRImage qrImageForString:self.codeStr imageSize:200];
}
- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0
                                                  target:self
                                                selector:@selector(updatePayQrCode) userInfo:nil
                                                 repeats:YES];
}
- (void)stopTimer {
    if (_timer){
        [_timer invalidate];
    }
}
- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString*)title icon:(NSString*)icon selected:(NSString *)selected click:(SEL)click{
    UIButton* btn = [[UIButton alloc] initWithFrame:frame];
    btn.backgroundColor = [UIColor clearColor];
    btn.userInteractionEnabled = YES;
    [btn addTarget:self action:click forControlEvents:UIControlEventTouchUpInside];
    [self.tableBody addSubview:btn];
    UIButton* image = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2-10, 0, 20, 20)];
    [image setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [image setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    image.userInteractionEnabled = NO;
    [btn addSubview:image];
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame)+15, frame.size.width, 13)];
    p.text = title;
    p.font = g_factory.font13;
    p.textAlignment = NSTextAlignmentCenter;
    p.backgroundColor = [UIColor clearColor];
    p.textColor = [HEXCOLOR(0xFFFFFF) colorWithAlphaComponent:0.5];
    [btn addSubview:p];
    return btn;
}
#pragma mark - ?????????????????????
- (NSString *)getPayQrCodeStr {
    NSString *qrCode = [g_payServer getQrCode];
    return qrCode;
}
-(int)getRandomNumber:(int)from to:(int)to {
    return (from + (arc4random() % (to - from + 1)));
}
#pragma mark - --------------???????????????????????????--------------
- (void)setupGetMoneyViews {
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(28, TFJunYou__SCREEN_TOP+60, TFJunYou__SCREEN_WIDTH-28*2, 318)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.masksToBounds = YES;
    _baseView.layer.cornerRadius = 7.f;
    _baseView.hidden = YES;
    _baseView.clipsToBounds = NO;
    [self.tableBody addSubview:_baseView];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((_payBaseView.frame.size.width-80)/2, -40, 80, 80)];
    [_baseView addSubview:icon];
    [g_server getHeadImageLarge:g_server.myself.userId userName:g_server.myself.userNickname imageView:icon];
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 80, 80)].CGPath;
    icon.layer.mask = circleShape;
    CAShapeLayer *circleBorder= [CAShapeLayer layer];
    circleBorder.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 80, 80)].CGPath;
    circleBorder.strokeColor = [UIColor whiteColor].CGColor;
    circleBorder.fillColor = [UIColor clearColor].CGColor;
    circleBorder.lineWidth = 7.f;
    [icon.layer addSublayer:circleBorder];
    _barCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, _baseView.frame.size.width, 15)];
    _barCodeLab.text = Localized(@"JX_ScanQrCodeToPayMe");
    _barCodeLab.textColor = HEXCOLOR(0x666666);
    _barCodeLab.font = SYSFONT(14);
    _barCodeLab.textAlignment = NSTextAlignmentCenter;
    [_baseView addSubview:_barCodeLab];
    _moneyLab = [[UILabel alloc] init];
    _moneyLab.font = SYSFONT(20);
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    [_baseView addSubview:_moneyLab];
    _descLab = [[UILabel alloc] init];
    _descLab.font = SYSFONT(14);
    _descLab.textColor = [UIColor lightGrayColor];
    _descLab.textAlignment = NSTextAlignmentCenter;
    [_baseView addSubview:_descLab];
    _getQrCode = [[UIImageView alloc] init];
    [_baseView addSubview:_getQrCode];
    _btnBaseView = [[UIView alloc] initWithFrame:CGRectMake(28, CGRectGetMaxY(_baseView.frame)+27, TFJunYou__SCREEN_WIDTH-28*2, 90)];
    _btnBaseView.layer.masksToBounds = YES;
    _btnBaseView.layer.cornerRadius = 7.f;
    _btnBaseView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [self.tableBody addSubview:_btnBaseView];
    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _btnBaseView.frame.size.width-15, 45)];
    _leftLabel.font = SYSFONT(16);
    _leftLabel.textColor = [UIColor whiteColor];
    _leftLabel.userInteractionEnabled = YES;
    [_btnBaseView addSubview:_leftLabel];
    UITapGestureRecognizer *tapL = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setMoneyCount)];
    [_leftLabel addGestureRecognizer:tapL];
    UIImageView* iv;
    iv = [[UIImageView alloc] initWithFrame:CGRectMake(_leftLabel.frame.size.width-15-7, (_leftLabel.frame.size.height-13)/2, 7, 13)];
    iv.image = [[UIImage imageNamed:@"new_icon_>"] imageWithTintColor:[UIColor whiteColor]];
    [_leftLabel addSubview:iv];
    UIView *botLine = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_leftLabel.frame), _btnBaseView.frame.size.width-15, LINE_WH)];
    botLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [_btnBaseView addSubview:botLine];
    _rigLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(botLine.frame), _btnBaseView.frame.size.width-15, 45)];
    _rigLabel.text = Localized(@"JX_SaveCollectionCode");
    _rigLabel.font = SYSFONT(16);
    _rigLabel.textColor = [UIColor whiteColor];
    _rigLabel.userInteractionEnabled = YES;
    [_btnBaseView addSubview:_rigLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveQr)];
    [_rigLabel addGestureRecognizer:tap];
    iv = [[UIImageView alloc] initWithFrame:CGRectMake(_rigLabel.frame.size.width-15-7, (_rigLabel.frame.size.height-13)/2, 7, 13)];
    iv.image = [[UIImage imageNamed:@"new_icon_>"] imageWithTintColor:[UIColor whiteColor]];
    [_rigLabel addSubview:iv];
    [self updateViews];
}
#pragma mark - ????????????
- (void)updateViews {
    CGSize mSize  = [self.money sizeWithAttributes:@{NSFontAttributeName:SYSFONT(20)}];
    _moneyLab.text = [NSString stringWithFormat:@"??%.2f",[self.money doubleValue]];
    _moneyLab.frame = CGRectMake(0, CGRectGetMaxY(_barCodeLab.frame)+10, _baseView.frame.size.width, mSize.height);
    CGSize dSize  = [self.desStr sizeWithAttributes:@{NSFontAttributeName:SYSFONT(14)}];
    _descLab.text = self.desStr;
    _descLab.frame = CGRectMake(0, CGRectGetMaxY(_moneyLab.frame)+10, _baseView.frame.size.width, dSize.height);
    _getQrCode.frame = CGRectMake((_baseView.frame.size.width - 190)/2, CGRectGetMaxY(_descLab.frame)+10, 190, 190);
    _leftLabel.text = self.money.length > 0 ? Localized(@"JX_RemoveTheAmount") : Localized(@"JX_SetTheAmount");
    _baseView.frame = CGRectMake(_baseView.frame.origin.x, _baseView.frame.origin.y, _baseView.frame.size.width, CGRectGetMaxY(_getQrCode.frame)+23);
    _btnBaseView.frame = CGRectMake(_btnBaseView.frame.origin.x, CGRectGetMaxY(_baseView.frame)+38, _btnBaseView.frame.size.width, _btnBaseView.frame.size.height);
    _payBtn.frame = CGRectMake(_payBtn.frame.origin.x, CGRectGetMaxY(_btnBaseView.frame)+38, _payBtn.frame.size.width, _payBtn.frame.size.height);
    _getBtn.frame = CGRectMake(_getBtn.frame.origin.x, CGRectGetMinY(_payBtn.frame), _getBtn.frame.size.width, _getBtn.frame.size.height);
    _scanBtn.frame = CGRectMake(_scanBtn.frame.origin.x, CGRectGetMinY(_payBtn.frame), _scanBtn.frame.size.width, _scanBtn.frame.size.height);
    if (!BIG_DEVICE) {
        if (CGRectGetMaxY(_scanBtn.frame)+10 > self.tableBody.frame.size.height) {
            self.tableBody.contentSize = CGSizeMake(0, CGRectGetMaxY(_scanBtn.frame)+10);
        }
    }
    [self updateGetQrCode];
}
- (void)setMoneyCount {
    if (self.money.length > 0) {
        self.money = nil;
        self.desStr = nil;
        [self updateViews];
        return;
    }
    TFJunYou_InputMoneyVC *inputVC = [[TFJunYou_InputMoneyVC alloc] init];
    inputVC.type = TFJunYou_InputMoneyTypeSetMoney;
    inputVC.delegate = self;
    inputVC.onInputMoney = @selector(onInputMoney:);
    [g_navigation pushViewController:inputVC animated:YES];
}
- (void)onInputMoney:(NSDictionary *)dict {
    if ([dict objectForKey:@"money"]) {
        self.money = [dict objectForKey:@"money"];
    }
    if ([dict objectForKey:@"desc"]) {
        self.desStr = [dict objectForKey:@"desc"];
    }
    [self updateViews];
}
#pragma mark - ????????????????????????
- (void)saveQr {
    UIImageWriteToSavedPhotosAlbum(self.getQrCode.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        [g_server showMsg:Localized(@"ImageBrowser_saveFaild")];
    }else{
        [g_server showMsg:Localized(@"ImageBrowser_saveSuccess")];
    }
}
#pragma mark - ?????????????????????
- (void)updateGetQrCode {
    UIImageView *imageView = [[UIImageView alloc] init];
    [g_server getHeadImageLarge:MY_USER_ID userName:MY_USER_NAME imageView:imageView];
    _getQrCode.image = [QRImage qrImageForString:[self getQrCodeStr] imageSize:_getQrCode.frame.size.width logoImage:imageView.image logoImageSize:30];
}
- (NSString *)getQrCodeStr {
    NSMutableDictionary *dict = @{@"userId":MY_USER_ID,@"userName":MY_USER_NAME}.mutableCopy;
    if (self.money.length > 0) {
        [dict addEntriesFromDictionary:@{@"money":self.money}];
    }
    if (self.desStr.length > 0) {
        [dict addEntriesFromDictionary:@{@"description":self.desStr}];
    }
    SBJsonWriter * OderJsonwriter = [SBJsonWriter new];
    NSString * jsonString = [OderJsonwriter stringWithObject:dict];
    return jsonString;
}
- (void)setupView:(UIView *)view colors:(NSArray *)colors {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, THE_DEVICE_HAVE_HEAD ? -44 : -20, TFJunYou__SCREEN_WIDTH, THE_DEVICE_HAVE_HEAD ? TFJunYou__SCREEN_HEIGHT+44 : TFJunYou__SCREEN_HEIGHT+20);  
    gradientLayer.colors = colors;  
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [view.layer addSublayer:gradientLayer];
}
- (void)addBorderToLayer2:(UIView *)view {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(view.frame) / 2, CGRectGetHeight(view.frame)/2)];
    [shapeLayer setStrokeColor:[UIColor lightGrayColor].CGColor];
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineDashPattern:@[@5,@3]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (CGRectGetWidth(view.frame) > CGRectGetHeight(view.frame)) {
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(view.frame),0);
    }else{
        CGPathAddLineToPoint(path, NULL, 0,CGRectGetHeight(view.frame));
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [view.layer addSublayer:shapeLayer];
}
- (void)updatePayPasswordSuccess:(NSString *)payPassword {
    [self didVerifyPay:payPassword];
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_payGetQrKey]) {
        [self updatePayQrCode];
        [self startTimer];
    }
    if ([aDownload.action isEqualToString:act_payVerifyQrKey]) {
        [self updatePayQrCode];
        [self startTimer];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_payVerifyQrKey]) {
        if ([g_server.myself.isPayPassword boolValue]) {
            self.verVC = [TFJunYou_VerifyPayVC alloc];
            self.verVC.type = TFJunYou_VerifyTypePaymentCode;
            self.verVC.RMB = @"";
            self.verVC.delegate = self;
            self.verVC.didDismissVC = @selector(dismissVerifyPayVC);
            self.verVC.didVerifyPay = @selector(didVerifyPay:);
            self.verVC = [self.verVC init];
            [self.view addSubview:self.verVC.view];
        } else {
            TFJunYou_PayPasswordVC *payPswVC = [TFJunYou_PayPasswordVC alloc];
            payPswVC.delegate = self;
            payPswVC.type = TFJunYou_PayTypeSetupPassword;
            payPswVC.enterType = TFJunYou_EnterTypePayQr;
            payPswVC = [payPswVC init];
            [g_navigation pushViewController:payPswVC animated:YES];
        }
        return hide_error;
    }
    if ([aDownload.action isEqualToString:act_payGetQrKey] || [aDownload.action isEqualToString:act_TransactionGetCode]) {
        [self.verVC clearUpPassword];
    }
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_payVerifyQrKey]) {
        if ([g_server.myself.isPayPassword boolValue]) {
            self.verVC = [TFJunYou_VerifyPayVC alloc];
            self.verVC.type = TFJunYou_VerifyTypePaymentCode;
            self.verVC.RMB = @"";
            self.verVC.delegate = self;
            self.verVC.didDismissVC = @selector(dismissVerifyPayVC);
            self.verVC.didVerifyPay = @selector(didVerifyPay:);
            self.verVC = [self.verVC init];
            [self.view addSubview:self.verVC.view];
        } else {
            TFJunYou_PayPasswordVC *payPswVC = [TFJunYou_PayPasswordVC alloc];
            payPswVC.delegate = self;
            payPswVC.type = TFJunYou_PayTypeSetupPassword;
            payPswVC.enterType = TFJunYou_EnterTypePayQr;
            payPswVC = [payPswVC init];
            [g_navigation pushViewController:payPswVC animated:YES];
        }
        return hide_error;
    }
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}
@end
