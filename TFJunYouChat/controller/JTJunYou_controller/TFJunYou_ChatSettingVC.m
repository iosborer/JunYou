//
//  TFJunYou_ChatSettingVC.m
//  TFJunYouChat
//
//  Created by p on 2018/5/19.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_ChatSettingVC.h"
#import "TFJunYou_UserInfoVC.h"
#import "TFJunYou_SelFriendVC.h"
#import "TFJunYou_SetChatBackgroundVC.h"
#import "TFJunYou_InputValueVC.h"
#import "TFJunYou_SearchChatLogVC.h"
#import "TFJunYou_LabelObject.h"
#import "TFJunYou_SetLabelVC.h"
#import "TFJunYou_SelectFriendsVC.h"
#import "TFJunYou_TransferRecordTableVC.h"
#import "TFJunYou_SetNoteAndLabelVC.h"

@interface TFJunYou_ChatSettingVC () <UIPickerViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) TFJunYou_ImageView *head;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userDesc;

@property (nonatomic, strong) TFJunYou_Label *remarksLabel;
@property (nonatomic, strong) TFJunYou_Label *chatRecordTimeOutLabel;
@property (nonatomic, strong) TFJunYou_Label *labelLabel;
@property (nonatomic, strong) UISwitch *messageFreeSwitch;
@property (nonatomic, strong) UISwitch *chatTopSwitch;
@property (nonatomic, strong) UISwitch *readDeleteSwitch;

@property (nonatomic, assign) BOOL isMsgFree;
@property (nonatomic, assign) BOOL isChatTop;
@property (nonatomic, assign) BOOL isReadDel;

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *pickerArr;

@property (nonatomic, strong) UILabel *describe;
@property (nonatomic, assign) BOOL isOtherUpdate;

@end

#define HEIGHT 55
@implementation TFJunYou_ChatSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack = YES;
    [self createHeadAndFoot];
    self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
    self.title = Localized(@"JX_ChatSettings");
    
    
    _pickerArr = @[Localized(@"JX_Forever"), Localized(@"JX_OneHour"), Localized(@"JX_OneDay"), Localized(@"JX_OneWeeks"), Localized(@"JX_OneMonth"), Localized(@"JX_OneQuarter"), Localized(@"JX_OneYear")];
    
    int h=0;
    int w=TFJunYou__SCREEN_WIDTH;
    
    [g_notify addObserver:self selector:@selector(actionQuitChatVC:) name:kActionRelayQuitVC object:nil];
    [g_notify addObserver:self selector:@selector(updateChatSetting) name:kXMPPMessageUpadteUserInfoNotification object:nil];
    [g_notify addObserver:self selector:@selector(updateChatSetting) name:kOfflineOperationUpdateUserSet object:nil];
    
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, 0)];
    baseView.backgroundColor = HEXCOLOR(0xF2F2F2);
    [self.tableBody addSubview:baseView];
    
    float marginHei = 10;
    
    TFJunYou_ImageView* iv;
    iv = [self createHeadButtonclick:nil];
    iv.frame = CGRectMake(0, h, w, 90);
    h+=iv.frame.size.height + marginHei;
    
