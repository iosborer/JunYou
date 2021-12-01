#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIViewController (DVVFixModalPresentationStyle)
#ifdef __IPHONE_13_0
@property (nonatomic, assign) BOOL dvv_didSetModalPresentationStyle API_AVAILABLE(ios(13.0));
#endif
@end
NS_ASSUME_NONNULL_END
