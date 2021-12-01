#import "TFJunYou_admobViewController.h"
@interface TFJunYou_inputPhoneVC : TFJunYou_admobViewController{
    UITextField* _area;
    UITextField* _phone;
    UITextField* _code;
    UITextField* _pwd;
    UITextField* _inviteCode;
    UIButton* _send;
    NSString* _smsCode;
    NSString* _imgCodeStr;
    NSString* _phoneStr;
    int _seconds;
}
@property (nonatomic, assign) BOOL isThirdLogin;
@property (nonatomic, assign) int type;
@end
