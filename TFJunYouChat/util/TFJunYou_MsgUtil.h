#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface TFJunYou_MsgUtil : NSObject
@property (nonatomic, strong) NSMutableDictionary *verifyFailedDic; 
@property (nonatomic,strong) NSMutableArray *getDHListIds;   
@property (strong, nonatomic) NSString *dhPrivatePem; 
@property (strong, nonatomic) NSString *dhPrivateKey; 
@property (strong, nonatomic) NSString *dhPublicPem;  
@property (strong, nonatomic) NSString *dhPublicKey;  
@property (strong, nonatomic) NSString *rsaPrivateKey; 
@property (strong, nonatomic) NSString *rsaPublicKey;  
+ (instancetype)sharedManager;
- (void) generatekeyPairsDH;
- (void) generatekeyPairsRSA;
- (NSData *)getMsgContentKeyWithMsgId:(NSString *)msgId key:(NSString *)key;
- (NSString *)encryptInsertChatMsgContent:(NSString *)content msgId:(NSString *)msgId;
- (NSString *)decryptInsertChatMsgContent:(NSString *)content msgId:(NSString *)msgId;
- (NSString *)getChatMsgMacWithContent:(NSString *)content fromUserId:(NSString *)fromUserId toUserId:(NSString *)toUserId isEncrypt:(NSInteger)isEncrypt msgId:(NSString *)msgId publicKey:(NSString *)publicKey ;
- (NSString *)encryptRoomMsgKey:(NSString *)roomJid randomKey:(NSString *)randomKey;
- (NSString *)decryptRoomMsgKey:(NSString *)roomJid randomKey:(NSString *)randomKey;
- (NSString *)getRoomMsgMacWithContent:(NSString *)content fromUserId:(NSString *)fromUserId isEncrypt:(NSInteger)isEncrypt msgId:(NSString *)msgId randomKey:(NSString *)randomKey;
- (NSString *)encryptContentWithPublicKey:(NSString *)publicKey content:(NSString *)content msgId:(NSString *)msgId;
- (NSString *)decryptContentWithPublicKey:(NSString *)publicKey content:(NSString *)content msgId:(NSString *)msgId;
- (NSString *)encryptRoomContentWithUser:(TFJunYou_UserObject *)user content:(NSString *)content;
- (NSString *)decryptRoomContentWithUser:(TFJunYou_UserObject *)user content:(NSString *)content;
- (void)getDHPublicKeyWithUserId:(NSString *)userId;
- (void)getChatKeyGroupWithRoomId:(NSString *)roomId;
#pragma mark - 群组
@end
NS_ASSUME_NONNULL_END
