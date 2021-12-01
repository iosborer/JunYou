#import "TFJunYou_admobViewController.h"
#import "DMScaleTransition.h"
#import "TFJunYou_ImageScrollVC.h"
#import "TFJunYou_ActionSheetVC.h"
#import "TFJunYou__SelectMenuView.h"
#import "TFJunYou_addMsgVC.h"
#import "TFJunYou_BlogRemindVC.h"
@protocol TFJunYou_ServerResult;
@interface TFJunYou_PSMyViewController : TFJunYou_admobViewController<TFJunYou_ServerResult,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TFJunYou_ActionSheetVCDelegate,TFJunYou_SelectMenuViewDelegate>{
    TFJunYou_ImageView* _head;
    UIImage* _image;
    UILabel* _userName;
    UILabel* _userDesc;
    UILabel* _friendLabel;
    UILabel* _groupLabel;
    BOOL _isSelected;
    TFJunYou_ImageView *_topImageVeiw;
    UIView *_setBaseView;
}
@property (nonatomic, strong) DMScaleTransition *scaleTransition;
@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic,strong) UILabel * moneyLabel;
@property (nonatomic, assign) BOOL isAudioMeeting;
@property (nonatomic, assign) BOOL isGetUser;
-(void)refreshUserDetail;
@end
