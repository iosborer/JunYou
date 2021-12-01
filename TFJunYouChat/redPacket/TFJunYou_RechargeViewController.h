#import "TFJunYou_TableViewController.h"
@protocol RechargeDelegate <NSObject>
-(void)rechargeSuccessed;
@end
@interface TFJunYou_RechargeViewController : TFJunYou_admobViewController
@property (nonatomic, weak) id<RechargeDelegate> rechargeDelegate;
@property (nonatomic,assign) BOOL isQuitAfterSuccess;
@end
