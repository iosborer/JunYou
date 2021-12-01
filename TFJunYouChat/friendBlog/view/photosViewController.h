#import <UIKit/UIKit.h>
@class AppDelegate;
@protocol TFJunYou_ServerResult;
@class TFJunYou_ImageView;
@interface photosViewController : UIViewController<UIScrollViewDelegate>{
    int _page;
    UIScrollView* sv;
    int      _photoCount;
    TFJunYou_ImageView* _iv;
    NSMutableArray* _array;
}
@property(nonatomic,retain) NSMutableArray* photos;
@property(nonatomic) int page;
+(photosViewController*)showPhotos:(NSArray*)a;
@end
