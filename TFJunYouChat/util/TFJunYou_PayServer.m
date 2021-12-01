#import "TFJunYou_PayServer.h"
#import "MD5Util.h"
#import "AESUtil.h"
@interface TFJunYou_PayServer()
@property (nonatomic, copy) NSString *action;
@property (nonatomic, weak) id toView;
@property (nonatomic, copy) NSString *payPassword;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *codeId;
@property (nonatomic, assign) long time;
@property (nonatomic, strong) NSMutableArray *param;
@property (nonatomic, assign) NSInteger verifyNum;
@end
@implementation TFJunYou_PayServer
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static TFJunYou_PayServer *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TFJunYou_PayServer alloc] init];
    });
    return instance;
}
- (instancetype)init {
    if ([super init]) {
    }
    return self;
}
- (void)payServerWithAction:(NSString *)action param:(NSMutableArray *)param payPassword:(NSString *)payPassword time:(long)time toView:(id)toView{
    self.action = action;
    self.toView = toView;
    self.payPassword = payPassword;
    self.time = time;
    self.param = param;
    NSString* s = [NSUUID UUID].UUIDString;
    s = [[s stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    NSString *salt = s;
    NSString *mac = [self getMacWithSalt:salt payPassword:payPassword];
    [g_server transactionGetCodeWithSalt:salt mac:mac toView:self];
}
- (NSString *)getMacWithSalt:(NSString *)salt payPassword:(NSString *)payPassword {
    NSMutableString *str = [NSMutableString string];
    [str appendString:APIKEY];
    [str appendString:g_myself.userId];
    [str appendString:g_server.access_token];
    [str appendString:salt];
    NSData *aesData = [AESUtil encryptAESData:[g_myself.userId dataUsingEncoding:NSUTF8StringEncoding] key:[MD5Util getMD5DataWithString:payPassword]];
    NSData *macData = [g_securityUtil getHMACMD5:[str dataUsingEncoding:NSUTF8StringEncoding] key:[[MD5Util getMD5StringWithData:aesData] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *mac = [macData base64EncodedStringWithOptions:0];
    return mac;
}
- (NSString *)getParamStringWithParamDic:(NSMutableArray *)param time:(long)time payPassword:(NSString *)payPassword code:(NSString *)code {
    NSMutableString *str1 = [NSMutableString string];
    [str1 appendString:APIKEY];
    [str1 appendString:g_myself.userId];
    [str1 appendString:g_server.access_token];
    NSMutableString *str2 = [NSMutableString string];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *key;
    for (NSInteger i = 0; i < param.count; i ++) {
        if (i % 2 == 0) {
            key = param[i];
        }else {
            [str2 appendString:param[i]];
            [dict setObject:param[i] forKey:key];
        }
    }
    [dict setObject:[NSNumber numberWithLong:time] forKey:@"time"];
    NSMutableString *str3 = [NSMutableString string];
    [str3 appendString:[NSString stringWithFormat:@"%ld",time]];
    NSData *aesData = [AESUtil encryptAESData:[g_myself.userId dataUsingEncoding:NSUTF8StringEncoding] key:[MD5Util getMD5DataWithString:payPassword]];
    NSString *aesMd5Str = [MD5Util getMD5StringWithData:aesData];
    [str3 appendString:aesMd5Str];
    NSMutableString *str = [NSMutableString string];
    [str appendString:str1];
    [str appendString:str2];
    [str appendString:str3];
    if (!g_securityUtil.privateKeyRef) {
        NSData *privateAesData = [[NSData alloc] initWithBase64EncodedString:g_securityUtil.privateAesStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *privateData = [AESUtil decryptAESData:privateAesData key:[MD5Util getMD5DataWithString:payPassword]];
        NSString *privateBase64 = [privateData base64EncodedStringWithOptions:0];
        g_securityUtil.privateKeyRef = [g_securityUtil getRSAKeyWithBase64Str:privateBase64 isPrivateKey:YES];
        if (!g_securityUtil.privateKeyRef) {
            if (self.verifyNum > 5) {
                self.verifyNum = 0;
                [TFJunYou_MyTools showTipView:@"code解密失败"];
                return nil;
            }
            g_securityUtil.privateAesStr = @"";
            NSString* s = [NSUUID UUID].UUIDString;
            s = [[s stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
            NSString *salt = s;
            NSString *mac = [self getMacWithSalt:salt payPassword:payPassword];
            [g_server transactionGetCodeWithSalt:salt mac:mac toView:self];
            self.verifyNum ++;
            return nil;
        }
    }
    NSData *codeData = [[NSData alloc] initWithBase64EncodedString:code options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *deCodeData = [g_securityUtil decryptMessageRSA:codeData];
    if (!deCodeData) {
        if (self.verifyNum > 5) {
            self.verifyNum = 0;
            [TFJunYou_MyTools showTipView:@"code解密失败"];
            return nil;
        }
        g_securityUtil.privateAesStr = @"";
        NSString* s = [NSUUID UUID].UUIDString;
        s = [[s stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
        NSString *salt = s;
        NSString *mac = [self getMacWithSalt:salt payPassword:payPassword];
        [g_server transactionGetCodeWithSalt:salt mac:mac toView:self];
        self.verifyNum ++;
        return nil;
    }
    NSString *deCodeBase = [deCodeData base64EncodedStringWithOptions:0];
    NSString *mac = [g_securityUtil getSignWithRSA:str withPriKey:g_securityUtil.privateKeyRef];
    [dict setObject:mac forKey:@"mac"];
    SBJsonWriter * OderJsonwriter = [SBJsonWriter new];
    NSString * jsonString = [OderJsonwriter stringWithObject:dict];
    NSData *aesJsonData = [AESUtil encryptAESData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] key:deCodeData];
    return [aesJsonData base64EncodedStringWithOptions:0];
}
- (NSData *)getQRCodeHash {
    long time = (long)[[NSDate date] timeIntervalSince1970];
    time = (time *1000 + g_server.timeDifference)/1000; 
    time = time / 60;   
    NSData *randByte = [self getDataWithInt:g_payServer.randNum];
    NSData *da = [randByte subdataWithRange:NSMakeRange(randByte.length - 1, 1)];
    Byte bRand[1];
    [da getBytes:bRand length:sizeof(bRand)];
    int rand = bRand[0];
    NSMutableString *value = [NSMutableString string];
    [value appendString:APIKEY];
    [value appendString:g_myself.userId];
    [value appendString:[NSString stringWithFormat:@"%d", rand]];
    [value appendString:[NSString stringWithFormat:@"%ld", time]];
    NSData *qrKey = [g_default objectForKey:kMyQRKey];
    NSData *macData = [g_securityUtil getHMACMD5:[value dataUsingEncoding:NSUTF8StringEncoding] key:qrKey];
    return macData;
}
- (unsigned int)getQRCodeOpt {
    g_payServer.randNum ++;
    NSData *hash = [self getQRCodeHash];
    NSData *randByte = [self getDataWithInt:g_payServer.randNum];
    NSData *da = [randByte subdataWithRange:NSMakeRange(randByte.length - 1, 1)];
    NSMutableData *optData = [NSMutableData data];
    NSData *hashSubData = [hash subdataWithRange:NSMakeRange(0, 3)];
    [optData appendData:hashSubData];
    [optData appendData:da];
    unsigned int opt;
    [optData getBytes:&opt length:sizeof(opt)];
    return opt;
}
- (NSString *) getQrCode {
    unsigned int opt = [self getQRCodeOpt];
    NSInteger userId = [g_myself.userId integerValue];
    long long num = userId << 32;
    long long qrCode = num + opt;
    NSMutableString *qrCodeStr = [NSMutableString stringWithFormat:@"%lld", qrCode];
    while (qrCodeStr.length < 19) {
        [qrCodeStr insertString:@"0" atIndex:0];
    }
    return qrCodeStr;
}
- (NSData *) getDataWithInt:(int)num {
    Byte b1=num & 0xff;
    Byte b2=(num>>8) & 0xff;
    Byte b3=(num>>16) & 0xff;
    Byte b4=(num>>24) & 0xff;
    Byte byte[] = {b4,b3,b2,b1};
    NSData *adddata = [NSData dataWithBytes:byte length:sizeof(byte)];
    return adddata;
}
#pragma mark - 服务器返回数据
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    if( [aDownload.action isEqualToString:act_TransactionGetCode] ){
        if (!dict) {
            [g_securityUtil generateKeyPairRSA];
            NSString *publicKeyStr = [g_securityUtil getRSAPublicKeyAsBase64ForJavaServer];
            NSData *privateKeyData = [g_securityUtil getKeyBitsFromKey:g_securityUtil.privateKeyRef];
            NSData *privateAesData = [AESUtil encryptAESData:privateKeyData key:[MD5Util getMD5DataWithString:self.payPassword]];
            NSString *privateAes = [privateAesData base64EncodedStringWithOptions:0];
            g_securityUtil.privateAesStr = privateAes;
            NSData *publicKeyData = [[NSData alloc] initWithBase64EncodedString:publicKeyStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            NSMutableData *data = [NSMutableData data];
            [data appendData:privateAesData];
            [data appendData:publicKeyData];
            NSData *aesData = [AESUtil encryptAESData:[g_myself.userId dataUsingEncoding:NSUTF8StringEncoding] key:[MD5Util getMD5DataWithString:self.payPassword]];
            NSString *key = [MD5Util getMD5StringWithData:aesData];
            NSData *macData = [g_securityUtil getHMACMD5:data key:[key dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *mac = [macData base64EncodedStringWithOptions:0];
            [g_server authkeysUploadPayKeyWithPrivateKey:privateAes publicKey:publicKeyStr mac:mac toView:self];
        }else { 
            self.code = dict[@"code"];
            self.codeId = dict[@"codeId"];
            if (!g_securityUtil.privateAesStr || g_securityUtil.privateAesStr.length <= 0) {
                [g_server authkeysGetPayPrivateKey:self];
            }else {
                NSString *data = [self getParamStringWithParamDic:self.param time:self.time payPassword:self.payPassword code:dict[@"code"]];
                if (data) {
                    if ([self.action isEqualToString:act_payGetQrKey]) {
                        [g_server payCommonWithAction:self.action code:self.code codeId:self.codeId param:self.param time:self.time payPassword:self.payPassword data:data toView:self];
                    }else {
                        [g_server payCommonWithAction:self.action code:self.code codeId:self.codeId param:self.param time:self.time payPassword:self.payPassword data:data toView:self.toView];
                    }
                }
            }
        }
    }
    if ([aDownload.action isEqualToString:act_AuthkeysUploadPayKey]) {
        NSString* s = [NSUUID UUID].UUIDString;
        s = [[s stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
        NSString *salt = s;
        NSString *mac = [self getMacWithSalt:salt payPassword:self.payPassword];
        [g_server transactionGetCodeWithSalt:salt mac:mac toView:self];
    }
    if ([aDownload.action isEqualToString:act_AuthkeysGetPayPrivateKey]) {
        g_securityUtil.privateAesStr = dict[@"privateKey"];
        NSString *data = [self getParamStringWithParamDic:self.param time:self.time payPassword:self.payPassword code:self.code];
        if (data) {
            if ([self.action isEqualToString:act_payGetQrKey]) {
                [g_server payCommonWithAction:self.action code:self.code codeId:self.codeId param:self.param time:self.time payPassword:self.payPassword data:data toView:self];
            }else {
                [g_server payCommonWithAction:self.action code:self.code codeId:self.codeId param:self.param time:self.time payPassword:self.payPassword data:data toView:self.toView];
            }
        }
    }
    if ([aDownload.action isEqualToString:act_payGetQrKey]) {
        NSData *codeData = [[NSData alloc] initWithBase64EncodedString:self.code options:NSDataBase64DecodingIgnoreUnknownCharacters];
        codeData = [g_securityUtil decryptMessageRSA:codeData withPrivateKey:g_securityUtil.privateKeyRef];
        NSString *dataStr = [dict objectForKey:@"data"];
        NSData *data = [[NSData alloc] initWithBase64EncodedString:dataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *qrKey = [AESUtil decryptAESData:data key:codeData];
        [g_default setObject:qrKey forKey:kMyQRKey];
        if( [self.toView respondsToSelector:@selector(didServerResultSucces:dict:array:)] )
            [self.toView didServerResultSucces:aDownload dict:nil array:nil];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    int n = show_error;
    if ([self.toView respondsToSelector:@selector(didServerResultFailed:dict:)]) {
        n = [self.toView didServerResultFailed:aDownload dict:dict];
    }
    return n;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    int n = show_error;
    if ([self.toView respondsToSelector:@selector(didServerConnectError:error:)]) {
        n = [self.toView didServerConnectError:aDownload error:error];
    }
    return n;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
}
@end
