#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface TFJunYou_TransferOpenPayModel : NSObject
@property (nonatomic, assign) double money;         
@property (nonatomic,copy) NSString *orderId;       
@property (nonatomic,copy) NSString *icon;          
@property (nonatomic,copy) NSString *name;          
- (void)getTransferDataWithDict:(NSDictionary *)dict;
@end
NS_ASSUME_NONNULL_END
