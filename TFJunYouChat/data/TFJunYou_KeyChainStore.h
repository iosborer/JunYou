#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface TFJunYou_KeyChainStore : NSObject
+ (void)save:(NSString*)service data:(id)data;
+ (id)load:(NSString*)service;
+ (void)deleteKeyData:(NSString*)service;
+ (NSString *)getUUIDByKeyChain;
@end
NS_ASSUME_NONNULL_END
