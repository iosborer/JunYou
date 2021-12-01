#import <UIKit/UIKit.h>
@class SCGIFImageView;
@protocol TFJunYou_gifViewControllerDelegate <NSObject>
- (void) selectGifWithString:(NSString *) str;
@end
@interface TFJunYou_gifViewController : UIView <UIScrollViewDelegate>{
	NSMutableArray            *_phraseArray;
    UIScrollView              *_sv;
    UIPageControl* _pc;
    SCGIFImageView* _gifIv;
    BOOL pageControlIsChanging;
    NSInteger maxPage;
    int tempN;
    int margin;
}
@property (nonatomic, weak) id <TFJunYou_gifViewControllerDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *faceArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end
