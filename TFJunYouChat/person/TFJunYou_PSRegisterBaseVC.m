#import "TFJunYou_PSRegisterBaseVC.h"
#import "selectValueVC.h"
#import "selectProvinceVC.h"
#import "ImageResize.h" 
#import "TFJunYou_ActionSheetVC.h"
#import "TFJunYou_CameraVC.h"
#import "resumeData.h"
#define HEIGHT 56
#define IMGSIZE 100
@interface TFJunYou_PSRegisterBaseVC ()<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,TFJunYou_ActionSheetVCDelegate,TFJunYou_CameraVCDelegate>
@end
@implementation TFJunYou_PSRegisterBaseVC
- (id)init
{
    self = [super init];
    if (self) {
        self.isGotoBack   = YES;
        if(self.isRegister){
            _resumeModel.telephone   = _user.telephone;
            self.title = [NSString stringWithFormat:@"%@",Localized(@"JX_BaseInfo")];
        }
        else
            self.title = Localized(@"JX_BaseInfo");
        self.heightFooter = 0;
        self.heightHeader = TFJunYou__SCREEN_TOP;
        [self createHeadAndFoot];
        self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
        self.tableBody.scrollEnabled = YES;
        int h = 0;
        NSString* s;
        TFJunYou_ImageView* iv;
        iv = [[TFJunYou_ImageView alloc]init];
        iv.frame = self.tableBody.bounds;
        iv.delegate = self;
        iv.didTouch = @selector(hideKeyboard);
        [self.tableBody addSubview:iv];
        _head = [[TFJunYou_ImageView alloc]initWithFrame:CGRectMake((TFJunYou__SCREEN_WIDTH-IMGSIZE)/2, INSETS, IMGSIZE, IMGSIZE)];
        _head.layer.cornerRadius = 6;
        _head.layer.masksToBounds = YES;
        _head.didTouch = @selector(pickImage);
        _head.delegate = self;
        _head.image = [[UIImage imageNamed:@"registered_default"] imageWithTintColor:THEMECOLOR];
        if(self.isRegister)
            s = _user.userId;
        else
            s = g_myself.userId;
        [g_server getHeadImageSmall:s userName:_resumeModel.name imageView:_head];
        [self.tableBody addSubview:_head];
        h = INSETS*2+IMGSIZE;
        NSString* workExp = [g_constant.workexp objectForKey:[NSNumber numberWithInt:_resumeModel.workexpId]];
        NSString* diploma = [g_constant.diploma objectForKey:[NSNumber numberWithInt:_resumeModel.diplomaId]];
        NSString* city = [g_constant getAddressForInt:_resumeModel.provinceId cityId:_resumeModel.cityId areaId:_resumeModel.areaId];
        iv = [self createButton:Localized(@"JX_Name") drawTop:NO drawBottom:YES must:YES click:nil];
        iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
        _name = [self createTextField:iv default:_resumeModel.name hint:Localized(@"JX_InputName")];
        h+=iv.frame.size.height;
        iv = [self createButton:Localized(@"JX_Sex") drawTop:NO drawBottom:YES must:YES click:nil];
        iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
        _sex = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:Localized(@"JX_Wuman"),Localized(@"JX_Man"),nil]];
        _sex.frame = CGRectMake(TFJunYou__SCREEN_WIDTH -87 - 15,(HEIGHT-25)/2,87,25);
        _sex.selectedSegmentIndex = _resumeModel.sex;
        _sex.tintColor = THEMECOLOR;
        _sex.layer.cornerRadius = 5;
        _sex.layer.borderWidth = 1.5;
        _sex.layer.borderColor = [THEMECOLOR CGColor];
        _sex.clipsToBounds = YES;
        _sex.selectedSegmentIndex = [_user.sex boolValue];
        _sex.apportionsSegmentWidthsByContent = NO;
        [iv addSubview:_sex];
        h+=iv.frame.size.height;
        if (!_resumeModel.birthday) {
            _resumeModel.birthday = [[NSDate date] timeIntervalSince1970];
        }
        iv = [self createButton:Localized(@"JX_BirthDay") drawTop:NO drawBottom:NO must:YES click:nil];
        iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
        _birthday = [self createTextField:iv default:[TimeUtil getDateStr:_resumeModel.birthday] hint:Localized(@"JX_BirthDay")];
        h+=iv.frame.size.height;
        if(!self.isRegister){
            iv = [self createButton:Localized(@"JX_WorkingYear") drawTop:YES drawBottom:YES must:YES click:@selector(onWorkexp)];
            iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
            _workexp = [self createLabel:iv default:workExp];
            h+=iv.frame.size.height;
            iv = [self createButton:Localized(@"JX_HighSchool") drawTop:NO drawBottom:YES must:YES click:@selector(onDiploma)];
            iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
            _dip = [self createLabel:iv default:diploma];
            h+=iv.frame.size.height;
            iv = [self createButton:Localized(@"JX_Address") drawTop:NO drawBottom:NO must:YES click:@selector(onCity)];
            iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
            _city = [self createLabel:iv default:city];
            h+=iv.frame.size.height;
        }
        h+=INSETS;
        UIButton* _btn;
        if(self.isRegister)
            _btn = [UIFactory createCommonButton:Localized(@"JX_NextStep") target:self action:@selector(onInsert)];
        else
            _btn = [UIFactory createCommonButton:Localized(@"JX_Update") target:self action:@selector(onUpdate)];
        _btn.layer.cornerRadius = 7;
        _btn.clipsToBounds = YES;
        _btn.custom_acceptEventInterval = .25f;
        _btn.frame = CGRectMake(15, h, TFJunYou__SCREEN_WIDTH-15*2, 40);
        [self.tableBody addSubview:_btn];
        _date = [[TFJunYou_DatePicker alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_HEIGHT-200, TFJunYou__SCREEN_WIDTH, 200)];
        _date.date = [NSDate dateWithTimeIntervalSince1970:_resumeModel.birthday];
        _date.datePicker.datePickerMode = UIDatePickerModeDate;
        _date.delegate = self;
        _date.didChange = @selector(onDate:);
        _date.didSelect = @selector(onDate:);
    }
    return self;
}
-(void)dealloc{
    self.resumeId = nil;
    self.user = nil;
    self.resumeModel = nil;
    [_date removeFromSuperview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == _birthday){
        [self hideKeyboard];
        [g_window addSubview:_date];
        _date.hidden = NO;
        return NO;
    }else{
        _date.hidden = YES;
        return YES;
    }
}
- (IBAction)onDate:(id)sender {
    NSDate *selected = [_date date];
    _birthday.text = [TimeUtil formatDate:selected format:@"yyyy-MM-dd"];
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if( [aDownload.action isEqualToString:act_Config]){
        [g_config didReceive:dict];
        [_user copyFromResume:_resumeModel];
        [g_loginServer registerUserV1:_user type:self.type inviteCode:_inviteCodeStr workexp:_resumeModel.workexpId diploma:_resumeModel.diplomaId isSmsRegister:self.isSmsRegister smsCode:self.smsCode password:self.password toView:self];
    }
    if( [aDownload.action isEqualToString:act_UploadHeadImage] ){
        _head.image = _image;
        _image = nil;
        if(self.isRegister){
        }else{
            [g_server delHeadImage:_user.userId];
            [g_App showAlert:Localized(@"JXAlert_UpdateOK")];
        }
        [g_notify postNotificationName:kUpdateUserNotifaction object:self userInfo:nil];
        [g_notify postNotificationName:kRegisterNotifaction object:self userInfo:nil];
        [self actionQuit];
    }
    if( [aDownload.action isEqualToString:act_Register] || [aDownload.action isEqualToString:act_RegisterV1]){
        [g_default setBool:NO forKey:kTHIRD_LOGIN_AUTO];
        [g_server doLoginOK:dict user:_user];
        self.user = g_server.myself;
        self.resumeId   = [(NSDictionary *)[dict objectForKey:@"cv"] objectForKey:@"resumeId"];
        [g_server getUser:[[dict objectForKey:@"userId"] stringValue] toView:self];
    }
    if([aDownload.action isEqualToString:act_UserGet]){
        if ([dict objectForKey:@"settings"]) {
            g_server.myself.chatRecordTimeOut = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"settings"] objectForKey:@"chatRecordTimeOut"]];
            g_server.myself.chatSyncTimeLen = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"settings"] objectForKey:@"chatSyncTimeLen"]];
            g_server.myself.groupChatSyncTimeLen = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"settings"] objectForKey:@"groupChatSyncTimeLen"]];
            g_server.myself.friendsVerify = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"settings"] objectForKey:@"friendsVerify"]];
            g_server.myself.isEncrypt = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"settings"] objectForKey:@"isEncrypt"]];
            g_server.myself.isTyping = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"settings"] objectForKey:@"isTyping"]];
            g_server.myself.isVibration = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"settings"] objectForKey:@"isVibration"]];
            g_server.myself.multipleDevices = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"settings"] objectForKey:@"multipleDevices"]];
            g_server.myself.isUseGoogleMap = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"settings"] objectForKey:@"isUseGoogleMap"]];
        }
        [g_server uploadHeadImage:_user.userId image:_image toView:self];
    }
    if( [aDownload.action isEqualToString:act_resumeUpdate] ){
        if(_image)
            [g_server uploadHeadImage:g_myself.userId image:_image toView:self];
        else{
            g_myself.userNickname = _name.text;
            g_myself.sex = [NSNumber numberWithInteger:_sex.selectedSegmentIndex];
            g_myself.birthday = _date.date;
            g_myself.cityId = [NSNumber numberWithInt:[_city.text intValue]];
            [g_App showAlert:Localized(@"JXAlert_UpdateOK")];
            [g_notify postNotificationName:kUpdateUserNotifaction object:self userInfo:nil];
            [self actionQuit];
        }
    }
    if ([aDownload.action isEqualToString:act_registerSDK] || [aDownload.action isEqualToString:act_registerSDKV1]) {
        [g_default setBool:YES forKey:kTHIRD_LOGIN_AUTO];
        g_server.openId = nil;
        [g_server doLoginOK:dict user:_user];
        self.user = g_server.myself;
        self.resumeId   = [(NSDictionary *)[dict objectForKey:@"cv"] objectForKey:@"resumeId"];
        [g_server getUser:[[dict objectForKey:@"userId"] stringValue] toView:self];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if( [aDownload.action isEqualToString:act_UploadHeadImage] ){
        _head.image = _image;
        _image = nil;
        if(self.isRegister){
        }else{
            [g_server delHeadImage:_user.userId];
            [g_App showAlert:Localized(@"JXAlert_UpdateOK")];
        }
        [g_notify postNotificationName:kUpdateUserNotifaction object:self userInfo:nil];
        [g_notify postNotificationName:kRegisterNotifaction object:self userInfo:nil];
        [self actionQuit];
    }
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait stop];
    if( [aDownload.action isEqualToString:act_UploadHeadImage] ){
        _head.image = _image;
        _image = nil;
        if(self.isRegister){
        }else{
            [g_server delHeadImage:_user.userId];
            [g_App showAlert:Localized(@"JXAlert_UpdateOK")];
        }
        [g_notify postNotificationName:kUpdateUserNotifaction object:self userInfo:nil];
        [g_notify postNotificationName:kRegisterNotifaction object:self userInfo:nil];
        [self actionQuit];
    }
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}
-(TFJunYou_ImageView*)createButton:(NSString*)title drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom must:(BOOL)must click:(SEL)click{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    if(click)
        btn.didTouch = click;
    else
        btn.didTouch = @selector(hideKeyboard);
    btn.delegate = self;
    [self.tableBody addSubview:btn];
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(15, 0, 130, HEIGHT)];
    p.text = title;
    p.font = g_factory.font16;
    p.backgroundColor = [UIColor clearColor];
    p.textColor = [UIColor blackColor];
    [btn addSubview:p];
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(15,0,TFJunYou__SCREEN_WIDTH-15,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    if(drawBottom){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(15,HEIGHT-LINE_WH,TFJunYou__SCREEN_WIDTH-15,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    if(click){
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, (HEIGHT-13)/2, 7, 13)];
        iv.image = [UIImage imageNamed:@"new_icon_>"];
        [btn addSubview:iv];
    }
    return btn;
}
-(UITextField*)createTextField:(UIView*)parent default:(NSString*)s hint:(NSString*)hint{
    UITextField* p = [[UITextField alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH/2,INSETS,TFJunYou__SCREEN_WIDTH/2-15,HEIGHT-INSETS*2)];
    p.delegate = self;
    p.autocorrectionType = UITextAutocorrectionTypeNo;
    p.autocapitalizationType = UITextAutocapitalizationTypeNone;
    p.enablesReturnKeyAutomatically = YES;
    p.borderStyle = UITextBorderStyleNone;
    p.returnKeyType = UIReturnKeyDone;
    p.clearButtonMode = UITextFieldViewModeWhileEditing;
    p.textAlignment = NSTextAlignmentRight;
    p.textColor = HEXCOLOR(0x666666);
    p.userInteractionEnabled = YES;
    p.text = s;
    p.placeholder = hint;
    p.font = g_factory.font16;
    [parent addSubview:p];
    return p;
}
-(UILabel*)createLabel:(UIView*)parent default:(NSString*)s{
    UILabel* p = [[UILabel alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH/2 -30 ,INSETS,TFJunYou__SCREEN_WIDTH/2,HEIGHT-INSETS*2)];
    p.userInteractionEnabled = NO;
    p.text = s;
    p.font = g_factory.font15;
    p.textAlignment = NSTextAlignmentRight;
    [parent addSubview:p];
    return p;
}
-(void)onWorkexp{
    if([self hideKeyboard])
        return;
    selectValueVC* vc = [selectValueVC alloc];
    vc.values = g_constant.workexp_name;
    vc.selNumber = _resumeModel.workexpId;
    vc.numbers   = g_constant.workexp_value;
    vc.delegate  = self;
    vc.didSelect = @selector(onSelWorkExp:);
    vc.quickSelect = YES;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}