//    iv = [self createRoomButtonClick:@selector(createRoom)];
//    iv.frame = CGRectMake(0, h, w, HEIGHT);
//    h += iv.frame.size.height + marginHei;
    if ([self.user.userId intValue]>10100 || [self.user.userId intValue]<10000) {
        
        iv = [self createButton:_user.describe.length > 0 ? Localized(@"JX_UserInfoDescribe") : Localized(@"JX_MemoName") drawTop:NO drawBottom:YES icon:nil click:@selector(setLabel)];
        iv.frame = CGRectMake(0,h, w, HEIGHT);
        h+=iv.frame.size.height;
        _remarksLabel = [self createLabel:iv default:_user.describe.length > 0 ? _user.describe : _user.remarkName isClick:YES];
    }
    
    iv = [self createButton:Localized(@"JX_Label") drawTop:NO drawBottom:NO icon:nil click:@selector(setLabel)];
    iv.frame = CGRectMake(0,h, w, HEIGHT);
    h+=iv.frame.size.height + marginHei;
    NSMutableArray *array = [[TFJunYou_LabelObject sharedInstance] fetchLabelsWithUserId:self.user.userId];
    NSMutableString *labelsName = [NSMutableString string];
    for (NSInteger i = 0; i < array.count; i ++) {
        TFJunYou_LabelObject *labelObj = array[i];
        if (i == 0) {
            [labelsName appendString:labelObj.groupName];
        }else {
            [labelsName appendFormat:@",%@",labelObj.groupName];
        }
    }
    _labelLabel = [self createLabel:iv default:labelsName isClick:YES];
    _labelLabel.textColor = HEXCOLOR(0x999999);
    
    iv = [self createButton:Localized(@"JX_LookupChatRecords") drawTop:NO drawBottom:NO icon:nil click:@selector(searchChatLog)];
    iv.frame = CGRectMake(0,h, w, HEIGHT);

    if ([g_config.enablePayModule boolValue]) {
        h+=iv.frame.size.height;

        iv = [self createButton:Localized(@"JX_ViewTransferRecords") drawTop:YES drawBottom:NO icon:nil click:@selector(checkTransfer)];
        iv.frame = CGRectMake(0,h, w, HEIGHT);
    }
    h+=iv.frame.size.height + marginHei;

    
    iv = [self createButton:Localized(@"JX_ReadDelete") drawTop:NO drawBottom:NO icon:nil click:nil];
    iv.frame = CGRectMake(0,h, w, HEIGHT);
    h+=iv.frame.size.height;
    
    NSString *isOpenReadDel = [NSString stringWithFormat:@"%@",self.user.isOpenReadDel];
    
    _readDeleteSwitch = [self createSwitch:iv defaule:[isOpenReadDel intValue] == 1 click:@selector(readDelAction:)];
    
    iv = [self createButton:Localized(@"JX_ChatAtTheTop") drawTop:YES drawBottom:NO icon:nil click:nil];
    iv.frame = CGRectMake(0,h, w, HEIGHT);
    h+=iv.frame.size.height;
    _chatTopSwitch = [self createSwitch:iv defaule:[self.user.topTime timeIntervalSince1970] > 0 click:@selector(topChatAction:)];
    
    iv = [self createButton:Localized(@"JX_MessageFree") drawTop:YES drawBottom:NO icon:nil click:nil];
    iv.frame = CGRectMake(0,h, w, HEIGHT);
    h+=iv.frame.size.height + marginHei;
    
    NSString *offlineNoPushMsg = [NSString stringWithFormat:@"%@",self.user.offlineNoPushMsg];
    _messageFreeSwitch = [self createSwitch:iv defaule:[offlineNoPushMsg intValue] == 1 click:@selector(messageFreeAction:)];
    
    
    iv = [self createButton:Localized(@"JX_ChatBackground") drawTop:NO drawBottom:NO icon:nil click:@selector(chatBackGroundImage)];
    iv.frame = CGRectMake(0,h, w, HEIGHT);
    h+=iv.frame.size.height + marginHei;
    
    iv = [self createButton:Localized(@"JX_MessageAutoDestroyed") drawTop:NO drawBottom:YES icon:nil click:@selector(chatRecordTimeOutAction)];
    iv.frame = CGRectMake(0,h, w, HEIGHT);
    h+=iv.frame.size.height;
    
    _chatRecordTimeOutLabel = [self createLabel:iv default:[self setChatRecordTimeOutLabelText] isClick:YES];
    
    iv = [self createButton:Localized(@"JX_EmptyChatRecords") drawTop:NO drawBottom:YES icon:nil click:@selector(cleanMessageLog)];
    iv.frame = CGRectMake(0,h, w, HEIGHT);
    h+=iv.frame.size.height;
    
    iv = [self createButton:Localized(@"JX_DelMsgTwoSides") drawTop:NO drawBottom:NO icon:nil click:@selector(cleanTwoSidesMessageLog)];
    iv.frame = CGRectMake(0,h, w, HEIGHT);
    h+=iv.frame.size.height;

    CGRect frame = baseView.frame;
    frame.size.height = h;
    baseView.frame = frame;
    
    if ((h + HEIGHT + 20) > self.tableBody.frame.size.height) {
        self.tableBody.contentSize = CGSizeMake(self_width, h + HEIGHT + 20);
    }
    
    [g_server getUser:self.user.userId toView:self];
    
    [self createPickerView];
}

