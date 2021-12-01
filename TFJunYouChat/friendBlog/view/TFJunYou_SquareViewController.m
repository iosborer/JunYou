#import "TFJunYou_SquareViewController.h"
#import "TFJunYou_WeiboVC.h"
#import "TFJunYou_ActionSheetVC.h"
#ifdef Meeting_Version
#import "TFJunYou_SelectFriendsVC.h"
#import "TFJunYou_AVCallViewController.h"
#endif
#ifdef Live_Version
#import "TFJunYou_LiveViewController.h"
#endif
#import "TFJunYou_ScanQRViewController.h"
#import "TFJunYou_NearVC.h"
#import "TFJunYou_BlogRemind.h"
#import "TFJunYou_TabMenuView.h"
#ifdef Meeting_Version
#ifdef Live_Version
#import "GKDYHomeViewController.h"
#import "TFJunYou_SmallVideoViewController.h"
#endif
#endif
#import "ImageResize.h"
#import "TFJunYou_ChatViewController.h"
#import "TFJunYou_Cell.h"
#import "TFJunYou_UserInfoVC.h"
#define SQUARE_HEIGHT      52      
#define INSET_IMAGE       7        
typedef NS_ENUM(NSInteger, TFJunYou_SquareType) {
    TFJunYou_SquareTypeLife,           
    TFJunYou_SquareTypeVideo,          
    TFJunYou_SquareTypeVideoLive,      
    TFJunYou_SquareTypeShortVideo,     
    TFJunYou_SquareTypeQrcode,         
    TFJunYou_SquareTypeNearby,         
};
@interface TFJunYou_SquareViewController () <TFJunYou_ActionSheetVCDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *iconArr;
@property (nonatomic, assign) TFJunYou_SquareType type;
@property (nonatomic, assign) BOOL isAudioMeeting;
@property (nonatomic, strong) UILabel *weiboNewMsgNum;
@property (nonatomic, strong) NSMutableArray *remindArray;
@property (nonatomic, strong) UIButton *imgV;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) NSMutableArray *subviews;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger page;
@property(nonatomic,strong) MJRefreshFooterView *footer;
@property(nonatomic,strong) MJRefreshHeaderView *header;
@end
@implementation TFJunYou_SquareViewController
- (instancetype)init {
    if (self = [super init]) {
        self.title = Localized(@"JXMainViewController_Find");
        _array = [NSMutableArray array];
        self.heightFooter = 0;
        self.heightHeader = TFJunYou__SCREEN_TOP;
        [self createHeadAndFoot];
        self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
        self.subviews = [[NSMutableArray alloc] init];
        [self setupViews];
        [g_notify addObserver:self selector:@selector(remindNotif:) name:kXMPPMessageWeiboRemind object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getServerData];
}
- (void)onQrCode {
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        [g_server showMsg:Localized(@"JX_CanNotopenCenmar")];
        return;
    }
    TFJunYou_ScanQRViewController * scanVC = [[TFJunYou_ScanQRViewController alloc] init];
    [g_navigation pushViewController:scanVC animated:YES];
}
- (void)getServerData {
    [g_server searchPublicWithKeyWorld:@"" limit:20 page:(int)_page toView:self];
}
-(void)dealloc{
    [g_notify removeObserver:self name:kXMPPMessageWeiboRemind object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showNewMsgNoti];
}
- (void)showNewMsgNoti {
    _remindArray = [[TFJunYou_BlogRemind sharedInstance] doFetchUnread];
    NSString *newMsgNum = [NSString stringWithFormat:@"%ld",_remindArray.count];
    if (_remindArray.count >= 10 && _remindArray.count <= 99) {
        self.weiboNewMsgNum.font = SYSFONT(12);
    }else if (_remindArray.count > 0 && _remindArray.count < 10) {
        self.weiboNewMsgNum.font = SYSFONT(13);
    }else if(_remindArray.count > 99){
        self.weiboNewMsgNum.font = SYSFONT(9);
    }
    self.weiboNewMsgNum.text = newMsgNum;
    int number = 0;
      if (g_App.linkArray.count == 0) {
          number = 2;
       }else if(g_App.linkArray.count == 1){
         number = 100;
       }else if(g_App.linkArray.count == 2){
         number = 100;
      }
       [g_mainVC.tb setBadge:number title:newMsgNum];
    self.weiboNewMsgNum.hidden = _remindArray.count <= 0;
}
- (void)setupViews {
    UIButton *qrCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15*2-18, TFJunYou__SCREEN_TOP-15*2-18, 18+15*2, 18+15*2)];
    [qrCodeBtn setImage:[UIImage imageNamed:@"square_qrcode"] forState:UIControlStateNormal];
    [qrCodeBtn addTarget:self action:@selector(onQrCode) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeader addSubview:qrCodeBtn];
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, 0)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.tableBody addSubview:baseView];
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, 180)];
    [baseView addSubview:_topImageView];
    CGFloat fl = (_topImageView.frame.size.width/_topImageView.frame.size.height);
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:g_config.headBackgroundImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            image = [UIImage imageNamed:@"Default_Gray"];
        }
        _topImageView.image = [ImageResize image:image fillSize:CGSizeMake((_topImageView.frame.size.height+200)*fl, _topImageView.frame.size.height+200)];
    }];
    UIView *boldLine = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_topImageView.frame)+20, 3, 20)];
    boldLine.backgroundColor = THEMECOLOR;
    [baseView addSubview:boldLine];
    CGSize size = [Localized(@"JX_TopicalApplication") boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYSFONT(18)} context:nil].size;
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(boldLine.frame)+10, CGRectGetMinY(boldLine.frame), size.width, 20)];
    hotLabel.text = Localized(@"JX_TopicalApplication");
    hotLabel.font = SYSFONT(17);
    [baseView addSubview:hotLabel];
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(hotLabel.frame)+10, CGRectGetMinY(boldLine.frame)+6, 160, 14)];
    hintLabel.text = Localized(@"JX_MoreApps");
    hintLabel.textColor = [UIColor grayColor];
    hintLabel.font = SYSFONT(12);
    [baseView addSubview:hintLabel];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hotLabel.frame)+5, TFJunYou__SCREEN_WIDTH, 0)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [baseView addSubview:_scrollView];
    BOOL lifeCircle = YES;      
    BOOL videoMeeting = YES;    
    BOOL liveVideo = YES;       
    BOOL shortVideo = YES;      
    BOOL peopleNearby = YES;    
    BOOL scan = YES;            
    if (g_config.popularAPP) {
        lifeCircle = [[g_config.popularAPP objectForKey:@"lifeCircle"] boolValue];
        videoMeeting = [[g_config.popularAPP objectForKey:@"videoMeeting"] boolValue];
        liveVideo = [[g_config.popularAPP objectForKey:@"liveVideo"] boolValue];
        shortVideo = [[g_config.popularAPP objectForKey:@"shortVideo"] boolValue];
        peopleNearby = [[g_config.popularAPP objectForKey:@"peopleNearby"] boolValue];
        scan = [[g_config.popularAPP objectForKey:@"scan"] boolValue];
    }
    UIButton *button;
    int  leftInset = (button.frame.size.width - SQUARE_HEIGHT)/2;
    int btnX = 0;
    int btnY = 0;
    if (lifeCircle) {
        button = [self createButtonWithFrame:CGRectMake(0, btnY, TFJunYou__SCREEN_WIDTH/5, 0) title:Localized(@"JX_LifeCircle") icon:@"square_life" highlighted:@"square_life_highlighted" index:TFJunYou_SquareTypeLife];
    }
