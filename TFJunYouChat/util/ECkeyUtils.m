#import "ECkeyUtils.h"
#import <openssl/pem.h>
#import <openssl/obj_mac.h>
#import <openssl/ecdh.h>
@implementation ECkeyPairs
@end
@implementation ECkeyUtils
typedef enum VoidType {
    VoidTypePrivate  = 0,
    VoidTypePublic
} voidType;
static int KCurveName = NID_secp256k1; 
- (ECkeyPairs *)eckeyPairs{
    if (!_eckeyPairs) {
        _eckeyPairs = [[ECkeyPairs alloc] init];
    }
    return _eckeyPairs;
}
- (void)generatekeyPairs{
    EC_KEY *eckey;
    eckey = [self createNewKeyWithCurve:KCurveName];
    NSString  *privatePem = [self getPem:eckey voidType:VoidTypePrivate];
    NSString  *publicPem = [self getPem:eckey voidType:VoidTypePublic];
    self.eckeyPairs.privatePem = privatePem;
    self.eckeyPairs.privateKey = [ECkeyUtils getKeyFromPemKey:privatePem isPrivate:YES];
    self.eckeyPairs.publicPem = publicPem;
    self.eckeyPairs.publicKey = [ECkeyUtils getKeyFromPemKey:publicPem isPrivate:NO];
    EC_KEY_free(eckey);
}
+ (NSString *)getShareKeyFromPeerPubPem:(NSString *)peerPubPem
                             privatePem:(NSString *)privatePem
                                 length:(int)length{
    EC_KEY *clientEcKey = [ECkeyUtils privateKeyFromPEM:privatePem];
    if (!clientEcKey) {
        return nil;
    }
    if (!length) {
        const EC_GROUP *group = EC_KEY_get0_group(clientEcKey);
        length = (EC_GROUP_get_degree(group) + 7)/8;
    }
    NSLog(@"\n--------------------------------------------------------------需生成Sharekey长度:%d",length);
    EC_KEY *serverEcKey = [ECkeyUtils publicKeyFromPEM:peerPubPem];
    const EC_POINT *serverEcKeyPoint = EC_KEY_get0_public_key(serverEcKey);
    char shareKey[length];
    ECDH_compute_key(shareKey, length, serverEcKeyPoint, clientEcKey,  NULL);
    EC_KEY_free(clientEcKey);
    EC_KEY_free(serverEcKey);
    NSData *shareKeyData = [NSData dataWithBytes:shareKey length:length];
    NSString *shareKeyStr = [shareKeyData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSLog(@"\nShareKey:\n--------\n%@\n--------",shareKeyStr);
    return shareKeyStr;
}
- (NSString *)getPem:(EC_KEY *)ecKey
            voidType:(voidType)voidType{
    BIO *out = NULL;
    BUF_MEM *buf;
    buf = BUF_MEM_new();
    out = BIO_new(BIO_s_mem());
    switch (voidType) {
        case VoidTypePrivate:
            PEM_write_bio_ECPrivateKey(out, ecKey, NULL, NULL, 0, NULL, NULL);
            break;
        case VoidTypePublic:
            PEM_write_bio_EC_PUBKEY(out, ecKey);
            break;
        default:
            break;
    }
    BIO_get_mem_ptr(out, &buf);
    NSString  *pem = [[NSString alloc] initWithBytes:buf->data
                                              length:(NSUInteger)buf->length
                                            encoding:NSASCIIStringEncoding];
    BIO_free(out);
    return pem;
}
+ (EC_KEY *)publicKeyFromPEM:(NSString *)publicKeyPEM {
    const char *buffer = [publicKeyPEM UTF8String];
    BIO *bpubkey = BIO_new_mem_buf(buffer, (int)strlen(buffer));
    EVP_PKEY *public = PEM_read_bio_PUBKEY(bpubkey, NULL, NULL, NULL);
    EC_KEY *ec_cdata = EVP_PKEY_get1_EC_KEY(public);
    BIO_free_all(bpubkey);
    return ec_cdata;
}
+ (EC_KEY *)privateKeyFromPEM:(NSString *)privateKeyPEM {
    const char *buffer = [privateKeyPEM UTF8String];
    BIO *out = BIO_new_mem_buf(buffer, (int)strlen(buffer));
    EC_KEY *pricateKey = PEM_read_bio_ECPrivateKey(out, NULL, NULL, NULL);
    BIO_free_all(out);
    return pricateKey;
}
- (EC_KEY *)createNewKeyWithCurve:(int)curve {
    int asn1Flag = OPENSSL_EC_NAMED_CURVE;
    int form = POINT_CONVERSION_UNCOMPRESSED;
    EC_KEY *eckey = NULL;
    EC_GROUP *group = NULL;
    eckey = EC_KEY_new();
    group = EC_GROUP_new_by_curve_name(curve);
    EC_GROUP_set_asn1_flag(group, asn1Flag);
    EC_GROUP_set_point_conversion_form(group, form);
    EC_KEY_set_group(eckey, group);
    int resultFromKeyGen = EC_KEY_generate_key(eckey);
    if (resultFromKeyGen != 1){
        raise(-1);
    }
    return eckey;
}
+ (NSString *)getKeyFromPemKey:(NSString *)pemKey isPrivate:(BOOL)isPrivate {
    NSString *key = [NSString string];
    key = [pemKey copy];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSRange range1, range2;
    if (isPrivate) {
        range1 = [key rangeOfString:@"-----BEGIN EC PRIVATE KEY-----"];
        range2 = [key rangeOfString:@"-----END EC PRIVATE KEY-----"];
    }else {
        range1 = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
        range2 = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    }
    key = [key substringWithRange:NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length)];
    return key;
}
+ (NSString *)getPemKeyFromKey:(NSString *)key isPrivate:(BOOL)isPrivate {
    NSMutableString *pemKey = [NSMutableString string];
    if (isPrivate) {
        [pemKey appendString:@"-----BEGIN EC PRIVATE KEY-----\n"];
    }else {
        [pemKey appendString:@"-----BEGIN PUBLIC KEY-----\n"];
    }
    NSMutableString *appendStr = [key mutableCopy];
    NSInteger index = 0;
    if (appendStr.length > 64) {
        index = 64;
    }
    while (index > 0) {
        [appendStr insertString:@"\n" atIndex:index];
        NSString *str = [appendStr substringFromIndex:index + 2];
        if (str.length > 64) {
            index = index + 2 + 64;
        }else {
            index = 0;
        }
    }
    [pemKey appendString:appendStr];
    if (isPrivate) {
        [pemKey appendString:@"\n-----END EC PRIVATE KEY-----"];
    }else {
        [pemKey appendString:@"\n-----END PUBLIC KEY-----"];
    }
    return pemKey;
}
@end