- (NSString *)setChatRecordTimeOutLabelText {
    double outTime = [self.user.chatRecordTimeOut doubleValue];
    NSString *str;
    if (outTime <= 0) {
        str = _pickerArr[0];
    }else if (outTime == 0.04) {
        str = _pickerArr[1];
    }else if (outTime == 1) {
        str = _pickerArr[2];
    }else if (outTime == 7) {
        str = _pickerArr[3];
    }else if (outTime == 30) {
        str = _pickerArr[4];
    }else if (outTime == 90) {
        str = _pickerArr[5];
    }else{
        str = _pickerArr[6];
    }
    return str;
}

- (void)updateChatSetting {
    self.isOtherUpdate = YES;
    [g_server getUser:self.user.userId toView:self];
}

- (void)createPickerView {
    _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 220, TFJunYou__SCREEN_WIDTH, 220)];
    _selectView.backgroundColor = HEXCOLOR(0xF2F2F2);
    _selectView.hidden = YES;
    [self.view addSubview:_selectView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_selectView.frame.size.width - 80, 20, 60, 20)];
    [btn setTitle:Localized(@"JX_Confirm") forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 50, 20)];
    [btn setTitle:Localized(@"JX_Cencal") forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:btn];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, _selectView.frame.size.width, _selectView.frame.size.height - 40)];
    _pickerView.delegate = self;
    double outTime = [self.user.chatRecordTimeOut doubleValue];
    NSInteger index = 0;
    if (outTime <= 0) {
        index = 0;
    }else if (outTime == 0.04) {
        index = 1;
    }else if (outTime == 1) {
        index = 2;
    }else if (outTime == 7) {
        index = 3;
    }else if (outTime == 30) {
        index = 4;
    }else if (outTime == 90) {
        index = 5;
    }else{
        index = 6;
    }
    
    [_pickerView selectRow:index inComponent:0 animated:NO];
    [_selectView addSubview:_pickerView];
}

- (void)btnAction:(UIButton *)btn {
    _selectView.hidden = YES;
    NSInteger row = [_pickerView selectedRowInComponent:0];
    _chatRecordTimeOutLabel.text = _pickerArr[row];
    
    NSString *str = [NSString stringWithFormat:@"%ld",row];
    switch (row) {
        case 0:
            str = @"-1";
            break;
        case 1:
            str = @"0.04";
            break;
        case 2:
            str = @"1";
            break;
        case 3:
            str = @"7";
            break;
        case 4:
            str = @"30";
            break;
        case 5:
            str = @"90";
            break;
        case 6:
            str = @"365";
            break;
            
        default:
            break;
    }
    self.user.chatRecordTimeOut = str;
    [self.user updateUserChatRecordTimeOut];
    [g_server friendsUpdate:self.user.userId chatRecordTimeOut:str toView:self];
}

- (void)cancelBtnAction:(UIButton *)btn {
    _selectView.hidden = YES;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerArr[row];
}

- (void)dealloc {
    [g_notify removeObserver:self];
}

- (void)checkTransfer {
    TFJunYou_TransferRecordTableVC *vc = [[TFJunYou_TransferRecordTableVC alloc] init];
    vc.userId = self.user.userId;
    [g_navigation pushViewController:vc animated:YES];
}

// 发起群聊
- (TFJunYou_ImageView *)createRoomButtonClick:(SEL)click {
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    btn.didTouch = click;
    btn.delegate = self;
    [self.tableBody addSubview:btn];
    
    TFJunYou_ImageView *add = [[TFJunYou_ImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
    add.image = [UIImage imageNamed:@"person_add"];
    [btn addSubview:add];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(add.frame) + 20, 0, 200, HEIGHT)];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = HEXCOLOR(0xff3db4ff);
    label.text = Localized(@"JX_LaunchGroupChat");
    [btn addSubview:label];
    
    return btn;
}

