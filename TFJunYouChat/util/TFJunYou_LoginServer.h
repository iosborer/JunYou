#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface TFJunYou_LoginServer : NSObject
+ (instancetype)sharedManager;
- (void)loginWithUser:(TFJunYou_UserObject *)user password:(NSString *)password areaCode:(NSString *)areaCode account:(NSString *)account toView:(id)toView;
- (void)autoLoginWithToView:(id)toView;
- (void)smsLoginWithUser:(TFJunYou_UserObject *)user areaCode:(NSString *)areaCode account:(NSString *)account toView:(id)toView;
-(void)thirdLoginV1:(TFJunYou_UserObject*)user password:(NSString *)password type:(NSInteger)type openId:(NSString *)openId isLogin:(BOOL)isLogin toView:(id)toView;
- (void)wxSdkLoginV1:(TFJunYou_UserObject *)user type:(NSInteger)type openId:(NSString *)openId toView:(id)toView;
-(void)registerUserV1:(TFJunYou_UserObject*)user type:(int)type inviteCode:(NSString *)inviteCode workexp:(int)workexp diploma:(int)diploma isSmsRegister:(BOOL)isSmsRegister smsCode:(NSString *)smsCode password:(NSString *)password toView:(id)toView;
- (NSString *)getUpdatePWDMacWithValue:(NSString *)value password:(NSString *)password;
@end
NS_ASSUME_NONNULL_END
