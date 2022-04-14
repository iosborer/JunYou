#import "TFJunYou_MyMoneyViewController.h"
#import "UIImage+Color.h"
#import "TFJunYou_CashWithDrawViewController.h"
#import "TFJunYou_RechargeViewController.h"
#import "TFJunYou_RecordCodeVC.h"
#import "TFJunYou_MoneyMenuViewController.h"
#import "TFJunYou_RealCerVc.h"
#import "TFJunYou_JLApplyForWithdrawalVC.h"
@interface TFJunYou_MyMoneyViewController ()
@property (nonatomic, strong) UIButton * listButton;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * myMoneyLabel;
@property (nonatomic, strong) UILabel * balanceLabel;
@property (nonatomic, strong) UIButton * rechargeBtn;
@property (nonatomic, strong) UIButton * withdrawalsBtn;
@end
@implementation TFJunYou_MyMoneyViewController
-(instancetype)init{
    if (self = [super init]) {
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.isGotoBack = YES;
        self.title = Localized(@"JXMoney_pocket");
        [g_notify addObserver:self selector:@selector(doRefresh:) name:kUpdateUserNotifaction object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHeadAndFoot];
    self.tableBody.alwaysBounceVertical = YES;
    [self.tableHeader addSubview:self.listButton];
    [self.tableBody addSubview:self.iconView];
    [self.tableBody addSubview:self.myMoneyLabel];
    [self.tableBody addSubview:self.balanceLabel];
    [self.tableBody addSubview:self.rechargeBtn];
    [self.tableBody addSubview:self.withdrawalsBtn];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [g_server getUserMoenyToView:self];
}
-(void)dealloc{
    [g_notify removeObserver:self];
}
-(UIButton *)listButton{
    if(!_listButton){
        _listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _listButton.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-24-15, TFJunYou__SCREEN_TOP - 35, 24, 24);
        [_listButton setImage:THESIMPLESTYLE ? [UIImage imageNamed:@"money_menu_black"] : [UIImage imageNamed:@"money_menu"] forState:UIControlStateNormal];
        _listButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_listButton addTarget:self action:@selector(listButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listButton;
}
-(UILabel *)myMoneyLabel{
    if (!_myMoneyLabel) {
        _myMoneyLabel = [UIFactory createLabelWith:CGRectZero text:Localized(@"JXMoney_myPocket") font:g_factory.font16 textColor:[UIColor blackColor] backgroundColor:nil];
        _myMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _myMoneyLabel.frame = CGRectMake(0, 99, TFJunYou__SCREEN_WIDTH, 20);
    }
    return _myMoneyLabel;
}
-(UILabel *)balanceLabel{
    if (!_balanceLabel) {
        NSString * moneyStr = [NSString stringWithFormat:@"¥%.2f",g_App.myMoney];
        _balanceLabel = [UIFactory createLabelWith:CGRectZero text:moneyStr font:g_factory.font28 textColor:[UIColor blackColor] backgroundColor:nil];
        _balanceLabel.textAlignment = NSTextAlignmentCenter;
        _balanceLabel.font = SYSFONT(40);
        _balanceLabel.frame = CGRectMake(0, CGRectGetMaxY(_myMoneyLabel.frame)+23, TFJunYou__SCREEN_WIDTH, 40);
    }
    return _balanceLabel;
}
-(UIButton *)rechargeBtn{
    if (!_rechargeBtn) {
        _rechargeBtn = [UIFactory createButtonWithRect:CGRectZero title:Localized(@"JXLiveVC_Recharge") titleFont:g_factory.font16 titleColor:[UIColor whiteColor] normal:nil selected:nil selector:@selector(rechargeBtnAction:) target:self];
        _rechargeBtn.frame = CGRectMake(15, CGRectGetMaxY(_balanceLabel.frame)+60, TFJunYou__SCREEN_WIDTH-15*2, 40);
        [_rechargeBtn setBackgroundImage:[UIImage createImageWithColor:THEMECOLOR] forState:UIControlStateNormal];
        _rechargeBtn.layer.cornerRadius = 7;
        _rechargeBtn.clipsToBounds = YES;
        _rechargeBtn.hidden = YES;
    }
    return _rechargeBtn;
}
-(UIButton *)withdrawalsBtn{
    if (!_withdrawalsBtn) {
        _withdrawalsBtn = [UIFactory createButtonWithRect:CGRectZero title:Localized(@"JXMoney_withdrawals") titleFont:g_factory.font16  titleColor:[UIColor whiteColor] normal:nil selected:nil selector:@selector(withdrawalsBtnAction:) target:self];
        _withdrawalsBtn.frame = CGRectMake(15, CGRectGetMaxY(_rechargeBtn.frame)+20, CGRectGetWidth(_rechargeBtn.frame), CGRectGetHeight(_rechargeBtn.frame));
        [_withdrawalsBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
        [_withdrawalsBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _withdrawalsBtn.layer.cornerRadius = 7;
        _withdrawalsBtn.clipsToBounds = YES;
        _withdrawalsBtn.layer.borderColor = THEMECOLOR.CGColor;
        _withdrawalsBtn.layer.borderWidth = 1.f;
    }
    return _withdrawalsBtn;
}
-(void)updateBalanceLabel{
    NSString * moneyStr = [NSString stringWithFormat:@"¥%.2f",g_App.myMoney];
    self.balanceLabel.text = moneyStr;
    CGFloat Width = [self.balanceLabel.text sizeWithAttributes:@{NSFontAttributeName:self.balanceLabel.font}].width;
    CGRect frame = self.balanceLabel.frame;
    frame.size.width = Width;
    self.balanceLabel.frame = frame;
    self.balanceLabel.center = CGPointMake(self.iconView.center.x, self.balanceLabel.center.y);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark Action
-(void)listButtonAction{
    _listButton.enabled = NO;
    [self performSelector:@selector(delayButtonReset) withObject:nil afterDelay:0.5];
    TFJunYou_MoneyMenuViewController *monVC = [[TFJunYou_MoneyMenuViewController alloc] init];
    [g_navigation pushViewController:monVC animated:YES];
}
-(void)rechargeBtnAction:(UIButton *)button{
    _rechargeBtn.enabled = NO;
    
    
//    if ([g_App.shortVideo intValue]==0) {
//         
//        TFJunYou_RealCerVc *cervc=[[TFJunYou_RealCerVc alloc]init];
//        [g_navigation pushViewController:cervc animated:YES];
//        return;
//    }
    
    [self performSelector:@selector(delayButtonReset) withObject:nil afterDelay:0.5];
    TFJunYou_RechargeViewController * rechargeVC = [[TFJunYou_RechargeViewController alloc] init];
    [g_navigation pushViewController:rechargeVC animated:YES];
}
-(void)withdrawalsBtnAction:(UIButton *)button{
    _withdrawalsBtn.enabled = NO;
    [self performSelector:@selector(delayButtonReset) withObject:nil afterDelay:0.5];
    // TFJunYou_JLApplyForWithdrawalVC TFJunYou_CashWithDrawViewController
    
    TFJunYou_CashWithDrawViewController * cashWithVC = [[TFJunYou_CashWithDrawViewController alloc] init];
    [g_navigation pushViewController:cashWithVC animated:YES];
}
-(void)problemBtnAction{
    [self performSelector:@selector(delayButtonReset) withObject:nil afterDelay:0.5];
}
-(void)delayButtonReset{
    _rechargeBtn.enabled = YES;
    _withdrawalsBtn.enabled = YES;
    _listButton.enabled = YES;
}
-(void)doRefresh:(NSNotification *)notifacation{
    _balanceLabel.text = [NSString stringWithFormat:@"¥%.2f",g_App.myMoney];
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    if ([aDownload.action isEqualToString:act_getUserMoeny]) {
        g_App.myMoney = [dict[@"balance"] doubleValue];
        NSString * moneyStr = [NSString stringWithFormat:@"¥%.2f",g_App.myMoney];
        _balanceLabel.text = moneyStr;
    }
}
@end