- (void)remarkAction {
    TFJunYou_InputValueVC* vc = [TFJunYou_InputValueVC alloc];
    vc.value = self.user.remarkName.length > 0  ? self.user.remarkName : self.user.userNickname;
    vc.title = Localized(@"JXUserInfoVC_SetName");
    vc.delegate  = self;
    vc.isLimit = YES;
    vc.didSelect = @selector(onSaveNickName:);
    vc = [vc init];
    //    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];
}
-(void)onSaveNickName:(TFJunYou_InputValueVC*)vc{
    _remarksLabel.text = vc.value;
    self.user.remarkName = vc.value;
    [g_server setFriendName:self.user.userId noteName:vc.value describe:nil toView:self];
}

// 标签
- (void)setLabel {
    
    TFJunYou_SetNoteAndLabelVC *vc = [[TFJunYou_SetNoteAndLabelVC alloc] init];
    vc.title = Localized(@"JX_SetNotesAndLabels");
    vc.delegate = self;
    vc.didSelect = @selector(refreshLabel:);
    vc.user = self.user;
    [g_navigation pushViewController:vc animated:YES];
}

- (void)refreshLabel:(TFJunYou_UserObject *)user {
    
    NSMutableArray *array = [[TFJunYou_LabelObject sharedInstance] fetchLabelsWithUserId:self.user.userId];
    NSMutableString *labelsName = [NSMutableString string];
    for (NSInteger i = 0; i < array.count; i ++) {
        TFJunYou_LabelObject *labelObj = array[i];
        if (i == 0) {
            [labelsName appendString:labelObj.groupName];
        }else {
            [labelsName appendFormat:@",%@",labelObj.groupName];
        }
    }
    _labelLabel.text = labelsName;
    
    if (user.describe.length > 0) {
        _describe.text = Localized(@"JX_UserInfoDescribe");
        _remarksLabel.text = user.describe;
    }else {
        _describe.text = Localized(@"JX_MemoName");
        _remarksLabel.text = user.remarkName;
    }
    self.user.remarkName = user.remarkName;
    self.user.describe = user.describe;
    [g_server setFriendName:self.user.userId noteName:user.remarkName describe:user.describe toView:self];

}

// 查找聊天内容
- (void)searchChatLog {
    
    TFJunYou_SearchChatLogVC *vc = [[TFJunYou_SearchChatLogVC alloc] init];
    vc.user = self.user;
    [g_navigation pushViewController:vc animated:YES];
}

// 阅后即焚
- (void)readDelAction:(UISwitch *)switchView {
    int readDel = switchView.isOn;
    
    self.isReadDel = YES;
    
    [g_server friendsUpdateOfflineNoPushMsgUserId:g_myself.userId toUserId:self.user.userId offlineNoPushMsg:readDel type:1 toView:self];
}

// 置顶聊天
- (void)topChatAction:(UISwitch *)switchView {
    int topChat = switchView.isOn;
    
    self.isChatTop = YES;
    
    [g_server friendsUpdateOfflineNoPushMsgUserId:g_myself.userId toUserId:self.user.userId offlineNoPushMsg:topChat  type:2 toView:self];

}

// 消息免打扰
- (void)messageFreeAction:(UISwitch *)switchView {
    int offlineNoPushMsg = switchView.isOn;
    self.isMsgFree = YES;
    [g_server friendsUpdateOfflineNoPushMsgUserId:g_myself.userId toUserId:self.user.userId offlineNoPushMsg:offlineNoPushMsg  type:0 toView:self];
}

- (void)chatRecordTimeOutAction {
    double outTime = [self.user.chatRecordTimeOut doubleValue];
    NSInteger index = 0;
    if (outTime <= 0) {
        index = 0;
    }else if (outTime == 0.04) {
        index = 1;
    }else if (outTime == 1) {
        index = 2;
    }else if (outTime == 7) {
        index = 3;
    }else if (outTime == 30) {
        index = 4;
    }else if (outTime == 90) {
        index = 5;
    }else{
        index = 6;
    }
    [_pickerView selectRow:index inComponent:0 animated:NO];
    _selectView.hidden = NO;
}

