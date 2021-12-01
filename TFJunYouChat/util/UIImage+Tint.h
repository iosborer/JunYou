#import <UIKit/UIKit.h>
@interface UIImage (Tint)
-(UIImage *) imageWithTintColor:(UIColor * )tintColor;
-(UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
+ (UIImage *)imageWithView:(UIView *)view;
@end
