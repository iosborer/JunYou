#import <UIKit/UIKit.h>
@interface HBImageScroller : UIScrollView
{
    UIImageView * _imageView;
    BOOL max;
    id _target;
    SEL _tapOnceAction;
    CGSize _beginSize;
    CGSize _beginImageSize;
    float _scale;
    float _imgScale;
}
@property(nonatomic,readonly) UIImageView * imageView;
@property(nonatomic,assign) UIViewController * controller;
-(id)initWithImage:(UIImage*)image andFrame:(CGRect)frame; 
-(void) addTarget:(id)target  tapOnceAction:(SEL)action;  
-(void)setImage:(UIImage*)image;
-(void)setImageWithURL:(NSString*)url  andSmallImage:(UIImage*)image;
-(void)setImageWithURL:(NSString *)url ;
-(void)reset;  
@end
typedef enum {
    RegionTopLeft=0,
    RegionBottomLeft,
    RegionTopRight,
    RegionBottomRight
} LocationRegion;
