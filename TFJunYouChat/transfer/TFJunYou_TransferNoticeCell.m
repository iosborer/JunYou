#import "TFJunYou_TransferNoticeCell.h"
#import "TFJunYou_TransferNoticeModel.h"
#import "TFJunYou_TransferModel.h"
#import "TFJunYou_TransferOpenPayModel.h"
@interface TFJunYou_TransferNoticeCell ()
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *moneyTit;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *payTit;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *noteTit;
@property (nonatomic, strong) UILabel *noteLab;
@property (nonatomic, strong) UILabel *backLab;
@property (nonatomic, strong) UILabel *backTime;
@property (nonatomic, strong) UILabel *sendLab;
@property (nonatomic, strong) UILabel *sendTime;
@end
@implementation TFJunYou_TransferNoticeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, TFJunYou__SCREEN_WIDTH-30, 200)];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.layer.masksToBounds = YES;
        _baseView.layer.cornerRadius = 7.f;
        [self.contentView addSubview:_baseView];
        _title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 18)];
        _title.font = SYSFONT(16);
        [_baseView addSubview:_title];
        _moneyTit = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_title.frame)+10, _baseView.frame.size.width, 18)];
        _moneyTit.text = Localized(@"JX_GetMoney");
        _moneyTit.textAlignment = NSTextAlignmentCenter;
        _moneyTit.textColor = HEXCOLOR(0x999999);
        [_baseView addSubview:_moneyTit];
        _moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_moneyTit.frame)+10, _baseView.frame.size.width, 43)];
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        _moneyLab.font = [UIFont boldSystemFontOfSize:40];
        [_baseView addSubview:_moneyLab];
        _payTit = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_moneyLab.frame)+20, 80, 18)];
        _payTit.textColor = HEXCOLOR(0x999999);
        _payTit.font = SYSFONT(16);
        [_baseView addSubview:_payTit];
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(95, _payTit.frame.origin.y, _baseView.frame.size.width-70, 18)];
        _nameLab.textColor = HEXCOLOR(0x999999);
        _nameLab.font = SYSFONT(16);
        [_baseView addSubview:_nameLab];
        _noteTit = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_payTit.frame)+10, 80, 18)];
        _noteTit.textColor = HEXCOLOR(0x999999);
        _noteTit.font = SYSFONT(16);
        [_baseView addSubview:_noteTit];
        _noteLab = [[UILabel alloc] initWithFrame:CGRectMake(95, _noteTit.frame.origin.y, _baseView.frame.size.width-70, 18)];
        _noteLab.textColor = HEXCOLOR(0x999999);
        _noteLab.font = SYSFONT(16);
        [_baseView addSubview:_noteLab];
        _backLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_noteTit.frame)+10, 80, 18)];
        _backLab.text = Localized(@"JX_ReturnTheTime");
        _backLab.textColor = HEXCOLOR(0x999999);
        _backLab.font = SYSFONT(16);
        [_baseView addSubview:_backLab];
        _backTime = [[UILabel alloc] initWithFrame:CGRectMake(95, _backLab.frame.origin.y, _baseView.frame.size.width-70, 18)];
        _backTime.textColor = HEXCOLOR(0x999999);
        _backTime.font = SYSFONT(16);
        [_baseView addSubview:_backTime];
        _sendLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_backLab.frame)+10, 80, 18)];
        _sendLab.text = Localized(@"JX_TransferTime");
        _sendLab.textColor = HEXCOLOR(0x999999);
        _sendLab.font = SYSFONT(16);
        [_baseView addSubview:_sendLab];
        _sendTime = [[UILabel alloc] initWithFrame:CGRectMake(95, _sendLab.frame.origin.y, _baseView.frame.size.width-70, 18)];
        _sendTime.textColor = HEXCOLOR(0x999999);
        _sendTime.font = SYSFONT(16);
        [_baseView addSubview:_sendTime];
    }
    return self;
}
- (void)setDataWithMsg:(TFJunYou_MessageObject *)msg model:(id)tModel {
    if ([msg.type intValue] == kWCMessageTypeTransferBack) {
        TFJunYou_TransferModel *model = (TFJunYou_TransferModel *)tModel;
        _moneyTit.text = Localized(@"JX_Refunds");
        _payTit.text = Localized(@"JX_TheRefundWay");
        _nameLab.text = Localized(@"JX_ReturnedToTheChange");
        _noteTit.text = Localized(@"JX_ReturnReason");
        [self hideTime:NO];
        _moneyLab.text = [NSString stringWithFormat:@"¥%.2f",model.money];
        _backTime.text = model.outTime;
        _sendTime.text = model.createTime;
        _baseView.frame = CGRectMake(10, 10, TFJunYou__SCREEN_WIDTH-20, 200+56);
    }
    else if ([msg.type intValue] == kWCMessageTypeOpenPaySuccess) {
        TFJunYou_TransferOpenPayModel *model = (TFJunYou_TransferOpenPayModel *)tModel;
        _noteTit.text = Localized(@"JX_Note");
        _payTit.text = Localized(@"JX_Payee");
        _nameLab.text = model.name;;
        [self hideTime:YES];
        _moneyLab.text = [NSString stringWithFormat:@"¥%.2f",model.money];
        _baseView.frame = CGRectMake(10, 10, TFJunYou__SCREEN_WIDTH-20, 200);
    }
    else {
        TFJunYou_TransferNoticeModel *model = (TFJunYou_TransferNoticeModel *)tModel;
        _noteTit.text = Localized(@"JX_Note");
        if (model.type == 1 && [model.userId intValue] == [MY_USER_ID intValue]) {
            _payTit.text = Localized(@"JX_Payee");
            _nameLab.text = model.toUserName;
        }
        else if (model.type == 1 && [model.userId intValue] != [MY_USER_ID intValue]) {
            _payTit.text = Localized(@"JX_Drawee");
            _nameLab.text = model.userName;
        }
        else if (model.type == 2 && [model.userId intValue] == [MY_USER_ID intValue]) {
            _payTit.text = Localized(@"JX_Drawee");
            _nameLab.text = model.toUserName;
        }
        else if (model.type == 2 && [model.userId intValue] != [MY_USER_ID intValue]){
            _payTit.text = Localized(@"JX_Payee");
            _nameLab.text = model.userName;
        }
        [self hideTime:YES];
        _moneyLab.text = [NSString stringWithFormat:@"¥%.2f",model.money];
        _baseView.frame = CGRectMake(10, 10, TFJunYou__SCREEN_WIDTH-20, 200);
    }
    _title.text = [self getTitle:[msg.type intValue]];
    _noteLab.text = [self getNote:msg];
}
- (void)hideTime:(BOOL)isHide {
    _backLab.hidden = isHide;
    _backTime.hidden = isHide;
    _sendLab.hidden = isHide;
    _sendTime.hidden = isHide;
}
- (NSString *)getTitle:(int)type {
    NSString *string;
    if (type == kWCMessageTypeTransferBack) {
        string = Localized(@"JX_RefundNoticeOfOverdueTransfer");
    }
    else if (type == kWCMessageTypePaymentOut || type == kWCMessageTypeReceiptOut) {
        string = Localized(@"JX_PaymentNo.");
    }
    else if (type == kWCMessageTypePaymentGet || type == kWCMessageTypeReceiptGet) {
        string = Localized(@"JX_ReceiptNotice");
    }
    if (type == kWCMessageTypeOpenPaySuccess) {
        string = Localized(@"JX_PaymentVoucher");
    }
    return string;
}
- (NSString *)getNote:(TFJunYou_MessageObject *)msg {
    NSString *string;
    if ([msg.type intValue] == kWCMessageTypeTransferBack) {
        string = Localized(@"JX_TransferIsOverdueAndTheChange");
    }
    else if ([msg.type intValue] == kWCMessageTypePaymentOut || [msg.type intValue] == kWCMessageTypeReceiptOut) {
        string = Localized(@"JX_PaymentToFriend");
    }
    else if ([msg.type intValue] == kWCMessageTypePaymentGet || [msg.type intValue] == kWCMessageTypeReceiptGet) {
        string = Localized(@"JX_PaymentReceived");
    }
    else if ([msg.type intValue] == kWCMessageTypeTransferBack) {
        string = [NSString stringWithFormat:@"%@%@",msg.toUserName,Localized(@"JX_NotReceive24Hours")];
    }
    if ([msg.type intValue] == kWCMessageTypeOpenPaySuccess) {
        string = Localized(@"JX_PaymentToFriend");
    }
    return string;
}
+ (float)getChatCellHeight:(TFJunYou_MessageObject *)msg {
    if ([msg.type intValue] == kWCMessageTypeTransferBack) {
        return 220+56;
    }else {
        return 220;
    }
    return 0;
}
@end
