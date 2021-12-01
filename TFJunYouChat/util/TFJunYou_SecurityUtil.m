#import "TFJunYou_SecurityUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "AESUtil.h"
#import "DESUtil.h"
#import "MD5Util.h"
#if DEBUG
    #define LOGGING_FACILITY(X, Y)    \
    NSAssert(X, Y);
    #define LOGGING_FACILITY1(X, Y, Z)    \
    NSAssert1(X, Y, Z);
#else
    #define LOGGING_FACILITY(X, Y)    \
    if (!(X)) {            \
        NSLog(Y);        \
    }
    #define LOGGING_FACILITY1(X, Y, Z)    \
    if (!(X)) {                \
        NSLog(Y, Z);        \
    }
#endif
@interface TFJunYou_SecurityUtil ()
@property (strong, nonatomic) NSString * publicIdentifier;
@property (strong, nonatomic) NSString * privateIdentifier;
@end
@implementation TFJunYou_SecurityUtil{
    size_t kSecAttrKeySizeInBitsLength;
}
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static TFJunYou_SecurityUtil *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TFJunYou_SecurityUtil alloc] init];
    });
    return instance;
}
- (instancetype)init {
    if ([super init]) {
        _publicIdentifier = [NSString stringWithFormat:@"com.RSA.publicIdentifier.mykey.%@",g_myself.userId];
        _privateIdentifier = [NSString stringWithFormat:@"com.RSA.privateIdentifier.mykey.%@",g_myself.userId];
        _privateAesStr = [g_default objectForKey:kMyPayPrivateKey];
    }
    return self;
}
#pragma mark ---------RSA---------
- (void)generateKeyPairRSA {
    _privateKeyRef = [self getRSAPrivateKey];
    _publicKeyRef = [self getRSAPublicKeyWithPrivateKey:_privateKeyRef];
}
- (SecKeyRef)getRSAPrivateKey {
    NSData* tag = [@"com.example.keys.mykey" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* attributes =@{
                                (id)kSecAttrKeyType : (id)kSecAttrKeyTypeRSA,
                                (id)kSecAttrKeySizeInBits : @1024,
                                (id)kSecPrivateKeyAttrs : @{
                                        (id)kSecAttrIsPermanent : @YES,
                                        (id)kSecAttrApplicationTag : tag,
                                        },
                                };
    CFErrorRef error = NULL;
    SecKeyRef privateKey = SecKeyCreateRandomKey((__bridge CFDictionaryRef)attributes,
                                                 &error);
    if (!privateKey) {
        NSError *err = CFBridgingRelease(error);  
        NSLog(@"getPrivateKeyError - %@", err);
    }
    return privateKey;
}
- (SecKeyRef)getRSAPublicKeyWithPrivateKey:(SecKeyRef)privateKey{
    SecKeyRef publicKey = SecKeyCopyPublicKey(privateKey);
    return publicKey;
}
- (void)setPrivateAesStr:(NSString *)privateAesStr {
    _privateAesStr = privateAesStr;
    [g_default setObject:privateAesStr forKey:kMyPayPrivateKey];
}
- (NSData *)getKeyBitsFromKey:(SecKeyRef)Key {
    CFErrorRef error = NULL;
    NSData* keyData = (NSData*)CFBridgingRelease(  
                                                 SecKeyCopyExternalRepresentation(Key, &error)
                                                 );
    if (!keyData) {
        NSError *err = CFBridgingRelease(error);  
        NSLog(@"getKeyBitsFromKeyError - %@", err);
    }
    return keyData;
}
- (SecKeyRef)getRSAKeyWithBase64Str:(NSString *)base64Str isPrivateKey:(BOOL)isPrivateKey {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSDictionary* options;
    if (isPrivateKey) {
        options =@{
                   (id)kSecAttrKeyType: (id)kSecAttrKeyTypeRSA,
                   (id)kSecAttrKeyClass: (id)kSecAttrKeyClassPrivate,
                   (id)kSecAttrKeySizeInBits: @1024,
                   };
    }else {
        options =@{
                   (id)kSecAttrKeyType: (id)kSecAttrKeyTypeRSA,
                   (id)kSecAttrKeyClass: (id)kSecAttrKeyClassPublic,
                   (id)kSecAttrKeySizeInBits: @1024,
                   };
    }
    CFErrorRef error = NULL;
    SecKeyRef key = SecKeyCreateWithData((__bridge CFDataRef)data,
                                         (__bridge CFDictionaryRef)options,
                                         &error);
    if (!key) {
        NSError *err = CFBridgingRelease(error);  
    }
    return key;
}
- (NSString *)getKeyForJavaServer:(NSData*)keyBits {
    static const unsigned char _encodedRSAEncryptionOID[15] = {
        0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00
    };
    unsigned char builder[15];
    NSMutableData * encKey = [[NSMutableData alloc] init];
    int bitstringEncLength;
    if  ([keyBits length ] + 1  < 128 )
        bitstringEncLength = 1 ;
    else
        bitstringEncLength = (int)(([keyBits length] + 1 ) / 256 ) + 2;
    builder[0] = 0x30;    
    size_t i = sizeof(_encodedRSAEncryptionOID) + 2 + bitstringEncLength +
    [keyBits length];
    size_t j = encodeLength(&builder[1], i);
    [encKey appendBytes:builder length:j +1];
    [encKey appendBytes:_encodedRSAEncryptionOID
                 length:sizeof(_encodedRSAEncryptionOID)];
    builder[0] = 0x03;
    j = encodeLength(&builder[1], [keyBits length] + 1);
    builder[j+1] = 0x00;
    [encKey appendBytes:builder length:j + 2];
    [encKey appendData:keyBits];
    return [encKey base64EncodedStringWithOptions:0];
}
size_t encodeLength(unsigned char * buf, size_t length) {
    if (length < 128) {
        buf[0] = length;
        return 1;
    }
    size_t i = (length / 256) + 1;
    buf[0] = i + 0x80;
    for (size_t j = 0 ; j < i; ++j) {
        buf[i - j] = length & 0xFF;
        length = length >> 8;
    }
    return i + 1;
}
- (void)deleteAsymmetricKeys {
    OSStatus sanityCheck = noErr;
    NSMutableDictionary * queryPublicKey        = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary * queryPrivateKey       = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary * queryServPublicKey    = [NSMutableDictionary dictionaryWithCapacity:0];
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:_publicIdentifier forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPrivateKey setObject:_privateIdentifier forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryPrivateKey);
    LOGGING_FACILITY1( sanityCheck == noErr || sanityCheck == errSecItemNotFound, @"Error removing private key, OSStatus == %ld.", (long)sanityCheck );
    sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryPublicKey);
    LOGGING_FACILITY1( sanityCheck == noErr || sanityCheck == errSecItemNotFound, @"Error removing public key, OSStatus == %ld.", (long)sanityCheck );
    if (_publicKeyRef) CFRelease(_publicKeyRef);
    if (_privateKeyRef) CFRelease(_privateKeyRef);
}
- (NSString *)getRSAPublicKeyAsBase64 {
    return [[self getKeyBitsFromKey:_publicKeyRef] base64EncodedStringWithOptions:0];
}
- (NSString *)getRSAPrivateKeyAsBase64 {
    return [[self getKeyBitsFromKey:_privateKeyRef] base64EncodedStringWithOptions:0];
}
- (NSString *)getRSAPublicKeyAsBase64ForJavaServer {
    return [self getKeyForJavaServer:[self getKeyBitsFromKey:_publicKeyRef]];
}
- (NSString *)getPublicKeyFromJavaServer:(NSString *)keyAsBase64 {
    NSData *rawFormattedKey = [[NSData alloc] initWithBase64EncodedString:keyAsBase64 options:0];
    unsigned char * bytes = (unsigned char *)[rawFormattedKey bytes];
    size_t bytesLen = [rawFormattedKey length];
    size_t i = 0;
    if (bytes[i++] != 0x30)
        return FALSE;
    if (bytes[i] > 0x80)
        i += bytes[i] - 0x80 + 1;
    else
        i++;
    if (i >= bytesLen)
        return FALSE;
    if (bytes[i] != 0x30)
        return FALSE;
    i += 15;
    if (i >= bytesLen - 2)
        return FALSE;
    if (bytes[i++] != 0x03)
        return FALSE;
    if (bytes[i] > 0x80)
        i += bytes[i] - 0x80 + 1;
    else
        i++;
    if (i >= bytesLen)
        return FALSE;
    if (bytes[i++] != 0x00)
        return FALSE;
    if (i >= bytesLen)
        return FALSE;
    NSData * extractedKey = [NSData dataWithBytes:&bytes[i] length:bytesLen - i];
    NSString *javaLessBase64String = [extractedKey base64EncodedStringWithOptions:0];
    return javaLessBase64String;
}
- (NSData *)encryptMessageRSA:(NSData *)msgData{
    return [self encryptMessageRSA:msgData withPublicKey:_publicKeyRef];
}
- (NSData *)encryptMessageRSA:(NSData *)msgData withPublicKey:(SecKeyRef)publicKey {
    NSData *data = msgData;
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    NSData *plainTextBytes = data;
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [NSMutableData dataWithCapacity:0];
    for (int i=0; i<blockCount; i++) {
        int bufferSize = (int)MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(publicKey,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);
    return encryptedData;
}
- (NSData *)decryptMessageRSA:(NSData *)msgData {
    return [self decryptMessageRSA:msgData withPrivateKey:_privateKeyRef];
}
- (NSData *)decryptMessageRSA:(NSData *)msgData withPrivateKey:(SecKeyRef)privateKey {
    NSData *data = msgData;
    size_t cipherBufferSize = SecKeyGetBlockSize(privateKey);
    size_t keyBufferSize = [data length];
    NSMutableData *bits = [NSMutableData dataWithLength:keyBufferSize];
    OSStatus sanityCheck = SecKeyDecrypt(privateKey,
                                         kSecPaddingPKCS1,
                                         (const uint8_t *) [data bytes],
                                         cipherBufferSize,
                                         [bits mutableBytes],
                                         &keyBufferSize);
    if (sanityCheck != 0) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:sanityCheck userInfo:nil];
        NSLog(@"Error: %@", [error description]);
        return nil;
    }
    NSAssert(sanityCheck == noErr, @"Error decrypting, OSStatus == %ld.", (long)sanityCheck);
    [bits setLength:keyBufferSize];
    return bits;
}
- (NSData *)sha1:(NSString *)str
{
    const void *data = [str cStringUsingEncoding:NSUTF8StringEncoding];
    CC_LONG len = (CC_LONG)strlen(data);
    uint8_t * md = malloc( CC_SHA1_DIGEST_LENGTH * sizeof(uint8_t) );;
    CC_SHA1(data, len, md);
    return [NSData dataWithBytes:md length:CC_SHA1_DIGEST_LENGTH];
}
- (NSString *)getSignWithRSA:(NSString *)string withPriKey:(SecKeyRef)priKey {
    SecKeyRef privateKeyRef = priKey;
    if (!privateKeyRef) { NSLog(@"添加私钥失败"); return  nil; }
    NSData *sha1Data = [self sha1:string];
    unsigned char *sig = (unsigned char *)malloc(256);
    size_t sig_len = SecKeyGetBlockSize(privateKeyRef);
    OSStatus status = SecKeyRawSign(privateKeyRef, kSecPaddingPKCS1SHA1, [sha1Data bytes], CC_SHA1_DIGEST_LENGTH, sig, &sig_len);
    if (status != noErr) { NSLog(@"加签失败:%d",status); return nil; }
    NSData *outData = [NSData dataWithBytes:sig length:sig_len];
    return [outData base64EncodedStringWithOptions:0];
}
#pragma mark ---------DH---------
- (void)generateKeyPairDH {
    CFErrorRef error = NULL;
    SecAccessControlRef sacObject;
    sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                kSecAccessControlTouchIDAny | kSecAccessControlPrivateKeyUsage, &error);
    NSDictionary *parameters = @{
                                 (__bridge id)kSecAttrKeyType: (__bridge id)kSecAttrKeyTypeEC,
                                 (__bridge id)kSecAttrKeySizeInBits: @256,
                                 (__bridge id)kSecPrivateKeyAttrs: @{
                                         (__bridge id)kSecAttrIsPermanent: @YES,
                                         },
                                 };
    SecKeyRef publicKey, privateKey;
    OSStatus status = SecKeyGeneratePair((__bridge CFDictionaryRef)parameters, &publicKey, &privateKey);
    if (status == errSecSuccess) {
        NSData *privateKeyData1 = [g_securityUtil getKeyBitsFromKey:privateKey];
        NSData *publicKeyData1 = [g_securityUtil getKeyBitsFromKey:publicKey];
        NSString *priStr1 = [g_securityUtil getDHPrivateKeyAsBase64];
        NSString *pubStr = [g_securityUtil getDHPublicKeyAsBase64];
    }
    return;
    [self getDHPrivateKey];
    [self getDHPublicKeyWithPrivateKey];
}
- (SecKeyRef)getDHPrivateKey {
    NSData* tag = [@"com.example.keys.mykey.DH" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* attributes =@{
                                (id)kSecAttrKeyType : (id)kSecAttrKeyTypeEC,
                                (id)kSecAttrKeySizeInBits : @256,
                                (id)kSecPrivateKeyAttrs : @{
                                        (id)kSecAttrIsPermanent : @NO,
                                        (id)kSecAttrApplicationTag : tag,
                                        },
                                };
    CFErrorRef error = NULL;
    SecKeyRef privateKey = SecKeyCreateRandomKey((__bridge CFDictionaryRef)attributes,
                                                 &error);
    if (!privateKey) {
        NSError *err = CFBridgingRelease(error);  
        NSLog(@"getPrivateKeyError - %@", err);
    }
    _privateKeyRefDH = privateKey;
    return privateKey;
}
- (SecKeyRef)getDHPublicKeyWithPrivateKey {
    SecKeyRef publicKey = SecKeyCopyPublicKey(_privateKeyRefDH);
    _publicKeyRefDH = publicKey;
    return publicKey;
}
- (NSData *) getSharedWithPrivateKey:(SecKeyRef)privateKey publicKey:(SecKeyRef)publicKey {
    NSString *identifier = [NSBundle mainBundle].bundleIdentifier;
    NSData *sharedData = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = @{
                             (id)kSecKeyKeyExchangeParameterRequestedSize : @(sharedData.length),
                             (id)kSecKeyKeyExchangeParameterSharedInfo : sharedData
                             };
    CFErrorRef error = NULL;
    CFDataRef dataRef = SecKeyCopyKeyExchangeResult(privateKey, kSecKeyAlgorithmECDHKeyExchangeStandardX963SHA256, publicKey, (__bridge CFDictionaryRef)params, &error);
    return (__bridge NSData *)dataRef;
}
- (NSString *)getDHPublicKeyAsBase64 {
    return [[self getKeyBitsFromKey:_publicKeyRefDH] base64EncodedStringWithOptions:0];
}
- (NSString *)getDHPrivateKeyAsBase64 {
    return [[self getKeyBitsFromKey:_privateKeyRefDH] base64EncodedStringWithOptions:0];
}
- (SecKeyRef)getDHKeyWithBase64Str:(NSString *)base64Str isPrivateKey:(BOOL)isPrivateKey {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSDictionary* options;
    if (isPrivateKey) {
        options =@{
                   (id)kSecAttrKeyType: (id)kSecAttrKeyTypeEC,
                   (id)kSecAttrKeyClass: (id)kSecAttrKeyClassPrivate,
                   (id)kSecAttrKeySizeInBits: @256,
                   };
    }else {
        options =@{
                   (id)kSecAttrKeyType: (id)kSecAttrKeyTypeEC,
                   (id)kSecAttrKeyClass: (id)kSecAttrKeyClassPublic,
                   (id)kSecAttrKeySizeInBits: @256,
                   };
    }
    CFErrorRef error = NULL;
    SecKeyRef key = SecKeyCreateWithData((__bridge CFDataRef)data,
                                         (__bridge CFDictionaryRef)options,
                                         &error);
    if (!key) {
        NSError *err = CFBridgingRelease(error);  
    }
    return key;
}
- (NSString *)getDHPublicKeyAsBase64ForJavaServer {
    return [self getKeyForJavaServer:[self getKeyBitsFromKey:_publicKeyRefDH]];
}
- (NSData *)getHMACMD5:(NSData *)data key:(NSData *)keyData {
    size_t dataLength = data.length;
    NSData *keys = keyData;
    size_t keyLength = keys.length;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgMD5, [keys bytes], keyLength, [data bytes], dataLength, result);
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        printf("%d ",result[i]);
    }
    printf("\n-------%s-------\n",result);
    NSData *data1 = [[NSData alloc] initWithBytes:result length:sizeof(result)];
    return data1;
}
void CCHmac(CCHmacAlgorithm algorithm,
            const void *key,
            size_t keyLength,
            const void *data,
            size_t dataLength,
            void *macOut)
__OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_2_0);
@end
