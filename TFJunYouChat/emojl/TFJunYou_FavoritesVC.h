@protocol TFJunYou_FavoritesVCDelegate <NSObject>
- (void) selectFavoritWithString:(NSString *) str;
- (void) deleteFavoritWithString:(NSString *) str;
@end
#import <UIKit/UIKit.h>
@interface TFJunYou_FavoritesVC : UIViewController
@property (nonatomic, weak) id<TFJunYou_FavoritesVCDelegate>delegate;
@end
