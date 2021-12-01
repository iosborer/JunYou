#import <UIKit/UIKit.h>
@interface UIImage (Color)
+(UIImage*) createImageWithColor:(UIColor*) color;
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
@end
