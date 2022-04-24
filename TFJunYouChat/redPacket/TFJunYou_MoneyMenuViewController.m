#import "TFJunYou_MoneyMenuViewController.h"
#import "TFJunYou_RecordCodeVC.h"
#import "TFJunYou_PayPasswordVC.h"
#import "TFJunYou_forgetPwdVC.h"
#define HEIGHT 56
@interface TFJunYou_MoneyMenuViewController ()<forgetPwdVCDelegate>
@end
@implementation TFJunYou_MoneyMenuViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = Localized(@"JX_PayCenter");
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.isGotoBack = YES;
        [self createHeadAndFoot];
        int h=0;
        int w=TFJunYou__SCREEN_WIDTH;
        TFJunYou_ImageView* iv;
        iv = [self createButton:Localized(@"JX_Bill") drawTop:NO drawBottom:YES click:@selector(onBill)];
        iv.frame = CGRectMake(0,h, w, HEIGHT);
        h+=iv.frame.size.height;
        
        iv = [self createButton:Localized(@"JX_SetPayPsw") drawTop:NO drawBottom:YES  click:@selector(onPayThePassword)];
        iv.frame = CGRectMake(0,h, w, HEIGHT);
        h+=iv.frame.size.height;
        iv = [self createButton:@"忘记支付密码" drawTop:NO drawBottom:NO  click:@selector(onForgetPassWord)];
        iv.frame = CGRectMake(0,h, w, HEIGHT);
        h+=iv.frame.size.height;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)onBill {
    TFJunYou_RecordCodeVC * recordVC = [[TFJunYou_RecordCodeVC alloc]init];
    [g_navigation pushViewController:recordVC animated:YES];
}
- (void)onPayThePassword {
    TFJunYou_PayPasswordVC * PayVC = [TFJunYou_PayPasswordVC alloc];
    if ([g_server.myself.isPayPassword boolValue]) {
        PayVC.type = TFJunYou_PayTypeInputPassword;
    }else {
        PayVC.type = TFJunYou_PayTypeSetupPassword;
    }
    PayVC.enterType = TFJunYou_EnterTypeDefault;
    PayVC = [PayVC init];
    [g_navigation pushViewController:PayVC animated:YES];
}
- (void)onForgetPassWord {
    TFJunYou_forgetPwdVC* vc = [[TFJunYou_forgetPwdVC alloc] init];
    vc.delegate = self;
    vc.isPayPWD = YES;
    vc.isModify = NO;
    [g_navigation pushViewController:vc animated:YES];
}
- (void)forgetPwdSuccess {
    g_server.myself.isPayPassword = nil;
    [self onPayThePassword];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(TFJunYou_ImageView*)createButton:(NSString*)title drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom click:(SEL)click{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    btn.didTouch = click;
    btn.delegate = self;
    [self.tableBody addSubview:btn];
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(15, 0, self_width-15, HEIGHT)];
    p.text = title;
    p.font = g_factory.font17;
    p.backgroundColor = [UIColor clearColor];
    p.textColor = HEXCOLOR(0x323232);
    [btn addSubview:p];
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(15,0,TFJunYou__SCREEN_WIDTH-20,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    if(drawBottom){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(15,HEIGHT-LINE_WH,TFJunYou__SCREEN_WIDTH-15,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    if(click){
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, (HEIGHT-13)/2, 7, 13)];
        iv.image = [UIImage imageNamed:@"new_icon_>"];
        [btn addSubview:iv];
    }
    return btn;
}
@end
