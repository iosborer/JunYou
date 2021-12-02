#import "TFJunYou_PSMyViewController.h"
#import "TFJunYou_ImageView.h"
#import "TFJunYou_Label.h"
#import "AppDelegate.h"
#import "TFJunYou_Server.h"
#import "TFJunYou_Connection.h"
#import "UIFactory.h"
#import "TFJunYou_TableView.h"
#import "TFJunYou_FriendViewController.h"
#import "ImageResize.h"
#import "TFJunYou_userWeiboVC.h"
#import "TFJunYou_myMediaVC.h"
#import "webpageVC.h"
#import "TFJunYou_loginVC.h"
#import "TFJunYou_NewFriendViewController.h"
#import "TFJunYou_PSRegisterBaseVC.h"
#import "photosViewController.h"
#import "TFJunYou_SettingVC.h"
#import "TFJunYou_PSUpdateUserVC.h"
#import "OrganizTreeViewController.h"
#import "TFJunYou_CourseListVC.h"
#import "TFJunYou_MyMoneyViewController.h"
#import "TFJunYou_NearVC.h"
#import "TFJunYou_SelFriendVC.h"
#import "TFJunYou_SelectFriendsVC.h"
#ifdef Meeting_Version
#import "TFJunYou_AVCallViewController.h"
#endif
#ifdef Live_Version
#import "TFJunYou_LiveViewController.h"
#endif
#import "TFJunYou_FriendViewController.h"
#import "TFJunYou_GroupViewController.h"
#import "UIImage+Color.h"
#import "TFJunYou_ScanQRViewController.h"
#import "TFJunYou_JLApplyForWithdrawalVC.h"
#import "TFJunYou_RealCerVc.h"
#import "QRImage.h"
#import "TFJunYou_QRCodeViewController.h"
#import "TFJunYou_SecuritySettingVC.h"
#import "TFJunYou_AboutVC.h"
#import "TFJunYou_ThirdServiceVC.h"
#import "TFJunYou_ChatViewController.h"

#define HEIGHT 45
#define MY_INSET  10
#define TOP_ADD_HEIGHT  400
/**我的动态 */
static const BOOL OPEN_DYNAMIC = YES;
/**我的收藏 */
static const BOOL OPEN_COLLECTION = NO;
/**我的课件 */
static const BOOL OPEN_MYCOURSEWARE = NO;
/**申请提现 */
static const BOOL OPEN_WITHDRAWAL = YES;
/**视频会议 */
static const BOOL OPEN_VIDEO_CONFERENCE = NO;
/**分享二维码 */
static const BOOL OPEN_SHARE_QRCODE = YES;
/**账号与安全 */
static const BOOL OPEN_ACCOUN_SECURITY = YES;
/** 第三方服务 */
static const BOOL OPEN_THIRD_SERVICE = YES;


@implementation TFJunYou_PSMyViewController
- (id)init{
    self = [super init];
    if (self) {
        self.isRefresh = NO;
        self.title = Localized(@"JX_My");
        self.heightHeader = 0;
        self.heightFooter = TFJunYou__SCREEN_BOTTOM;
        [self createHeadAndFoot];
        int h=-20;
        int w=TFJunYou__SCREEN_WIDTH;
        float marginHei = 10;
        int H = 86;
        TFJunYou_ImageView* iv;
        iv = [self createHeadButtonclick:@selector(onResume)];
        _topImageVeiw = iv;
        
        iv.frame = CGRectMake(0, THE_DEVICE_HAVE_HEAD ? 44 : 20, w, 173);
//        iv.frame = CGRectMake(0, THE_DEVICE_HAVE_HEAD ? -TOP_ADD_HEIGHT- 44 : -TOP_ADD_HEIGHT-20, w, 173+TFJunYou__SCREEN_TOP+TOP_ADD_HEIGHT);
        h = CGRectGetMaxY(iv.frame);
        _setBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, h, TFJunYou__SCREEN_WIDTH,TFJunYou__SCREEN_HEIGHT - h - TFJunYou__SCREEN_BOTTOM+80)];
        _setBaseView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.tableBody addSubview:_setBaseView];
