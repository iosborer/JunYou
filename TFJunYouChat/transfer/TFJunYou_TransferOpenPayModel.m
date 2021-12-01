#import "TFJunYou_TransferOpenPayModel.h"
@implementation TFJunYou_TransferOpenPayModel
- (void)getTransferDataWithDict:(NSDictionary *)dict {
    self.money = [[dict objectForKey:@"money"] doubleValue];
    self.orderId = [dict objectForKey:@"orderId"];
    self.icon = [dict objectForKey:@"icon"];
    self.name = [dict objectForKey:@"name"];
}
@end
