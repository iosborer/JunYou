#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface DESUtil : NSObject
+(NSString *)encryptDESStr:(NSString *)sText key:(NSString *)key;
+(NSString *)decryptDESStr:(NSString *)sText key:(NSString *)key;
+ (NSString*)stringWithHexBytes2:(NSData *)sende;
+(NSData*) parseHexToByteArray:(NSString*) hexString;
+(NSData *)encryptDESData:(NSData *)data key:(NSData *)keyData;
+(NSData *)decryptDESData:(NSData *)data key:(NSData *)keyData;
@end
