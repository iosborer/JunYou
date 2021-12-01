#import "TFJunYou_PSUpdateUserVC.h"
#import "selectValueVC.h"
#import "selectProvinceVC.h"
#import "ImageResize.h"
#import "TFJunYou_QRCodeViewController.h"
#import "TFJunYou_ActionSheetVC.h"
#import "TFJunYou_CameraVC.h"
#import "TFJunYou_SetShikuNumVC.h"
#import "TFJunYou_InputValueVC.h"
#define HEIGHT 56
#define IMGSIZE 36
@interface TFJunYou_PSUpdateUserVC ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TFJunYou_ActionSheetVCDelegate,TFJunYou_CameraVCDelegate,TFJunYou_SetShikuNumVCDelegate,UIScrollViewDelegate>
@property (nonatomic, assign) BOOL isUpdate;
@property (nonatomic, strong) UILabel *desLabel;
@end
@implementation TFJunYou_PSUpdateUserVC
@synthesize user;
- (id)init
{
    self = [super init];
    if (self) {
        self.isGotoBack   = YES;
        if(self.isRegister)
            self.title = [NSString stringWithFormat:@"4.%@",Localized(@"PSUpdateUserVC")];
        else
            self.title = Localized(@"JX_BaseInfo");
        self.heightFooter = 0;
        self.heightHeader = TFJunYou__SCREEN_TOP;
        [self createHeadAndFoot];
        self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
        self.tableBody.scrollEnabled = YES;
        self.tableBody.delegate = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [g_notify postNotificationName:kUpdateUserNotifaction object:self userInfo:nil];
        });
        [g_server delHeadImage:user.userId];
        [self createCustomView];
        [g_notify addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
        [g_notify addObserver:self selector:@selector(updateUserInfo:) name:kXMPPMessageUpadteUserInfoNotification object:nil];
    }
    return self;
}
- (void)updateUserInfo:(NSNotification *)noti {
    [g_server getUser:g_server.myself.userId toView:self];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _date.hidden = YES;
}
- (void) createCustomView {
    int h = 0;
    NSString* s;
    TFJunYou_ImageView* iv;
    iv = [[TFJunYou_ImageView alloc]init];
    iv.frame = self.tableBody.bounds;
    iv.delegate = self;
    iv.didTouch = @selector(hideKeyboard);
    [self.tableBody addSubview:iv];
    iv = [self createButton:@"头像" drawTop:NO drawBottom:YES must:YES click:@selector(pickImage)];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _head = [[TFJunYou_ImageView alloc]initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-IMGSIZE-41, (HEIGHT-IMGSIZE)/2, IMGSIZE, IMGSIZE)];
    _head.layer.cornerRadius = IMGSIZE/2;
    _head.layer.masksToBounds = YES;
    _head.image = self.headImage;
    s = user.userId;
    [g_server getHeadImageLarge:s userName:user.userNickname imageView:_head];
    [iv addSubview:_head];
    h+=iv.frame.size.height;
    NSString* city = [g_constant getAddressForNumber:user.provinceId cityId:user.cityId areaId:user.areaId];
    iv = [self createButton:Localized(@"JX_Name") drawTop:NO drawBottom:YES must:YES click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _name = [self createTextField:iv default:user.userNickname hint:Localized(@"JX_InputName")];
    h+=iv.frame.size.height;
    [_name addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    iv = [self createButton:Localized(@"JX_Sex") drawTop:NO drawBottom:YES must:YES click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _sex = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:Localized(@"JX_Wuman"),Localized(@"JX_Man"),nil]];
    _sex.frame = CGRectMake(TFJunYou__SCREEN_WIDTH -100 - 15,INSETS+3,100,HEIGHT-INSETS*2-6);
    _sex.userInteractionEnabled = YES;
    _sex.tintColor = THEMECOLOR;
    _sex.layer.cornerRadius = 5;
    _sex.layer.borderWidth = 1.5;
    _sex.layer.borderColor = [THEMECOLOR CGColor];
    _sex.clipsToBounds = YES;
    _sex.selectedSegmentIndex = [user.sex boolValue];
    _sex.apportionsSegmentWidthsByContent = NO;
    [iv addSubview:_sex];
    h+=iv.frame.size.height;
    iv = [self createButton:Localized(@"JX_BirthDay") drawTop:NO drawBottom:YES must:YES click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _birthday = [self createTextField:iv default:[TimeUtil getDateStr:[user.birthday timeIntervalSince1970]] hint:Localized(@"JX_BirthDay")];
    h+=iv.frame.size.height;
    if ([g_config.isOpenPositionService intValue] == 0) {
        iv = [self createButton:Localized(@"JXUserInfoVC_Address") drawTop:NO drawBottom:YES must:YES click:@selector(onCity)];
        iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
        _city = [self createLabel:iv default:city];
        h+=iv.frame.size.height;
    }
    if (!self.isRegister) {
        iv = [self createButton:Localized(@"JX_MyQRImage") drawTop:NO drawBottom:YES must:NO click:@selector(showUserQRCode)];
        iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
        h+=iv.frame.size.height;
        iv = [self createButton:Localized(@"JX_MyPhoneNumber") drawTop:NO drawBottom:YES must:NO click:nil];
        iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
        [self createLabel:iv default:g_myself.telephone];
        h+=iv.frame.size.height;
        if ([self.user.setAccountCount integerValue] > 0) {
            iv = [self createButton:Localized(@"JX_Communication") drawTop:NO drawBottom:NO must:NO click:nil];
        }else {
            iv = [self createButton:Localized(@"JX_Communication") drawTop:NO drawBottom:NO must:NO click:@selector(onShikuNum)];
        }
        UILabel *lab = [self createLabel:iv default:self.user.account];
        if ([self.user.setAccountCount integerValue] <= 0) {
            CGSize lSize = [self.user.account sizeWithAttributes:@{NSFontAttributeName:SYSFONT(15)}];
            CGRect frame = lab.frame;
            frame.origin.x = TFJunYou__SCREEN_WIDTH - lSize.width - INSETS - 20;
            lab.frame = frame;
        }
        iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
        h+=iv.frame.size.height;
        if ([g_config.registerInviteCode intValue] == 2) {
            iv = [self createButton:Localized(@"JX_InvitationCode") drawTop:YES drawBottom:NO must:NO click:nil];
            iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
            [self createLabel:iv default:g_myself.myInviteCode];
            h+=iv.frame.size.height;
        }
        iv = [self createButton:@"个性签名" drawTop:YES drawBottom:NO must:NO click:@selector(onIputDes)];
        iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
         _desLabel = [self createLabel:iv default:self.user.userDescription];
        h+=iv.frame.size.height;
        if (self.user.userDescription.length > 0) {
            [self updateDesLabelFrame];
        }
    }
    h+=40;
    UIButton* _btn;
    if(self.isRegister)
        _btn = [UIFactory createCommonButton:Localized(@"JX_NextStep") target:self action:@selector(onInsert)];
    else
        _btn = [UIFactory createCommonButton:Localized(@"JX_Update") target:self action:@selector(onUpdate)];
    _btn.layer.cornerRadius = 7;
    _btn.clipsToBounds = YES;
    _btn.custom_acceptEventInterval = 1.0f;
    _btn.frame = CGRectMake(INSETS, h, WIDTH, 40);
    [self.tableBody addSubview:_btn];
    int height = 200;
    if (THE_DEVICE_HAVE_HEAD) {
        height = 235;
    }
    _date = [[TFJunYou_DatePicker alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_HEIGHT-height, TFJunYou__SCREEN_WIDTH, height)];
    _date.datePicker.datePickerMode = UIDatePickerModeDate;
    _date.date = user.birthday;
    _date.delegate = self;
    _date.didChange = @selector(onDate:);
    _date.didSelect = @selector(onDate:);
    if (self.tableBody.frame.size.height < h+HEIGHT+INSETS) {
        self.tableBody.contentSize = CGSizeMake(0, h+HEIGHT+INSETS);
    }
}
- (void)updateDesLabelFrame {
    CGSize lSize = [self.user.userDescription sizeWithAttributes:@{NSFontAttributeName:SYSFONT(15)}];
    if (lSize.width > TFJunYou__SCREEN_WIDTH/2-INSETS - 20) {
        lSize.width = TFJunYou__SCREEN_WIDTH/2-INSETS - 20;
    }
    CGRect frame = _desLabel.frame;
    frame.origin.x = TFJunYou__SCREEN_WIDTH - lSize.width - INSETS - 20;
    frame.size.width = lSize.width;
    _desLabel.frame = frame;
}
- (void)onIputDes {
    TFJunYou_InputValueVC* vc = [TFJunYou_InputValueVC alloc];
    vc.value = g_myself.userDescription;
    vc.title = @"个性签名";
    vc.delegate  = self;
    vc.didSelect = @selector(onSaveRoomName:);
    vc.isLimit = YES;
    vc.limitLen = 30;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}
- (void)onSaveRoomName:(TFJunYou_InputValueVC*)vc {
    self.isUpdate = YES;
    _desLabel.text = vc.value;
    user.userDescription = vc.value;
    [self updateDesLabelFrame];
}
-(void)dealloc{
    [g_notify removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [g_notify removeObserver:self name:kXMPPMessageUpadteUserInfoNotification object:nil];
    self.user = nil;
    [_date removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
        [self.view endEditing:YES];
        [g_window addSubview:_date];
        _date.hidden = NO;
        return NO;
    }else{
        if (textField == _name && textField.text.length > 0) {
            _name.frame = CGRectMake(TFJunYou__SCREEN_WIDTH/2-8,INSETS,TFJunYou__SCREEN_WIDTH/2,HEIGHT-INSETS*2);
        }
        _date.hidden = YES;
        return YES;
    }
}
- (void)textDidChange:(UITextField *)textField {
    if (textField == _name) {
        if (textField.text.length > 0) {
            _name.frame = CGRectMake(TFJunYou__SCREEN_WIDTH/2-8,INSETS,TFJunYou__SCREEN_WIDTH/2,HEIGHT-INSETS*2);
        }else {
            _name.frame = CGRectMake(TFJunYou__SCREEN_WIDTH/2-15,INSETS,TFJunYou__SCREEN_WIDTH/2,HEIGHT-INSETS*2);
        }
        [self validationText:textField];
    }
}
- (NSString *)disable_Text:(NSString *)text
{
    NSLog(@"过滤--->%@",text);
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return [self disable_emoji:text];
}
- (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}
- (NSString *)validationText:(UITextField *)textField
{
    NSString *toBeString = [self disable_Text:textField.text];
    NSString *lang = [textField.textInputMode primaryLanguage];
    NSLog(@"%@",lang);
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length>=8) {
                NSString *strNew = [NSString stringWithString:toBeString];
                [textField setText:[strNew substringToIndex:8]];
            }else{
                [textField setText:toBeString];
            }
        }
        else
        {
            NSLog(@"输入的英文还没有转化为汉字的状态");
        }
    }
    else{
        if (toBeString.length > 8) {
            textField.text = [toBeString substringToIndex:8];
        }else{
            textField.text = toBeString;
        }
    }
    return textField.text;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == _name) {
        _name.frame = CGRectMake(TFJunYou__SCREEN_WIDTH/2-15,INSETS,TFJunYou__SCREEN_WIDTH/2,HEIGHT-INSETS*2);
    }
    return YES;
}
- (IBAction)onDate:(id)sender {
    NSDate *selected = [_date date];
    _birthday.text = [TimeUtil formatDate:selected format:@"yyyy-MM-dd"];
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if( [aDownload.action isEqualToString:act_UploadHeadImage] ){
        _image = nil;
        [g_server delHeadImage:user.userId];
        if(self.isRegister){
            [g_App showMainUI];
            [g_App showAlert:Localized(@"JX_RegOK")];
        }else{
            [g_App showAlert:Localized(@"JXAlert_UpdateOK")];
        }
        [g_notify postNotificationName:kUpdateUserNotifaction object:self userInfo:nil];
        [self actionQuit];
    }
    if( [aDownload.action isEqualToString:act_Register] || [aDownload.action isEqualToString:act_RegisterV1] ){
        [g_server doLoginOK:dict user:user];
        self.user = g_server.myself;
        [g_server uploadHeadImage:user.userId image:_image toView:self];
        [g_notify postNotificationName:kRegisterNotifaction object:self userInfo:nil];
    }
    if( [aDownload.action isEqualToString:act_UserUpdate] ){
        if(_image)
            [g_server uploadHeadImage:user.userId image:_image toView:self];
        else{
            user.userNickname = _name.text;
            user.sex = [NSNumber numberWithInteger:_sex.selectedSegmentIndex];
            user.birthday = _date.date;
            user.cityId = [NSNumber numberWithInt:[_city.text intValue]];
            [g_App showAlert:Localized(@"JXAlert_UpdateOK")];
            g_server.myself.userNickname = user.userNickname;
            g_server.myself.userDescription = user.userDescription;
            [g_default setObject:g_server.myself.userNickname forKey:kMY_USER_NICKNAME];
            [g_notify postNotificationName:kUpdateUserNotifaction object:self userInfo:nil];
            [self actionQuit];
        }
    }
    if ([aDownload.action isEqualToString:act_UserGet]) {
        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
        [user getDataFromDict:dict];
        self.user = user;
        [self createCustomView];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait stop];
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
    p.font = g_factory.font15;
    p.backgroundColor = [UIColor clearColor];
    p.textColor = [UIColor blackColor];
    [btn addSubview:p];
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(15,0,TFJunYou__SCREEN_WIDTH-15,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    if(drawBottom){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT-LINE_WH,TFJunYou__SCREEN_WIDTH-15,LINE_WH)];
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
    UITextField* p = [[UITextField alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH/2-15,INSETS,TFJunYou__SCREEN_WIDTH/2,HEIGHT-INSETS*2)];
    p.delegate = self;
    p.autocorrectionType = UITextAutocorrectionTypeNo;
    p.autocapitalizationType = UITextAutocapitalizationTypeNone;
    p.enablesReturnKeyAutomatically = YES;
    p.borderStyle = UITextBorderStyleNone;
    p.returnKeyType = UIReturnKeyDone;
    p.clearButtonMode = UITextFieldViewModeWhileEditing;
    p.textAlignment = NSTextAlignmentRight;
    p.userInteractionEnabled = YES;
    p.textColor = HEXCOLOR(0x999999);
    p.text = s;
    p.placeholder = hint;
    p.font = g_factory.font15;
    [parent addSubview:p];
    return p;
}
-(UILabel*)createLabel:(UIView*)parent default:(NSString*)s{
    UILabel* p = [[UILabel alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH/2,INSETS,TFJunYou__SCREEN_WIDTH/2 -30,HEIGHT-INSETS*2)];
    p.userInteractionEnabled = NO;
    p.text = s;
    p.font = g_factory.font15;
    p.textAlignment = NSTextAlignmentRight;
    p.textColor = HEXCOLOR(0x999999);
    [parent addSubview:p];
    CGSize size = [s boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:g_factory.font15} context:nil].size;
    CGRect frame = p.frame;
    frame.size.width = size.width;
    frame.origin.x = TFJunYou__SCREEN_WIDTH - size.width - INSETS;
    p.frame = frame;
    NSString* city = [g_constant getAddressForNumber:user.provinceId cityId:user.cityId areaId:user.areaId];
    if ([s isEqualToString:city]) {
        CGSize size = [Localized(@"JXUserInfoVC_Address") boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:g_factory.font13} context:nil].size;
        p.frame = CGRectMake(size.width + 30 + 10, INSETS, TFJunYou__SCREEN_WIDTH - size.width - 30 - 10 - 30, HEIGHT - INSETS * 2);
    }
    if ([s isEqualToString:g_myself.myInviteCode]) {
        p.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPre:)];
        [p addGestureRecognizer:longPress];
        _inviteCode = p;
    }
    return p;
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}
- (void)copy:(id)sender{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = [_inviteCode text];
}
- (void)longPre:(UILongPressGestureRecognizer *)recognizer{
    [self becomeFirstResponder]; 
    UIView *view = recognizer.view;
    [[UIMenuController sharedMenuController] setTargetRect:view.frame inView:view.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
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
    if (self) {
        [self resetViewFrame];
    }
    if ([user.cityId intValue] != sender.cityId) {
        self.isUpdate = YES;
    }
    user.cityId = [NSNumber numberWithInt:sender.cityId];
    user.provinceId = [NSNumber numberWithInt:sender.provinceId];
    user.areaId = [NSNumber numberWithInt:sender.areaId];
    user.countryId = [NSNumber numberWithInt:1];
    _city.text = sender.selValue;
}
- (void)resetViewFrame{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, self.view.frame.size.height);
    }];
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
}
- (void)actionSheet:(TFJunYou_ActionSheetVC *)actionSheet didButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        ipc.modalPresentationStyle = UIModalPresentationCurrentContext;
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
    if (_image || self.isUpdate) {
        [g_server updateUser:user toView:self];
    }else {
        [self actionQuit];
    }
}
-(void)onInsert{
    if(![self getInputValue])
        return;
    [g_loginServer registerUserV1:user type:0 inviteCode:nil workexp:0 diploma:0 isSmsRegister:NO smsCode:nil password:@"" toView:self];
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
    if(user.cityId<=0){
        [g_App showAlert:Localized(@"JX_Live")];
        return NO;
    }
    if (_birthday.text.length <= 0) {
        [g_App showAlert:Localized(@"JX_SelectDateOfBirth")];
        return NO;
    }
    if (![user.userNickname isEqualToString:_name.text] || [user.birthday timeIntervalSince1970] != [_date.date timeIntervalSince1970] || [user.sex integerValue] != _sex.selectedSegmentIndex) {
        self.isUpdate = YES;
    }
    user.userNickname = _name.text;
    user.birthday = _date.date;
    user.sex = [NSNumber numberWithBool:_sex.selectedSegmentIndex];
    return  YES;
}
-(BOOL)hideKeyboard{
    BOOL b = _name.editing || _pwd.editing || _repeat.editing || _birthday.editing;
    _date.hidden = YES;
    [self.view endEditing:YES];
    return b;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    NSValue *keyboardBeginBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyboardBeginBounds CGRectValue];
    NSValue *keyboardEndBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect=[keyboardEndBounds CGRectValue];
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    deltaY=-endRect.size.height;
}
-(void)showUserQRCode{
    TFJunYou_QRCodeViewController * qrVC = [[TFJunYou_QRCodeViewController alloc] init];
    qrVC.type = QRUserType;
    qrVC.userId = user.userId;
    qrVC.account = user.account;
    qrVC.nickName = user.userNickname;
    qrVC.sex = user.sex;
    [g_navigation pushViewController:qrVC animated:YES];
}
- (void)onShikuNum {
    TFJunYou_SetShikuNumVC *vc = [[TFJunYou_SetShikuNumVC alloc] init];
    vc.delegate = self;
    vc.user = user;
    [g_navigation pushViewController:vc animated:YES];
}
- (void)setShikuNum:(TFJunYou_SetShikuNumVC *)setShikuNumVC updateSuccessWithAccount:(NSString *)account {
    [self.tableBody.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createCustomView];
}
@end
