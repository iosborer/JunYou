#import "TFJunYou_RecordModel.h"
@implementation TFJunYou_RecordModel
- (void)getDataWithDict:(NSDictionary *)dict {
    self.money = [[dict objectForKey:@"money"] doubleValue];
    self.desc = [dict objectForKey:@"desc"];
    self.payType = [[dict objectForKey:@"payType"] intValue];
    self.time = [[dict objectForKey:@"time"] longValue];
    self.status = [[dict objectForKey:@"status"] intValue];
    self.type = [[dict objectForKey:@"type"] intValue];
}
@end
