#import <UIKit/UIKit.h>
@protocol YBAttributeTapActionDelegate <NSObject>
@optional
- (void)yb_tapAttributeInLabel:(UILabel *)label
                        string:(NSString *)string
                         range:(NSRange)range
                         index:(NSInteger)index;
@end
@interface UILabel (YBAttributeTextTapAction)
@property (nonatomic, assign) BOOL enabledTapEffect;
@property (nonatomic, strong) UIColor * tapHighlightedColor;
@property (nonatomic, assign) BOOL enlargeTapArea;
- (void)yb_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                 tapClicked:(void (^) (UILabel * label, NSString *string, NSRange range, NSInteger index))tapClick;
- (void)yb_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                   delegate:(id <YBAttributeTapActionDelegate> )delegate;
- (void)yb_addAttributeTapActionWithRanges:(NSArray <NSString *> *)ranges
                                 tapClicked:(void (^) (UILabel * label, NSString *string, NSRange range, NSInteger index))tapClick;
- (void)yb_addAttributeTapActionWithRanges:(NSArray <NSString *> *)ranges
                                   delegate:(id <YBAttributeTapActionDelegate> )delegate;
@end
