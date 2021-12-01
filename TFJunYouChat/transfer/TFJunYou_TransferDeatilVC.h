#import "TFJunYou_admobViewController.h"
@interface TFJunYou_TransferDeatilVC : TFJunYou_admobViewController
@property (nonatomic, strong) TFJunYou_UserObject *user;
@property (nonatomic, strong) TFJunYou_MessageObject *msg;
@property (assign) SEL onResend; 
@property (weak, nonatomic) id delegate;
@end
