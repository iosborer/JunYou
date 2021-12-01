#import "QRImage.h"
@implementation QRImage
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *outPutImage = [filter outputImage];
    return [[self alloc] createNonInterpolatedUIImageFormCIImage:outPutImage imageSize:Imagesize logoImage:nil logoImageSize:0];
}
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImage:(UIImage *)logoImage logoImageSize:(CGFloat)logoImagesize{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *outPutImage = [filter outputImage];
    return [[self alloc] createNonInterpolatedUIImageFormCIImage:outPutImage imageSize:Imagesize logoImage:logoImage logoImageSize:logoImagesize];
}
+ (UIImage *)barCodeWithString:(NSString *)text BCSize:(CGSize)size
{
    CIImage *image = [self generateBarCodeImage:text];
    return [self resizeCodeImage:image withSize:size];
}
+ (CIImage *)generateBarCodeImage:(NSString *)source
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        NSData *data = [source dataUsingEncoding: NSASCIIStringEncoding];
        CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
        [filter setValue:data forKey:@"inputMessage"];
        [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputQuietSpace"];
        return filter.outputImage;
    }else{
        return nil;
    }
}
+ (UIImage *)resizeCodeImage:(CIImage *)image withSize:(CGSize)size
{
    if (image) {
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        UIImage *barImage = [UIImage imageWithCGImage:imageRefResized];
        CGContextRelease(contentRef);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(imageRef);
        CGImageRelease(imageRefResized);
        return barImage;
    }else{
        return nil;
    }
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image imageSize:(CGFloat)imageSize logoImage:(UIImage *)logoImage logoImageSize:(CGFloat)logoImagesize{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(imageSize/CGRectGetWidth(extent), imageSize/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , imageSize, imageSize)];
    if (logoImage) {
        logoImage = [self logoImage:logoImage withParam:logoImagesize/2];
        [logoImage drawInRect:CGRectMake((imageSize-logoImagesize)/2.0, (imageSize-logoImagesize)/2.0, logoImagesize, logoImagesize)];
    }
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}
- (UIImage *)logoImage:(UIImage *)image withParam:(CGFloat)inset {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, inset*2, inset*2)];
    imageV.image = image;
    imageV.layer.cornerRadius = inset;
    imageV.layer.masksToBounds = YES;
    imageV.layer.borderColor = [UIColor whiteColor].CGColor;
    imageV.layer.borderWidth = 3.f;
    UIImage *newImage = [UIImage imageWithView:imageV];
    return newImage;
}
@end
