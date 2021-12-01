#import <UIKit/UIKit.h>
#import "TFJunYou_FaceViewController.h"
#import "TFJunYou_FavoritesVC.h"
#import "TFJunYou_EmojiPackgeVC.h"
@class menuImageView;
@class TFJunYou_gifViewController;
@interface TFJunYou_emojiViewController : UIView{
    menuImageView* _tb;
    TFJunYou_FaceViewController* _faceView;
    TFJunYou_gifViewController* _gifView;
}
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) TFJunYou_FaceViewController* faceView;
@property (nonatomic, strong) TFJunYou_FavoritesVC *TFJunYou_FavoritesVC;
@property (nonatomic, strong) NSArray *emojiDataArray;
-(void)selectType:(int)n;
@end
