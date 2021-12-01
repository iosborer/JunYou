#import "TFJunYou_admobViewController.h"
typedef NS_ENUM(NSInteger, TFJunYou_InputMoneyType) {
    TFJunYou_InputMoneyTypeSetMoney,        
    TFJunYou_InputMoneyTypeCollection,      
    TFJunYou_InputMoneyTypePayment,         
};
@interface TFJunYou_InputMoneyVC : TFJunYou_admobViewController
@property (nonatomic, assign) TFJunYou_InputMoneyType type;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *desStr;
@property (nonatomic, strong) NSString *paymentCode;
@property (weak, nonatomic) id delegate;
@property (nonatomic, assign) SEL onInputMoney;
@end
