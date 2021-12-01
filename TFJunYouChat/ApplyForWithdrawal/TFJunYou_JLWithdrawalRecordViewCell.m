#import "TFJunYou_JLWithdrawalRecordViewCell.h"
@interface TFJunYou_JLWithdrawalRecordViewCell()
@property (weak, nonatomic) IBOutlet UILabel *platformNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reasonHeight;
@property (weak, nonatomic) IBOutlet UIView *container;
@end
@implementation TFJunYou_JLWithdrawalRecordViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    _container.layer.cornerRadius = 15;
    _container.layer.masksToBounds = YES;
}
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    _platformNameLabel.text = [NSString stringWithFormat:@"平台: %@", dict[@"platformName"]];
    _amountLabel.text = [NSString stringWithFormat:@"金额: ¥ %@", dict[@"amount"]];
    NSString *ds = [NSString stringWithFormat:@"%@", dict[@"createTime"]];
    NSDate* d = [NSDate dateWithTimeIntervalSince1970:[ds doubleValue]/1000];
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
       NSString *s = [formatter stringFromDate:d];
    _timeLabel.text = s;
    NSString *status = [NSString stringWithFormat:@"%@", dict[@"status"]];
    if([status intValue] == 0) {
        _statusLabel.text = @"申请中";
        _reasonHeight.constant = 0;
        _statusLabel.textColor = HEXCOLOR(0x388db7);
    } else if ([status intValue] == 1) {
        _statusLabel.text = @"成功";
        _reasonHeight.constant = 0;
        _statusLabel.textColor = HEXCOLOR(0x388db7);
    } else {
        _statusLabel.text = @"失败";
        _reasonLabel.text = [NSString stringWithFormat:@"失败原因: %@", dict[@"refuseReason"]];
        _statusLabel.textColor = [UIColor redColor];
        _reasonHeight.constant = 30;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