//        [self setPartRoundWithView:_setBaseView corners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:20];
        h = 13;
        if ([g_config.enablePayModule boolValue]) {

                iv = [self createButton:Localized(@"JX_MyBalance") drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"balance_recharge_simple" : @"balance_recharge" click:@selector(onRecharge)];
                iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);

                h+=iv.frame.size.height+MY_INSET;
        }
        
        if (OPEN_DYNAMIC) {
            iv = [self createButton:@"我的相册" drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"my_space_simple" : @"my_space" click:@selector(onMyBlog)];
            iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
            h+=iv.frame.size.height+MY_INSET;
        }
        if (OPEN_COLLECTION) {
            iv = [self createButton:Localized(@"JX_MyCollection") drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"collection_me_simple" : @"collection_me" click:@selector(onMyFavorite)];
            iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
            h+=iv.frame.size.height+MY_INSET;
        }
        if (OPEN_MYCOURSEWARE) {
            iv = [self createButton:Localized(@"JX_MyLecture") drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"my_lecture_simple" : @"my_lecture" click:@selector(onCourse)];
            iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
            h+=iv.frame.size.height+MY_INSET;
        }
        
//        if ([g_App.isShowApplyForWithdrawal intValue] == 0) {
//            if (OPEN_WITHDRAWAL) {
//             iv = [self createButton:@"申请提现" drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"balance_recharge_simple" : @"balance_recharge" click:@selector(onApplyForWithdrawal)];
//             iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
//             h+=iv.frame.size.height+MY_INSET;
//            }
//        }
     
        
//       if ([g_App.videoMeeting intValue] == 1) {
//           iv = [self createButton:g_App.activityName drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"my_space_simple" : @"my_space" click:@selector(onActivity)];
//           iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
//           h+=iv.frame.size.height+MY_INSET;
//       }
        BOOL isShowLine = NO;
#ifdef IS_SHOW_MENU
#else
#ifdef Meeting_Version
        isShowLine = YES;
        if ([g_App.videoMeeting intValue] == 1) {
            if (OPEN_VIDEO_CONFERENCE) {
                UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), TFJunYou__SCREEN_WIDTH, marginHei)];
                line1.backgroundColor = HEXCOLOR(0xF2F2F2);
                [_setBaseView addSubview:line1];
                iv = [self createButton:Localized(@"JXSettingVC_VideoMeeting") drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"videomeeting_simple" : @"videomeeting" click:@selector(onMeeting)];
                iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
                h+=iv.frame.size.height+MY_INSET;
            }
        }
        
    
        isShowLine = NO;
#else
        isShowLine = YES;
#endif
#ifdef Live_Version
        if ([g_App.isShowRedPacket intValue] == 1 ) {
            if (!isShowLine) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), TFJunYou__SCREEN_WIDTH, marginHei)];
                line.backgroundColor = HEXCOLOR(0xF2F2F2);
                [_setBaseView addSubview:line];
            }
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), TFJunYou__SCREEN_WIDTH, marginHei)];
            line1.backgroundColor = HEXCOLOR(0xF2F2F2);
            [_setBaseView addSubview:line1];
            iv = [self createButton:Localized(@"JX_LiveDemonstration") drawTop:isShowLine drawBottom:NO icon:THESIMPLESTYLE ? @"videoshow_simple" : @"videoshow" click:@selector(onLive)];
            iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
            h+=iv.frame.size.height + marginHei;
        }
      
        isShowLine = YES;
#else
        isShowLine = NO;
#endif
#endif
        
        
//        if (OPEN_SHARE_QRCODE) {
//            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), TFJunYou__SCREEN_WIDTH, marginHei)];
//            line1.backgroundColor = HEXCOLOR(0xF2F2F2);
//            [_setBaseView addSubview:line1];
//            iv = [self createButton:@"分享二维码" drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"icon-fenx" : @"icon-fenx" click:@selector(realNameCer)];
//            iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
//            h+=iv.frame.size.height+MY_INSET;
//        }
        if (OPEN_ACCOUN_SECURITY) {
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), TFJunYou__SCREEN_WIDTH, marginHei)];
            line1.backgroundColor = HEXCOLOR(0xF2F2F2);
            [_setBaseView addSubview:line1];
            iv = [self createButton:@"账号与安全" drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"账号安全" : @"账号安全" click:@selector(accountSecurity)];
            iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
            h+=iv.frame.size.height+MY_INSET;
        }
        
