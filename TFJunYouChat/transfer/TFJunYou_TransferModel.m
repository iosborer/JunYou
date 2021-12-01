#import "TFJunYou_TransferModel.h"
@implementation TFJunYou_TransferModel
- (void)getTransferDataWithDict:(NSDictionary *)dict {
    self.userId = [dict[@"userId"] longValue];
    self.toUserId = [dict[@"toUserId"] longValue];
    self.userName = dict[@"userName"];
    self.reamrk = dict[@"reamrk"];
    self.money = [dict[@"money"] doubleValue];
    self.status = [dict[@"status"] intValue];
    self.createTime  = [self getTime:dict[@"createTime"]];
    self.outTime  = [self getTime:dict[@"outTime"]];
    self.receiptTime  = [self getTime:dict[@"receiptTime"]];
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
