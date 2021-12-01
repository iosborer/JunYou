#import "TFJunYou_admobViewController.h"
@interface TFJunYou_PSUpdateUserVC : TFJunYou_admobViewController{
    UITextField* _pwd;
    UITextField* _repeat;
    UITextField* _name;
    UILabel* _workexp;
    UILabel* _city;
    UILabel* _dip;
    UISegmentedControl* _sex;
    UITextField* _birthday;
    TFJunYou_DatePicker* _date;
    UIImage* _image;
    TFJunYou_ImageView* _head;
    UILabel *_inviteCode;
}
@property (nonatomic,strong) TFJunYou_UserObject* user;
@property (nonatomic,assign) BOOL isRegister;
@property (nonatomic, strong) UIImage *headImage;
@end