// 清除聊天记录
- (void)cleanMessageLog {
    [g_App showAlert:Localized(@"JX_ConfirmDeleteChat") delegate:self tag:1111 onlyConfirm:NO];

}

//清空双方的聊天记录
- (void)cleanTwoSidesMessageLog {
    [g_App showAlert:Localized(@"JX_ConfirmDelMsgTwoSides?") delegate:self tag:2222 onlyConfirm:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1 && (alertView.tag == 1111 || alertView.tag == 2222)) {
        if (alertView.tag == 2222) {
            TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
            msg.timeSend = [NSDate date];
            msg.type = [NSNumber numberWithInt:kWCMessageTypeDelMsgTwoSides];
            msg.fromUserId = MY_USER_ID;
            msg.toUserId = self.user.userId;
            [g_xmpp sendMessage:msg roomName:nil];
        }
        TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
        msg.toUserId = self.user.userId;
        [msg deleteAll];
        msg.type = [NSNumber numberWithInt:1];
        msg.content = @" ";
        [msg updateLastSend:UpdateLastSendType_None];
        [msg notifyMyLastSend];
        [g_server emptyMsgWithTouserId:self.user.userId type:[NSNumber numberWithInt:0] toView:self];
        [g_notify postNotificationName:kRefreshChatLogNotif object:nil];

    }
}

-(TFJunYou_ImageView*)createHeadButtonclick:(SEL)click{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    btn.didTouch = click;
    btn.delegate = self;
    [self.tableBody addSubview:btn];
    
    _head = [[TFJunYou_ImageView alloc]initWithFrame:CGRectMake(20, 10, 50, 50)];
    _head.layer.cornerRadius = 50 / 2;
    _head.layer.masksToBounds = YES;
//    _head.didTouch = @selector(onHeadImage);
    _head.delegate = self;
    _head.didTouch = @selector(onResume);
    [g_server getHeadImageLarge:self.user.userId userName:self.user.userNickname imageView:_head];
    [btn addSubview:_head];
    //        [_head release];
    
    if ([self.user.userType intValue] != 2) {
        TFJunYou_ImageView *add = [[TFJunYou_ImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_head.frame) + 20, _head.frame.origin.y, _head.frame.size.width, _head.frame.size.height)];
        add.delegate = self;
        add.didTouch = @selector(createRoom);
        add.image = [UIImage imageNamed:@"add"];
        [btn addSubview:add];
    }
    
    //名字Label
    UILabel* p = [[UILabel alloc]initWithFrame:CGRectMake(_head.frame.origin.x, CGRectGetMaxY(_head.frame), _head.frame.size.width, 20)];
    p.font = g_factory.font13;
    p.text = g_server.myself.userNickname;
    p.textAlignment = NSTextAlignmentCenter;
    p.backgroundColor = [UIColor clearColor];
    [btn addSubview:p];
    _userName = p;
    _userName.text = self.user.remarkName.length > 0  ? self.user.remarkName : self.user.userNickname;
    
    if(click){
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, (HEIGHT-13)/2, 7, 13)];
        iv.image = [UIImage imageNamed:@"new_icon_>"];
        iv.center = CGPointMake(iv.center.x, CGRectGetMidY(_head.frame));
        [btn addSubview:iv];
    }
    
//    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0,90-0.5,TFJunYou__SCREEN_WIDTH,0.5)];
//    line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
//    [btn addSubview:line];

    return btn;
}

