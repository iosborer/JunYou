#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface TFJunYou_PayServer : NSObject
@property (nonatomic, assign) int randNum;
+ (instancetype)sharedManager;
- (NSString *)getParamStringWithParamDic:(NSMutableArray *)param time:(long)time payPassword:(NSString *)payPassword code:(NSString *)code;
- (void)payServerWithAction:(NSString *)action param:(NSMutableArray *)param payPassword:(NSString *)payPassword time:(long)time toView:(id)toView;
- (NSString *) getQrCode;
@end
NS_ASSUME_NONNULL_END