#ifdef Meeting_Version
    if (videoMeeting) {
        btnX += button.frame.size.width;
        button = [self createButtonWithFrame:CGRectMake(btnX, btnY, TFJunYou__SCREEN_WIDTH/5, 0) title:Localized(@"JXSettingVC_VideoMeeting") icon:@"square_video" highlighted:@"square_video_highlighted" index:TFJunYou_SquareTypeVideo];
    }
#endif
#ifdef Live_Version
    if (liveVideo) {
        btnX += button.frame.size.width;
        button = [self createButtonWithFrame:CGRectMake(btnX, btnY, TFJunYou__SCREEN_WIDTH/5, 0) title:Localized(@"JX_LiveVideo") icon:@"square_videochat" highlighted:@"square_videochat_highlighted" index:TFJunYou_SquareTypeVideoLive];
    }
#endif
    if (shortVideo) {
        btnX += button.frame.size.width;
        button = [self createButtonWithFrame:CGRectMake(btnX, btnY, TFJunYou__SCREEN_WIDTH/5, 0) title:Localized(@"JX_ShorVideo") icon:@"square_douyin" highlighted:@"square_douyin_highlighted" index:TFJunYou_SquareTypeShortVideo];
    }
    if (peopleNearby) {
        btnX += button.frame.size.width;
        button = [self createButtonWithFrame:CGRectMake(btnX, btnY, TFJunYou__SCREEN_WIDTH/5, 0) title:Localized(@"JXNearVC_NearPer") icon:@"square_nearby" highlighted:@"square_nearby_highlighted" index:TFJunYou_SquareTypeNearby];
    }
    CGRect scrollFrame = _scrollView.frame;
    scrollFrame.size.height = button.frame.size.height;
    _scrollView.frame = scrollFrame;
    _scrollView.contentSize = CGSizeMake(btnX+button.frame.size.width, 0);
    CGRect frame = baseView.frame;
    frame.size.height = CGRectGetMaxY(_scrollView.frame)+25;
    baseView.frame = frame;
    if ([g_config.enableMpModule boolValue]) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(baseView.frame)+8, TFJunYou__SCREEN_WIDTH, 50)];
        headerView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 3, 20)];
        line.backgroundColor = THEMECOLOR;
        [headerView addSubview:line];
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+8, 20, 240, 20)];
        numLabel.text = Localized(@"JX_PopularPublicAccount");
        numLabel.font = SYSFONT(17);
        [headerView addSubview:numLabel];
        [self.tableBody addSubview:headerView];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT - TFJunYou__SCREEN_TOP - CGRectGetMaxY(headerView.frame)-TFJunYou__SCREEN_BOTTOM) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXCOLOR(0xF2F2F2);
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.tableBody addSubview:_tableView];
        [self addHeader];
        [self addFooter];
    }
}
- (void)stopLoading {
    [_footer endRefreshing];
    [_header endRefreshing];
}
- (void)addFooter
{
    if(_footer){
    }
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    __weak TFJunYou_SquareViewController *weakSelf = self;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [weakSelf scrollToPageDown];
    };
    _footer.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
    };
    _footer.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        switch (state) {
            case MJRefreshStateNormal:
                break;
            case MJRefreshStatePulling:
                break;
            case MJRefreshStateRefreshing:
                break;
            default:
                break;
        }
    };
}
- (void)addHeader
{
    if(_header){
    }
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    __weak TFJunYou_SquareViewController *weakSelf = self;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [weakSelf scrollToPageUp];
    };
    _header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
    };
    _header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        switch (state) {
            case MJRefreshStateNormal:
                break;
            case MJRefreshStatePulling:
                break;
            case MJRefreshStateRefreshing:
                break;
            default:
                break;
        }
    };
}
-(void)scrollToPageUp{
    _page = 0;
    [self getServerData];
}
-(void)scrollToPageDown{
    [self getServerData];
}
#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_array.count == 1) {
        return 100;
    }
    return 59;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TFJunYou_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    TFJunYou_UserObject *user = _array[indexPath.row];
    if (_array.count == 1) {
        if ([cell isKindOfClass:[TFJunYou_Cell class]]) {
            cell = nil;
        }
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 40, 40)];
            imgV.tag = 100;
            imgV.layer.cornerRadius = imgV.frame.size.width/2;
            imgV.layer.masksToBounds = YES;
            [cell.contentView addSubview:imgV];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+10, 41.5, 200, 17)];
            label.tag = 101;
            [cell.contentView addSubview:label];
        }
        UIImageView *imgV = [cell.contentView viewWithTag:100];
        UILabel *label = [cell.contentView viewWithTag:101];
        [g_server getHeadImageSmall:user.userId userName:user.userNickname imageView:imgV];
        label.text = user.userNickname;
    }else {
        TFJunYou_Cell *cell=nil;
        if(cell==nil){
            cell = [[TFJunYou_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.title = user.userNickname;
        cell.index = (int)indexPath.row;
        cell.userId = user.userId;
        [cell.lbTitle setText:cell.title];
        cell.isSmall = YES;
        [cell headImageViewImageWithUserId:nil roomId:nil];
        if (indexPath.row == _array.count - 1) {
            cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x, cell.lineView.frame.origin.y, cell.lineView.frame.size.width, 0);
        }else {
            cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x, cell.lineView.frame.origin.y, cell.lineView.frame.size.width, LINE_WH);
        }
        return cell;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TFJunYou_UserObject *user = _array[indexPath.row];
    [g_server getUser:user.userId toView:self];
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    if( [aDownload.action isEqualToString:act_PublicSearch] ){
        [self stopLoading];
        if (array1.count < 20) {
            _footer.hidden = YES;
        }
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if(_page == 0){
            [_array removeAllObjects];
            for (int i = 0; i < array1.count; i++) {
                TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
                [user getDataFromDict:array1[i]];
                [arr addObject:user];
            }
            [_array addObjectsFromArray:arr];
        }else{
            if([array1 count]>0){
                for (int i = 0; i < array1.count; i++) {
                    TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
                    [user getDataFromDict:array1[i]];
                    [arr addObject:user];
                }
                [_array addObjectsFromArray:arr];
            }
        }
        _page ++;
        [self setTableviewHeight];
        [_tableView reloadData];
    }
    if( [aDownload.action isEqualToString:act_UserGet] ){
        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
        [user getDataFromDict:dict];
        if([user.userType intValue] == 2 && [user.status intValue] != 2){
            TFJunYou_UserInfoVC* userVC = [TFJunYou_UserInfoVC alloc];
            userVC.userId = user.userId;
            userVC.user = user;
            userVC.fromAddType = 6;
            userVC = [userVC init];
            [g_navigation pushViewController:userVC animated:YES];
            return;
        }
        TFJunYou_ChatViewController *sendView=[TFJunYou_ChatViewController alloc];
        sendView.scrollLine = 0;
        sendView.title = user.userNickname;
        sendView.chatPerson = user;
        sendView = [sendView init];
        [g_navigation pushViewController:sendView animated:YES];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait hide];
    [self stopLoading];
    return hide_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait hide];
    [self stopLoading];
    return hide_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
}
- (void)setTableviewHeight {
    int height = [self tableView:_tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGRect frame = _tableView.frame;
    frame.size.height = height*_array.count;
    _tableView.frame = frame;
    self.tableBody.contentSize = CGSizeMake(0, CGRectGetMaxY(_tableView.frame)+50+8);
}
- (void)clickButtonWithTag:(NSInteger)btnTag {
    switch (btnTag) {
        case TFJunYou_SquareTypeLife:{
            TFJunYou_WeiboVC *weiboVC = [TFJunYou_WeiboVC alloc];
            weiboVC.user = g_server.myself;
            weiboVC = [weiboVC init];
            [g_navigation pushViewController:weiboVC animated:YES];
        }
            break;
        case TFJunYou_SquareTypeVideo:{
#ifdef Meeting_Version
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
#endif
        }
            break;
        case TFJunYou_SquareTypeVideoLive:{ 
#ifdef Live_Version
            TFJunYou_LiveViewController *vc = [[TFJunYou_LiveViewController alloc] init];
            [g_navigation pushViewController:vc animated:YES];
#endif
        }
            break;
        case TFJunYou_SquareTypeShortVideo:{
#ifdef Meeting_Version
#ifdef Live_Version
            TFJunYou_SmallVideoViewController *vc = [[TFJunYou_SmallVideoViewController alloc] init];
            [g_navigation pushViewController:vc animated:YES];
            return;
#endif
#endif
            [TFJunYou_MyTools showTipView:Localized(@"JX_It'sNotOpenYet")];
        }
            break;
        case TFJunYou_SquareTypeQrcode:{
            AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
            {
                [g_server showMsg:Localized(@"JX_CanNotopenCenmar")];
                return;
            }
            TFJunYou_ScanQRViewController * scanVC = [[TFJunYou_ScanQRViewController alloc] init];
            [g_navigation pushViewController:scanVC animated:YES];
        }
            break;
        case TFJunYou_SquareTypeNearby:{
            TFJunYou_NearVC * nearVc = [[TFJunYou_NearVC alloc] init];
            [g_navigation pushViewController:nearVc animated:YES];
        }
            break;
        default:
            break;
    }
}
#ifdef Meeting_Version
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
-(void)onInvite{
    NSMutableSet* p = [[NSMutableSet alloc]init];
    TFJunYou_SelectFriendsVC* vc = [TFJunYou_SelectFriendsVC alloc];
    vc.isNewRoom = NO;
    vc.isShowMySelf = NO;
    vc.type = TFJunYou_SelectFriendTypeSelFriends;
    vc.existSet = p;
    vc.delegate = self;
    vc.didSelect = @selector(meetingAddMember:);
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}
- (void) remindNotif:(NSNotification *)notif {
    [self showNewMsgNoti];
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
- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title icon:(NSString *)iconName highlighted:(NSString *)highlighted index:(NSInteger)index {
    UIButton *button = [[UIButton alloc] init];
    button.frame = frame;
    button.tag = index;
    [button addTarget:self action:@selector(didButton:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(didButtonDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(didButtonDragInside:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(didButtonDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
    [_scrollView addSubview:button];
    CGFloat inset =(TFJunYou__SCREEN_WIDTH-SQUARE_HEIGHT*5)/10;   
    CGFloat originY = 15;
    _imgV = [[UIButton alloc] init];
    _imgV.frame = CGRectMake(inset, originY, SQUARE_HEIGHT, SQUARE_HEIGHT);
    [_imgV setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [_imgV setImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    _imgV.userInteractionEnabled = NO;
    _imgV.tag = index;
    [button addSubview:_imgV];
    [_subviews addObject:_imgV];
    _imgV.highlighted = button.highlighted;
    if (index == TFJunYou_SquareTypeLife) {
        self.weiboNewMsgNum = [[UILabel alloc] initWithFrame:CGRectMake(SQUARE_HEIGHT - 18, -2, 20, 20)];
        self.weiboNewMsgNum.backgroundColor = HEXCOLOR(0xEF2D37);
        self.weiboNewMsgNum.font = SYSFONT(13);
        self.weiboNewMsgNum.textAlignment = NSTextAlignmentCenter;
        self.weiboNewMsgNum.layer.cornerRadius = self.weiboNewMsgNum.frame.size.width / 2;
        self.weiboNewMsgNum.layer.masksToBounds = YES;
        self.weiboNewMsgNum.hidden = YES;
        self.weiboNewMsgNum.textColor = [UIColor whiteColor];
        self.weiboNewMsgNum.text = @"99";
        [_imgV addSubview:self.weiboNewMsgNum];
    }
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYSFONT(14)} context:nil].size;
    UILabel *lab = [[UILabel alloc] init];
    lab.text = title;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = HEXCOLOR(0x323232);
    lab.font = SYSFONT(14);
    lab.frame = CGRectMake(0, CGRectGetMaxY(_imgV.frame)+INSET_IMAGE, frame.size.width - 5, size.height);
    CGPoint center = lab.center;
    center.x = _imgV.center.x;
    lab.center = center;
    CGRect btnFrame = button.frame;
    btnFrame.size.height = originY+SQUARE_HEIGHT+size.height+INSET_IMAGE;
    button.frame = btnFrame;
    [button addSubview:lab];
    return button;
}
- (void)didButton:(UIButton *)button {
    for (UIView *sub in button.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            btn.highlighted = button.highlighted;
            [self clickButtonWithTag:button.tag];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                btn.highlighted = NO;
            });
        }
    }
}
- (void)didButtonDown:(UIButton *)button {
    for (UIView *sub in button.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            btn.highlighted = button.highlighted;
        }
    }
}
- (void)didButtonDragInside:(UIButton *)button {
    UIButton *btn;
    for (UIView *sub in button.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            btn = (UIButton *)sub;
            btn.highlighted = button.highlighted;
        }
    }
}
- (void)didButtonDragOutside:(UIButton *)button {
    UIButton *btn;
    for (UIView *sub in button.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            btn = (UIButton *)sub;
            btn.highlighted = button.highlighted;
        }
    }
}
@end
