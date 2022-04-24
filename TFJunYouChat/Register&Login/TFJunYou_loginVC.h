#import "TFJunYou_admobViewController.h"
typedef NS_ENUM(NSInteger, TFJunYou_LoginType) {
    TFJunYou_LoginQQ = 1,          
    TFJunYou_LoginWX,               
};
@interface TFJunYou_loginVC : TFJunYou_admobViewController{
    UITextField* _pwd;
    UITextField* _phone;
    TFJunYou_UserObject* _user;
}
@property(assign)BOOL isAutoLogin;
@property(assign)BOOL isSwitchUser;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) TFJunYou_Location *location;
@property (nonatomic, assign) BOOL isThirdLogin;
@property (nonatomic, assign) BOOL isSMSLogin;
@property (nonatomic, assign) TFJunYou_LoginType type;
@property (nonatomic,strong) UIView *launchView;
@end
