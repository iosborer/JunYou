#import <Foundation/Foundation.h>
typedef enum {
    THUMB_NOTIC_BIG=1,      
    THUMB_NOTIC_MIDDLE=2,    
    THUMB_NOTIC_SMALL_1=3,   
    THUMB_WEIBO_BIG=6,    
    THUMB_WEIBO_MIDDLE=7,  
    THUMB_WEIBO_SMALL_1=8,   
    THUMB_WEIBO_SMALL_2=9,  
    THUMB_TASK_BIG=11,   
    THUMB_TASK_MIDDLE=12,  
    THUMB_TASK_SMALL_1=13,  
    THUMB_TALK_BIG=16,  
    THUMB_TALK_MIDDLE=17,  
    THUMB_TALK_SMALL_1=18,  
    THUMB_AVATAR_BIG=21 ,  
    THUMB_AVATAR_SMALL_2=22,  
    THUMB_LOGO_BIG=26,  
    THUMB_LOGO_SMALL_2=27   
} ImageThumbType;
@interface NSImageUtil : NSObject
{
    UIImage * _image;
    UIView * _backView;
    UIImageView *_imageView;
}
+(UIImage*)getClickImage:(UIImage*)originaLimage  withSize:(CGSize)size;
+(UIImage*)limitSizeImage:(UIImage*)originaImage withSize:(CGSize)size;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
-(void) showBigImage:(UIImage*)image fromView:(UIImageView*)fromView  complete:(void(^)(UIView *bacView))complete;
-(void) showBigImageWithUrl:(NSString *)url fromView:(UIImageView *)fromView complete:(void (^)(UIView *))complete;
-(void) goBackToView:(UIImageView*)toView withImage:(UIImage*)image;
-(void) goBackToView:(UIImageView *)toView withImageUrl:(NSString *)url;
@end
