#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface TFJunYou_SecurityUtil : NSObject
@property (nonatomic, strong) NSString *privateAesStr;
@property (nonatomic) SecKeyRef publicKeyRef;
@property (nonatomic) SecKeyRef privateKeyRef;
@property (nonatomic, strong) NSString *privateAesStrDH;
@property (nonatomic) SecKeyRef publicKeyRefDH;
@property (nonatomic) SecKeyRef privateKeyRefDH;
+ (instancetype)sharedManager;
#pragma mark ---------RSA---------
- (void)generateKeyPairRSA;
- (SecKeyRef)getRSAPrivateKey;
- (SecKeyRef)getRSAPublicKeyWithPrivateKey:(SecKeyRef)privateKey;
- (NSString *)getRSAPublicKeyAsBase64;
- (NSString *)getRSAPrivateKeyAsBase64;
- (SecKeyRef)getRSAKeyWithBase64Str:(NSString *)base64Str isPrivateKey:(BOOL)isPrivateKey;
- (NSString *)getRSAPublicKeyAsBase64ForJavaServer;
- (NSString *)getKeyForJavaServer:(NSData*)keyBits;
- (NSString *)getPublicKeyFromJavaServer:(NSString *)keyAsBase64;
- (NSData *)getKeyBitsFromKey:(SecKeyRef)Key;
- (NSData *)encryptMessageRSA:(NSData *)msgData;
- (NSData *)encryptMessageRSA:(NSData *)msgData withPublicKey:(SecKeyRef)publicKey;
- (NSData *)decryptMessageRSA:(NSData *)msgData;
- (NSData *)decryptMessageRSA:(NSData *)msgData withPrivateKey:(SecKeyRef)privateKey;
- (NSString *)getSignWithRSA:(NSString *)string withPriKey:(SecKeyRef)priKey;
#pragma mark ---------DH---------
- (void)generateKeyPairDH;
- (SecKeyRef)getDHPrivateKey;
- (SecKeyRef)getDHPublicKeyWithPrivateKey;
- (NSData *) getSharedWithPrivateKey:(SecKeyRef)privateKey publicKey:(SecKeyRef)publicKey;
- (NSString *)getDHPublicKeyAsBase64;
- (NSString *)getDHPrivateKeyAsBase64;
- (SecKeyRef)getDHKeyWithBase64Str:(NSString *)base64Str isPrivateKey:(BOOL)isPrivateKey;
- (NSString *)getDHPublicKeyAsBase64ForJavaServer;
- (NSData *)getHMACMD5:(NSData *)data key:(NSData *)keyData;
@end
NS_ASSUME_NONNULL_END