//        if (OPEN_ACCOUN_SECURITY) {
//            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), TFJunYou__SCREEN_WIDTH, marginHei)];
//            line1.backgroundColor = HEXCOLOR(0xF2F2F2);
//            [_setBaseView addSubview:line1];
//            iv = [self createButton:@"eBay团队" drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"账号安全" : @"账号安全" click:@selector(team)];
//            iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
//            h+=iv.frame.size.height+MY_INSET;
//        }

        
//        if (OPEN_THIRD_SERVICE) {
//            // 第三方服务
//            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), TFJunYou__SCREEN_WIDTH, marginHei)];
//            line1.backgroundColor = HEXCOLOR(0xF2F2F2);
//            [_setBaseView addSubview:line1];
//            iv = [self createButton:@"第三方服务" drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"collection_me_simple" : @"collection_me_simple" click:@selector(onThirdService)];
//            iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
//            h+=iv.frame.size.height+MY_INSET;
//        }
        
        
        
        // 关于我们
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), TFJunYou__SCREEN_WIDTH, marginHei)];
        line1.backgroundColor = HEXCOLOR(0xF2F2F2);
        [_setBaseView addSubview:line1];
        iv = [self createButton:Localized(@"JXAboutVC_AboutUS") drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"my_lecture_simple" : @"my_lecture_simple" click:@selector(onAbout)];
        iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
        h+=iv.frame.size.height+MY_INSET;
        
    
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), TFJunYou__SCREEN_WIDTH, marginHei)];
        line.backgroundColor = HEXCOLOR(0xF2F2F2);
        [_setBaseView addSubview:line];
        iv = [self createButton:Localized(@"JXSettingVC_Set") drawTop:NO drawBottom:YES icon:THESIMPLESTYLE ? @"set_up_simple" : @"set_up" click:@selector(onSetting)];
        iv.frame = CGRectMake(MY_INSET,h, w-MY_INSET*2, HEIGHT);
        CGRect frame = _setBaseView.frame;
        frame.size.height = CGRectGetMaxY(iv.frame)+MY_INSET;
        _setBaseView.frame = frame;
        
        self.tableBody.contentSize = CGSizeMake(self_width, CGRectGetMaxY(_setBaseView.frame) + 10);
        
        [g_notify addObserver:self selector:@selector(doRefresh:) name:kUpdateUserNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(updateUserInfo:) name:kXMPPMessageUpadteUserInfoNotification object:nil];
        [g_notify addObserver:self selector:@selector(doRefresh:) name:kOfflineOperationUpdateUserSet object:nil];
        [g_server getUserMoenyToView:self];
    }
    return self;
}
- (void)updateUserInfo:(NSNotification *)noti {
    [g_server getUser:g_server.myself.userId toView:self];
}
-(void)dealloc{
    NSLog(@"TFJunYou_PSMyViewController.dealloc");
    [g_notify removeObserver:self name:kUpdateUserNotifaction object:nil];
    [g_notify removeObserver:self name:kXMPPMessageUpadteUserInfoNotification object:nil];
    [g_notify removeObserver:self name:kOfflineOperationUpdateUserSet object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (_friendLabel) {
         NSArray *friends = [[TFJunYou_UserObject sharedInstance] fetchAllUserFromLocal];
           _friendLabel.text = [NSString stringWithFormat:@"%ld",friends.count];
    }
    if (_groupLabel) {
        NSArray *groups = [[TFJunYou_UserObject sharedInstance] fetchAllRoomsFromLocal];
        _groupLabel.text = [NSString stringWithFormat:@"%ld",groups.count];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidAppear:(BOOL)animated
{
    if (self.isRefresh) {
        self.isRefresh = NO;
    }else{
        [super viewDidAppear:animated];
        [self doRefresh:nil];
    }
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}
-(void)doRefresh:(NSNotification *)notifacation{
    _head.image = nil;
    [g_server getHeadImageSmall:g_server.myself.userId userName:g_server.myself.userNickname imageView:_head];
    _userName.text = g_server.myself.userNickname;
    _userDesc.text = g_server.myself.phone;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
        [_wait hide];
    if( [aDownload.action isEqualToString:act_resumeList] ){
    }
    if( [aDownload.action isEqualToString:act_UserGet] ){
        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
        [user getDataFromDict:dict];
        g_server.myself.userNickname = user.userNickname;
        NSRange range = [user.telephone rangeOfString:@"86"];
        if (range.location != NSNotFound) {
            g_server.myself.telephone = [user.telephone substringFromIndex:range.location + range.length];
        }
        if (self.isGetUser) {
            self.isGetUser = NO;
            TFJunYou_PSUpdateUserVC* vc = [TFJunYou_PSUpdateUserVC alloc];
            vc.headImage = [_head.image copy];
            vc.user = user;
            vc = [vc init];
            [g_navigation pushViewController:vc animated:YES];
            return;
        }
        _userName.text = user.userNickname;
        [g_server delHeadImage:g_server.myself.userId];
        [g_server getHeadImageSmall:g_server.myself.userId userName:g_server.myself.userNickname imageView:_head];
    }
    if ([aDownload.action isEqualToString:act_getUserMoeny]) {
        g_App.myMoney = [dict[@"balance"] doubleValue];
        _moneyLabel.text = [NSString stringWithFormat:@"%.2f%@",g_App.myMoney,Localized(@"JX_ChinaMoney")];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait hide];
    if( [aDownload.action isEqualToString:act_UserGet] ){
        if (!self.isGetUser) {
            TFJunYou_PSUpdateUserVC* vc = [TFJunYou_PSUpdateUserVC alloc];
            vc.headImage = [_head.image copy];
            vc.user = g_server.myself;
            vc = [vc init];
            [g_navigation pushViewController:vc animated:YES];
        }
    }
    return hide_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait hide];
    if( [aDownload.action isEqualToString:act_UserGet] ){
        if (!self.isGetUser) {
            TFJunYou_PSUpdateUserVC* vc = [TFJunYou_PSUpdateUserVC alloc];
            vc.headImage = [_head.image copy];
            vc.user = g_server.myself;
            vc = [vc init];
            [g_navigation pushViewController:vc animated:YES];
        }
    }
    return hide_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
}
-(void)actionClear{
    [_wait start:Localized(@"PSMyViewController_Clearing") delay:100];
}
#ifdef Live_Version
- (void)onLive {
    TFJunYou_LiveViewController *vc = [[TFJunYou_LiveViewController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}
#endif
#ifdef Meeting_Version
- (void)onMeeting {
    if(g_xmpp.isLogined != 1){
        [g_xmpp showXmppOfflineAlert];
        return;
    }
    NSString *str1;
    NSString *str2;
    str1 = Localized(@"JXSettingVC_VideoMeeting");
    str2 = Localized(@"JX_Meeting");
    TFJunYou_ActionSheetVC *actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[@"meeting_tel",@"meeting_video"] names:@[str2,str1]];
    actionVC.delegate = self;
    [self presentViewController:actionVC animated:NO completion:nil];
}
- (void)actionSheet:(TFJunYou_ActionSheetVC *)actionSheet didButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        [self onGroupAudioMeeting:nil];
    }else if(index == 1){
        [self onGroupVideoMeeting:nil];
    }
}
-(void)onGroupAudioMeeting:(TFJunYou_MessageObject*)msg{
    self.isAudioMeeting = YES;
    [self onInvite];
}
-(void)onGroupVideoMeeting:(TFJunYou_MessageObject*)msg{
    self.isAudioMeeting = NO;
    [self onInvite];
}

- (void)accountSecurity {
    TFJunYou_SecuritySettingVC *vc = [[TFJunYou_SecuritySettingVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}

- (void)team {
    
    // 客服
    TFJunYou_ChatViewController *sendView = [TFJunYou_ChatViewController alloc];

    
    TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
    
    user = [user getUserById:COSUMER_SERVICE_CENTER_USERID];

    sendView.chatPerson = user;
    sendView.chatPerson.userId = COSUMER_SERVICE_CENTER_USERID;
    sendView.chatPerson.userNickname = @"在线客服";
    sendView.title = @"在线客服";

    sendView = [sendView init];

    [g_navigation pushViewController:sendView animated:YES];
}

- (void)onThirdService {
    TFJunYou_ThirdServiceVC *vc = [[TFJunYou_ThirdServiceVC alloc] init];
//    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];
}

- (void)onAbout {
    TFJunYou_AboutVC *vc = [[TFJunYou_AboutVC alloc] init];
//    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];
}

-(void)realNameCer{
    
    
    TFJunYou_QRCodeViewController * qrVC = [[TFJunYou_QRCodeViewController alloc] init];
    qrVC.type = QRUserType;
    qrVC.userId = g_myself.userId;
    qrVC.account = g_server.myself.phone;
    qrVC.nickName = g_myself.userNickname;
    qrVC.sex = g_myself.sex;
    [g_navigation pushViewController:qrVC animated:YES];
    
    return;
    NSMutableString * qrStr = [NSMutableString stringWithFormat:@"%@?action=",g_config.website];
    [qrStr appendString:@"user"];
    UIImageView *imageView = [[UIImageView alloc] init];
    [g_server getHeadImageLarge:g_myself.userId userName:g_myself.userNickname imageView:imageView];
     
    UIImage * qrImage = [QRImage qrImageForString:qrStr imageSize:300 logoImage:imageView.image logoImageSize:70];
      
    NSArray * activityItems = @[qrImage];
    UIActivityViewController * activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
            //[ToastUtils showHud:@"分享成功"];//此tost为自己封装的所以这句不用复制
        }else{
            // [ToastUtils showHud:@"分享失败，请重试"];//此tost为自己封装的所以这句不用复制
        }
        [activityVC dismissViewControllerAnimated:YES completion:nil];
    };
    activityVC.completionWithItemsHandler = myBlock;
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,    UIActivityTypePostToTwitter,  UIActivityTypePostToWeibo,  UIActivityTypeMessage,  UIActivityTypeMail,  UIActivityTypePrint,  UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll,  UIActivityTypePostToTencentWeibo,  UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks];
    [self presentViewController:activityVC animated:YES completion:nil];
  
  
    
    
    
    
    return;
    TFJunYou_RealCerVc *cervc=[[TFJunYou_RealCerVc alloc]init];
    
    [g_navigation pushViewController:cervc animated:YES];
}
-(void)onInvite{
    NSMutableSet* p = [[NSMutableSet alloc]init];
    TFJunYou_SelectFriendsVC* vc = [TFJunYou_SelectFriendsVC alloc];
    vc.isNewRoom = NO;
    vc.isShowMySelf = NO;
    vc.type = TFJunYou_SelUserTypeSelFriends;
    vc.existSet = p;
    vc.delegate = self;
    vc.didSelect = @selector(meetingAddMember:);
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}
-(void)meetingAddMember:(TFJunYou_SelectFriendsVC*)vc{
    int type;
    if (self.isAudioMeeting) {
        type = kWCMessageTypeAudioMeetingInvite;
    }else {
        type = kWCMessageTypeVideoMeetingInvite;
    }
    for(NSNumber* n in vc.set){
        TFJunYou_UserObject *user;
        if (vc.seekTextField.text.length > 0) {
            user = vc.searchArray[[n intValue] % 100000-1];
        }else{
            user = [[vc.letterResultArr objectAtIndex:[n intValue] / 100000-1] objectAtIndex:[n intValue] % 100000-1];
        }
        NSString* s = [NSString stringWithFormat:@"%@",user.userId];
        [g_meeting sendMeetingInvite:s toUserName:user.userNickname roomJid:MY_USER_ID callId:nil type:type];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (g_meeting.isMeeting) {
            return;
        }
        TFJunYou_AVCallViewController *avVC = [[TFJunYou_AVCallViewController alloc] init];
        avVC.roomNum = MY_USER_ID;
        avVC.isAudio = self.isAudioMeeting;
        avVC.isGroup = YES;
        avVC.toUserName = MY_USER_NAME;
        avVC.view.frame = [UIScreen mainScreen].bounds;
        [g_window addSubview:avVC.view];
    });
}
#endif
- (void)onApplyForWithdrawal {
    TFJunYou_JLApplyForWithdrawalVC *vc = [[TFJunYou_JLApplyForWithdrawalVC alloc] init];
    [g_App.navigation pushViewController:vc animated:YES];
}
- (void)onActivity {
     webpageVC * webVC = [webpageVC alloc];
     webVC.url =  g_App.activityUrl;
     webVC.isSend = NO;
     webVC = [webVC init];
    [g_navigation pushViewController:webVC animated:YES];
}
-(void)onMyBlog{
    TFJunYou_userWeiboVC* vc = [TFJunYou_userWeiboVC alloc];
    vc.user = g_myself;
    vc.isGotoBack = YES;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}
