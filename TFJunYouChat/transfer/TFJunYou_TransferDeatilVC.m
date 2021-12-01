#import "TFJunYou_TransferDeatilVC.h"
#import "TFJunYou_TransferModel.h"
#import "TFJunYou_MyMoneyViewController.h"
typedef NS_ENUM(NSInteger, TFJunYou_TransferDeatilType) {
    TFJunYou_TransferDeatilTypeMySend,        
    TFJunYou_TransferDeatilTypeWait,          
    TFJunYou_TransferDeatilTypeComplete,      
    TFJunYou_TransferDeatilTypeOverdue,       
};
@interface TFJunYou_TransferDeatilVC () <UIAlertViewDelegate>
@property (nonatomic, assign) TFJunYou_TransferDeatilType type;
@property (nonatomic, strong) TFJunYou_TransferModel *model;
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UILabel *hintLab;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *oneDayLabel;
@property (nonatomic, strong) UILabel *clickLab;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) UILabel *transferTime;
@property (nonatomic, strong) UILabel *getTime;
@end
@implementation TFJunYou_TransferDeatilVC
- (instancetype)init {
    if (self = [super init]) {
        self.heightHeader = 0;
        self.heightFooter = 0;
        [self createHeadAndFoot];
        self.model = [[TFJunYou_TransferModel alloc] init];
        [self setupViews];
        [g_notify addObserver:self selector:@selector(transferReceive:) name:kXMPPMessageTransferReceiveNotification object:nil]; 
        [g_notify addObserver:self selector:@selector(transferBack:) name:kXMPPMessageTransferBackNotification object:nil]; 
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getServerData];
}
- (void)setupViews {
    self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP - 46, 46, 46)];
    [btn setBackgroundImage:[UIImage imageNamed:@"title_back_black_big"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionQuit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    _imgV = [[UIImageView alloc] init];
    [self.tableBody addSubview:_imgV];
    _hintLab = [[UILabel alloc] init];
    _hintLab.font = SYSFONT(14);
    [self.tableBody addSubview:_hintLab];
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.font = SYSFONT(30);
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableBody addSubview:_moneyLabel];
    _oneDayLabel = [[UILabel alloc] init];
    _oneDayLabel.textColor = [UIColor lightGrayColor];
    _oneDayLabel.font = SYSFONT(14);
    [self.tableBody addSubview:_oneDayLabel];
    _clickLab = [[UILabel alloc] init];
    _clickLab.font = SYSFONT(14);
    _clickLab.textColor = HEXCOLOR(0x383893);
    _clickLab.userInteractionEnabled = YES;
    [self.tableBody addSubview:_clickLab];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickLab)];
    [_clickLab addGestureRecognizer:tap];
    _completeBtn = [[UIButton alloc] init];
    _completeBtn.layer.masksToBounds = YES;
    _completeBtn.layer.cornerRadius = 3.f;
    [_completeBtn setTitle:Localized(@"JX_ConfirmReceipt") forState:UIControlStateNormal];
    [_completeBtn setBackgroundColor:HEXCOLOR(0x1aad19)];
    [_completeBtn addTarget:self action:@selector(clickCompleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.tableBody addSubview:_completeBtn];
    _transferTime = [[UILabel alloc] init];
    _transferTime.textColor = [UIColor lightGrayColor];
    _transferTime.font = SYSFONT(14);
    [self.tableBody addSubview:_transferTime];
    _getTime = [[UILabel alloc] init];
    _getTime.textColor = [UIColor lightGrayColor];
    _getTime.font = SYSFONT(14);
    [self.tableBody addSubview:_getTime];
}
- (void)updateViews {
    UIImage *image;
    NSString *hintStr;
    NSString *oneDayStr;
    NSString *clickLabStr;
    NSString *botTimeStr;
    NSString *botTime;
    if (self.type == TFJunYou_TransferDeatilTypeMySend) {
        image = [UIImage imageNamed:@"ic_ts_status2"];
        hintStr = [NSString stringWithFormat:Localized(@"JX_ReceiptConfirmedBy%@"),self.model.userName];
        oneDayStr = Localized(@"JX_FriendNotConfirm1Day");
        clickLabStr = Localized(@"JX_ResendTransferMessage");
    }else if (self.type == TFJunYou_TransferDeatilTypeWait) {
        image = [UIImage imageNamed:@"ic_ts_status2"];
        hintStr = Localized(@"JX_PaymentConfirmed");
        oneDayStr = Localized(@"JX_SelfNotConfirm1Day");
    }else if (self.type == TFJunYou_TransferDeatilTypeComplete) {
        image = [UIImage imageNamed:@"ic_ts_status1"];
        clickLabStr = Localized(@"JX_LookAtTheChange");
        botTimeStr = Localized(@"JX_CollectMoneyTime");
        botTime = self.model.receiptTime;
    }else if (self.type == TFJunYou_TransferDeatilTypeOverdue) {
        image = [UIImage imageNamed:@"ic_ts_status3"];
        hintStr = Localized(@"JX_Returned(expired)");
        botTimeStr = Localized(@"JX_ExpirationTime");
        oneDayStr = Localized(@"JX_TheChangeHasBeenRefunded");
        clickLabStr = Localized(@"JX_LookAtTheChange");
        botTime = self.model.outTime;
    }
    _imgV.frame = CGRectMake((TFJunYou__SCREEN_WIDTH-40)/2, TFJunYou__SCREEN_TOP+20, 40, 40);
    _imgV.image = image;
    CGSize size = [hintStr sizeWithAttributes:@{NSFontAttributeName:SYSFONT(14)}];
    _hintLab.frame = CGRectMake((TFJunYou__SCREEN_WIDTH-size.width)/2, CGRectGetMaxY(_imgV.frame)+20, size.width, size.height);
    _hintLab.text = hintStr;
    _moneyLabel.frame = CGRectMake(0, CGRectGetMaxY(_hintLab.frame)+18, TFJunYou__SCREEN_WIDTH, 30);
    _moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.model.money];
    CGSize oneDaySize = [oneDayStr sizeWithAttributes:@{NSFontAttributeName:SYSFONT(14)}];
    CGSize clickLabSize = [clickLabStr sizeWithAttributes:@{NSFontAttributeName:SYSFONT(14)}];
    _oneDayLabel.frame = CGRectMake((TFJunYou__SCREEN_WIDTH-oneDaySize.width-clickLabSize.width)/2, CGRectGetMaxY(_moneyLabel.frame)+20, oneDaySize.width, oneDaySize.height);
    _oneDayLabel.text = oneDayStr;
    _clickLab.frame = CGRectMake(CGRectGetMaxX(_oneDayLabel.frame), _oneDayLabel.frame.origin.y, clickLabSize.width, clickLabSize.height);
    _clickLab.hidden = clickLabStr.length <= 0;
    _clickLab.text = clickLabStr;
    _completeBtn.frame = CGRectMake(100, CGRectGetMaxY(_oneDayLabel.frame)+40, TFJunYou__SCREEN_WIDTH-100*2, 40);
    _completeBtn.hidden = self.type != TFJunYou_TransferDeatilTypeWait;
    NSString *tranStr = [NSString stringWithFormat:@"%@:%@",Localized(@"JX_TransferTime"),self.model.createTime];
    CGSize trSize = [tranStr sizeWithAttributes:@{NSFontAttributeName:SYSFONT(14)}];
    _transferTime.frame = CGRectMake((TFJunYou__SCREEN_WIDTH-trSize.width)/2, TFJunYou__SCREEN_HEIGHT-130, trSize.width, 20);
    _transferTime.text = tranStr;
    NSString *getStr = [NSString stringWithFormat:@"%@:%@",botTimeStr,botTime];
    CGSize getSize = [getStr sizeWithAttributes:@{NSFontAttributeName:SYSFONT(14)}];
    _getTime.frame = CGRectMake(_transferTime.frame.origin.x, TFJunYou__SCREEN_HEIGHT-100, getSize.width, 20);
    _getTime.text = getStr;
    _getTime.hidden = self.type != TFJunYou_TransferDeatilTypeComplete && self.type != TFJunYou_TransferDeatilTypeOverdue;
}
- (void)clickCompleteBtn {
    [g_server getTransfer:self.msg.objectId toView:self];
}
- (void)onClickLab {
    if (self.type == TFJunYou_TransferDeatilTypeComplete || self.type == TFJunYou_TransferDeatilTypeOverdue) {
        TFJunYou_MyMoneyViewController *moneyVC = [[TFJunYou_MyMoneyViewController alloc] init];
        [g_navigation pushViewController:moneyVC animated:YES];
    }else if (self.type == TFJunYou_TransferDeatilTypeMySend) {
        [g_App showAlert:Localized(@"JX_ResendTransferMessage") delegate:self];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        int time = (int)([[NSDate date] timeIntervalSince1970] - [self.msg.timeSend timeIntervalSince1970]) / 60 % 60;
        if (time >= 5) {            
            if (self.delegate && [self.delegate respondsToSelector:self.onResend]) {
                [self.delegate performSelectorOnMainThread:self.onResend withObject:self.msg waitUntilDone:NO];
                [self actionQuit];
            }
        }else {
            [g_App showAlert:[NSString stringWithFormat:Localized(@"JX_ Again%dMinutesLater"),5-time]];
        }
    }
}
- (void)transferReceive:(NSNotification *)noti {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", time];
    self.model.receiptTime = [self getTime:timeString];
    self.type = TFJunYou_TransferDeatilTypeComplete;
    [self updateViews];
}
- (void)transferBack:(NSNotification *)noti {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", time];
    self.model.outTime = [self getTime:timeString];
    self.type = TFJunYou_TransferDeatilTypeOverdue;
    [self updateViews];
}
- (void)getServerData {
    [g_server transferDetail:self.msg.objectId toView:self];
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if([aDownload.action isEqualToString:act_getTransferInfo]){
        [self.model getTransferDataWithDict:dict];
        if (self.model.status == 1) {
            if (self.model.userId == [[NSString stringWithFormat:@"%@",MY_USER_ID] longLongValue]) {
                self.type = TFJunYou_TransferDeatilTypeMySend;
            }else {
                self.type = TFJunYou_TransferDeatilTypeWait;
            }
        }
        else if (self.model.status == 2) {
            self.type = TFJunYou_TransferDeatilTypeComplete;
            [g_notify postNotificationName:kUpdateTransferMsgFileSize object:[(NSDictionary *)dict[@"data"] objectForKey:@"id"]];
        }
        else if (self.model.status == -1) {
            self.type = TFJunYou_TransferDeatilTypeOverdue;
            [g_notify postNotificationName:kUpdateTransferMsgFileSize object:[(NSDictionary *)dict[@"data"] objectForKey:@"id"]];
        }
        [self updateViews];
    }
    if([aDownload.action isEqualToString:act_receiveTransfer]){
        self.model.receiptTime = [self getTime:dict[@"time"]];
        self.type = TFJunYou_TransferDeatilTypeComplete;
        [self updateViews];
        [g_notify postNotificationName:kUpdateTransferMsgFileSize object:dict[@"transferId"]];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if([aDownload.action isEqualToString:act_getTransferInfo]){
        if ([[dict objectForKey:@"resultCode"] intValue] == 100301 || [[dict objectForKey:@"resultCode"] intValue] == 100302) {
            NSDictionary *data = [dict objectForKey:@"data"];
            [self.model getTransferDataWithDict:data];
            if (self.model.status == 1) {
                if (self.model.userId == [[NSString stringWithFormat:@"%@",MY_USER_ID] longLongValue]) {
                    self.type = TFJunYou_TransferDeatilTypeMySend;
                }else {
                    self.type = TFJunYou_TransferDeatilTypeWait;
                }
            }
            else if (self.model.status == 2) {
                self.type = TFJunYou_TransferDeatilTypeComplete;
                [g_notify postNotificationName:kUpdateTransferMsgFileSize object:[(NSDictionary *)dict[@"data"] objectForKey:@"id"]];
            }
            else if (self.model.status == -1) {
                self.type = TFJunYou_TransferDeatilTypeOverdue;
                [g_notify postNotificationName:kUpdateTransferMsgFileSize object:[(NSDictionary *)dict[@"data"] objectForKey:@"id"]];
            }
            [self updateViews];
            return hide_error;
        }
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
- (NSString *)getTime:(NSString *)time {
    NSTimeInterval interval    = [time doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*currentDateStr = [formatter stringFromDate: date];
    return currentDateStr;
}
@end
