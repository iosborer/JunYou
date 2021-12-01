#import <UIKit/UIKit.h>
@class TFJunYou_MoreSelectVC;
@protocol TFJunYou_MoreSelectVCDelegate <NSObject>
- (void)didSureBtn:(TFJunYou_MoreSelectVC *)moreSelectVC indexStr:(NSString *)indexStr;
@end
@interface TFJunYou_MoreSelectVC : UIViewController
@property (nonatomic, strong) NSString *indexStr;
@property (weak, nonatomic) id <TFJunYou_MoreSelectVCDelegate>delegate;
- (instancetype)initWithTitle:(NSString *)title dataArray:(NSArray *)dataArray;
@end
