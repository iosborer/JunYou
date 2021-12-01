#import "TFJunYou_admobViewController.h"
@protocol transferVCDelegate <NSObject>
-(void)transferToUser:(NSDictionary *)redpacketDict;
@end
@interface TFJunYou_TransferViewController : TFJunYou_admobViewController
@property (nonatomic, strong) TFJunYou_UserObject *user;
@property (weak, nonatomic) id <transferVCDelegate> delegate;
@end
