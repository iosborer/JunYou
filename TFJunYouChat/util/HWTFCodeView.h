#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class HWTFCodeView;
@protocol HWTFCodeViewDelegate <NSObject>
- (void)codeView:(HWTFCodeView *)codeView inputFnish:(NSString *)text;
@end
@interface HWTFCodeView : UIView
@property (nonatomic, copy, readonly) NSString *code;
- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
@property (nonatomic, weak) id<HWTFCodeViewDelegate> delegate;
@end
NS_ASSUME_NONNULL_END
