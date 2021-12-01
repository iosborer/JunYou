#import "TFJunYou_LoginServer.h"
#import "MD5Util.h"
#import "AESUtil.h"
#import "NSMutableDictionary+NSMutableDictionary_SK.h"
#import "TFJunYou_KeyChainStore.h"
@interface TFJunYou_LoginServer()
@property (nonatomic, weak) id toView;
@property (nonatomic, copy) NSString *password; 
@property (nonatomic, copy) NSString *areaCode; 
@property (nonatomic, copy) NSString *account;  
@property (nonatomic, copy) NSString *userId;   
@property (nonatomic, copy) NSString *code;     
@property (nonatomic, strong) NSData *codeData; 
@property (nonatomic, copy) NSString *salt;     
@property (nonatomic, strong) NSMutableDictionary *param;   
@property (nonatomic,copy) NSString *loginToken;    
@property (nonatomic,copy) NSString *loginKey;      
@property (nonatomic,copy) NSString *verificationCode;      
@property (nonatomic, assign) BOOL isThird;
@end
@implementation TFJunYou_LoginServer
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static TFJunYou_LoginServer *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TFJunYou_LoginServer alloc] init];
    });
    return instance;
}
- (instancetype)init {
    if ([super init]) {
    }
    return self;
}
- (void)loginWithUser:(TFJunYou_UserObject *)user password:(NSString *)password areaCode:(NSString *)areaCode account:(NSString *)account toView:(id)toView{
    self.isThird = NO;
    long time = (long)[[NSDate date] timeIntervalSince1970];
    time = time *1000 + g_server.timeDifference;
    self.salt = [NSString stringWithFormat:@"%ld",time];
    self.toView = toView;
    self.password = password;
    self.areaCode = areaCode;
    self.account = account;
    self.param = [self getLoginParamWithUser:user];
    NSString *mac = [self getCodeMac];
    [g_server authGetLoginCodeWithAreaCode:areaCode account:account salt:self.salt deviceId:@"ios" mac:mac toView:self];
}
- (void)autoLoginWithToView:(id)toView {
    long time = (long)[[NSDate date] timeIntervalSince1970];
    time = time *1000 + g_server.timeDifference;
    self.salt = [NSString stringWithFormat:@"%ld",time];
    self.toView = toView;
    self.param = [self getAutoLoginParam];
    self.loginToken = [g_default objectForKey:kMY_USER_LOGINTOKEN];
    if (!self.loginToken) {
        self.loginToken = @"";
    }
    self.loginKey = [g_default objectForKey:kMY_USER_LOGINKEY];
    if (!self.loginKey) {
        self.loginKey = @"";
    }
    self.userId = MY_USER_ID;
    NSString *data = [self getDataString:YES];
    [g_server autoLoginV1:self.loginToken salt:self.salt data:data toView:self];
}
- (NSMutableDictionary *)getLoginParamWithUser:(TFJunYou_UserObject *)user {
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (user.verificationCode) {
        [dict setObject:user.verificationCode forKey:@"verificationCode"];
    }
    [dict setObject:@"client_credentials" forKey:@"grant_type"];
    if (user.model) {
        [dict setObject:user.model forKey:@"model"];
    }
    if (user.osVersion) {
        [dict setObject:user.osVersion forKey:@"osVersion"];
    }
    [dict setObject:[TFJunYou_KeyChainStore getUUIDByKeyChain] forKey:@"serial"];
    [dict setObject:[NSNumber numberWithDouble:g_server.latitude] forKey:@"latitude"];
    [dict setObject:[NSNumber numberWithDouble:g_server.longitude] forKey:@"longitude"];
    if (user.location) {
        [dict setObject:user.location forKey:@"location"];
    }
    [dict setObject:identifier forKey:@"appId"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"xmppVersion"];
    if (user.verificationCode.length > 0) {
        [dict setObject:@1 forKey:@"loginType"];
    }else {
        [dict setObject:@0 forKey:@"loginType"];
    }
    if ([g_config.isOpenCluster integerValue] == 1) {
        NSString *area = [g_default objectForKey:kLocationArea];
        if (area) {
            [dict setObject:area forKey:@"area"];
        }
    }
    return dict;
}
- (NSMutableDictionary *)getAutoLoginParam{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:g_macAddress forKey:@"serial"];
    [dict setObject:[NSNumber numberWithDouble:g_server.latitude] forKey:@"latitude"];
    [dict setObject:[NSNumber numberWithDouble:g_server.longitude] forKey:@"longitude"];
    [dict setObject:identifier forKey:@"appId"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"xmppVersion"];
    if ([g_config.isOpenCluster integerValue] == 1) {
        NSString *area = [g_default objectForKey:kLocationArea];
        if (area) {
            [dict setObject:area forKey:@"area"];
        }
    }
    return dict;
}
- (NSString *)getCodeMac{
    NSMutableString *macStr = [NSMutableString string];
    [macStr appendString:APIKEY];
    [macStr appendString:self.areaCode];
    [macStr appendString:self.account];
    [macStr appendString:self.salt];
    NSData *aesData = [AESUtil encryptAESData:[MD5Util getMD5DataWithString:self.password] key:[MD5Util getMD5DataWithString:self.password]];
    NSData *macData = [g_securityUtil getHMACMD5:[macStr dataUsingEncoding:NSUTF8StringEncoding] key:[[MD5Util getMD5StringWithData:aesData] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *mac = [macData base64EncodedStringWithOptions:0];
    return mac;
}
- (NSString *)getLoginMac:(BOOL)isAutoLogin {
    NSMutableString *macStr = [NSMutableString string];
    [macStr appendString:APIKEY];
    [macStr appendString:self.userId];
    if (isAutoLogin) {
        [macStr appendString:self.loginToken];
    }
    NSString *paramStr = [self getParamStr];
    [macStr appendString:paramStr];
    [macStr appendString:self.salt];
    NSData *macData;
    if (!isAutoLogin) {
        NSData *aesData = [AESUtil encryptAESData:[MD5Util getMD5DataWithString:self.password] key:[MD5Util getMD5DataWithString:self.password]];
        [macStr appendString:[MD5Util getMD5StringWithData:aesData]];
        macData = [g_securityUtil getHMACMD5:[macStr dataUsingEncoding:NSUTF8StringEncoding] key:self.codeData];
    }else {
        NSData *keyData = [[NSData alloc] initWithBase64EncodedString:self.loginKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
        macData = [g_securityUtil getHMACMD5:[macStr dataUsingEncoding:NSUTF8StringEncoding] key:keyData];
    }
    NSString *mac = [macData base64EncodedStringWithOptions:0];
    return mac;
}
- (NSString *)getParamStr {
    NSMutableString *paramStr = [NSMutableString string];
    NSArray *keys = [[self.param allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (NSInteger i = 0; i < keys.count; i ++) {
        NSString *key = keys[i];
        NSString *value = self.param[key];
        if ([self.param[key] isKindOfClass:[NSNumber class]]) {
            NSNumber *num = self.param[key];
            value = [num stringValue];
        }
        [paramStr appendString:value];
        [self.param setObject:value forKey:key];
    }
    return [paramStr copy];
}
- (NSString *)getDataString:(BOOL)isAutoLogin {
    NSString *mac = [self getLoginMac:isAutoLogin];
    NSMutableDictionary *dict = [self.param mutableCopy];
    [dict setObject:mac forKey:@"mac"];
    SBJsonWriter * OderJsonwriter = [SBJsonWriter new];
    NSString * jsonString = [OderJsonwriter stringWithObject:dict];
    NSData *aesJsonData;
    if (isAutoLogin) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:self.loginKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
        aesJsonData = [AESUtil encryptAESData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] key:data];
    }else {
        aesJsonData = [AESUtil encryptAESData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] key:self.codeData];
    }
    return [aesJsonData base64EncodedStringWithOptions:0];
}
#pragma mark ----- 短信登录
- (void)smsLoginWithUser:(TFJunYou_UserObject *)user areaCode:(NSString *)areaCode account:(NSString *)account toView:(id)toView {
    long time = (long)[[NSDate date] timeIntervalSince1970];
    time = time *1000 + g_server.timeDifference;
    self.salt = [NSString stringWithFormat:@"%ld",time];
    self.toView = toView;
    self.areaCode = areaCode;
    self.account = account;
    self.verificationCode = user.verificationCode;
    self.param = [self getLoginParamWithUser:user];
    NSString *data = [self getSMSDataStr];
    [g_server userSMSLogin:self.areaCode account:self.account salt:self.salt data:data toView:self];
}
- (NSString *)getSMSDataStr {
    NSString *mac = [self getSMSMac];
    NSMutableDictionary *dict = [self.param mutableCopy];
    [dict setObject:mac forKey:@"mac"];
    SBJsonWriter * OderJsonwriter = [SBJsonWriter new];
    NSString * jsonString = [OderJsonwriter stringWithObject:dict];
    NSData *aesJsonData = [AESUtil encryptAESData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] key:[MD5Util getMD5DataWithString:self.verificationCode]];
    return [aesJsonData base64EncodedStringWithOptions:0];
}
- (NSString *)getSMSMac{
    NSMutableString *macStr = [NSMutableString string];
    [macStr appendString:APIKEY];
    [macStr appendString:self.areaCode];
    [macStr appendString:self.account];
    NSString *paramStr = [self getParamStr];
    [macStr appendString:paramStr];
    [macStr appendString:self.salt];
    NSData *macData = [g_securityUtil getHMACMD5:[macStr dataUsingEncoding:NSUTF8StringEncoding] key:[MD5Util getMD5DataWithString:self.verificationCode]];
    NSString *mac = [macData base64EncodedStringWithOptions:0];
    return mac;
}
#pragma mark ----- 第三方绑定
-(void)thirdLoginV1:(TFJunYou_UserObject*)user password:(NSString *)password type:(NSInteger)type openId:(NSString *)openId isLogin:(BOOL)isLogin toView:(id)toView {
    self.isThird = YES;
    long time = (long)[[NSDate date] timeIntervalSince1970];
    time = time *1000 + g_server.timeDifference;
    self.salt = [NSString stringWithFormat:@"%ld",time];
    self.password = password;
    self.toView = toView;
    self.param = [self getThirdLoginParamWithUser:user type:type openId:openId isLogin:isLogin];
    self.areaCode = user.areaCode;
    self.account = user.telephone;
    NSString *mac = [self getCodeMac];
    [g_server authGetLoginCodeWithAreaCode:self.areaCode account:self.account salt:self.salt deviceId:@"ios" mac:mac toView:self];
}
- (NSMutableDictionary *)getThirdLoginParamWithUser:(TFJunYou_UserObject *)user type:(NSInteger)type openId:(NSString *)openId isLogin:(BOOL)isLogin {
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setNotNullObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [p setNotNullObject:openId forKey:@"loginInfo"];
    if (g_server.openId.length > 0 ) {
        NSString *tel = [NSString stringWithFormat:@"%@%@",user.areaCode,user.telephone];
        [p setNotNullObject:tel forKey:@"telephone"];
    }else {
        [p setNotNullObject:user.telephone forKey:@"telephone"];
    }
    NSData *aesData = [AESUtil encryptAESData:[MD5Util getMD5DataWithString:self.password] key:[MD5Util getMD5DataWithString:self.password]];
    [p setObject:[MD5Util getMD5StringWithData:aesData]forKey:@"password"];
    if (!isLogin) {
        [p setNotNullObject:user.areaCode forKey:@"areaCode"];
        [p setNotNullObject:@"client_credentials" forKey:@"grant_type"];
        [p setNotNullObject:user.model forKey:@"model"];
        [p setNotNullObject:user.osVersion forKey:@"osVersion"];
        [p setNotNullObject:g_macAddress forKey:@"serial"];
        [p setNotNullObject:[NSNumber numberWithDouble:g_server.latitude] forKey:@"latitude"];
        [p setNotNullObject:[NSNumber numberWithDouble:g_server.longitude] forKey:@"longitude"];
        [p setNotNullObject:user.location forKey:@"location"];
        [p setNotNullObject:identifier forKey:@"appId"];
        [p setNotNullObject:[NSNumber numberWithInt:1] forKey:@"xmppVersion"];
        [p setNotNullObject:[TFJunYou_KeyChainStore getUUIDByKeyChain] forKey:@"serial"];
        if ([g_config.isOpenCluster integerValue] == 1) {
            NSString *area = [g_default objectForKey:kLocationArea];
            [p setNotNullObject:area forKey:@"area"];
        }
    }
    return p;
}
- (NSString *)getThirdDataStr {
    NSString *mac = [self getThirdMac];
    NSMutableDictionary *dict = [self.param mutableCopy];
    [dict setObject:mac forKey:@"mac"];
    SBJsonWriter * OderJsonwriter = [SBJsonWriter new];
    NSString * jsonString = [OderJsonwriter stringWithObject:dict];
    NSData *aesJsonData = [AESUtil encryptAESData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] key:self.codeData];
    return [aesJsonData base64EncodedStringWithOptions:0];
}
- (NSString *)getThirdMac{
    NSMutableString *macStr = [NSMutableString string];
    [macStr appendString:APIKEY];
    [macStr appendString:self.userId];
    NSString *paramStr = [self getParamStr];
    [macStr appendString:paramStr];
    [macStr appendString:self.salt];
    NSData *aesData = [AESUtil encryptAESData:[MD5Util getMD5DataWithString:self.password] key:[MD5Util getMD5DataWithString:self.password]];
    [macStr appendString:[MD5Util getMD5StringWithData:aesData]];
    NSData *macData = [g_securityUtil getHMACMD5:[macStr dataUsingEncoding:NSUTF8StringEncoding] key:self.codeData];
    NSString *mac = [macData base64EncodedStringWithOptions:0];
    return mac;
}
#pragma mark  -------微信登录
- (void)wxSdkLoginV1:(TFJunYou_UserObject *)user type:(NSInteger)type openId:(NSString *)openId toView:(id)toView {
    long time = (long)[[NSDate date] timeIntervalSince1970];
    time = time *1000 + g_server.timeDifference;
    self.salt = [NSString stringWithFormat:@"%ld",time];
    self.toView = toView;
    self.account = openId;
    self.param = [self getWXSdkLoginParamWithUser:user type:type openId:openId];
    NSString *data = [self getWXSdkLoginDataStr];
    [g_server wxSdkLoginV1:self.salt data:data toView:self];
}
- (NSMutableDictionary *)getWXSdkLoginParamWithUser:(TFJunYou_UserObject *)user type:(NSInteger)type openId:(NSString *)openId{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setNotNullObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [p setNotNullObject:openId forKey:@"loginInfo"];
    [p setNotNullObject:user.areaCode forKey:@"areaCode"];
    [p setNotNullObject:user.verificationCode forKey:@"verificationCode"];
    [p setNotNullObject:@"client_credentials" forKey:@"grant_type"];
    [p setNotNullObject:user.model forKey:@"model"];
    [p setNotNullObject:user.osVersion forKey:@"osVersion"];
    [p setNotNullObject:g_macAddress forKey:@"serial"];
    [p setNotNullObject:[NSNumber numberWithDouble:g_server.latitude] forKey:@"latitude"];
    [p setNotNullObject:[NSNumber numberWithDouble:g_server.longitude] forKey:@"longitude"];
    [p setNotNullObject:user.location forKey:@"location"];
    [p setNotNullObject:identifier forKey:@"appId"];
    [p setNotNullObject:[NSNumber numberWithInt:1] forKey:@"xmppVersion"];
    [p setNotNullObject:[TFJunYou_KeyChainStore getUUIDByKeyChain] forKey:@"serial"];
    if ([g_config.isOpenCluster integerValue] == 1) {
        NSString *area = [g_default objectForKey:kLocationArea];
        [p setNotNullObject:area forKey:@"area"];
    }
    return p;
}
- (NSString *)getWXSdkLoginDataStr {
    NSString *mac = [self getWXSdkLogindMac];
    NSMutableDictionary *dict = [self.param mutableCopy];
    [dict setObject:mac forKey:@"mac"];
    SBJsonWriter * OderJsonwriter = [SBJsonWriter new];
    NSString * jsonString = [OderJsonwriter stringWithObject:dict];
    NSData *aesJsonData = [AESUtil encryptAESData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] key:[MD5Util getMD5DataWithString:APIKEY]];
    return [aesJsonData base64EncodedStringWithOptions:0];
}
- (NSString *)getWXSdkLogindMac{
    NSMutableString *macStr = [NSMutableString string];
    [macStr appendString:APIKEY];
    NSString *paramStr = [self getParamStr];
    [macStr appendString:paramStr];
    [macStr appendString:self.salt];
    NSData *macData = [g_securityUtil getHMACMD5:[macStr dataUsingEncoding:NSUTF8StringEncoding] key:[MD5Util getMD5DataWithString:APIKEY]];
    NSString *mac = [macData base64EncodedStringWithOptions:0];
    return mac;
}
-(void)registerUserV1:(TFJunYou_UserObject*)user type:(int)type inviteCode:(NSString *)inviteCode workexp:(int)workexp diploma:(int)diploma isSmsRegister:(BOOL)isSmsRegister smsCode:(NSString *)smsCode password:(NSString *)password toView:(id)toView {
    long time = (long)[[NSDate date] timeIntervalSince1970];
    time = time *1000 + g_server.timeDifference;
    self.salt = [NSString stringWithFormat:@"%ld",time];
    self.password = password;
    self.toView = toView;
    self.param = [self getRegisterParamWithUser:user type:type inviteCode:inviteCode workexp:workexp diploma:diploma isSmsRegister:isSmsRegister smsCode:smsCode];
    NSString *data = [self getRegisterDataStr];
    [g_server registerUser:self.salt data:data toView:self];
}
- (NSMutableDictionary *)getRegisterParamWithUser:(TFJunYou_UserObject *)user type:(int)type inviteCode:(NSString *)inviteCode workexp:(int)workexp diploma:(int)diploma isSmsRegister:(BOOL)isSmsRegister smsCode:(NSString *)smsCode{
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    if (g_server.openId.length <= 0) {
    }else {
        [p setNotNullObject:[NSNumber numberWithInteger:type] forKey:@"type"];
        [p setNotNullObject:g_server.openId forKey:@"loginInfo"];
    }
    [p setNotNullObject:user.telephone forKey:@"telephone"];
    NSData *aesData = [AESUtil encryptAESData:[MD5Util getMD5DataWithString:self.password] key:[MD5Util getMD5DataWithString:self.password]];
    [p setNotNullObject:[MD5Util getMD5StringWithData:aesData] forKey:@"password"];
    [p setNotNullObject:user.areaCode forKey:@"areaCode"];
    [p setNotNullObject:user.userType forKey:@"userType"];
    [p setNotNullObject:user.userNickname forKey:@"nickname"];
    [p setNotNullObject:user.userDescription forKey:@"description"];
    [p setNotNullObject:[NSNumber numberWithLongLong:[user.birthday timeIntervalSince1970]] forKey:@"birthday"];
    [p setNotNullObject:user.sex forKey:@"sex"];
    [p setNotNullObject:user.companyId forKey:@"companyId"];
    [p setNotNullObject:user.countryId forKey:@"countryId"];
    [p setNotNullObject:user.provinceId forKey:@"provinceId"];
    if ([user.cityId integerValue] > 0) {
        [p setNotNullObject:user.cityId forKey:@"cityId"];
    }else {
        [p setNotNullObject:[NSNumber numberWithInt:g_server.cityId] forKey:@"cityId"];
    }
    [p setNotNullObject:user.areaId forKey:@"areaId"];
    [p setNotNullObject:user.model forKey:@"model"];
    [p setNotNullObject:user.osVersion forKey:@"osVersion"];
    [p setNotNullObject:user.serialNumber forKey:@"serialNumber"];
    [p setNotNullObject:user.latitude forKey:@"latitude"];
    [p setNotNullObject:user.longitude forKey:@"longitude"];
    [p setNotNullObject:user.location forKey:@"location"];
    [p setNotNullObject:[NSNumber numberWithInt:workexp] forKey:@"w"];
    [p setNotNullObject:[NSNumber numberWithInt:diploma] forKey:@"d"];
    [p setNotNullObject:[NSNumber numberWithInt:1] forKey:@"xmppVersion"];
    [p setNotNullObject:[NSNumber numberWithInt:(isSmsRegister ? 1 : 0)] forKey:@"isSmsRegister"];
    [p setNotNullObject:inviteCode forKey:@"inviteCode"];
    [p setNotNullObject:smsCode forKey:@"smsCode"];
    [p setNotNullObject:[TFJunYou_KeyChainStore getUUIDByKeyChain] forKey:@"serial"];
#ifdef IS_MsgEncrypt
    [g_msgUtil generatekeyPairsDH];
    NSData *dhPriData = [[NSData alloc] initWithBase64EncodedString:g_msgUtil.dhPrivateKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *dhPriAesData = [AESUtil encryptAESData:dhPriData key:[MD5Util getMD5DataWithString:self.password]];
    NSString *dhPriStr = [dhPriAesData base64EncodedStringWithOptions:0];
    [p setNotNullObject:dhPriStr forKey:@"dhPrivateKey"];
    [p setNotNullObject:g_msgUtil.dhPublicKey forKey:@"dhPublicKey"];
    [g_msgUtil generatekeyPairsRSA];
    NSData *rsaPriData = [[NSData alloc] initWithBase64EncodedString:g_msgUtil.rsaPrivateKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *rsaPriAesData = [AESUtil encryptAESData:rsaPriData key:[MD5Util getMD5DataWithString:self.password]];
    NSString *rsaPriStr = [rsaPriAesData base64EncodedStringWithOptions:0];
    [p setNotNullObject:rsaPriStr forKey:@"rsaPrivateKey"];
    [p setNotNullObject:g_msgUtil.rsaPublicKey forKey:@"rsaPublicKey"];
#endif
    return p;
}
- (NSString *)getRegisterDataStr {
    NSString *mac = [self getRegisterMac];
    NSMutableDictionary *dict = [self.param mutableCopy];
    [dict setObject:mac forKey:@"mac"];
    SBJsonWriter * OderJsonwriter = [SBJsonWriter new];
    NSString * jsonString = [OderJsonwriter stringWithObject:dict];
    NSData *aesJsonData = [AESUtil encryptAESData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] key:[MD5Util getMD5DataWithString:APIKEY]];
    return [aesJsonData base64EncodedStringWithOptions:0];
}
- (NSString *)getRegisterMac{
    NSMutableString *macStr = [NSMutableString string];
    [macStr appendString:APIKEY];
    NSString *paramStr = [self getParamStr];
    [macStr appendString:paramStr];
    [macStr appendString:self.salt];
    NSData *macData = [g_securityUtil getHMACMD5:[macStr dataUsingEncoding:NSUTF8StringEncoding] key:[MD5Util getMD5DataWithString:APIKEY]];
    NSString *mac = [macData base64EncodedStringWithOptions:0];
    return mac;
}
#pragma mark - 服务器返回数据
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    if( [aDownload.action isEqualToString:act_AuthGetLoginCode] ){
        self.userId = dict[@"userId"];
        if (!dict[@"code"]) {
            SecKeyRef privateKey = [g_securityUtil getRSAPrivateKey];
            SecKeyRef publicKey = [g_securityUtil getRSAPublicKeyWithPrivateKey:privateKey];
            NSString *publicKeyStr = [g_securityUtil getKeyForJavaServer:[g_securityUtil getKeyBitsFromKey:publicKey]];
            NSData *privateKeyData = [g_securityUtil getKeyBitsFromKey:privateKey];
            NSData *privateAesData = [AESUtil encryptAESData:privateKeyData key:[MD5Util getMD5DataWithString:self.password]];
            NSString *privateAes = [privateAesData base64EncodedStringWithOptions:0];
            NSMutableString *macStr = [NSMutableString string];
            [macStr appendString:APIKEY];
            [macStr appendString:self.userId];
            [macStr appendString:privateAes];
            [macStr appendString:publicKeyStr];
            [macStr appendString:_salt];
            NSData *aesData = [AESUtil encryptAESData:[MD5Util getMD5DataWithString:self.password] key:[MD5Util getMD5DataWithString:self.password]];
            NSData *macData = [g_securityUtil getHMACMD5:[macStr dataUsingEncoding:NSUTF8StringEncoding] key:[[MD5Util getMD5StringWithData:aesData] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *mac = [macData base64EncodedStringWithOptions:0];
            [g_server authkeysUploadLoginKeyWithUserId:self.userId salt:self.salt privateKey:privateAes publicKey:publicKeyStr mac:mac toView:self];
        }else { 
            self.code = dict[@"code"];
            NSMutableString *macStr = [NSMutableString string];
            [macStr appendString:APIKEY];
            [macStr appendString:self.userId];
            [macStr appendString:self.salt];
            NSData *aesData = [AESUtil encryptAESData:[MD5Util getMD5DataWithString:self.password] key:[MD5Util getMD5DataWithString:self.password]];
            NSData *macData = [g_securityUtil getHMACMD5:[macStr dataUsingEncoding:NSUTF8StringEncoding] key:[[MD5Util getMD5StringWithData:aesData] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *mac = [macData base64EncodedStringWithOptions:0];
            [g_server authkeysGetLoginPrivateKeyWithUserId:self.userId salt:self.salt mac:mac toView:self];
        }
    }
    if ([aDownload.action isEqualToString:act_AuthkeysUploadLoginKey]) {
        NSString *mac = [self getCodeMac];
        [g_server authGetLoginCodeWithAreaCode:self.areaCode account:self.account salt:self.salt deviceId:@"ios" mac:mac toView:self];
    }
    if ([aDownload.action isEqualToString:act_AuthkeysGetLoginPrivateKey]) {
        NSString *privateAesStr = dict[@"privateKey"];
        NSData *privateAesData = [[NSData alloc] initWithBase64EncodedString:privateAesStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *privateData = [AESUtil decryptAESData:privateAesData key:[MD5Util getMD5DataWithString:self.password]];
        NSString *privateBase64 = [privateData base64EncodedStringWithOptions:0];
        SecKeyRef privateKey = [g_securityUtil getRSAKeyWithBase64Str:privateBase64 isPrivateKey:YES];
        NSData *codeData = [[NSData alloc] initWithBase64EncodedString:self.code options:NSDataBase64DecodingIgnoreUnknownCharacters];
        self.codeData = [g_securityUtil decryptMessageRSA:codeData withPrivateKey:privateKey];
        if (self.isThird) {
            NSString *data = [self getThirdDataStr];
            if (data) {
                [g_server thirdLoginV1:self.userId salt:self.salt data:data toView:self];
            }
        }else {
            NSString *data = [self getDataString:NO];
            if (data) {
                [g_server loginV1:self.userId salt:self.salt data:data toView:self];
            }
        }
    }
    if ([aDownload.action isEqualToString:act_UserLoginV1] || [aDownload.action isEqualToString:act_thirdLoginV1]) {
        NSString *dataStr = [dict objectForKey:@"data"];
        NSData *data = [[NSData alloc] initWithBase64EncodedString:dataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *jsonData = [AESUtil decryptAESData:data key:self.codeData];
        NSString *json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        SBJsonParser * resultParser = [[SBJsonParser alloc] init];
        NSDictionary *resultObject = [resultParser objectWithString:json];
        if( [self.toView respondsToSelector:@selector(didServerResultSucces:dict:array:)] )
            [self.toView didServerResultSucces:aDownload dict:resultObject array:nil];
    }
    if ([aDownload.action isEqualToString:act_userLoginAutoV1]) {
        NSString *dataStr = [dict objectForKey:@"data"];
        NSData *data = [[NSData alloc] initWithBase64EncodedString:dataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *keyData = [[NSData alloc] initWithBase64EncodedString:self.loginKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *jsonData = [AESUtil decryptAESData:data key:keyData];
        NSString *json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        SBJsonParser * resultParser = [[SBJsonParser alloc] init];
        NSDictionary *resultObject = [resultParser objectWithString:json];
        if (!resultObject) {
            resultObject = [resultParser objectWithString:dataStr];
        }
        if( [self.toView respondsToSelector:@selector(didServerResultSucces:dict:array:)] )
            [self.toView didServerResultSucces:aDownload dict:resultObject array:nil];
    }
    if ([aDownload.action isEqualToString:act_UserSMSLogin]) {
        NSString *dataStr = [dict objectForKey:@"data"];
        NSData *data = [[NSData alloc] initWithBase64EncodedString:dataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *jsonData = [AESUtil decryptAESData:data key:[MD5Util getMD5DataWithString:self.verificationCode]];
        NSString *json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        SBJsonParser * resultParser = [[SBJsonParser alloc] init];
        NSDictionary *resultObject = [resultParser objectWithString:json];
        if( [self.toView respondsToSelector:@selector(didServerResultSucces:dict:array:)] )
            [self.toView didServerResultSucces:aDownload dict:resultObject array:nil];
    }
    if ([aDownload.action isEqualToString:act_sdkLoginV1] || [aDownload.action isEqualToString:act_RegisterV1] || [aDownload.action isEqualToString:act_registerSDKV1]) {
        NSString *dataStr = [dict objectForKey:@"data"];
        NSData *data = [[NSData alloc] initWithBase64EncodedString:dataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *jsonData = [AESUtil decryptAESData:data key:[MD5Util getMD5DataWithString:APIKEY]];
        NSString *json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        SBJsonParser * resultParser = [[SBJsonParser alloc] init];
        NSDictionary *resultObject = [resultParser objectWithString:json];
        if( [self.toView respondsToSelector:@selector(didServerResultSucces:dict:array:)] )
            [self.toView didServerResultSucces:aDownload dict:resultObject array:nil];
#ifdef IS_MsgEncrypt
        NSString *userId = [[dict objectForKey:@"userId"] stringValue];
        NSData *dhPriData = [[NSData alloc] initWithBase64EncodedString:g_msgUtil.dhPrivateKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *dhPriAesData = [AESUtil encryptAESData:dhPriData key:[userId dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *dhPriStr = [dhPriAesData base64EncodedStringWithOptions:0];
        [g_default setObject:dhPriStr forKey:kMY_USER_PrivateKey_DH];
        NSData *rsaPriData = [[NSData alloc] initWithBase64EncodedString:g_msgUtil.rsaPrivateKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *rsaPriAesData = [AESUtil encryptAESData:rsaPriData key:[userId dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *rsaPriStr = [rsaPriAesData base64EncodedStringWithOptions:0];
        [g_default setObject:rsaPriStr forKey:kMY_USER_PrivateKey_RSA];
#endif
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    if( [self.toView respondsToSelector:@selector(didServerResultFailed:dict:)] ) {
        [self.toView didServerResultFailed:aDownload dict:dict];
    }
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    if ([self.toView respondsToSelector:@selector(didServerConnectError:error:)]) {
        [self.toView didServerConnectError:aDownload error:error];
    }
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    if ([self.toView respondsToSelector:@selector(didServerConnectStart:)]) {
        [self.toView didServerConnectStart:aDownload];
    }
}
- (NSString *)getUpdatePWDMacWithValue:(NSString *)value password:(NSString *)password {
    NSData *encryptPWDData = [AESUtil encryptAESData:[MD5Util getMD5DataWithString:password] key:[MD5Util getMD5DataWithString:password]];
    NSString *encryptPWD = [MD5Util getMD5StringWithData:encryptPWDData];
    NSData *aesKey = [[NSData alloc] initWithBase64EncodedString:encryptPWD options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *macValue = [AESUtil encryptAESData:[APIKEY dataUsingEncoding:NSUTF8StringEncoding] key:aesKey];
    NSData *macData = [g_securityUtil getHMACMD5:macValue key:[value dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *mac = [macData base64EncodedStringWithOptions:0];
    return mac;
}
@end
