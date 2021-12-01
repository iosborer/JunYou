#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface GALCaptcha : UIView
@property (nonatomic, strong)NSArray *CatArray;
@property (nonatomic, strong)NSMutableString *CatString;
-(void)refresh;
@end
NS_ASSUME_NONNULL_END
