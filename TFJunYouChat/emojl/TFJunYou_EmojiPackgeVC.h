#import <UIKit/UIKit.h>
#import "JLFacePackgeModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol EmojiPackgeVCDelegate <NSObject>
- (void)selectEmojiPackgeWithString:(NSString *) str;
@end
@interface TFJunYou_EmojiPackgeVC : UIViewController
@property (nonatomic, weak) id<EmojiPackgeVCDelegate>delegate;
@property (nonatomic, strong) JLFacePackgeModel *model;
@end
NS_ASSUME_NONNULL_END
