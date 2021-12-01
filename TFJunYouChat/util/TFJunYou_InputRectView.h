#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface TFJunYou_InputRectView : UIView
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) SEL onRelease;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeString;
@property (weak, nonatomic) id delegate;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isTitleCenter;
- (instancetype)initWithFrame:(CGRect)frame sureBtnTitle:(NSString *)btnTitle;
- (void)hide;
@end
NS_ASSUME_NONNULL_END
