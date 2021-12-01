#import "TFJunYou_admobViewController.h"
@protocol forgetPwdVCDelegate <NSObject>
- (void)forgetPwdSuccess;
@end
@interface TFJunYou_forgetPwdVC : TFJunYou_admobViewController{
    UITextField* _phone;
    UITextField* _oldPwd;
    UITextField* _pwd;
    UITextField* _repeat;
    UITextField* _code;
    UIButton* _send;
    NSString* _smsCode;
    int _seconds;
}
@property (nonatomic, weak) id<forgetPwdVCDelegate> delegate;
@property (nonatomic, assign) BOOL isModify;
@property (nonatomic, assign) BOOL isPayPWD;
@end
