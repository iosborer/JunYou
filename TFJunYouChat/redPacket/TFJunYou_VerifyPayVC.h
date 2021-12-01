#import "TFJunYou_admobViewController.h"
typedef NS_OPTIONS(NSInteger, TFJunYou_VerifyType) {
    TFJunYou_VerifyTypeWithdrawal,         
    TFJunYou_VerifyTypeSendReadPacket,     
    TFJunYou_VerifyTypeTransfer,           
    TFJunYou_VerifyTypeQr,                 
    TFJunYou_VerifyTypeSkPay,              
    TFJunYou_VerifyTypePaymentCode,
    TFJunYou_VerifyTypeUserCancel,
};
@interface TFJunYou_VerifyPayVC : TFJunYou_admobViewController
@property (nonatomic, assign) TFJunYou_VerifyType type;
@property (nonatomic, strong) NSString *RMB;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, assign) SEL didDismissVC;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL didVerifyPay;
- (void)clearUpPassword;
- (NSString *)getMD5Password;
- (void)didDismissVerifyPayVC;
@end