-(TFJunYou_ImageView*)createButton:(NSString*)title drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom icon:(NSString*)icon click:(SEL)click{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    btn.didTouch = click;
    btn.delegate = self;
    [self.tableBody addSubview:btn];
    
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(15, 0, TFJunYou__SCREEN_WIDTH-100, HEIGHT)];
    p.text = title;
    p.font = g_factory.font15;
    p.backgroundColor = [UIColor clearColor];
    p.textColor = [UIColor blackColor];
    p.delegate = self;
    p.didTouch = click;
    [btn addSubview:p];
    if ([title isEqualToString:Localized(@"JX_UserInfoDescribe")] || [title isEqualToString:Localized(@"JX_MemoName")]) {
        _describe = p;
    }
    
    if(icon){
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, (HEIGHT-20)/2, 20, 20)];
        iv.image = [UIImage imageNamed:icon];
        [btn addSubview:iv];
    }
    
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(15,0,TFJunYou__SCREEN_WIDTH-15,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(drawBottom){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(15,HEIGHT-LINE_WH,TFJunYou__SCREEN_WIDTH,LINE_WH)];
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


-(TFJunYou_Label*)createLabel:(UIView*)parent default:(NSString*)s isClick:(BOOL) boo{
    TFJunYou_Label * p;
    if (boo) {
        p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH/2 - 23 -INSETS,INSETS,TFJunYou__SCREEN_WIDTH/2 - INSETS,HEIGHT-INSETS*2)];
    }else{
        p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH/2 ,INSETS,TFJunYou__SCREEN_WIDTH/2 - INSETS,HEIGHT-INSETS*2)];
    }
    
    p.userInteractionEnabled = NO;
    p.text = s;
    p.textColor = [UIColor lightGrayColor];
    p.font = g_factory.font15;
    p.textAlignment = NSTextAlignmentRight;
    [parent addSubview:p];
    //    [p release];
    return p;
}

- (UISwitch *)createSwitch:(UIView *)parent defaule:(BOOL)isOn click:(SEL)click {
    UISwitch *switchView = [[UISwitch alloc] init];
    switchView.frame = CGRectMake(TFJunYou__SCREEN_WIDTH -INSETS - 51, 6, 0, 0);
    [switchView addTarget:self action:click forControlEvents:UIControlEventValueChanged];
    switchView.onTintColor = THEMECOLOR;
    [switchView setOn:isOn];
    [parent addSubview:switchView];
    return switchView;
}

- (void)onResume {
    
//    [g_server getUser:self.user.userId toView:self];
    
    TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
    vc.userId       = self.user.userId;
    vc.user = self.user;
    vc.fromAddType = 6;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}

- (void)createRoom {
    if ([g_config.isCommonCreateGroup intValue] == 1) {
        [g_App showAlert:Localized(@"JX_NotCreateNewRoom")];
        return;
    }
    memberData *member = [[memberData alloc] init];
    member.userId = [g_myself.userId longLongValue];
    member.userNickName = MY_USER_NAME;
    member.role = @1;
    [_room.members addObject:member];

    TFJunYou_SelectFriendsVC* vc = [TFJunYou_SelectFriendsVC alloc];
//    vc.chatRoom = _chatRoom;
    vc.room = _room;
    vc.isNewRoom = YES;
    vc.isForRoom = YES;
    vc.forRoomUser = self.user;
    vc = [vc init];
//    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];
}

- (void)actionQuitChatVC:(NSNotification *)notif {
    [self actionQuit];
}

- (void)chatBackGroundImage {
    TFJunYou_SetChatBackgroundVC *vc = [[TFJunYou_SetChatBackgroundVC alloc] init];
    vc.userId = self.user.userId;
    [g_navigation pushViewController:vc animated:YES];
}


