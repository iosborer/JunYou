#import "TFJunYou_MsgUtil.h"
#import "ECkeyUtils.h"
#import "MD5Util.h"
#import "AESUtil.h"
#import "TFJunYou_UserPublicKeyObj.h"
@interface TFJunYou_MsgUtil()
@end
@implementation TFJunYou_MsgUtil
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static TFJunYou_MsgUtil *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TFJunYou_MsgUtil alloc] init];
    });
    return instance;
}
- (instancetype)init {
    if ([super init]) {
        self.verifyFailedDic = [NSMutableDictionary dictionary];
        self.getDHListIds = [NSMutableArray array];
        [g_notify  addObserver:self selector:@selector(newMsgCome:) name:kXMPPNewMsgNotifaction object:nil];
    }
    return self;
}
#pragma mark  接受新消息广播
-(void)newMsgCome:(NSNotification *)notifacation {
    TFJunYou_MessageObject *msg = notifacation.object;
    if ([msg.type intValue] == kWCMessageTypeUpdateFriendPublicKey) {
        NSArray *keys = [msg.content componentsSeparatedByString:@","];
        if (keys.count > 0) {
            TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:msg.fromUserId];
            user.publicKeyDH = keys.firstObject;
            user.publicKeyRSARoom = keys.lastObject;
            [user updateDHPublicKeyAndRSAPublicKey];
            TFJunYou_UserPublicKeyObj *keyObj = [[TFJunYou_UserPublicKeyObj alloc] init];
            keyObj.userId = msg.fromUserId;
            keyObj.publicKey = keys.firstObject;
            keyObj.keyCreateTime = msg.timeSend;
            [keyObj insert];
        }
    }
}
- (void)setDhPublicKey:(NSString *)dhPublicKey {
    _dhPublicKey = dhPublicKey;
    _dhPublicPem = [ECkeyUtils getPemKeyFromKey:dhPublicKey isPrivate:NO];
}
- (void)setDhPrivateKey:(NSString *)dhPrivateKey{
    _dhPrivateKey = dhPrivateKey;
    _dhPrivatePem = [ECkeyUtils getPemKeyFromKey:dhPrivateKey isPrivate:YES];
}
- (void)setDhPublicPem:(NSString *)dhPublicPem {
    _dhPublicPem = dhPublicPem;
    _dhPublicKey = [ECkeyUtils getKeyFromPemKey:dhPublicPem isPrivate:NO];
}
- (void)setDhPrivatePem:(NSString *)dhPrivatePem {
    _dhPrivatePem = dhPrivatePem;
    _dhPrivateKey = [ECkeyUtils getKeyFromPemKey:dhPrivatePem isPrivate:YES];
}
- (void) generatekeyPairsDH {
    ECkeyUtils *keyUtils = [[ECkeyUtils alloc] init];
    [keyUtils generatekeyPairs];
    self.dhPrivatePem = keyUtils.eckeyPairs.privatePem;
    self.dhPrivateKey = keyUtils.eckeyPairs.privateKey;
    self.dhPublicPem = keyUtils.eckeyPairs.publicPem;
    self.dhPublicKey = keyUtils.eckeyPairs.publicKey;
}
- (void) generatekeyPairsRSA {
    SecKeyRef privateKey = [g_securityUtil getRSAPrivateKey];
    SecKeyRef publicKey = [g_securityUtil getRSAPublicKeyWithPrivateKey:privateKey];
    NSData *privateData = [g_securityUtil getKeyBitsFromKey:privateKey];
    NSData *publicData = [g_securityUtil getKeyBitsFromKey:publicKey];
    NSString *privateStr = [privateData base64EncodedStringWithOptions:0];
    self.rsaPrivateKey = privateStr;
    self.rsaPublicKey = [g_securityUtil getKeyForJavaServer:publicData];
}
- (NSData *)getMsgContentKeyWithMsgId:(NSString *)msgId key:(NSString *)key; {
    NSMutableString *appendStr = [NSMutableString string];
    [appendStr appendString:APIKEY];
    [appendStr appendString:msgId];
    [appendStr appendString:key];
    NSData *data = [MD5Util getMD5DataWithString:appendStr];
    return data;
}
- (NSString *)encryptInsertChatMsgContent:(NSString *)content msgId:(NSString *)msgId {
    NSMutableString *appendStr = [NSMutableString string];
    [appendStr appendString:APIKEY];
    [appendStr appendString:msgId];
    NSData *keyData= [MD5Util getMD5DataWithString:appendStr];
    NSData *aesData = [AESUtil encryptAESData:[content dataUsingEncoding:NSUTF8StringEncoding] key:keyData];
    NSString *aesStr = [aesData base64EncodedStringWithOptions:0];
    return aesStr;
}
- (NSString *)decryptInsertChatMsgContent:(NSString *)content msgId:(NSString *)msgId {
    if (!content || content.length <= 0) {
        return @"";
    }
    NSMutableString *appendStr = [NSMutableString string];
    [appendStr appendString:APIKEY];
    [appendStr appendString:msgId];
    NSData *keyData= [MD5Util getMD5DataWithString:appendStr];
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *aesData = [AESUtil decryptAESData:contentData key:keyData];
    NSString *aesStr = [[NSString alloc] initWithData:aesData encoding:NSUTF8StringEncoding];
    return aesStr;
}
- (NSString *)getChatMsgMacWithContent:(NSString *)content fromUserId:(NSString *)fromUserId toUserId:(NSString *)toUserId isEncrypt:(NSInteger)isEncrypt msgId:(NSString *)msgId publicKey:(NSString *)publicKey {
    NSString *pubPem = [ECkeyUtils getPemKeyFromKey:publicKey isPrivate:NO];
    NSString *shareKey = [ECkeyUtils getShareKeyFromPeerPubPem:pubPem privatePem:g_msgUtil.dhPrivatePem length:32];
    if (!shareKey || shareKey.length <= 0) {
        return nil;
    }
    NSData *keyData = [self getMsgContentKeyWithMsgId:msgId key:shareKey];
    NSString *msgKey = [keyData base64EncodedStringWithOptions:0];
    NSMutableString *appendStr = [NSMutableString string];
    [appendStr appendString:fromUserId];
    [appendStr appendString:toUserId];
    [appendStr appendString:[NSString stringWithFormat:@"%ld",(long)isEncrypt]];
    [appendStr appendString:msgId];
    [appendStr appendString:msgKey];
    NSData *macData = [g_securityUtil getHMACMD5:[content dataUsingEncoding:NSUTF8StringEncoding] key:[appendStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *mac = [macData base64EncodedStringWithOptions:0];
    return mac;
}
- (NSString *)encryptRoomMsgKey:(NSString *)roomJid randomKey:(NSString *)randomKey {
    NSMutableString *appendStr = [NSMutableString string];
    [appendStr appendString:APIKEY];
    [appendStr appendString:roomJid];
    NSData *keyData= [MD5Util getMD5DataWithString:appendStr];
    NSData *aesData = [AESUtil encryptAESData:[randomKey dataUsingEncoding:NSUTF8StringEncoding] key:keyData];
    NSString *aesStr = [aesData base64EncodedStringWithOptions:0];
    return aesStr;
}
- (NSString *)decryptRoomMsgKey:(NSString *)roomJid randomKey:(NSString *)randomKey {
    NSMutableString *appendStr = [NSMutableString string];
    [appendStr appendString:APIKEY];
    [appendStr appendString:roomJid];
    NSData *keyData= [MD5Util getMD5DataWithString:appendStr];
    NSData *randomData = [[NSData alloc] initWithBase64EncodedString:randomKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *data = [AESUtil decryptAESData:randomData key:keyData];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}
- (NSString *)getRoomMsgMacWithContent:(NSString *)content fromUserId:(NSString *)fromUserId isEncrypt:(NSInteger)isEncrypt msgId:(NSString *)msgId randomKey:(NSString *)randomKey {
    NSMutableString *appendStr = [NSMutableString string];
    [appendStr appendString:fromUserId];
    [appendStr appendString:[NSString stringWithFormat:@"%ld",(long)isEncrypt]];
    [appendStr appendString:msgId];
    [appendStr appendString:randomKey];
    NSData *macData = [g_securityUtil getHMACMD5:[content dataUsingEncoding:NSUTF8StringEncoding] key:[appendStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *mac = [macData base64EncodedStringWithOptions:0];
    return mac;
}
- (NSString *)encryptContentWithPublicKey:(NSString *)publicKey content:(NSString *)content msgId:(NSString *)msgId{
    NSString *pubPem = [ECkeyUtils getPemKeyFromKey:publicKey isPrivate:NO];
    NSString *shareKey = [ECkeyUtils getShareKeyFromPeerPubPem:pubPem privatePem:g_msgUtil.dhPrivatePem length:32];
    if (!shareKey || shareKey.length <= 0) {
        return nil;
    }
    NSData *keyData = [self getMsgContentKeyWithMsgId:msgId key:shareKey];
    NSData *encryptData = [AESUtil encryptAESData:[content dataUsingEncoding:NSUTF8StringEncoding] key:keyData];
    NSString *encryptStr = [encryptData base64EncodedStringWithOptions:0];
    return encryptStr;
}
- (NSString *)decryptContentWithPublicKey:(NSString *)publicKey content:(NSString *)content msgId:(NSString *)msgId {
    NSString *pubPem = [ECkeyUtils getPemKeyFromKey:publicKey isPrivate:NO];
    NSString *shareKey = [ECkeyUtils getShareKeyFromPeerPubPem:pubPem privatePem:g_msgUtil.dhPrivatePem length:32];
    NSData *keyData = [self getMsgContentKeyWithMsgId:msgId key:shareKey];
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [AESUtil decryptAESData:contentData key:keyData];
    NSString *decryptStr = [[NSString alloc]initWithData:decryptData encoding:NSUTF8StringEncoding];
    return decryptStr;
}
- (NSString *)encryptRoomContentWithUser:(TFJunYou_UserObject *)user content:(NSString *)content {
    NSString *chatKeyGroup = [g_msgUtil decryptRoomMsgKey:user.roomId randomKey:user.chatKeyGroup];
    NSData *encryptData = [AESUtil encryptAESData:[content dataUsingEncoding:NSUTF8StringEncoding] key:[chatKeyGroup dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *encryptStr = [encryptData base64EncodedStringWithOptions:0];
    return encryptStr;
}
- (NSString *)decryptRoomContentWithUser:(TFJunYou_UserObject *)user content:(NSString *)content {
    NSString *chatKeyGroup = [g_msgUtil decryptRoomMsgKey:user.roomId randomKey:user.chatKeyGroup];
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [AESUtil decryptAESData:contentData key:[chatKeyGroup dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *decryptStr = [[NSString alloc]initWithData:decryptData encoding:NSUTF8StringEncoding];
    return decryptStr;
}
- (void)getDHPublicKeyWithUserId:(NSString *)userId {
    [g_server authkeysGetDHMsgKeyListWithUserId:userId toView:self];
}
- (void)getChatKeyGroupWithRoomId:(NSString *)roomId {
    [g_server getRoom:roomId toView:self];
}
- (void)didServerResultSucces:(TFJunYou_Connection *)task dict:(NSDictionary *)dict array:(NSArray *)array1{
    if ([task.action isEqualToString:act_AuthkeysGetDHMsgKeyList]) {
        NSString *userId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
        NSArray *publicKeyList = [dict objectForKey:@"publicKeyList"];
        for (NSInteger i = 0; i < publicKeyList.count; i ++) {
            NSDictionary *dic = publicKeyList[i];
            [[TFJunYou_UserPublicKeyObj sharedManager] deletePublicKeyWIthUserId:userId];
            TFJunYou_UserPublicKeyObj *obj =[[TFJunYou_UserPublicKeyObj alloc] init];
            obj.userId = userId;
            obj.publicKey = [dic objectForKey:@"key"];
            obj.keyCreateTime = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"time"] doubleValue]];
            [obj insert];
        }
        TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:userId];
        if (!user.publicKeyDH || user.publicKeyDH.length > 0) {
            [g_server getUser:userId toView:self];
        }
        NSMutableArray *keys = [[TFJunYou_UserPublicKeyObj sharedManager] fetchPublicKeyWithUserId:userId];
        NSArray *msgArr = [g_msgUtil.verifyFailedDic objectForKey:userId];
        for (NSInteger i = 0; i < msgArr.count; i ++) {
            TFJunYou_MessageObject *msg = msgArr[i];
            BOOL flag = NO;
            for (NSInteger i = 0; i < keys.count; i ++) {
                TFJunYou_UserPublicKeyObj *obj = keys[i];
                if (obj.publicKey && obj.publicKey.length > 0) {
                    NSString *signature = [g_msgUtil getChatMsgMacWithContent:msg.content fromUserId:msg.fromUserId toUserId:msg.toUserId isEncrypt:[msg.isEncrypt integerValue] msgId:msg.messageId publicKey:obj.publicKey];
                    if ([signature isEqualToString:msg.signature]) {
                        flag = YES;
                        msg.content = [g_msgUtil decryptContentWithPublicKey:obj.publicKey content:msg.content msgId:msg.messageId];
                        [msg update];
                        break;
                    }
                }
            }
        }
        [g_msgUtil.verifyFailedDic removeObjectForKey:userId];
        NSInteger index = 0;
        for (NSInteger i  = 0; i < g_msgUtil.getDHListIds.count; i ++) {
            NSString *str = g_msgUtil.getDHListIds[i];
            if ([str isEqualToString:userId]) {
                index = i;
                break;
            }
        }
        [g_msgUtil.getDHListIds removeObjectAtIndex:index];
    }
    if ([task.action isEqualToString:act_UserGet]) {
        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
        user.userId = [dict objectForKey:@"userId"];
        NSDictionary *friendsDict = [dict objectForKey:@"friends"];
        user.publicKeyDH = [friendsDict objectForKey:@"dhMsgPublicKey"];
        NSDictionary *publicKeyRSARoomDict = [dict objectForKey:@"friends"];
        user.publicKeyRSARoom = [publicKeyRSARoomDict objectForKey:@"rsaMsgPublicKey"];
        [user updateDHPublicKeyAndRSAPublicKey];
    }
    if ([task.action isEqualToString:act_roomGet]) {
        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
        [user getDataFromDict:dict];
        [user updateChatKeyGroup];
        NSArray *msgArr = [g_msgUtil.verifyFailedDic objectForKey:user.userId];
        for (NSInteger i = 0; i < msgArr.count; i ++) {
            TFJunYou_MessageObject *msg = msgArr[i];
            NSString *chatKeyGroup = [g_msgUtil decryptRoomMsgKey:user.roomId randomKey:user.chatKeyGroup];
            NSString *encryptStr = [g_msgUtil encryptRoomContentWithUser:user content:msg.content];
            NSString *signature = [g_msgUtil getRoomMsgMacWithContent:encryptStr fromUserId:msg.fromUserId isEncrypt:[msg.isEncrypt integerValue] msgId:msg.messageId randomKey:chatKeyGroup];
            if ([signature isEqualToString:msg.signature]) {
                msg.content = [g_msgUtil decryptRoomContentWithUser:user content:msg.content];
                [msg update];
            }
        }
        [g_msgUtil.verifyFailedDic removeObjectForKey:user.userId];
        NSInteger index = 0;
        for (NSInteger i  = 0; i < g_msgUtil.getDHListIds.count; i ++) {
            NSString *str = g_msgUtil.getDHListIds[i];
            if ([str isEqualToString:user.userId]) {
                index = i;
                break;
            }
        }
        [g_msgUtil.getDHListIds removeObjectAtIndex:index];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    return hide_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    return hide_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
}
@end
