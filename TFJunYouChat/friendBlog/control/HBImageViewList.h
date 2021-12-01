#import <UIKit/UIKit.h>
#import "HBImageScroller.h"
@interface HBImageViewList : UIScrollView<UIScrollViewDelegate>
{
    NSArray *_images;
    NSMutableArray *_imageViews;
    UIImage * _showImage;
    UIPageControl * _pageControl;
    int _prePage;
    id _target;
    SEL _tapOnceAction;
}
@property(nonatomic,readonly) NSArray * imageViews;
-(void)addImages:(NSArray*)images;          
-(void)addImagesURL:(NSArray*)urls withSmallImage:(NSArray*)images;
-(void)addImagesURL:(NSArray *)urls;
-(void)setImage:(UIImage *)image;        
-(void)setIndex:(int) index;
-(void)addTarget:(id)target tapOnceAction:(SEL)action; 
@end
