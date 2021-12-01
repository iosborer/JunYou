#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
NS_ASSUME_NONNULL_BEGIN
@interface AESUtil : NSObject
+(NSData *)encryptAESData:(NSData *)data key:(NSData *)keyData;
+(NSData *)decryptAESData:(NSData *)data key:(NSData *)keyData;
@end
NS_ASSUME_NONNULL_END
