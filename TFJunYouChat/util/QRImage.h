#import <Foundation/Foundation.h>
@interface QRImage : NSObject
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize;
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImage:(UIImage *)logoImage logoImageSize:(CGFloat)logoImagesize;
+ (UIImage *)barCodeWithString:(NSString *)text BCSize:(CGSize)size;
@end