-(void)onDiploma{
    if([self hideKeyboard])
        return;
    selectValueVC* vc = [selectValueVC alloc];
    vc.values = g_constant.diploma_name;
    vc.selNumber = _resumeModel.diplomaId;
    vc.numbers   = g_constant.diploma_value;
    vc.delegate  = self;
    vc.didSelect = @selector(onSelDiploma:);
    vc.quickSelect = YES;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}
-(void)onCity{
    if([self hideKeyboard])
        return;
    selectProvinceVC* vc = [selectProvinceVC alloc];
    vc.delegate = self;
    vc.didSelect = @selector(onSelCity:);
    vc.showCity = YES;
    vc.showArea = NO;
    vc.parentId = 1;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}
-(void)onSelCity:(selectProvinceVC*)sender{
    _resumeModel.cityId = sender.cityId;
    _resumeModel.provinceId = sender.provinceId;
    _resumeModel.areaId = sender.areaId;
    _resumeModel.countryId = 1;
    _city.text = sender.selValue;
}
-(void)onSelDiploma:(selectValueVC*)sender{
    _resumeModel.diplomaId = sender.selNumber;
    _dip.text = sender.selValue;
}
-(void)onSelWorkExp:(selectValueVC*)sender{
    _resumeModel.workexpId = sender.selNumber;
    _workexp.text = sender.selValue;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _image = [ImageResize image:[info objectForKey:@"UIImagePickerControllerEditedImage"] fillSize:CGSizeMake(640, 640)];
    _head.image = _image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void) pickImage
{
    [self hideKeyboard];
    TFJunYou_ActionSheetVC *actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"JX_ChoosePhoto"),Localized(@"JX_TakePhoto")]];
    actionVC.delegate = self;
    [self presentViewController:actionVC animated:NO completion:nil];
	UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
	ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	ipc.delegate = self;
	ipc.allowsEditing = YES;
    ipc.modalPresentationStyle = UIModalPresentationFullScreen;
    if (IS_PAD) {
        UIPopoverController *pop =  [[UIPopoverController alloc] initWithContentViewController:ipc];
        [pop presentPopoverFromRect:CGRectMake((self.view.frame.size.width - 320) / 2, 0, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else {
        [self presentViewController:ipc animated:YES completion:nil];
    }
}
- (void)actionSheet:(TFJunYou_ActionSheetVC *)actionSheet didButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        ipc.modalPresentationStyle = UIModalPresentationFullScreen;
        if (IS_PAD) {
            UIPopoverController *pop =  [[UIPopoverController alloc] initWithContentViewController:ipc];
            [pop presentPopoverFromRect:CGRectMake((self.view.frame.size.width - 320) / 2, 0, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else {
            [self presentViewController:ipc animated:YES completion:nil];
        }
    }else {
        TFJunYou_CameraVC *vc = [TFJunYou_CameraVC alloc];
        vc.cameraDelegate = self;
        vc.isPhoto = YES;
        vc = [vc init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)cameraVC:(TFJunYou_CameraVC *)vc didFinishWithImage:(UIImage *)image {
    _image = [ImageResize image:image fillSize:CGSizeMake(640, 640)];
    _head.image = _image;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)onUpdate{
    if(![self getInputValue])
        return;
}
-(void)onInsert{
    if(![self getInputValue])
        return;
    [g_server getSetting:self];
}
-(BOOL)getInputValue{
    if(_image==nil && self.isRegister){
        [g_App showAlert:Localized(@"JX_SetHead")];
        return NO;
    }
    if([_name.text length]<=0){
        [g_App showAlert:Localized(@"JX_InputName")];
        return NO;
    }
    if(!self.isRegister){
        if(_resumeModel.workexpId<=0){
            [g_App showAlert:Localized(@"JX_InputWorking")];
            return NO;
        }
        if(_resumeModel.diplomaId<=0){
            [g_App showAlert:Localized(@"JX_School")];
            return NO;
        }
        if(_resumeModel.cityId<=0){
            [g_App showAlert:Localized(@"JX_Live")];
            return NO;
        }
    }
    _resumeModel.name = _name.text;
    _resumeModel.birthday = [_date.date timeIntervalSince1970];
    _resumeModel.sex = _sex.selectedSegmentIndex;
    return  YES;
}
-(BOOL)hideKeyboard{
    BOOL b = _name.editing || _pwd.editing || _repeat.editing;
    _date.hidden = YES;
    [self.view endEditing:YES];
    return b;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
@end
