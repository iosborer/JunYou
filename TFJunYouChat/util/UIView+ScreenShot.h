#import <UIKit/UIKit.h>
@interface UIView (ScreenShot)
- (UIImage *)screenshot;
- (UIImage *)screenshotWithRect:(CGRect)rect;
- (UIImage *)snapshot:(UIView *)view;
- (UIImage *)viewSnapshot:(UIView *)view withInRect:(CGRect)rect;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
@end