-(void)onNear{
    TFJunYou_NearVC * nearVc = [[TFJunYou_NearVC alloc] init];
    [g_navigation pushViewController:nearVc animated:YES];
}
-(void)onFriend{
    TFJunYou_FriendViewController* vc = [[TFJunYou_FriendViewController alloc]init];
    [g_navigation pushViewController:vc animated:YES];
}
-(void)onResume{
    self.isGetUser = YES;
    [g_server getUser:MY_USER_ID toView:self];
}
-(void)onSpace{
}
-(void)onVideo{
    TFJunYou_myMediaVC* vc = [[TFJunYou_myMediaVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}
-(void)onMyFavorite{
    TFJunYou_WeiboVC * collection = [[TFJunYou_WeiboVC alloc] initCollection];
    [g_navigation pushViewController:collection animated:YES];
}
- (void)onCourse {
    TFJunYou_CourseListVC *vc = [[TFJunYou_CourseListVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}
-(void)onRecharge{
    TFJunYou_MyMoneyViewController * moneyVC = [[TFJunYou_MyMoneyViewController alloc] init];
    [g_navigation pushViewController:moneyVC animated:YES];
}
-(void)onOrganiz{
    OrganizTreeViewController * organizVC = [[OrganizTreeViewController alloc] init];
    [g_navigation pushViewController:organizVC animated:YES];
}
-(void)onMyLove{
}
-(void)onMoney{
}
-(void)onSetting{
    TFJunYou_SettingVC* vc = [[TFJunYou_SettingVC alloc]init];
    [g_navigation pushViewController:vc animated:YES];
}
- (void)onAdd {
    TFJunYou__SelectMenuView *menuView = [[TFJunYou__SelectMenuView alloc] initWithTitle:@[Localized(@"JX_SendImage"),Localized(@"JX_SendVoice"),Localized(@"JX_SendVideo"),Localized(@"JX_SendFile")]image:@[@"menu_add_msg",@"menu_add_voice",@"menu_add_video",@"menu_add_file",@"menu_add_reply"]cellHeight:45];
    menuView.delegate = self;
    [g_App.window addSubview:menuView];
}
- (void)didMenuView:(TFJunYou__SelectMenuView *)MenuView WithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        case 1:
        case 2:
        case 3:{
            TFJunYou_addMsgVC* vc = [[TFJunYou_addMsgVC alloc] init];
            vc.dataType = (int)index + 2;
            [g_navigation pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
-(TFJunYou_ImageView*)createHeadButtonclick:(SEL)click{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    btn.didTouch = click;
    btn.delegate = self;
    [self.tableBody addSubview:btn];
//    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_ADD_HEIGHT, TFJunYou__SCREEN_WIDTH, 173+TFJunYou__SCREEN_TOP)];
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, -40, TFJunYou__SCREEN_WIDTH, 173+TFJunYou__SCREEN_TOP)];
    [btn addSubview:baseView];
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15*2-18, THE_DEVICE_HAVE_HEAD ? 59-15 : 35-15, 18+15*2, 18+15*2)];
    [addBtn setImage:[UIImage imageNamed:@"my_add_white"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(onAdd) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:addBtn];
    _head = [[TFJunYou_ImageView alloc]initWithFrame:CGRectMake(20, TFJunYou__SCREEN_TOP + 32, 85, 85)];
    _head.layer.cornerRadius = _head.frame.size.width / 2;
    _head.layer.masksToBounds = YES;
    _head.layer.borderWidth = 3.f;
    _head.layer.borderColor = [UIColor whiteColor].CGColor;
    _head.didTouch = @selector(onResume);
    _head.delegate = self;
    [baseView addSubview:_head];
    UILabel* p = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_head.frame)+20, CGRectGetMinY(_head.frame)+16, 150, 22)];
    p.font = SYSFONT(20);
    p.text = MY_USER_NAME;
    p.textColor = [UIColor blackColor];
    p.backgroundColor = [UIColor clearColor];
    [baseView addSubview:p];
    _userName = p;
    p = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(p.frame), CGRectGetMaxY(p.frame)+12, 100, 14)];
    p.font = SYSFONT(14);
    p.text = g_server.myself.telephone;
    p.textColor = [UIColor lightGrayColor];
    p.backgroundColor = [UIColor clearColor];
    [baseView addSubview:p];
    _userDesc = p;
    UIImageView* qrImgV = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-20-35, TFJunYou__SCREEN_TOP+65, 13, 13)];
    qrImgV.image = [UIImage imageNamed:@"my_qrcode"];
    [baseView addSubview:qrImgV];
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-6, CGRectGetMinY(qrImgV.frame), 6, 12)];
    iv.image = [UIImage imageNamed:@"my_next_white"];
    [baseView addSubview:iv];
    return btn;
}
- (void)setPartRoundWithView:(UIView *)view corners:(UIRectCorner)corners cornerRadius:(float)cornerRadius {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
    view.layer.mask = shapeLayer;
}
- (void)onColleagues:(UITapGestureRecognizer *)tap {
    if (_isSelected)
        return;
    _isSelected = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isSelected = NO;
    });
    switch (tap.view.tag) {
        case 0:{
            TFJunYou_FriendViewController *friendVC = [TFJunYou_FriendViewController alloc];
            friendVC.isMyGoIn = YES;
            friendVC = [friendVC  init];
            [g_navigation pushViewController:friendVC animated:YES];
        }
            break;
        case 1:{
            TFJunYou_GroupViewController *groupVC = [[TFJunYou_GroupViewController alloc] init];
            [g_navigation pushViewController:groupVC animated:YES];
        }
            break;
        default:
            break;
    }
}
- (UIButton *)createViewWithFrame:(CGRect)frame title:(NSString *)title icon:(NSString *)icon index:(CGFloat)index showLine:(BOOL)isShow{
    UIButton *view = [[UIButton alloc] init];
    [view setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [view setBackgroundImage:[UIImage createImageWithColor:HEXCOLOR(0xF6F5FA)] forState:UIControlStateHighlighted];
    view.frame = frame;
    view.tag = index;
    [self.tableBody addSubview:view];
    int imgH = 40.5;
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.frame = CGRectMake((view.frame.size.width-imgH)/2, (view.frame.size.height-imgH-15-3)/2, imgH, imgH);
    imgV.image = [UIImage imageNamed:icon];
    [view addSubview:imgV];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, CGRectGetMaxY(imgV.frame)+3, view.frame.size.width, 15);
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = SYSFONT(15);
    label.textColor = HEXCOLOR(0x323232);
    [view addSubview:label];
    if (index == 0) {
        _friendLabel = label;
    }else {
        _groupLabel = label;
    }
    if (isShow) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width-LINE_WH, (view.frame.size.height-24)/2, LINE_WH, 24)];
        line.backgroundColor = THE_LINE_COLOR;
        [view addSubview:line];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onColleagues:)];
    [view addGestureRecognizer:tap];
    return view;
}
-(TFJunYou_ImageView*)createButton:(NSString*)title drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom icon:(NSString*)icon click:(SEL)click{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    btn.didTouch = click;
    btn.delegate = self;
    [_setBaseView addSubview:btn];
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(53, 0, self_width-35-20-5, HEIGHT)];
    p.text = title;
    p.font = g_factory.font16;
    p.backgroundColor = [UIColor clearColor];
    p.textColor = HEXCOLOR(0x323232);
    [btn addSubview:p];
    if(icon){
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (HEIGHT-23)/2, 23, 23)];
        iv.image = [UIImage imageNamed:icon];
        [btn addSubview:iv];
    }
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(53,0,TFJunYou__SCREEN_WIDTH-53,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
//        [btn addSubview:line];
    }
    if(drawBottom){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(53,HEIGHT-0.3,TFJunYou__SCREEN_WIDTH-53,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
//        [btn addSubview:line];
    }
    if(click){
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7-2*MY_INSET, (HEIGHT-13)/2, 7, 13)];
        iv.image = [UIImage imageNamed:@"new_icon_>"];
        [btn addSubview:iv];
    }
    
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    return btn;
}
-(void)onHeadImage{
    [g_server delHeadImage:g_myself.userId];
    TFJunYou_ImageScrollVC * imageVC = [[TFJunYou_ImageScrollVC alloc]init];
    imageVC.imageSize = CGSizeMake(TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_WIDTH);
    imageVC.iv = [[TFJunYou_ImageView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_WIDTH)];
    imageVC.iv.center = imageVC.view.center;
    [g_server getHeadImageLarge:g_myself.userId userName:g_myself.userNickname imageView:imageVC.iv];
    [self addTransition:imageVC];
    [self presentViewController:imageVC animated:YES completion:^{
        self.isRefresh = YES;
    }];
}
- (void)setupView:(UIView *)view colors:(NSArray *)colors {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, 266+TOP_ADD_HEIGHT-86);  
    gradientLayer.colors = colors;  
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [view.layer addSublayer:gradientLayer];
}
- (void) addTransition:(TFJunYou_ImageScrollVC *) siv
{
    self.scaleTransition = [[DMScaleTransition alloc]init];
    [siv setTransitioningDelegate:self.scaleTransition];
}
@end
