#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface TFJunYou_RecordModel : NSObject
@property (nonatomic, assign) double money;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) int payType;
@property (nonatomic, assign) long time;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int type; 
@property (nonatomic, assign) double payMoney;
@property (nonatomic, assign) double getMoney;
- (void)getDataWithDict:(NSDictionary *)dict;
@end
NS_ASSUME_NONNULL_END
