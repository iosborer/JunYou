#import "TFJunYou_admobViewController.h"
@interface TFJunYou_PSRegisterBaseVC : TFJunYou_admobViewController{
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
}
@property (nonatomic,strong) NSString* resumeId;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,assign) BOOL isRegister;
@property (nonatomic,strong) resumeBaseData* resumeModel;
@property (nonatomic,strong) TFJunYou_UserObject* user;
@property (nonatomic,assign) BOOL isSmsRegister;
@property (nonatomic,copy) NSString *inviteCodeStr; 
@property (nonatomic,copy) NSString *smsCode; 
@property (nonatomic, assign) int type;
@end
