#import <UIKit/UIKit.h>
@protocol TFJunYou_FaceViewControllerDelegate <NSObject>
- (void) selectImageNameString:(NSString*)imageName ShortName:(NSString *)shortName isSelectImage:(BOOL)isSelectImage;
- (void) faceViewDeleteAction;
@end
@interface TFJunYou_FaceViewController : UIView <UIScrollViewDelegate>{
	NSMutableArray            *_phraseArray;
    UIScrollView              *_sv;
    UIPageControl* _pc;
    BOOL pageControlIsChanging;
}
@property (nonatomic, weak) id<TFJunYou_FaceViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *shortNameArray;
@property (nonatomic, strong) NSMutableArray *shortNameArrayC;
@property (nonatomic, strong) NSMutableArray *shortNameArrayE;
@end
