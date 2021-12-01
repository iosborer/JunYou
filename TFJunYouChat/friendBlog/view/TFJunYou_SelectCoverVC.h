#import "TFJunYou_admobViewController.h"
NS_ASSUME_NONNULL_BEGIN
@class TFJunYou_SelectCoverVC;
@protocol TFJunYou_SelectCoverVCDelegate <NSObject>
- (void)touchAtlasButtonReturnCover:(UIImage *)img;
- (void)selectImage:(UIImage *)img toView:(TFJunYou_SelectCoverVC *)view;
@end
@interface TFJunYou_SelectCoverVC : TFJunYou_admobViewController
@property (nonatomic,weak) id<TFJunYou_SelectCoverVCDelegate> delegate;
- (instancetype)initWithVideo:(NSString *)video;
@end
NS_ASSUME_NONNULL_END