//服务端返回数据
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    
//    if( [aDownload.action isEqualToString:act_UserGet] ){
//        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
//        [user getDataFromDict:dict];
//
//        TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
//        vc.user       = user;
//        vc = [vc init];
//        //        [g_window addSubview:vc.view];
//        [g_navigation pushViewController:vc animated:YES];
//    }
    if( [aDownload.action isEqualToString:act_UploadFile] ){
        NSDictionary* p = nil;
        if([(NSArray *)[dict objectForKey:@"audios"] count]>0)
            p = [[dict objectForKey:@"audios"] objectAtIndex:0];
        if([(NSArray *)[dict objectForKey:@"images"] count]>0)
            p = [[dict objectForKey:@"images"] objectAtIndex:0];
        if([(NSArray *)[dict objectForKey:@"videos"] count]>0)
            p = [[dict objectForKey:@"videos"] objectAtIndex:0];
        if(p==nil)
            p = [(NSArray *)[dict objectForKey:@"others"] objectAtIndex:0];
        
        NSString* url = [p objectForKey:@"oUrl"];
        [g_constant.userBackGroundImage setObject:url forKey:self.user.userId];
        BOOL isSuccess = [g_constant.userBackGroundImage writeToFile:backImage atomically:YES];
        if (isSuccess) {
            [g_App showAlert:Localized(@"JX_SetUpSuccess")];
        }else {
            [g_App showAlert:Localized(@"JX_SettingFailure")];
        }
    }
    
    if([aDownload.action isEqualToString:act_FriendRemark]){
        [_wait stop];
        _userName.text = self.user.remarkName.length > 0  ? self.user.remarkName : self.user.userNickname;

        TFJunYou_UserObject* user1 = [[TFJunYou_UserObject sharedInstance] getUserById:self.user.userId];
        user1.remarkName = self.user.remarkName;
        user1.describe = self.user.describe;
        // 修改备注后实时刷新
        [g_notify postNotificationName:kFriendRemark object:user1];
        [user1 update];
        [g_App showAlert:Localized(@"JXAlert_SetOK")];
    }
    
    if([aDownload.action isEqualToString:act_friendsUpdateOfflineNoPushMsg]){
        [_wait stop];
        if (self.isMsgFree) {
            self.isMsgFree = NO;
            self.user.offlineNoPushMsg = [NSNumber numberWithBool:_messageFreeSwitch.isOn];
            [self.user updateOfflineNoPushMsg];
            [g_App showAlert:Localized(@"JXAlert_SetOK")];
        }
        else if (self.isChatTop) {
            self.isChatTop = NO;
            long long time = [[dict objectForKey:@"openTopChatTime"] longLongValue];
            self.user.topTime = [NSDate dateWithTimeIntervalSince1970:time];
            if (!_chatTopSwitch.isOn) {
                self.user.topTime = nil;
            }

            [self.user updateTopTime];
            [g_notify postNotificationName:kFriendListRefresh object:nil];
            [g_notify postNotificationName:kChatViewDisappear object:nil];
        }
        else if (self.isReadDel) {
            self.isReadDel = NO;
            if (_readDeleteSwitch.isOn) {
                [g_App showAlert:Localized(@"JX_ReadDeleteTip")];
            }
        
            self.user.isOpenReadDel = [NSNumber numberWithBool:_readDeleteSwitch.isOn];
            [self.user updateIsOpenReadDel];
            [g_notify postNotificationName:kOpenReadDelNotif object:self.user.isOpenReadDel];
        }
    }
    
    if( [aDownload.action isEqualToString:act_UserGet] ){
        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
        [user getDataFromDict:dict];
        
        self.user = user;
        
        _remarksLabel.text = _user.describe.length > 0 ? _user.describe : _user.remarkName;
        [_readDeleteSwitch setOn:[user.isOpenReadDel boolValue]];
        [_chatTopSwitch setOn:[user.topTime timeIntervalSince1970] > 0];
        [_messageFreeSwitch setOn:[user.offlineNoPushMsg intValue] == 1];
        _chatRecordTimeOutLabel.text = [self setChatRecordTimeOutLabelText];
        
        [g_notify postNotificationName:kOpenReadDelNotif object:self.user.isOpenReadDel];
    }
    
    
    if( [aDownload.action isEqualToString:act_EmptyMsg] ){
        
        // 清除聊天记
        TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
        msg.isGroup = YES;
        msg.toUserId = self.user.userId;
        [msg deleteAll];
        msg.type = [NSNumber numberWithInt:1];
        msg.content = @" ";
        [msg updateLastSend:UpdateLastSendType_None];
        [msg notifyMyLastSend];
        //        [g_notify postNotificationName:kRefreshChatLogNotif object:nil];
        
        [g_notify postNotificationName:kChatVCReloadNotif object:nil];
        
        [g_App showAlert:Localized(@"JXAlert_DeleteOK")];
    }
}

-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait hide];
    return show_error;
}

-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait hide];
    return show_error;
}

-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
