#import "TFJunYou_admobViewController.h"
typedef NS_OPTIONS(NSInteger, TFJunYou_PayType) {
    TFJunYou_PayTypeSetupPassword,     
    TFJunYou_PayTypeRepeatPassword,    
    TFJunYou_PayTypeInputPassword,     
};
typedef NS_OPTIONS(NSInteger, TFJunYou_EnterType) {
    TFJunYou_EnterTypeDefault,            
    TFJunYou_EnterTypeWithdrawal,         
    TFJunYou_EnterTypeSendRedPacket,      
    TFJunYou_EnterTypeTransfer,           
    TFJunYou_EnterTypeQr,                 
    TFJunYou_EnterTypeSkPay,              
    TFJunYou_EnterTypePayQr,               
};
@protocol TFJunYou_PayPasswordVCDelegate <NSObject>
- (void)updatePayPasswordSuccess:(NSString *)payPassword;
@end
@interface TFJunYou_PayPasswordVC : TFJunYou_admobViewController
@property (nonatomic, assign) TFJunYou_PayType type;
@property (nonatomic, assign) TFJunYou_EnterType enterType;
@property (nonatomic, strong) NSString *lastPsw;
@property (nonatomic, strong) NSString *oldPsw;
@property (nonatomic, weak) id<TFJunYou_PayPasswordVCDelegate> delegate;
@end
