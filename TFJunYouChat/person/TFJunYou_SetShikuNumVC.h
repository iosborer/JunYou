#import "TFJunYou_admobViewController.h"
NS_ASSUME_NONNULL_BEGIN
@class TFJunYou_SetShikuNumVC;
@protocol TFJunYou_SetShikuNumVCDelegate <NSObject>
-(void)setShikuNum:(TFJunYou_SetShikuNumVC *)setShikuNumVC updateSuccessWithAccount:(NSString *)account;
@end
@interface TFJunYou_SetShikuNumVC : TFJunYou_admobViewController
@property (nonatomic, strong) TFJunYou_UserObject *user;
@property (nonatomic, weak) id<TFJunYou_SetShikuNumVCDelegate> delegate;
@end
NS_ASSUME_NONNULL_END
