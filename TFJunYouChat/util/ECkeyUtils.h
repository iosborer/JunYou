#import <Foundation/Foundation.h> 
#import "obj_mac.h"
#import "ecdh.h"
#import "pem.h"
#import <openssl/pem.h>
#import <openssl/obj_mac.h>
#import <openssl/ecdh.h>
@interface ECkeyPairs : NSObject
@property (strong, nonatomic) NSString *privatePem; 
@property (strong, nonatomic) NSString *privateKey; 
@property (strong, nonatomic) NSString *publicPem;  
@property (strong, nonatomic) NSString *publicKey;  
@property (strong, nonatomic) NSString *peerPublicPem;  
@property (strong, nonatomic) NSString *peerPublicKey;  
@property (strong, nonatomic) NSString *shareKey;
@end
@interface ECkeyUtils : NSObject
@property (strong, nonatomic)ECkeyPairs *eckeyPairs;
- (void)generatekeyPairs;
+ (NSString *)getShareKeyFromPeerPubPem:(NSString *)peerPubPem
                             privatePem:(NSString *)privatePem
                                 length:(int)length;
+ (EC_KEY *)publicKeyFromPEM:(NSString *)publicKeyPEM;
+ (EC_KEY *)privateKeyFromPEM:(NSString *)privateKeyPEM;
+ (NSString *)getKeyFromPemKey:(NSString *)pemKey isPrivate:(BOOL)isPrivate;
+ (NSString *)getPemKeyFromKey:(NSString *)key isPrivate:(BOOL)isPrivate;
@end
